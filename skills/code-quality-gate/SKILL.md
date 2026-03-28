---
name: code-quality-gate
description: Use when the user asks for code quality scanning, static analysis, linting, test execution, or coverage reporting across Flutter/Dart, Go, or mixed-language repositories. Prefer Flutter official analyzer plus lint plus metrics, Go golangci-lint plus go test coverage, and Semgrep for cross-language rules and repo-wide security/code-pattern scanning.
---

# Code Quality Gate

## Overview

Run a practical engineering-grade quality pass for the current repository.

Use this skill when the user asks for any of these:

- code quality scan
- static analysis
- lint
- unit tests
- coverage report
- pre-merge quality gate
- repo health check
- cross-language scanning

Default tool stack:

- Flutter/Dart: `flutter analyze` + repo lints + metrics + `flutter test --coverage`
- Go: `golangci-lint run ./...` + `go test ./... -coverprofile=coverage.out`
- Cross-language or mixed repos: `semgrep scan --config auto`

Do not invent a custom tool stack when the repo already has one. Prefer repo-native commands first, then fill gaps with the defaults above.

## Workflow

### 1. Detect the stack

Check the repo before running anything:

- Flutter/Dart: `pubspec.yaml`, `analysis_options.yaml`, `lib/`, `test/`
- Go: `go.mod`, `*.go`, `.golangci.yml`, `.golangci.yaml`
- CI/tooling hints: `Makefile`, `justfile`, `taskfile.yml`, `.github/workflows/`

If the repo already defines a quality entrypoint such as `make lint`, `make test`, `just check`, or CI wrapper scripts, prefer that first and then supplement missing checks.

### 2. Verify tool availability

Preferred local prerequisites:

```bash
brew install semgrep
brew install golangci-lint
```

If a tool is missing:

- install it when the user explicitly asked for setup
- otherwise report the missing tool clearly
- do not modify repo dependencies just to make metrics work unless the user asked

### 3. Run the right checks

#### Flutter / Dart

Baseline:

```bash
flutter analyze
flutter test --coverage
```

If the repo already uses metrics tooling such as `dart_code_metrics`, run it too:

```bash
dart run dart_code_metrics:metrics analyze lib test
```

Rules:

- prefer the repo's existing `analysis_options.yaml`
- do not add new lint packages without approval
- if metrics tooling is absent, report that metrics are unavailable instead of silently adding it

Coverage:

```bash
lcov --summary coverage/lcov.info
```

If `lcov` is unavailable, report that raw coverage was generated but not summarized locally.

#### Go

Baseline:

```bash
golangci-lint run ./...
go test ./... -covermode=atomic -coverprofile=coverage.out
go tool cover -func=coverage.out
```

Rules:

- prefer the repo's existing `golangci` config
- do not weaken lints to force green results unless the user asked
- if the repo has multiple Go modules, run per module or use the repo-defined wrapper

#### Cross-language / Mixed repos

Use Semgrep as the common layer:

```bash
semgrep scan --config auto
```

For stricter CI-style gating, use:

```bash
semgrep scan --config auto --error
```

Use `--error` only when the user wants gate behavior. For exploratory scans, prefer plain output first.

## Reporting

Report in this order:

1. failing checks and actionable findings
2. coverage result
3. missing tools or blocked steps
4. exact commands run

Keep findings concrete:

- tool name
- file/path
- error or rule summary
- whether it is a blocker or advisory

For coverage, report:

- total line/function coverage when available
- whether the repo defines a threshold
- whether the result is only informational or should block

Do not invent a target threshold. Use the repo threshold if one exists; otherwise report the measured value only.

## Guardrails

- Prefer one command path per tool; avoid redundant duplicate scans.
- Do not auto-edit CI, lint configs, or thresholds unless the user asked for fixes.
- Do not claim coverage improved unless a new report proves it.
- If a tool crashes or the environment blocks execution, say so plainly and preserve the partial results.
