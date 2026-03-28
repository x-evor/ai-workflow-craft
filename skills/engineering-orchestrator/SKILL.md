---
name: "engineering-orchestrator"
description: "Use when the user wants Codex to act as a principal engineering orchestrator: keep GPT-5.4 on the main thread for core development, and delegate bounded testing, verification, documentation, review, and external execution subtasks through local subagents or external CLIs such as Ollama-launched integrations."
---

# Engineering Orchestrator

## Overview

Convert an ambiguous engineering request into an execution-ready multi-agent architecture brief.
Primary objective: multi-agent collaborative dispatch for software work.

Keep the semantics engineering-centered:

- requirements -> acceptance evidence
- architecture options -> ranked trade-offs
- implementation milestones -> critical path plus parallel slices
- review loop -> design/code review, fixes, verification, re-review

This skill is primarily a dispatch layer. When the user explicitly invokes `$engineering-orchestrator`, treat that as permission to decompose the work, assign parallel agent roles when useful, and run an independent review path.

Default output is a compact architecture plan plus agent topology, not a broad rewrite. Do not jump into large implementation until the plan is stable, unless the user explicitly asks to implement immediately.

## Main-Thread Ownership

Default posture:

- GPT-5.4 on the Codex main thread is the core developer and source of truth.
- Keep architecture decisions, repository-coupled implementation, final integration, and acceptance judgment on the main thread.
- Use external CLI subtasks to save tokens on bounded side work such as testing, documentation drafting, verification, review, critique, and report generation.
- Do not offload the primary implementation path to external CLIs unless the user explicitly wants that tradeoff.
- Do not let an external subtask become the authority on repository facts when the main thread can inspect those facts directly.

## Human-Readable Role Split

Use this plain-language split by default:

- GPT-5.4 main thread: core development and final judgment.
- `claude`, `codex`, `opencode`: code-related or verification-related external subtasks.
- `openclaw`: project-external execution subtasks such as consultation gathering, media publishing, and outbound operations.

When explaining the workflow to humans, prefer `main thread`, `external subtask`, and `parallel task`.

## Core Line

The main line of this skill is always:

1. Requirements -> Acceptance Evidence
2. Architecture Options Ranking
3. Implementation Milestones
4. Code/Design Review Loop

Multi-agent dispatch exists to advance this line, not to replace it.

## Workflow

1. Normalize the request.
- Extract goal, constraints, non-goals, affected surfaces, and migration pressure.
- Rewrite vague asks into testable requirements.
- Build a `Requirements -> Acceptance Evidence` map.
- Treat evidence as tests, UI checks, route behavior, logs, metrics, docs, or manual verification.

2. Generate and rank 2-4 architecture options.
- Compare simplicity, blast radius, reversibility, migration cost, and testability.
- Prefer the smallest change that preserves current user-visible behavior.
- Call out one recommended option and the reason it wins.
- Eliminate options that duplicate routes, duplicate shells, or add hidden state.

3. Freeze the architecture plan.
- Define module boundaries, interfaces, data flow, state ownership, and migration steps.
- Convert run order into implementation milestones:
  1. foundation
  2. routing or composition
  3. behavior migration
  4. cleanup and old-path removal
  5. verification
- For each milestone, specify:
  - files or modules touched
  - blockers and dependencies
  - acceptance evidence
  - rollback or fallback path

4. Orchestrate execution through multiple agents.
- Keep the immediate blocking analysis local.
- Keep the critical-path engineering work on the GPT-5.4 main thread by default.
- Treat explicit invocation of this skill as explicit delegation intent.
- Default to a multi-agent plan when the task has parallelizable slices, independent questions, or a meaningful review subtask.
- Use a single-agent path only when the task is too small, too coupled, or entirely blocked on one critical-path step. If so, say why.
- Standard role split:
  - planner kept local
  - `explorer` agents for narrow codebase questions
  - `worker` agents for disjoint implementation slices
  - a separate reviewer agent for an independent critique
- Give each agent a concrete ownership boundary, expected deliverable, and non-overlapping write scope.
- Do not delegate the next blocking step if local progress depends on it.
- Prefer external CLI subtasks for peripheral work that reduces token pressure on the main thread:
  - test execution
  - build verification
  - documentation drafting
  - review or critique
  - evidence collection
- Keep the number of active agents small and purposeful. Prefer 2-4 clear parallel tasks over many weak ones.

