# Decision 005 — Self-Assessment Protocol (Rule 12)

**Date**: 2026-05-18
**Status**: Active
**Added in**: v1.2.0
**Rule**: `rules/universal.md` Rule 12

---

## The Problem It Solves

Before v1.2.0, the rule system was static and top-down:
- Claude could update rules as instructed
- Other AIs (GPT, Gemini, Ollama, Copilot) could only acknowledge rules — they had no feedback channel
- AI-specific rule files were written by the developer based on general knowledge, not by the AIs that actually use them
- If a rule in `rules/gpt.md` didn't match how GPT actually works, there was no mechanism for GPT to flag it

Rule 12 closes this loop: every AI, on every acknowledgment, must evaluate its own rule file and propose changes if it finds problems.

---

## How It Works

```
1. AI receives rules/{ai}.md + rules/universal.md
2. AI checks: are there duplicates? conflicts? inapplicable rules? gaps?
3. AI produces proposal blocks using proposals/template.md format
4. User copies proposals to proposals/{ai}/YYYY-MM-DD-{topic}.md and commits
5. Claude reviews on next session, implements approved changes
6. Version bumps; all AIs re-acknowledge
```

---

## Why Proposals Are Human-Mediated

**Option considered**: AI submits proposals directly to the repo

Rejected because:
- Claude could theoretically approve its own proposals and implement them without human review
- This creates a self-modifying rule system with no human checkpoint
- An AI could (intentionally or not) weaken its own constraints through the proposal mechanism

**What we chose**: User as the gate

The user must manually copy the proposal block and commit it. This ensures:
1. A human sees every proposal before it enters the review queue
2. Frivolous or manipulative proposals never enter the repo
3. The audit trail shows exactly when the user introduced a proposal

---

## First-Time Self-Assessment

The first time an AI performs self-assessment under Rule 12, expect a burst of proposals — especially `remove-duplicate` types, since AI-specific files were written before the "no duplication" principle was formalized.

This is intentional and desirable. The proposal review process handles volume; Claude prioritizes `remove-duplicate` over `add-rule` since removals reduce maintenance burden.

---

## Scope of Self-Assessment

The AI checks its own `rules/{ai}.md` only — not other AIs' files. Cross-AI concerns (e.g., "a universal rule doesn't apply to any AI") should be raised as `modify-rule` against `rules/universal.md`.
