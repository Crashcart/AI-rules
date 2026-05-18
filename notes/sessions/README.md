# Session Notes

Claude's cross-session working memory. One file per meaningful session.

---

## Format

Filename: `YYYY-MM-DD-{topic}.md`

Example: `2026-05-18-initial-build.md`

Content:
```markdown
# Session: {topic}

**Date**: YYYY-MM-DD
**Version at session start**: x.y.z

## Decisions Made
- {decision and why}

## Things Tried and Failed
- {approach} — {why it didn't work}

## Open Questions
- {question left unresolved}

## Notes for Next Session
- {anything future-me should know}
```

---

## When to Create a Session Note

Create a session note when:
- A non-obvious architectural decision was made
- An approach was tried and failed (saves future sessions from re-trying it)
- A pattern was noticed that affects multiple files or rules
- Something was left incomplete and needs continuation

Skip session notes for routine rule updates, formatting fixes, or anything already captured in CHANGELOG.md.

---

## Retention

Session notes are permanent. Never delete them. If a decision was later reversed, add a note to the original file explaining why — don't delete it.

Cross-reference between session notes and `notes/decisions/` when a session led to a formal decision record.