5. Run the review loop.
- After each milestone or meaningful diff:
  - review against requirements and acceptance evidence
  - fix the highest-risk issues first
  - rerun verification
  - re-review until the requirement is satisfied or a blocker remains
- Review for:
  - requirement coverage
  - regression risk
  - route and shell duplication
  - migration completeness
  - test gaps
  - operational or security concerns

6. Close out with a decision record.
- Summarize the chosen design, rejected options, milestone status, evidence gathered, unresolved risks, and follow-up work.

## Output Contract

When the request is architectural, prefer this shape:

```markdown
# Architecture Brief

## Goal
## Requirements -> Acceptance Evidence
## Ranked Options
## Recommended Design
## Module Boundaries and Interfaces
## Implementation Milestones
## Agent Topology
## Delegation Plan
## Review Loop
## Risks and Rollback
```

Keep it compact. Optimize for fast execution, not slideware.

## Multi-Agent Contract

- This skill should actively look for safe parallelism.
- Planner: keep the source of truth for requirements, boundaries, and final integration local.
- Explorer: answer specific codebase questions; avoid code changes unless explicitly assigned.
- Worker A/B/...: implement disjoint slices with explicit file ownership.
- Reviewer: perform an independent pass on the plan or patch.
- Default sequence:
  1. local planner freezes requirements and options
  2. explorers answer unresolved codebase questions
  3. workers implement disjoint slices
  4. reviewer checks the combined result
  5. planner integrates, verifies, and decides whether another loop is needed
- Never assign the same file family to multiple workers.
- Review delegated results locally before integration.
- If parallelism is not justified, still emit an `Agent Topology` section that says `local-only` and explains why.

## External Agent Backends

This skill may route some work through external agent CLIs when that materially improves coverage, independence, or provider diversity.
Use external backends as workers or reviewers, not as the source of truth for repository facts.

Allowed backend families:
- local Codex agents via `spawn_agent`
- `opencode`
- `gemini`
- `ollama launch <integration>` such as `claude`, `opencode`, `codex`, or `openclaw`

### Local Ollama Dispatch

Use `ollama launch` when you want the orchestrator to delegate a bounded subtask to a local CLI-backed agent session.

Preferred flow:

1. Check that `ollama` is available with `command -v ollama`.
2. Check installed models with `ollama list`.
3. Prefer models in this order when the user has not asked for a specific one:
   1. `minimax-m2.7:cloud`
   2. `qwen3.5:cloud`
   3. `glm-5:cloud`
   4. `kimi-k2.5:cloud`
4. Launch the selected integration through Ollama in headless mode. Common `ollama launch` subcommands include `claude`, `codex`, `opencode`, and `openclaw`:

```bash
ollama launch <integration> --model <model> --yes -- -p "<self-contained task prompt>"
```

Use this external subtask pattern for:

- independent critique
- review-only subtasks
- long-running or provider-specific sessions
- bounded worker subtasks that do not need direct local code inspection

### Task Result Callback

For delegated Ollama subtasks that are expected to execute a concrete subtask, prefer a file-based callback over terminal-only output.

Required pattern:

1. Use a task id that is stable and sortable, for example `ui-verify-20260323-001`.
2. Write intermediate task results to the project-local temporary path, such as `tmp/codex-tasks/<task-id>/`.
3. Never create task-result files inside the project root unless they are the final archived report.
4. Prefer a filename that maps back to the task identity, for example:
   - `tmp/codex-tasks/<task-id>/<task-id>.md`
   - `tmp/codex-tasks/<task-id>/<task-id>-<slug>.md`
   - `tmp/codex-tasks/<task-id>/<task-name>-result.md`
5. If the parent session coordinates multiple delegated subtasks, keep a lightweight manifest in the same temp area, such as `tmp/codex-tasks/index.md`, that maps `task-id`, task name, backend, and output file.
6. The manifest should be append-friendly and table-shaped so multiple tasks can be correlated without overwriting each other.
7. Make the filename and manifest easy to correlate with the delegated subtask later.
8. Put these sections in the file:
   - scope
   - commands run
   - command results
   - findings
   - risks
   - follow-up or recommendation
9. Stop after writing the temp file. Do not wait for human confirmation.
10. The Codex parent session should read the markdown file back and use it as the source of truth for the delegated task.
11. Only the final, user-facing test archive document may be written to `docs/reports/`.

