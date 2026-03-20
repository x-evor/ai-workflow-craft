# MCP Servers Catalog

## Summary

| Source | Path Pattern | Count | Notes |
| --- | --- | ---: | --- |
| OpenCode user config | `MCP/servers/*.toml` | 5 | One file per server extracted from `~/.opencode/config.toml` |
| WorkBuddy extracted configs | `MCP/servers/workbuddy-*.json` | 9 | One file per discovered server from `mcp.json` or `.mcp.json` |

## OpenCode MCP Records

| Server | Path | Format |
| --- | --- | --- |
| chrome-devtools | `MCP/servers/chrome-devtools.toml` | TOML |
| github | `MCP/servers/github.toml` | TOML |
| next-devtools | `MCP/servers/next-devtools.toml` | TOML |
| onwalk-site | `MCP/servers/onwalk-site.toml` | TOML |
| ssh-manager | `MCP/servers/ssh-manager.toml` | TOML |

## WorkBuddy MCP Records

| Server Record | Path |
| --- | --- |
| design-converter | `MCP/servers/workbuddy-_workbuddy__plugins__marketplaces__cb_teams_marketplace__plugins__design-to-code___mcp_json-design-converter.json` |
| akshare-one-mcp | `MCP/servers/workbuddy-_workbuddy__plugins__marketplaces__cb_teams_marketplace__plugins__lseg___mcp_json-akshare-one-mcp.json` |
| repomix | `MCP/servers/workbuddy-_workbuddy__plugins__marketplaces__codebuddy-plugins-official__external_plugins__repomix-mcp___mcp_json-repomix.json` |
| task-master-ai | `MCP/servers/workbuddy-_workbuddy__plugins__marketplaces__codebuddy-plugins-official__external_plugins__taskmaster__mcp_json-task-master-ai.json` |
| lexiang (plugin) | `MCP/servers/workbuddy-_workbuddy__plugins__marketplaces__codebuddy-plugins-official__plugins__lexiang-knowledge-plugins__skills__lexiang-knowledge-base__mcp_json-lexiang.json` |
| context7 | `MCP/servers/workbuddy-_workbuddy__plugins__marketplaces__codebuddy-plugins-official__plugins__oh-my-codebuddy__mcp___mcp_json-context7.json` |
| grep_app | `MCP/servers/workbuddy-_workbuddy__plugins__marketplaces__codebuddy-plugins-official__plugins__oh-my-codebuddy__mcp___mcp_json-grep_app.json` |
| testbuddy_tools | `MCP/servers/workbuddy-_workbuddy__plugins__marketplaces__codebuddy-plugins-official__plugins__testbuddy___mcp_json-testbuddy_tools.json` |
| lexiang (marketplace) | `MCP/servers/workbuddy-_workbuddy__skills-marketplace__skills__lexiang-knowledge-base__mcp_json-lexiang.json` |

## Notes

| Topic | Note |
| --- | --- |
| File model | Each file is a single extracted server record to simplify comparison and later curation |
| Sanitization | Absolute home paths were normalized to `${HOME}` where extraction logic touched them |
| Review priority | Review WorkBuddy-derived records before publishing; some contain service URLs and env-var placeholders |
