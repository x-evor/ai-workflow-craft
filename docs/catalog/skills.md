# Skills Catalog

## Summary

| Source | Path | Count | Notes |
| --- | --- | ---: | --- |
| Codex system skills | `skills/.system/` | 3 | Built-in system-oriented skills mirrored from local Codex home |
| Codex custom skills | `skills/` top level | 13 | Direct skills such as `figma`, `playwright`, `makefile`, `vercel-deploy` |
| WorkBuddy local skills | `skills/workbuddy-local/` | 13 | Closest match to actively linked local WorkBuddy skills |
| WorkBuddy marketplace mirror | `skills/workbuddy-marketplace/` | 45 | Local mirror only, default excluded from commits |
| WorkBuddy plugin mirror | `skills/workbuddy-plugins/` | 508 imported `SKILL.md` directories | Local mirror only, default excluded from commits |

## Top-Level Layout

| Group | Path | Shape | Notes |
| --- | --- | --- | --- |
| System | `skills/.system/` | nested skill dirs | `openai-docs`, `skill-creator`, `skill-installer` |
| Direct custom skills | `skills/<skill-name>/` | one dir per skill | Core personal skill set |
| WorkBuddy local | `skills/workbuddy-local/` | nested skill dirs | Local skills resolved from direct folders and symlinks |
| WorkBuddy marketplace | `skills/workbuddy-marketplace/` | nested skill dirs | Local mirror of marketplace package contents, not part of default commit scope |
| WorkBuddy plugins | `skills/workbuddy-plugins/` | nested marketplace trees | Local plugin mirror, not part of default commit scope |

## Direct Custom Skills

| Skill | Path |
| --- | --- |
| architect-orchestrator | `skills/architect-orchestrator/` |
| calm_compact_workspace_system | `skills/calm_compact_workspace_system/` |
| db-migration-runbook | `skills/db-migration-runbook/` |
| figma | `skills/figma/` |
| gh-fix-ci | `skills/gh-fix-ci/` |
| git-history-secret-remediation | `skills/git-history-secret-remediation/` |
| github-action-conventions | `skills/github-action-conventions/` |
| makefile | `skills/makefile/` |
| openai-docs | `skills/openai-docs/` |
| playwright | `skills/playwright/` |
| security-best-practices | `skills/security-best-practices/` |
| vercel-deploy | `skills/vercel-deploy/` |
| vps-vhost-inspection | `skills/vps-vhost-inspection/` |
| xstream-functional-test-baseline | `skills/xstream-functional-test-baseline/` |
| xworkmate-acceptance | `skills/xworkmate-acceptance/` |
| xworkmate-secure-development | `skills/xworkmate-secure-development/` |

## WorkBuddy Local Skills

| Skill | Path |
| --- | --- |
| browser-automation | `skills/workbuddy-local/browser-automation/` |
| docx | `skills/workbuddy-local/docx/` |
| find-skills | `skills/workbuddy-local/find-skills/` |
| github | `skills/workbuddy-local/github/` |
| gog | `skills/workbuddy-local/gog/` |
| notebooklm | `skills/workbuddy-local/notebooklm/` |
| pdf | `skills/workbuddy-local/pdf/` |
| playwright-cli | `skills/workbuddy-local/playwright-cli/` |
| pptx | `skills/workbuddy-local/pptx/` |
| skill-creator | `skills/workbuddy-local/skill-creator/` |
| workbuddy-channel-setup | `skills/workbuddy-local/workbuddy-channel-setup/` |
| xiaohongshu | `skills/workbuddy-local/xiaohongshu/` |
| xlsx | `skills/workbuddy-local/xlsx/` |

## Curation Notes

| Topic | Recommendation |
| --- | --- |
| Public sharing | Curate from `skills/` and `skills/workbuddy-local/` first |
| Marketplace mirrors | Treat `workbuddy-marketplace` and `workbuddy-plugins` as local source archives and keep them out of normal commits |
| Default sync scope | The config-center sync layer excludes mirror/cache roots unless `agent_sync_include_mirrors=true` is set |
| Future cleanup | Add a later `skills/curated/` layer when active skills are finalized |
