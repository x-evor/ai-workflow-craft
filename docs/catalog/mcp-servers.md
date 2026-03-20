# MCP Servers Catalog

## Summary

| Source | Path Pattern | Count | Notes |
| --- | --- | ---: | --- |
| OpenCode user config | `MCP/servers/*.toml` | 5 | One file per server extracted from `~/.opencode/config.toml` |

## OpenCode MCP Records

| Server | Path | Format |
| --- | --- | --- |
| chrome-devtools | `MCP/servers/chrome-devtools.toml` | TOML |
| github | `MCP/servers/github.toml` | TOML |
| next-devtools | `MCP/servers/next-devtools.toml` | TOML |
| onwalk-site | `MCP/servers/onwalk-site.toml` | TOML |
| ssh-manager | `MCP/servers/ssh-manager.toml` | TOML |

## Notes

| Topic | Note |
| --- | --- |
| File model | Each file is a single extracted server record to simplify comparison and later curation |
| Sanitization | Absolute home paths were normalized to `${HOME}` where extraction logic touched them |
| Default sync scope | The config-center sync layer only renders curated `MCP/servers/*.toml` records by default |
| Vendor-specific records | `workbuddy-*.json` records are intentionally excluded from this repo and from default sync behavior |