Task naming and archive rules:

- Use `task-id = <topic>-YYYYMMDD-NNN` for every delegated test or review subtask.
- Keep temp outputs in `tmp/codex-tasks/<task-id>/` and do not write intermediate results into the repo tree.
- Use `tmp/codex-tasks/index.md` as the shared manifest when multiple subtasks are running.
- Final archive documents must go to `docs/reports/` and should use a date-prefixed name, for example `docs/reports/YYYY-MM-DD-<topic>-report.md`.
- If the final archive document is derived from a temp result, copy the verified summary from the temp file instead of rewriting the conclusion from memory.

If the subtask is asked to produce a test outcome, treat "wrote the temp markdown file" as the primary completion signal. Terminal output is optional and advisory only.

Some `ollama launch` runs may return a mixed terminal transcript, for example a launcher status line, a `zsh: terminated` note, and then a human-readable summary from the delegated process. Treat that terminal text as advisory only. Do not mark the subtask complete from terminal output alone when the temp markdown file is expected. If the summary is readable but the expected callback file is missing, normalize the subtask as `callback_missing` with `evidence_source = terminal_only`.

If the model cannot write the file, report the failure explicitly and do not claim success.

When delegating a test or verification subtask, make the prompt end with an explicit callback requirement such as:

- write the result to `tmp/codex-tasks/<task-id>/<task-id>.md`
- verify the file exists and is non-empty before exiting
- if the file cannot be written, state that failure in the terminal summary

Recommended write-first prompt template:

```text
You are an independent verification executor.
First action: write a minimal result file to tmp/codex-tasks/<task-id>/<task-id>.md.
Do not continue with any other work until the file exists.
Then add the required sections: scope, commands run, command results, findings, risks, follow-up or recommendation.
If you cannot write the file, or if the file is empty after writing, stop and report the failure explicitly.
```

Use that pattern when the task depends on file-based callback validation, especially for `ollama launch` lanes where terminal summaries may be noisy or incomplete.

### Subagent Result Normalization

When the parent Codex session runs as the orchestrator and delegates 2-4 parallel `ollama launch` commands, treat those external subtasks as synthetic subagents with a normalized result contract.

Recommended topology:

1. Codex main thread owns:
   - task decomposition
   - task id assignment
   - launch command construction
   - callback file collection
   - final evidence merge
2. Each `ollama launch` command is one external subagent task.
3. Every external subtask must have:
   - `task-id`
   - `task-name`
   - `backend = ollama launch`
   - `model`
   - expected callback file path
4. The parent should maintain a shared manifest, usually `tmp/codex-tasks/index.md`, so multiple external subtasks can be tracked together.

Normalize each external subtask into a result object with these fields:

- `agent_id`
- `task_id`
- `task_name`
- `backend`
- `model`
- `command`
- `output_file`
- `status`
- `summary`
- `evidence_source`

Status values should be one of:

- `completed`
- `failed`
- `manual_follow_up`
- `callback_missing`
- `timed_out`

Evidence priority order:

1. callback markdown file
2. direct repository evidence such as tests, logs, or artifacts
3. terminal summary text
4. raw process exit state

If the external subtask produced a readable terminal summary but did not write the expected callback file, normalize it as:

- `status = callback_missing`
- `evidence_source = terminal_only`
- `summary` may be retained as advisory context, but it is not completion evidence
- the parent must not upgrade the subtask to `completed`

Do not silently upgrade that subtask to `completed`.

If the external subtask wrote a non-empty callback file successfully, the parent Codex session may treat that as equivalent to a completed subagent result and surface it in the same style as an internal subagent completion.

Practical pattern for three parallel Ollama subtasks:

1. `test-YYYYMMDD-001`
2. `build-YYYYMMDD-001`
3. `review-YYYYMMDD-001`

Each writes to:

- `tmp/codex-tasks/test-YYYYMMDD-001/test-YYYYMMDD-001.md`
- `tmp/codex-tasks/build-YYYYMMDD-001/build-YYYYMMDD-001.md`
- `tmp/codex-tasks/review-YYYYMMDD-001/review-YYYYMMDD-001.md`

The parent Codex thread then merges those three normalized subtask results with its own local result into the final acceptance summary.

Keep the prompt self-contained and include:

- goal
- constraints
- target files or scope
- expected deliverable
- acceptance criteria

