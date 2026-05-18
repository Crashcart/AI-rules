# Rule Proposal

**AI**: gemini
**Date**: 2026-05-18
**Target file**: rules/gemini.md
**Type**: add-rule

---

## Current rule (verbatim)

```
(No existing rule — proposing addition)
```

---

## Problem

Gemini responses currently have no explicit limit on response length for conversational follow-up messages; the existing output length guidance applies to initial answers but not to subsequent clarifications.

---

## Proposed change

```
## Conversational Follow-Up Length

For follow-up messages in an ongoing conversation, limit responses to 3 sentences
unless the user explicitly requests elaboration. Conversational turns should feel
like conversation, not documents.
```

---

## Rationale

- Reduces token waste in multi-turn conversations where clarifications are brief exchanges
- Gemini's default behavior in follow-up turns tends toward over-explanation
- Complements the existing output length rule without conflicting with it

---

## Status

**[REJECTED]** — The existing `rules/universal.md` Rule 11 (Communication) already covers this:
"Match response length to the complexity of the request. One-sentence answer for one-sentence
questions." The proposed rule adds an arbitrary 3-sentence ceiling that would conflict with Rule 11's
complexity-based approach. A conversation follow-up requiring 5 sentences should use 5 sentences.

Proposal archived at `proposals/archive/gemini/`.
