#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import os
import re
import sys
import tomllib
from copy import deepcopy
from pathlib import Path
from typing import Any


CLIENT_DEFAULTS = {
    "codex": {
        "target_root": "~/.codex",
        "skill_relpath": "skills",
        "config_relpath": "config.toml",
        "state_relpath": ".ai-workflow-craft-state.json",
        "mcp_key": "mcp_servers",
        "config_format": "toml",
    },
    "gemini": {
        "target_root": "~/.gemini/antigravity",
        "skill_relpath": "skills",
        "config_relpath": "mcp_config.json",
        "state_relpath": ".ai-workflow-craft-state.json",
        "mcp_key": "mcpServers",
        "config_format": "json",
    },
    "claude": {
        "target_root": "~/.claude",
        "skill_relpath": "skills",
        "config_relpath": "settings.json",
        "state_relpath": ".ai-workflow-craft-state.json",
        "mcp_key": "mcpServers",
        "config_format": "json",
    },
    "opencode": {
        "target_root": "~/.opencode",
        "skill_relpath": "skills",
        "config_relpath": "config.toml",
        "state_relpath": ".ai-workflow-craft-state.json",
        "mcp_key": "mcp_servers",
        "config_format": "toml",
        "manage_skill_paths": True,
    },
    "ollama": {
        "target_root": "~/.ollama/agent-craft",
        "skill_relpath": "skills",
        "config_relpath": "config.json",
        "state_relpath": ".ai-workflow-craft-state.json",
        "mcp_key": "mcpServers",
        "config_format": "json",
        "apply_supported": False,
    },
}

SECRET_WORDS = ("token", "secret", "password", "api_key", "apikey", "private_key")
BARE_KEY_RE = re.compile(r"^[A-Za-z0-9_-]+$")
BARE_ENV_RE = re.compile(r"^[A-Z0-9_]+$")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Build sync plans for ai-workflow-craft clients.")
    subparsers = parser.add_subparsers(dest="command", required=True)

    plan = subparsers.add_parser("plan", help="Build a client sync plan")
    plan.add_argument("--repo-root", required=True)
    plan.add_argument("--client", required=True, choices=sorted(CLIENT_DEFAULTS))
    plan.add_argument("--scopes", default="skills,mcp")
    plan.add_argument("--target-root", default="")
    plan.add_argument("--include-mirrors", action="store_true")
    plan.add_argument("--exclude-skill-roots-json", default="[]")
    plan.add_argument("--exclude-dir-names-json", default='[".venv","__pycache__","browser_state"]')

    return parser.parse_args()


def pathify(value: str) -> Path:
    return Path(os.path.expanduser(value))


def load_json_file(path: Path) -> dict[str, Any]:
    if not path.exists():
        return {}
    return json.loads(path.read_text())


def load_toml_file(path: Path) -> dict[str, Any]:
    if not path.exists():
        return {}
    return tomllib.loads(path.read_text())


def expand_home(value: Any, home_path: str) -> Any:
    if isinstance(value, str):
        return value.replace("${HOME}", home_path)
    if isinstance(value, list):
        return [expand_home(item, home_path) for item in value]
    if isinstance(value, dict):
        return {key: expand_home(item, home_path) for key, item in value.items()}
    return value


def canonicalize(value: Any) -> Any:
    if isinstance(value, dict):
        return {key: canonicalize(value[key]) for key in sorted(value)}
    if isinstance(value, list):
        return [canonicalize(item) for item in value]
    return value


def format_toml_key(key: str) -> str:
    if BARE_KEY_RE.match(key):
        return key
    return json.dumps(key)


def format_toml_value(value: Any) -> str:
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, int):
        return str(value)
    if isinstance(value, float):
        return str(value)
    if isinstance(value, str):
        return json.dumps(value)
    if isinstance(value, list):
        return "[" + ", ".join(format_toml_value(item) for item in value) + "]"
    raise TypeError(f"Unsupported TOML value type: {type(value)!r}")


