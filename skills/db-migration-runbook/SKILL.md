---
name: db-migration-runbook
description: End-to-end PostgreSQL migration runbook for Cloud-Neutral Toolkit (backup/restore, stop-write, and online migration), including containerized Postgres steps and troubleshooting.
metadata:
  short-description: PostgreSQL migration runbook
---

# DB Migration Runbook Skill

Use this skill when the user asks for PostgreSQL migration guidance, runbooks, or operational steps for Cloud-Neutral Toolkit databases (`account`, `knowledge_db`, `postgres`).

## Scope
- Containerized PostgreSQL (`docker exec postgresql-svc-plus`)
- Source/target host migrations
- **Backup/Restore**
- **Stop-write migration** (short maintenance window, consistent)
- **Online migration** (full copy + incremental sync)
- Troubleshooting `pg_dump` with `pg_jieba`/FTS configs

## Workflow
1) **Confirm scope**: source host, target host, DB list, write window.
2) **Pre-flight**: confirm Postgres versions, extensions (`vector`, `pg_jieba`, `hstore`).
3) **Choose migration mode**: backup/restore, stop-write, or online.
4) **Execute** with `docker exec postgresql-svc-plus` steps.
5) **Validate** sizes, row counts, app checks.
6) **Rollback plan** documented.

## Known Issue: `pg_dump` crash on `jieba_search`
If `pg_dump` fails on `pg_ts_config_map`:
- Drop `documents.content_tsv`
- Drop `jieba_search` config
- Dump schema + data
- Restore
- Recreate `jieba_search` and `content_tsv`

## References
- Runbook: `docs/operations-governance/db-migration-runbook.md`

