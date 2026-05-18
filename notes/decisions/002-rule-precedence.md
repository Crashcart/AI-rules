# Decision 002 — Rule Precedence: {ai}.md > universal.md

**Date**: 2026-05-18
**Status**: Active

---

## The Rule

```
{ai}.md  >  universal.md
```

When an AI-specific rule file and `universal.md` conflict, the AI-specific rule wins.

---

## Why This Direction

**Option considered**: `universal.md > {ai}.md` (universal always wins)

Rejected because:
- Different AIs have hard provider constraints that can't be overridden (e.g., Gemini has different safety policies than Claude)
- Forcing universal rules on top makes it impossible to have AI-specific behavior that legitimately diverges
- AIs become unable to comply — they'd either violate provider policies or violate the universal rule

**Option considered**: Merge everything into one file per AI

Rejected because:
- All 12 universal rules would be duplicated across 5 AI files — 60 rule copies to maintain
- Any change to a universal rule requires editing 5 files
- Drift becomes guaranteed

**What we chose**: `{ai}.md` as an overlay on `universal.md`

- Universal rules are the default baseline
- AI-specific files extend and override where needed
- No duplication unless intentionally overriding

---

## How to Tell Overriding vs. Duplicating

**Override** = the AI-specific version changes the behavior:
```
universal.md Rule 5: Do not start responses with filler phrases.
claude.md: Do not start responses with "Great question!", "Sure!", or "Of course!" — these are the specific patterns that fail Rule 5 in practice.
```
The claude.md version *specifies* which patterns to avoid. Different behavior → valid override.

**Duplicate** = the AI-specific version repeats the same behavior:
```
universal.md Rule 3: Every output must be correct, complete, and shippable.
gpt.md: Produce correct, complete, production-ready code.
```
Same behavior, different words → remove the duplicate from gpt.md.

---

## Edge Cases

- If you're unsure whether you're overriding or duplicating: it's a duplicate. Remove it.
- If your provider policy directly contradicts a universal rule: flag it in your `.ack.json` conflicts array and in a `flag-conflict` proposal. Your file wins, but the conflict must be logged.
- If a universal rule doesn't apply to you at all (e.g., Rule 7 daily snapshot references `.claude/settings.json` — irrelevant to Ollama): propose removal via `remove-duplicate` type, explaining it's inapplicable rather than duplicated.