def dump_toml_table(lines: list[str], table_path: list[str], table_value: dict[str, Any]) -> None:
    if table_path:
        lines.append("[" + ".".join(format_toml_key(part) for part in table_path) + "]")
    scalar_items = []
    nested_items = []
    for key, value in table_value.items():
        if isinstance(value, dict):
            nested_items.append((key, value))
        else:
            scalar_items.append((key, value))
    for key, value in scalar_items:
        lines.append(f"{format_toml_key(key)} = {format_toml_value(value)}")
    if scalar_items and nested_items:
        lines.append("")
    for index, (key, value) in enumerate(nested_items):
        dump_toml_table(lines, table_path + [key], value)
        if index != len(nested_items) - 1:
            lines.append("")


def dump_toml(data: dict[str, Any]) -> str:
    lines: list[str] = []
    dump_toml_table(lines, [], data)
    while lines and lines[-1] == "":
        lines.pop()
    return "\n".join(lines) + "\n"


def collect_skill_relpaths(
    repo_root: Path,
    include_mirrors: bool,
    excluded_roots: list[str],
    excluded_dir_names: list[str],
) -> list[str]:
    skills_root = repo_root / "skills"
    relpaths: set[str] = set()
    for skill_file in skills_root.rglob("SKILL.md"):
        skill_dir = skill_file.parent
        relpath = skill_dir.relative_to(skills_root).as_posix()
        parts = Path(relpath).parts
        if any(part in excluded_dir_names for part in parts):
            continue
        if not include_mirrors:
            skip = False
            for root_name in excluded_roots:
                if relpath == root_name or relpath.startswith(root_name + "/"):
                    skip = True
                    break
            if skip:
                continue
        relpaths.add(relpath)
    return sorted(relpaths)


def collect_repo_mcp_servers(repo_root: Path, home_path: str) -> dict[str, Any]:
    server_root = repo_root / "MCP" / "servers"
    servers: dict[str, Any] = {}
    for path in sorted(server_root.glob("*.toml")):
        if path.name == ".gitkeep":
            continue
        servers[path.stem] = expand_home(tomllib.loads(path.read_text()), home_path)
    return servers


def detect_inline_secret(value: Any, context_key: str = "") -> bool:
    if isinstance(value, dict):
        for key, item in value.items():
            lowered = key.lower()
            if lowered == "env" and isinstance(item, dict):
                for env_key, env_value in item.items():
                    env_lower = env_key.lower()
                    if any(word in env_lower for word in SECRET_WORDS):
                        if isinstance(env_value, str) and env_value and not env_value.startswith("${"):
                            return True
                    if detect_inline_secret(env_value, env_key):
                        return True
            if any(word in lowered for word in SECRET_WORDS):
                if isinstance(item, str) and item and not item.startswith("${") and not BARE_ENV_RE.match(item):
                    return True
            if detect_inline_secret(item, key):
                return True
        return False
    if isinstance(value, list):
        return any(detect_inline_secret(item, context_key) for item in value)
    if isinstance(value, str):
        lowered = context_key.lower()
        if any(word in lowered for word in SECRET_WORDS):
            return bool(value) and not value.startswith("${") and not BARE_ENV_RE.match(value)
    return False


def discover_local_skill_relpaths(target_root: Path) -> list[str]:
    if not target_root.exists():
        return []
    relpaths: set[str] = set()
    for skill_file in target_root.rglob("SKILL.md"):
        relpaths.add(skill_file.parent.relative_to(target_root).as_posix())
    return sorted(relpaths)


def merge_mcp_maps(
    current_config: dict[str, Any],
    mcp_key: str,
    previous_names: list[str],
    managed_servers: dict[str, Any],
    manage_mcp: bool,
) -> dict[str, Any]:
    merged = deepcopy(current_config)
    if not manage_mcp:
        return merged
    existing = deepcopy(merged.get(mcp_key, {}))
    if not isinstance(existing, dict):
        existing = {}
    for previous_name in previous_names:
        existing.pop(previous_name, None)
    for name, definition in managed_servers.items():
        existing[name] = definition
    merged[mcp_key] = existing
    return merged


