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

## Timing

Claude reviews open proposals at the **start of the session in which they were committed** — not immediately on submission. If a proposal is committed to a branch that isn't the active session branch, it will be reviewed when that branch becomes active.

---

## Cross-AI Conflicts

If two AIs submit proposals that contradict each other (e.g., GPT proposes adding a rule, Gemini proposes removing the same rule):

1. Claude reads both proposals
2. Evaluates which position is better supported by the rule's intent
3. Implements the stronger proposal; archives both with a note explaining the decision
4. The rejected proposal's archive entry explains why the other was chosen

If the conflict is genuinely irresolvable: both are deferred with a note and the user is asked to decide via `AskUserQuestion`.

---

## Moving to Archive

"Move to archive" means `git mv`, not copy-paste:

```bash
git mv proposals/{ai}/YYYY-MM-DD-{topic}.md proposals/archive/{ai}/YYYY-MM-DD-{topic}.md
```

The `proposals/archive/` directory was pre-created with a `.gitkeep`. First-time archive for a new AI creates the `archive/{ai}/` subdirectory via the `git mv` target path.

---

## Examples

See [`proposals/examples/`](examples/) for a complete approved proposal and a complete rejected proposal, each showing the full format and outcome status line.

---

## Proposal Types

| Type | When to use |
|------|-------------|
| `remove-duplicate` | Rule in `{ai}.md` restates a universal rule without changing it |
| `add-rule` | Behavior the AI applies that isn't captured in its rule file |
| `modify-rule` | Existing rule needs rewording, scoping, or correction |
| `flag-conflict` | Rule in `{ai}.md` contradicts `universal.md`; AI-specific rule wins, but conflict must be logged |
