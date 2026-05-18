# Rule Proposal

**AI**: gpt
**Date**: 2026-05-18
**Target file**: rules/gpt.md
**Type**: remove-duplicate

---

## Current rule (verbatim)

```
## Quality Standard

Every output must be correct, complete, and production-ready. Do not produce
placeholder code, partial implementations, or unverified logic. If you cannot
produce a correct result, say so.
```

---

## Problem

This rule duplicates `rules/universal.md` Rule 3 without changing the behavior.

---

## Proposed change

```
REMOVE
```

---

## Rationale

- `rules/universal.md` Rule 3 already states: "Every output must be correct, polished, honest, and shippable. Do not produce placeholders, unverified logic, or partial implementations."
- The GPT-specific version adds no GPT-specific behavior or constraint — it only rephrases the same rule
- Removing it reduces maintenance surface: if universal Rule 3 changes, this copy doesn't drift

---

## Status

**[APPROVED]** — Implemented in v1.3.0. Rule removed from `rules/gpt.md`.
Duplicate confirmed: zero behavioral difference between gpt.md version and universal.md Rule 3.
Proposal moved to `proposals/archive/gpt/` after implementation.