def merge_opencode_skill_paths(
    current_config: dict[str, Any],
    previous_paths: list[str],
    current_path: str | None,
    manage_skills: bool,
) -> dict[str, Any]:
    merged = deepcopy(current_config)
    if not manage_skills:
        return merged
    section = deepcopy(merged.get("skills", {}))
    if not isinstance(section, dict):
        section = {}
    existing_paths = section.get("paths", [])
    if not isinstance(existing_paths, list):
        existing_paths = []
    preserved_paths = [item for item in existing_paths if item not in previous_paths]
    if current_path and current_path not in preserved_paths:
        preserved_paths.append(current_path)
    if preserved_paths:
        section["paths"] = preserved_paths
        merged["skills"] = section
    return merged


def load_current_config(client: str, config_path: Path) -> dict[str, Any]:
    if not config_path.exists():
        return {}
    config_format = CLIENT_DEFAULTS[client]["config_format"]
    if config_format == "toml":
        return load_toml_file(config_path)
    return load_json_file(config_path)


def render_config(client: str, config: dict[str, Any]) -> str:
    config_format = CLIENT_DEFAULTS[client]["config_format"]
    if config_format == "toml":
        return dump_toml(config)
    return json.dumps(config, indent=2, ensure_ascii=True) + "\n"


def build_report(
    client: str,
    scopes: set[str],
    skill_target_root: Path,
    config_path: Path,
    current_config: dict[str, Any],
    mcp_key: str,
    repo_skill_relpaths: list[str],
    repo_mcp_servers: dict[str, Any],
    previous_state: dict[str, Any],
) -> dict[str, Any]:
    report: dict[str, Any] = {
        "client": client,
        "target_root": str(skill_target_root.parent if skill_target_root.name == "skills" else skill_target_root),
        "scopes": sorted(scopes),
        "notes": [],
    }
    if "skills" in scopes:
        local_skills = discover_local_skill_relpaths(skill_target_root)
        repo_skills = sorted(repo_skill_relpaths)
        previous_skills = previous_state.get("managed_skill_relpaths", [])
        report["skills"] = {
            "repo_managed": repo_skills,
            "local_found": local_skills,
            "missing": sorted(set(repo_skills) - set(local_skills)),
            "extra_local": sorted(set(local_skills) - set(repo_skills)),
            "stale_managed": sorted(set(previous_skills) - set(repo_skills)),
        }
    if "mcp" in scopes:
        current_map = current_config.get(mcp_key, {})
        if not isinstance(current_map, dict):
            current_map = {}
        current_map = expand_home(current_map, str(Path.home()))
        repo_names = sorted(repo_mcp_servers)
        current_names = sorted(current_map)
        drift = []
        for name in sorted(set(repo_names) & set(current_names)):
            if canonicalize(current_map.get(name)) != canonicalize(repo_mcp_servers.get(name)):
                drift.append(name)
        inline_secret_servers = [
            name for name, definition in current_map.items() if detect_inline_secret(definition)
        ]
        report["mcp"] = {
            "config_path": str(config_path),
            "repo_managed": repo_names,
            "local_found": current_names,
            "missing": sorted(set(repo_names) - set(current_names)),
            "extra_local": sorted(set(current_names) - set(repo_names)),
            "drift": drift,
            "inline_secret_servers": sorted(inline_secret_servers),
        }
    return report


