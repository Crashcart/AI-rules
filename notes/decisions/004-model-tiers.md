# Decision 004 — Model Selection Tiers (Haiku / Sonnet / Opus)

**Date**: 2026-05-18
**Status**: Active
**Rule**: `rules/universal.md` Rule 2; `rules/claude.md` Model Selection section

---

## The Tiers

| Tier | Use For | Examples |
|------|---------|---------|
| Haiku | Single-file, no side effects, fast answer | Read a file, grep, simple Q&A, format a snippet |
| Sonnet | Multi-file, multi-step, judgment required | Refactor across files, debug a feature, write tests |
| Opus | Architecture, security, ambiguous high-stakes | System design, security audit, breaking change planning |

---

## Why Three Tiers

**Cost and latency**: Opus is ~15x more expensive per token than Haiku and ~2x slower. Routing every task to Opus would be wasteful for simple operations. Routing everything to Haiku would miss important judgment calls.

**Quality ceiling**: Haiku makes more errors on complex multi-file reasoning. Sonnet handles most real tasks. Opus is needed when the cost of a wrong answer is high.

---

## The Heuristic

Ask two questions:
1. **How many files does this touch?** One file → Haiku usually fine. Multiple files → Sonnet. Architecture-wide → Opus.
2. **What's the cost of a wrong answer?** Low (can easily revert) → Haiku fine. Medium (takes time to undo) → Sonnet. High (production system, security impact, breaking change) → Opus.

If either answer points to a higher tier, use the higher tier.

---

## Subagent Note

When Claude Code spawns subagents, the same tiers apply. An Explore subagent for a quick file search uses Haiku. A subagent doing multi-file analysis uses Sonnet. A Plan agent for an architectural decision uses Opus.

The tier is about the task, not about the caller.

---

## Why Opus Is Reserved

Opus is expensive enough that using it for simple tasks noticeably increases cost for the Crashcart developer. The rule "reserve Opus for architecture and security decisions" exists because those are the decisions where the higher reasoning quality actually changes the outcome — for routine tasks, Sonnet is just as correct.
