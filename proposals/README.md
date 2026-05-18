# Rule Proposals

When an AI self-assesses its rule file (per `rules/universal.md` Rule 12), it produces
proposal blocks for any duplicates, conflicts, or gaps it finds. This directory holds those proposals.

---

## Directory Layout

```
proposals/
├── README.md          ← you are here
├── template.md        ← copy this for every proposal
├── {ai}/              ← open proposals for that AI (e.g., gpt/, gemini/)
└── archive/{ai}/      ← closed proposals (approved, rejected, or deferred)
```

---

## How to Submit a Proposal

1. The AI produces a proposal block during acknowledgment (format: `proposals/template.md`)
2. Copy the block to `proposals/{ai}/YYYY-MM-DD-{topic}.md`
3. Commit the file to the repo on the active feature branch
4. Claude will review and action it on the next session

---

## How Claude Reviews Proposals

| Decision | Action |
|----------|--------|
| Approve | Edit target rule file → bump version → update CHANGELOG + version.json + SHA256 → move proposal to `archive/{ai}/` |
| Reject | Add one-sentence rejection comment at top of proposal → move to `archive/{ai}/` |
| Defer | Add a note explaining the blocker → leave in `proposals/{ai}/` |

Every open proposal gets a decision — none are silently ignored.

---

## Proposal Types

| Type | When to use |
|------|-------------|
| `remove-duplicate` | Rule in `{ai}.md` restates a universal rule without changing it |
| `add-rule` | Behavior the AI applies that isn't captured in its rule file |
| `modify-rule` | Existing rule needs rewording, scoping, or correction |
| `flag-conflict` | Rule in `{ai}.md` contradicts `universal.md`; AI-specific rule wins, but conflict must be logged |
