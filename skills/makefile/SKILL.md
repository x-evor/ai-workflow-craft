---
name: makefile
description: Create, refactor, and debug GNU Makefiles for local development and CI pipelines. Use when users ask to add or improve `Makefile` targets, fix dependency or ordering issues, standardize build/test/release commands, add self-documenting help output, or diagnose flaky/non-deterministic make behavior.
---

# Makefile

## Overview

Deliver robust Makefile changes with explicit dependency graphs, predictable shell behavior, and clear user-facing targets.
Prefer minimal and auditable edits over broad rewrites.

## Workflow

1. Detect current state.
- Locate root `Makefile` and any included files (`include`, `-include`).
- Identify existing variables, `.PHONY` declarations, target categories, and default goal.
- Confirm whether GNU Make features are safe to use in the repository environment.

2. Define target contract before editing.
- Specify required targets (for example: `help`, `build`, `test`, `lint`, `clean`, `run`).
- Specify inputs/outputs and ordering dependencies for each target.
- Keep behavior deterministic (avoid hidden state and implicit side effects).

3. Implement with safe defaults.
- Set `SHELL := /bin/bash` only when bash-specific syntax is required.
- Use `.ONESHELL` only when multi-line shell state must be shared.
- Use explicit prerequisites and order-only prerequisites (`|`) when appropriate.
- Declare command-only targets under `.PHONY`.

4. Add discoverability.
- Provide a `help` target that lists stable targets and short descriptions.
- Keep target names short and action-oriented.

5. Validate.
- Run `make help`.
- Run the modified targets at least once.
- Use `make -n <target>` to inspect command plans when side effects are expensive.
- Use `make -d <target>` only for dependency debugging.

## Implementation Rules

- Use `?=` for overridable defaults.
- Use `:=` for immediate expansion when values should not change later.
- Use `=` for recursively expanded variables only when late evaluation is needed.
- Quote variables in shell commands when values may include spaces.
- Prefer reusable variables for tool commands (for example `GO ?= go`, `FLUTTER ?= flutter`).
- Keep recipe lines tab-indented.
- Avoid fragile wildcard behavior in destructive commands.

## Standard Snippets

```make
.PHONY: help
help: ## Show available targets
	@grep -E '^[a-zA-Z0-9_.-]+:.*?## ' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "%-20s %s\n", $$1, $$2}'
```

```make
.PHONY: build test lint clean

build: ## Build project artifacts
	$(MAKE) -C app build

test: ## Run tests
	$(MAKE) -C app test

lint: ## Run static checks
	$(MAKE) -C app lint

clean: ## Remove generated files
	rm -rf build dist
```

## Debug Checklist

- Confirm missing-target errors (`No rule to make target`) by tracing prerequisites.
- Confirm stale-output issues by checking file timestamps and target/file name collisions.
- Confirm parallel build safety before recommending `-j`.
- Confirm environment-specific failures by printing critical vars (`$(info VAR=$(VAR))`) during diagnosis.
