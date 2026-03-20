---
name: vps-vhost-inspection
description: Inspect VPS, Vhost, or Linux server health over SSH. Use when the user asks to check running services, failed units, storage, inode usage, memory, CPU, network listeners, routes, Docker state, log growth, or safe disk cleanup on remote hosts. Also use when the user wants read-only server inspection reports or wants those checks converted into execution prompts for tools like Xworkmate.
---

# VPS Vhost Inspection

## Overview

Use this skill for remote Linux host inspection over SSH with an operations mindset. Default to read-only checks, identify the highest-signal risks, estimate reclaimable disk space from low-risk cleanup targets, and only provide cleanup commands unless the user explicitly asks you to execute them.

Read [references/checklist.md](references/checklist.md) when you need the concrete command set or the reporting layout. Read [references/xworkmate-prompts.md](references/xworkmate-prompts.md) when the user wants reusable prompts for another agent or app to run.

## Trigger Conditions

Use this skill when the user asks for any of the following:

- SSH inspection of VPS, Vhost, Linux VM, cloud instance, bastion, or server
- Service status checks for `systemd`, Docker containers, reverse proxies, databases, or custom daemons
- System capacity checks for disk, inode, memory, swap, CPU, load average, ports, interfaces, or routing
- Safe cleanup planning for journal logs, apt/yum caches, Docker images, build cache, temp files, or user caches
- Converting a proven inspection flow into prompts for Xworkmate or another execution agent

## Safety Rules

Default to these rules unless the user explicitly overrides them:

- Read-only first. Do not edit files, restart services, clear caches, prune images, or delete data during the inspection pass.
- Use the exact SSH user and host the user supplied. If that login is rejected and the host explicitly requires another user, report that clearly before continuing with the least-privilege read-only path.
- Never assume it is safe to remove Docker volumes, database files, application logs, or anything under data directories.
- Treat credentials, tokens, and config files as sensitive. Do not dump secret contents into the response.
- Prefer reversible, low-risk cleanup suggestions. High-risk cleanup requires a separate explicit approval step.

## Workflow

### 1. Confirm targets and access

- Identify each host and SSH user.
- If the user already gave a checklist, preserve it.
- If the user asked for "inspection only", do not execute cleanup.

### 2. Run the read-only inspection

Use the command set in [references/checklist.md](references/checklist.md). Prefer a compact first pass:

- hostname, date, kernel, uptime
- `systemctl is-system-running`
- running services and failed units
- status of the named business-critical services
- disk, inode, memory, top CPU and memory consumers
- interfaces, routes, listeners
- Docker containers and Docker disk usage when Docker is present
- journal size, package cache size, large directories under `/var` and the relevant user home

### 3. Interpret instead of dumping raw output

Prioritize the findings:

- Are the core services active?
- Is the host healthy, degraded, or under resource pressure?
- Are there failed units that explain the degraded state?
- Is memory tight because of no swap or a specific process?
- Is disk pressure caused by logs, package cache, Docker images, or user cache?
- Are the cleanup candidates actually low risk?

Call out warnings separately from confirmed outages. For example, an active service with periodic 404s or reverse-proxy cancellations is not the same as the service being down.

### 4. Recommend safe cleanup

Only recommend low-risk cleanup items by default:

- `journalctl --vacuum-time=7d` or another bounded retention target
- package-manager cache cleanup such as `apt-get clean`
- removing apt/yum metadata caches if appropriate
- `docker image prune -a` and `docker builder prune -a` only for unused images and build cache
- clearing obvious user cache directories when they are large and not business data

Do not recommend deleting:

- Docker volumes
- database directories
- application uploads
- unknown files under `/var/lib`
- active container logs without confirming the logging setup

### 5. Output format

For each host, report in this order:

1. Access status
2. Service summary
3. System summary
4. Storage summary
5. Memory and CPU summary
6. Network summary
7. Safe cleanup candidates with estimated reclaimable space
8. Risks or anomalies

If the user asked for prompts, generate copy-paste-ready prompts using [references/xworkmate-prompts.md](references/xworkmate-prompts.md) and adapt the SSH user, host, service names, and whether execution is read-only or cleanup-enabled.

## Common Judgments

- `degraded` with only unused failed units is lower risk than `degraded` with failed active business services.
- Low free memory with no swap is worth flagging even when the load average is low.
- A high `docker system df` reclaimable number is usually safe only for unused images and build cache, not volumes.
- Large journals and package caches are usually the safest first cleanup targets.
- Large `/root/.cache` or `/home/<user>/.cache` directories are usually safer than `/var/lib`.

## Examples

- "SSH 检查两台 VPS 的 xray、caddy、haproxy 状态，顺便看磁盘和内存，但不要修改。"
- "帮我巡检这个 Vhost 的存储、网络端口、Docker 占用，并给出安全清理建议。"
- "把这套 SSH 巡检流程整理成 Xworkmate 可以执行的 prompts。"
