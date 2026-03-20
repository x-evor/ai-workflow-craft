# Ansible Catalog

## Summary

| Area | Path | Count | Notes |
| --- | --- | ---: | --- |
| Top-level playbook files | `ansible/playbooks/` | 77 | Mixed YAML playbooks, helper files, and shell entrypoints |
| Top-level playbook subdirs | `ansible/playbooks/` | 8 | `deepflow`, `docs`, `group_vars`, `inventory`, `roles`, `scripts`, `skills`, `vars` |
| Imported role groups | `ansible/playbooks/roles/` | 5 | `charts`, `docker`, `github`, `grafana-dashboard`, `vhosts` |
| Local config-center roles | `ansible/roles/` | 1 | `agent_sync` for repo-to-client sync and scan |

## Config-Center Entry Points

| Playbook | Path | Purpose |
| --- | --- | --- |
| `sync_agent_clients.yml` | `ansible/playbooks/sync_agent_clients.yml` | Apply repo-managed `skills/` and curated `MCP/servers/*.toml` into supported local clients |
| `scan_agent_clients.yml` | `ansible/playbooks/scan_agent_clients.yml` | Scan local clients for drift, extra local config, and inline secret warnings |

| Role | Path | Purpose |
| --- | --- | --- |
| `agent_sync` | `ansible/roles/agent_sync/` | Normalize repo assets, render per-client config, apply copies, and produce scan reports |

## Top-Level Playbook Areas

| Entry | Path | Type | Notes |
| --- | --- | --- | --- |
| deepflow | `ansible/playbooks/deepflow/` | directory | Deepflow-specific playbooks and nested roles |
| docs | `ansible/playbooks/docs/` | directory | Playbook documentation |
| group_vars | `ansible/playbooks/group_vars/` | directory | Shared group vars |
| inventory | `ansible/playbooks/inventory/` | directory | Inventory-related files |
| roles | `ansible/playbooks/roles/` | directory | Main role library |
| scripts | `ansible/playbooks/scripts/` | directory | Playbook support scripts |
| skills | `ansible/playbooks/skills/` | directory | Skill artifacts colocated with playbooks |
| vars | `ansible/playbooks/vars/` | directory | Variable sets |

## Representative Playbooks

| Playbook | Path | Theme |
| --- | --- | --- |
| `deploy_grafana_docker.yaml` | `ansible/playbooks/deploy_grafana_docker.yaml` | Docker service deployment |
| `deploy_nginx_vhosts.yml` | `ansible/playbooks/deploy_nginx_vhosts.yml` | Vhost deployment |
| `init_k3s_cluster_server` | `ansible/playbooks/init_k3s_cluster_server` | K3s cluster bootstrap |
| `init_vault` | `ansible/playbooks/init_vault` | Secret infrastructure bootstrap |
| `init_vpn_gateway.yml` | `ansible/playbooks/init_vpn_gateway.yml` | VPN bootstrap |
| `setup-docker.yml` | `ansible/playbooks/setup-docker.yml` | Host setup |
| `vpn-wireguard-hub.yaml` | `ansible/playbooks/vpn-wireguard-hub.yaml` | VPN overlay |

## Role Groups

| Role Group | Path | Notes |
| --- | --- | --- |
| charts | `ansible/playbooks/roles/charts/` | Helm and Kubernetes chart roles |
| docker | `ansible/playbooks/roles/docker/` | Docker-compose style service roles |
| github | `ansible/playbooks/roles/github/` | GitHub repo/ruleset automation |
| grafana-dashboard | `ansible/playbooks/roles/grafana-dashboard/` | Dashboard assets |
| vhosts | `ansible/playbooks/roles/vhosts/` | Traditional host and service roles |

## Notes

| Topic | Note |
| --- | --- |
| Structure | `ansible/playbooks/` is already a self-contained imported project, not just a small playbook folder |
| Config center | `ansible/roles/agent_sync/` and the new sync/scan playbooks make this repo a local config center for Codex, Gemini, Claude, and Opencode |
| Check mode | The sync workflow is designed to run with `ansible-playbook -C -D` against temporary target roots before applying to real home directories |
| Public review | Review embedded templates and sample configs before publishing broadly |
