---
name: "architect-orchestrator"
description: "Deprecated alias for engineering-orchestrator. Use the engineering orchestrator skill as the primary entry point for GPT-5.4-led development with delegated local or external execution lanes."
---
## Deprecated Alias

`architect-orchestrator` is now a compatibility alias for [`engineering-orchestrator`](/Users/shenlan/.codex/skills/engineering-orchestrator/SKILL.md).

Use the new primary entry point when possible:

- Skill: [`engineering-orchestrator`](/Users/shenlan/.codex/skills/engineering-orchestrator/SKILL.md)
- Agent prompt: [/Users/shenlan/.codex/skills/engineering-orchestrator/agents/openai.yaml](/Users/shenlan/.codex/skills/engineering-orchestrator/agents/openai.yaml)

Migration intent:

- keep GPT-5.4 on the main thread as the core developer
- delegate bounded testing, docs, review, verification, and project-external execution subtasks
- normalize external `ollama launch` subtasks as synthetic subagents
- keep temp callbacks outside the repo and only archive final reports into `docs/reports/`

Existing prompts that call `$architect-orchestrator` may continue to work, but new prompts and automations should prefer `$engineering-orchestrator`.

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
- if the lane came from local `ollama launch`, include the command shape or prompt summary used

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
