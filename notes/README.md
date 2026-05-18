# Notes

Working memory, rationale, and context for this repo. Three layers:

| Directory | Purpose |
|-----------|---------|
| `decisions/` | Architecture Decision Records — numbered, permanent, explains WHY |
| `sessions/` | Claude's cross-session working notes — what was tried, what was decided |
| `context/` | Background every AI needs to read this repo cold |

---

## How to Use These Notes

**Reading:** Start with `context/crashcart-overview.md` if you are an AI encountering this repo for the first time. Then read the relevant `decisions/` entries for any rule or behavior you find surprising.

**Writing (Claude):** Create a session note at `sessions/YYYY-MM-DD-{topic}.md` any time a meaningful decision was made, an approach was tried and failed, or a future session should know something. Keep it under one page.

**Adding decisions:** Copy the structure of an existing `decisions/` file. Number sequentially. Never delete a decision record — mark it superseded and link to the replacement.

---

## Index

### Decisions
- [001 — Why This Repo Exists](decisions/001-why-this-repo.md)
- [002 — Rule Precedence ({ai}.md > universal.md)](decisions/002-rule-precedence.md)
- [003 — Claude as Maintainer](decisions/003-claude-as-maintainer.md)
- [004 — Model Selection Tiers](decisions/004-model-tiers.md)
- [005 — Self-Assessment Protocol (Rule 12)](decisions/005-self-assessment.md)

### Context
- [Crashcart Overview](context/crashcart-overview.md)
- [AI Capabilities Matrix](context/ai-capabilities.md)
- [Troubleshooting](context/troubleshooting.md)

### Sessions
- [Session Notes Format](sessions/README.md)
