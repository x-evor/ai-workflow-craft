---
name: "architect-orchestrator"
description: "Use when the user wants Codex to act as a multi-agent software architect and dispatcher: turn a feature, migration, or technical problem into ranked architecture options, requirement-to-acceptance evidence, implementation milestones, delegated code-agent work, and a review-fix-re-review loop. Supports external agent backends including Opencode, Gemini CLI, and Ollama-launched integrations."
---

# Architect Orchestrator

## Overview

Convert an ambiguous engineering request into an execution-ready multi-agent architecture brief.
Primary objective: multi-agent collaborative dispatch for software work.

Keep the semantics engineering-centered:

- requirements -> acceptance evidence
- architecture options -> ranked trade-offs
- implementation milestones -> critical path plus parallel slices
- review loop -> design/code review, fixes, verification, re-review

This skill is primarily a dispatch layer. When the user explicitly invokes `$architect-orchestrator`, treat that as permission to decompose the work, assign parallel agent roles when useful, and run an independent review path.

Default output is a compact architecture plan plus agent topology, not a broad rewrite. Do not jump into large implementation until the plan is stable, unless the user explicitly asks to implement immediately.

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
- Treat explicit invocation of this skill as explicit delegation intent.
- Default to a multi-agent plan when the task has parallelizable slices, independent questions, or a meaningful review lane.
- Use a single-agent path only when the task is too small, too coupled, or entirely blocked on one critical-path step. If so, say why.
- Standard role split:
  - planner kept local
  - `explorer` agents for narrow codebase questions
  - `worker` agents for disjoint implementation slices
  - a separate reviewer agent for an independent critique
- Give each agent a concrete ownership boundary, expected deliverable, and non-overlapping write scope.
- Do not delegate the next blocking step if local progress depends on it.
- Keep the number of active agents small and purposeful. Prefer 2-4 clear lanes over many weak ones.

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

This skill may route some lanes through external agent CLIs when that materially improves coverage, independence, or provider diversity.
Use external backends as workers or reviewers, not as the source of truth for repository facts.

Allowed backend families:
- local Codex agents via `spawn_agent`
- `opencode`
- `gemini`
- `ollama launch <integration>` such as `claude`, `opencode`, `codex`, or `openclaw`

Use an external backend when:
- the user explicitly asks for a provider or CLI
- you want an independent critique lane separate from Codex subagents
- you need a long-running or provider-specific session outside the local agent graph
- you want model diversity for option ranking or review

Do not use an external backend when:
- the task is blocked on direct local code inspection
- the lane needs secrets or sensitive config contents
- the output would override direct tests, logs, or repository evidence

### Backend selection

1. Use local Codex agents for repository-coupled exploration, implementation, and final integration.
2. Use `opencode` when the user wants an external coding agent/session or a separate build lane.
3. Use `gemini` for alternative critique, plan challenge, or summarization, preferably in non-interactive mode.
4. Use `ollama launch <integration>` when the user wants a specific integration or model bridge, including launching `claude` or `opencode` under an Ollama-selected model.

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
