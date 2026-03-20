---
name: "github-action-conventions"
description: "Use when creating, reviewing, or refactoring GitHub Actions workflows. Enforces workflow rules for structure, script extraction, reuse, security, and maintainability."
---

# GitHub Actions Conventions

## Hard Rules

1. Do not embed Python, shell, or Node exec logic directly inside workflow YAML for primary job logic.
   - Do not place substantial business logic inside `run: |` blocks.
   - Do not use inline `python - <<'PY'`, `node -e`, or complex shell heredocs for core workflow behavior.
   - Primary logic must be referenced from external scripts, Make targets, package scripts, or repository tooling files.

2. Workflows orchestrate. They do not implement.
   - A workflow step should describe what is being invoked, not contain the full implementation.
   - Complex behavior belongs in `scripts/`, existing CLIs, `Makefile`, or project task entrypoints.

3. Prefer reuse over custom inline logic.
   - Use official actions when they fit.
   - Reuse existing repository scripts instead of rewriting equivalent logic in workflow YAML.

4. Secrets, tokens, and sensitive configuration must flow through GitHub Secrets, Variables, or OIDC.
   - Never hardcode sensitive values in workflow YAML, shell strings, or echoed output.

5. Every workflow must remain readable, auditable, and locally reproducible.
   - Step names must be explicit.
   - Referenced script paths must be stable.
   - Local execution paths should match CI behavior as closely as possible.

## Recommended Layout

- Keep orchestration in `.github/workflows/*.yml`
- Keep implementation in repository-owned entrypoints such as:
  - `scripts/*.sh`
  - `scripts/*.py`
  - `scripts/*.ts`
  - `Makefile`
  - `package.json` scripts

## Review Checklist

- Is substantial logic hidden inside `run: |`?
- Does the workflow use `python - <<'PY'`, `node -e`, or long shell heredocs?
- Is the workflow duplicating logic that already exists in repository scripts?
- Are secrets injected only through approved secure channels?
- Are step names, failure points, and data flow easy to understand?

## Default Refactor Strategy

When a workflow contains too much inline logic, refactor in this order:

1. Extract the logic into a repository script
2. Give the script stable inputs and outputs
3. Replace the workflow body with a simple invocation
4. Add minimal comments only when the orchestration intent is not obvious

## Exceptions

- Simple one-line to three-line commands may remain in `run:`
- Version printing, environment inspection, and invocation of a single existing command may remain inline
- Once the logic includes branching, looping, JSON processing, file generation, network requests, or recovery logic, extract it
