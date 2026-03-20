# ai-workflow-craft

Methods, patterns, and reusable assets for building practical AI workflows.

This repository is a working library of:

- `skills/` for agent capabilities and prompt workflows
- `MCP/servers/` for MCP server config records
- `ansible/playbooks/` for operational automation
- `iac/modules/` for infrastructure modules and supporting assets

It also acts as the local configuration center for selected agent clients. The canonical sources are:

- `skills/` for managed skill directories
- `MCP/servers/` for managed MCP server records

The v1 sync layer pushes those sources to local client homes with Ansible in one direction only: `repo -> clients`.

## Repository Map

| Area | Path | Current Shape | Index |
| --- | --- | --- | --- |
| Skills | `skills/` | Codex skills, local WorkBuddy skills, plus imported marketplace/plugin mirrors | [docs/catalog/skills.md](docs/catalog/skills.md) |
| MCP Servers | `MCP/servers/` | OpenCode MCP configs plus extracted WorkBuddy MCP records | [docs/catalog/mcp-servers.md](docs/catalog/mcp-servers.md) |
| Ansible | `ansible/playbooks/` | Playbooks, inventory, vars, scripts, and grouped roles | [docs/catalog/ansible.md](docs/catalog/ansible.md) |
| IaC | `iac/modules/` | Terraform, Pulumi, examples, scripts, VPN overlay, and supporting docs | [docs/catalog/iac-modules.md](docs/catalog/iac-modules.md) |
| Documentation | `docs/` | Workflow notes plus repository inventory indexes | [docs/README.md](docs/README.md) |

## Config Center

| Entry | Path | Purpose |
| --- | --- | --- |
| Sync playbook | `ansible/playbooks/sync_agent_clients.yml` | Apply repo-managed `skills/` and `MCP/servers/` into local clients |
| Scan playbook | `ansible/playbooks/scan_agent_clients.yml` | Compare repo state against local clients and emit drift/import findings |
| Sync docs | `ansible/docs/agent-sync.md` | Variables, supported clients, and example commands |

Supported v1 clients:

- `codex`
- `gemini`
- `claude`
- `opencode`
- `ollama` stub only, no real writes yet

Default sync behavior:

- copies files, never symlinks
- excludes mirror/cache skill roots such as `skills/workbuddy-marketplace/` and `skills/workbuddy-plugins/`
- keeps repo as source of truth
- preserves unrelated config outside managed MCP entries and managed `skills.paths`

## Documentation

| Document | Purpose |
| --- | --- |
| [docs/README.md](docs/README.md) | Entry point for repository indexes |
| [docs/catalog/skills.md](docs/catalog/skills.md) | Skills inventory by source and top-level grouping |
| [docs/catalog/mcp-servers.md](docs/catalog/mcp-servers.md) | MCP server config inventory and source notes |
| [docs/catalog/ansible.md](docs/catalog/ansible.md) | Playbooks and role layout summary |
| [docs/catalog/iac-modules.md](docs/catalog/iac-modules.md) | IaC module layout summary |
| [ansible/docs/agent-sync.md](ansible/docs/agent-sync.md) | Config-center sync/scan workflow for local agent clients |

## Notes

| Topic | Note |
| --- | --- |
| Imported content | Some directories are synchronized from local tool workspaces and are not yet fully curated for public release. |
| Marketplace mirrors | `skills/workbuddy-marketplace/` and `skills/workbuddy-plugins/` are treated as local mirrors and default to not being committed. |
| MCP records | MCP files are normalized into one-record-per-server artifacts so they can be reviewed and curated later. Default sync only consumes curated `MCP/servers/*.toml` records. |
