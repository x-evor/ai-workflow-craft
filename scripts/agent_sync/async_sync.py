#!/usr/bin/env python3
"""Asynchronous wrapper for repo -> client agent sync.

Usage:
  python3 scripts/agent_sync/async_sync.py start
  python3 scripts/agent_sync/async_sync.py status

The `start` command returns immediately and spawns a detached worker that runs
the existing ansible sync playbook in the background. UI code can wire a
"Refresh / Sync" button to `start`, then poll `status` until `running=false`.
"""

from __future__ import annotations

import argparse
import datetime as dt
import json
import os
import signal
import subprocess
import sys
from pathlib import Path
from typing import Any


SCRIPT_PATH = Path(__file__).resolve()
REPO_ROOT = SCRIPT_PATH.parents[2]
DEFAULT_STATE_DIR = Path.home() / ".cache" / "ai-workflow-craft" / "agent-sync"


def utc_now() -> str:
    return dt.datetime.now(dt.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def is_pid_running(pid: int | None) -> bool:
    if not pid:
        return False
    try:
        os.kill(pid, 0)
    except OSError:
        return False
    return True


def state_paths(state_dir: Path) -> dict[str, Path]:
    return {
        "meta": state_dir / "sync-status.json",
        "log": state_dir / "sync.log",
    }


def load_meta(meta_path: Path) -> dict[str, Any]:
    if not meta_path.exists():
        return {
            "running": False,
            "pid": None,
            "started_at": None,
            "finished_at": None,
            "exit_code": None,
            "log_path": str(meta_path.with_name("sync.log")),
            "clients": [],
            "scopes": [],
            "include_mirrors": False,
            "command": [],
        }
    return json.loads(meta_path.read_text())


def write_meta(meta_path: Path, payload: dict[str, Any]) -> None:
    meta_path.parent.mkdir(parents=True, exist_ok=True)
    meta_path.write_text(json.dumps(payload, indent=2, ensure_ascii=False) + "\n")


def build_ansible_command(clients: list[str], scopes: list[str], include_mirrors: bool) -> list[str]:
    extra_vars = {
        "agent_sync_clients": clients,
        "agent_sync_scopes": scopes,
        "agent_sync_include_mirrors": include_mirrors,
    }
    return [
        "ansible-playbook",
        "-i",
        "localhost,",
        "-c",
        "local",
        "ansible/playbooks/sync_agent_clients.yml",
        "-e",
        json.dumps(extra_vars, separators=(",", ":")),
    ]


def command_status(state_dir: Path) -> int:
    paths = state_paths(state_dir)
    meta = load_meta(paths["meta"])
    if meta.get("running") and not is_pid_running(meta.get("pid")):
        meta["running"] = False
        meta["finished_at"] = meta.get("finished_at") or utc_now()
        meta["exit_code"] = meta.get("exit_code", 1)
        write_meta(paths["meta"], meta)
    print(json.dumps(meta, indent=2, ensure_ascii=False))
    return 0


def command_start(state_dir: Path, clients: list[str], scopes: list[str], include_mirrors: bool) -> int:
    paths = state_paths(state_dir)
    current = load_meta(paths["meta"])
    if current.get("running") and is_pid_running(current.get("pid")):
        print(json.dumps(current, indent=2, ensure_ascii=False))
        return 0

    worker_cmd = [
        sys.executable,
        str(SCRIPT_PATH),
        "_run",
        "--state-dir",
        str(state_dir),
        "--clients",
        ",".join(clients),
        "--scopes",
        ",".join(scopes),
    ]
    if include_mirrors:
        worker_cmd.append("--include-mirrors")

    process = subprocess.Popen(
        worker_cmd,
        cwd=REPO_ROOT,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        stdin=subprocess.DEVNULL,
        start_new_session=True,
    )

    meta = {
        "running": True,
        "pid": process.pid,
        "started_at": utc_now(),
        "finished_at": None,
        "exit_code": None,
        "log_path": str(paths["log"]),
        "clients": clients,
        "scopes": scopes,
        "include_mirrors": include_mirrors,
        "command": build_ansible_command(clients, scopes, include_mirrors),
    }
    write_meta(paths["meta"], meta)
    print(json.dumps(meta, indent=2, ensure_ascii=False))
    return 0


def command_run(state_dir: Path, clients: list[str], scopes: list[str], include_mirrors: bool) -> int:
    paths = state_paths(state_dir)
    meta = load_meta(paths["meta"])
    meta.update(
        {
            "running": True,
            "pid": os.getpid(),
            "started_at": meta.get("started_at") or utc_now(),
            "finished_at": None,
            "exit_code": None,
            "log_path": str(paths["log"]),
            "clients": clients,
            "scopes": scopes,
            "include_mirrors": include_mirrors,
            "command": build_ansible_command(clients, scopes, include_mirrors),
        }
    )
    write_meta(paths["meta"], meta)

    env = os.environ.copy()
    env["ANSIBLE_CONFIG"] = str(REPO_ROOT / "ansible" / "playbooks" / "ansible.cfg")
    command = meta["command"]

    with paths["log"].open("a", encoding="utf-8") as log_file:
        log_file.write(f"[{utc_now()}] start {' '.join(command)}\n")
        log_file.flush()
        process = subprocess.run(
            command,
            cwd=REPO_ROOT,
            env=env,
            stdout=log_file,
            stderr=subprocess.STDOUT,
            check=False,
        )
        log_file.write(f"[{utc_now()}] exit {process.returncode}\n")

    meta["running"] = False
    meta["finished_at"] = utc_now()
    meta["exit_code"] = process.returncode
    write_meta(paths["meta"], meta)
    return process.returncode


def parse_csv(value: str) -> list[str]:
    return [item.strip() for item in value.split(",") if item.strip()]


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Async wrapper for agent sync")
    parser.add_argument("command", choices=["start", "status", "_run"])
    parser.add_argument("--state-dir", default=str(DEFAULT_STATE_DIR))
    parser.add_argument("--clients", default="codex,gemini,claude,opencode")
    parser.add_argument("--scopes", default="skills,mcp")
    parser.add_argument("--include-mirrors", action="store_true")
    return parser


def main() -> int:
    args = build_parser().parse_args()
    state_dir = Path(args.state_dir).expanduser().resolve()
    clients = parse_csv(args.clients)
    scopes = parse_csv(args.scopes)

    if args.command == "status":
        return command_status(state_dir)
    if args.command == "start":
        return command_start(state_dir, clients, scopes, args.include_mirrors)
    return command_run(state_dir, clients, scopes, args.include_mirrors)


if __name__ == "__main__":
    raise SystemExit(main())
