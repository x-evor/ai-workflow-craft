# Xworkmate Prompt Templates

Use these when the user wants the inspection packaged into prompts for Xworkmate or another execution agent. Replace the placeholders with the real user, host, and service list.

## Read-Only Inspection Prompt

```text
通过 SSH 连接 <ssh_user>@<host>，只做只读检查，不要修改任何文件和配置，不要重启服务。

检查目标：
1. 系统状态
2. 运行中的服务
3. 失败的 systemd units
4. 存储占用
5. 内存和 CPU
6. 网络监听和路由
7. Docker 容器与 Docker 空间占用
8. 可安全清理的空间估算

请依次执行并汇总结果：
- hostname
- date -Is
- uname -a
- uptime
- systemctl is-system-running || true
- systemctl list-units --type=service --state=running --no-pager --plain
- systemctl --failed --no-pager --plain || true
- systemctl --no-pager --full status <service_1> <service_2> <service_3>
- df -hT / /var /tmp /home 2>/dev/null
- df -ih / /var /tmp /home 2>/dev/null
- free -h
- ps -eo pid,comm,%cpu,%mem --sort=-%mem | head -n 12
- ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 12
- ss -tulpn | head -n 30
- ip -br addr
- ip route
- docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'
- docker system df
- journalctl --disk-usage || true
- du -sh /var/cache/apt /var/lib/apt/lists 2>/dev/null
- du -xhd1 /var 2>/dev/null | sort -h
- du -sh /var/log/journal /var/log/*.log 2>/dev/null | sort -h | tail -n 20

输出要求：
- 先给一段结论摘要
- 再给详细结果
- 最后单独输出“安全可清理项”，只列低风险项目，不执行清理
- 明确标注任何异常，例如 failed units、404、磁盘或内存压力
```

## Non-Root With Sudo Prompt

```text
通过 SSH 连接 <ssh_user>@<host>，只做只读检查，不要修改任何文件和配置，不要重启服务。
如果需要查看 systemd 或 Docker 详情，可使用 sudo -n，但仍然禁止做任何变更。

对需要提权的命令自动加上 sudo -n，其余命令保持普通用户执行。
其余检查项和输出要求与只读检查模板一致。
```

## Safe Cleanup Execution Prompt

Only use this after the user explicitly asks to execute cleanup:

```text
通过 SSH 连接 <ssh_user>@<host>，执行低风险系统空间清理。
禁止修改业务配置，禁止停止或重启服务，禁止删除 Docker volumes，禁止删除正在使用的容器和镜像，禁止碰数据库数据。

只允许执行这些清理动作：
1. 清理 systemd journal 的旧日志，只保留 7 天
2. 清理 apt 缓存
3. 清理未使用的 Docker 镜像
4. 清理未使用的 Docker build cache

执行前先记录：
- df -hT /
- free -h
- docker system df
- journalctl --disk-usage || true

执行清理：
- journalctl --vacuum-time=7d
- apt-get clean
- rm -rf /var/lib/apt/lists/*
- docker image prune -a -f
- docker builder prune -a -f

执行后再次记录：
- df -hT /
- docker system df
- journalctl --disk-usage || true

输出要求：
- 给出执行前后对比
- 标注释放了多少磁盘空间
- 如果遇到任何可能影响业务的项目，停止并报告，不要继续扩大清理范围
```

## Adaptation Rules

- If the host rejects `root`, switch the prompt to the real login user and state whether `sudo -n` is allowed.
- Keep the service list short and host-specific.
- If the user asked for inspection only, do not include execution cleanup commands.
- If Docker is absent, remove the Docker steps instead of leaving failing commands in the prompt.