Do not route secrets, tokens, or sensitive config contents through this external subtask.

Use an external backend when:
- the user explicitly asks for a provider or CLI
- you want an independent critique subtask separate from Codex subagents
- you need a long-running or provider-specific session outside the local agent graph
- you want model diversity for option ranking or review

Do not use an external backend when:
- the task is blocked on direct local code inspection
- the external subtask needs secrets or sensitive config contents
- the output would override direct tests, logs, or repository evidence

### Backend selection

1. Use local Codex agents for repository-coupled exploration, implementation, and final integration.
2. Use `opencode` when the user wants an external coding agent/session or a separate build subtask.
3. Use `gemini` for alternative critique, plan challenge, or summarization, preferably in non-interactive mode.
4. Use `ollama launch <integration>` when the user wants a specific integration or model bridge, including launching `claude` or `opencode` under an Ollama-selected model.
   - `openclaw` is a good fit for project-external execution subtasks such as consultation gathering, media publishing, outbound operations, and other off-repo tasks.
   - Default model preference order for delegated tasks: `minimax-m2.7:cloud`, `qwen3.5:cloud`, `glm-5:cloud`, `kimi-k2.5:cloud`.
   - Fall back to the next model when the preferred one is unavailable.

### Discovery

- Check command availability first with `command -v`.
- For Ollama-backed flows, check local models with `ollama list`.
- Prefer a model explicitly named by the user.
- Otherwise prefer an installed reasoning or coder model such as `qwen3-coder:*`, `deepseek-r1:*`, `gpt-oss:*`, or another available local/cloud Ollama model.

### Good uses

- architecture option generation
- adversarial design critique
- migration-risk review
- review checklist generation
- summarizing a plan for human approval
- project-external consultation or information gathering
- media publishing or outbound task execution
- non-repo operational subtasks that should stay outside the main coding thread

### Bad uses

- deciding codebase facts without direct code inspection
- owning the final plan
- receiving secrets, tokens, or sensitive configs

Keep external prompts self-contained. Include:
- goal
- constraints
- current architecture summary
- requested deliverable
- evaluation criteria

When the expected deliverable is a task report, include the output path explicitly and require the result to be written there.

### Command patterns

Prefer non-interactive or scriptable forms when possible.

Opencode:

```bash
opencode run --agent plan --model <provider/model> "Review this architecture plan. Goal: ... Constraints: ... Return: main risks, simpler alternative, missing acceptance checks."
```

Gemini CLI:

```bash
gemini -m <model> "Review this architecture plan. Goal: ... Constraints: ... Return: main risks, simpler alternative, missing acceptance checks."
```

Ollama direct:

```bash
ollama run qwen3-coder:30b "You are reviewing a software architecture plan. Goal: ... Constraints: ... Existing design: ... Return: 1) main risks 2) missing acceptance checks 3) simpler alternative."
```

Ollama launching Claude Code with an Ollama-selected model:

```bash
ollama launch claude --model minimax-m2.7:cloud --yes -- -p "Review this repository architecture. Goal: ... Constraints: ... Return: main risks, simpler alternative, missing acceptance checks."
```

Ollama launching Opencode:

```bash
ollama launch opencode --model qwen3.5:cloud --yes -- run "Review this architecture plan. Goal: ... Constraints: ... Return: main risks, simpler alternative, missing acceptance checks."
```

If an external backend is unavailable, interactive-only, or unhelpful, continue with local Codex agents.

### Reporting rule

When you use an external backend, record in the `Agent Topology` or `Delegation Plan`:
- backend
- model
- role
- exact deliverable expected
- whether the result is advisory or blocking
- if the subtask came from local `ollama launch`, include the command shape or prompt summary used

## Review Heuristics

- Prefer deleting duplicated paths over wiring a third path.
- Prefer adapting the existing shell or route over adding a parallel shell.
- Preserve current UI, menu, and layout unless the user explicitly asks to change them.
- Convert claim language into requirement language backed by evidence.
- Separate must-have acceptance evidence from nice-to-have hardening.

## Rules

- Keep names engineering-oriented; avoid paper or research language.
- Prefer small tables and milestone lists over long narrative.
- Be explicit about assumptions and boundary decisions.
- If a migration removes an old path, name the entrypoints and routes being removed.
- Do not let external model feedback override direct code inspection, tests, or runtime verification.
