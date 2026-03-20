# VPS/Vhost Read-Only Inspection Checklist

Use this checklist when the user wants a real inspection over SSH. Start compact, then add deeper commands only when the first pass shows pressure or anomalies.

## Baseline Commands

Run these first on each host:

```bash
hostname
date -Is
uname -a
uptime
systemctl is-system-running || true
systemctl list-units --type=service --state=running --no-pager --plain
systemctl --failed --no-pager --plain || true
df -hT / /var /tmp /home 2>/dev/null
df -ih / /var /tmp /home 2>/dev/null
free -h
ps -eo pid,comm,%cpu,%mem --sort=-%mem | head -n 12
ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 12
ss -tulpn | head -n 30
ip -br addr
ip route
```

## Service-Focused Checks

Use when the user names specific services or when the box is `degraded`:

```bash
systemctl --no-pager --full status xray.service xray-tcp.service caddy.service haproxy.service agent-svc-plus.service
journalctl -u xray.service -u xray-tcp.service -u caddy.service -u haproxy.service -u agent-svc-plus.service --since '2 hours ago' --no-pager
```

Adapt the unit names to the target host. If the session is non-root, prepend `sudo -n` when needed and only if it is available.

## Docker Checks

Use when Docker is installed or containers are part of the runtime:

```bash
docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'
docker system df
du -xhd1 /var/lib/docker 2>/dev/null | sort -h | tail -n 20
```

Interpretation notes:

- `docker system df` is better than raw `du` for reclaimable image and build-cache estimates.
- Do not infer that volumes are safe to delete just because they are large.

## Disk Growth Checks

Use when the user asks about safe cleanup or disk pressure:

```bash
journalctl --disk-usage || true
du -sh /var/cache/apt /var/lib/apt/lists 2>/dev/null
du -xhd1 /var 2>/dev/null | sort -h
du -xhd1 /root 2>/dev/null | sort -h
du -xhd1 /home/"$USER" 2>/dev/null | sort -h
du -sh /var/log/journal /var/log/*.log 2>/dev/null | sort -h | tail -n 20
```

Focus on these low-risk reclaimable sources first:

- journal archives
- package-manager caches
- unused Docker images
- Docker build cache
- obvious user cache directories

## Cleanup Commands To Recommend, Not Execute By Default

Only provide these when the user asks for safe cleanup guidance:

```bash
journalctl --vacuum-time=7d
apt-get clean
rm -rf /var/lib/apt/lists/*
docker image prune -a -f
docker builder prune -a -f
```

Do not recommend automated deletion of:

- Docker volumes
- database paths
- application data under `/var/lib`
- uploads, backups, or unknown archives

## Reporting Template

For each host, summarize:

1. Access status
2. Core services and whether they are active
3. Failed units and whether they matter
4. Disk, inode, and memory pressure
5. Network listeners and routes
6. Docker runtime state
7. Safe cleanup candidates and estimated reclaimable space
8. Risks that need manual follow-up