def build_plan(args: argparse.Namespace) -> dict[str, Any]:
    client_defaults = CLIENT_DEFAULTS[args.client]
    target_root = pathify(args.target_root or client_defaults["target_root"])
    repo_root = pathify(args.repo_root)
    scopes = {scope for scope in args.scopes.split(",") if scope}
    excluded_roots = json.loads(args.exclude_skill_roots_json)
    excluded_dir_names = json.loads(args.exclude_dir_names_json)

    if not client_defaults.get("apply_supported", True):
        return {
            "client": args.client,
            "supports_apply": False,
            "report": {
                "client": args.client,
                "notes": ["v1 does not sync ollama. Stub only."],
                "target_root": str(target_root),
                "scopes": sorted(scopes),
            },
        }

    skill_target_root = target_root / client_defaults["skill_relpath"]
    config_target_path = target_root / client_defaults["config_relpath"]
    state_target_path = target_root / client_defaults["state_relpath"]

    repo_skill_relpaths = collect_skill_relpaths(
        repo_root=repo_root,
        include_mirrors=args.include_mirrors,
        excluded_roots=excluded_roots,
        excluded_dir_names=excluded_dir_names,
    )
    repo_mcp_servers = collect_repo_mcp_servers(repo_root, str(Path.home()))

    previous_state = load_json_file(state_target_path)
    current_config = load_current_config(args.client, config_target_path)

    manage_skills = "skills" in scopes
    manage_mcp = "mcp" in scopes
    should_write_config = manage_mcp or (args.client == "opencode" and manage_skills)

    current_skill_root_entry = str(skill_target_root)
    previous_skill_root_entries = previous_state.get("managed_skill_paths_entries", [])

    merged_config = merge_mcp_maps(
        current_config=current_config,
        mcp_key=client_defaults["mcp_key"],
        previous_names=previous_state.get("managed_mcp_server_names", []),
        managed_servers=repo_mcp_servers,
        manage_mcp=manage_mcp,
    )
    if args.client == "opencode":
        merged_config = merge_opencode_skill_paths(
            current_config=merged_config,
            previous_paths=previous_skill_root_entries,
            current_path=current_skill_root_entry if repo_skill_relpaths else None,
            manage_skills=manage_skills,
        )

    next_state = {
        "version": 1,
        "client": args.client,
        "managed_skill_relpaths": repo_skill_relpaths if manage_skills else previous_state.get("managed_skill_relpaths", []),
        "managed_mcp_server_names": sorted(repo_mcp_servers) if manage_mcp else previous_state.get("managed_mcp_server_names", []),
        "managed_skill_paths_entries": (
            [current_skill_root_entry] if args.client == "opencode" and manage_skills and repo_skill_relpaths else []
        ),
    }

    remove_skill_relpaths = []
    if manage_skills:
        remove_skill_relpaths = sorted(
            set(previous_state.get("managed_skill_relpaths", [])) - set(repo_skill_relpaths)
        )

    report = build_report(
        client=args.client,
        scopes=scopes,
        skill_target_root=skill_target_root,
        config_path=config_target_path,
        current_config=current_config,
        mcp_key=client_defaults["mcp_key"],
        repo_skill_relpaths=repo_skill_relpaths,
        repo_mcp_servers=repo_mcp_servers,
        previous_state=previous_state,
    )

    return {
        "client": args.client,
        "supports_apply": True,
        "target_root": str(target_root),
        "skill_target_root": str(skill_target_root),
        "config_target_path": str(config_target_path),
        "state_target_path": str(state_target_path),
        "skill_relpaths": repo_skill_relpaths,
        "remove_skill_relpaths": remove_skill_relpaths,
        "managed_mcp_server_names": sorted(repo_mcp_servers),
        "should_write_config": should_write_config,
        "rendered_config_content": render_config(args.client, merged_config) if should_write_config else "",
        "rendered_state_content": json.dumps(next_state, indent=2, ensure_ascii=True) + "\n",
        "report": report,
    }


def main() -> int:
    args = parse_args()
    if args.command == "plan":
        print(json.dumps(build_plan(args), indent=2, ensure_ascii=True))
        return 0
    raise RuntimeError(f"Unsupported command: {args.command}")


if __name__ == "__main__":
    sys.exit(main())
