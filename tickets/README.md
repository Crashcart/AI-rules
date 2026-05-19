# Tickets

Work items for the AI-rules repo. Any AI or the user can open a ticket. Claude (as CEO) processes open tickets on every session start.

---

## Lifecycle

```
tickets/{title}.md   →   (Claude processes)   →   tickets/archive/{title}.md
     open                                               closed
```

1. **Open**: create a `.md` file in `tickets/` using `tickets/template.md`
2. **In-progress**: Claude adds a `**Status:** in-progress` line when it begins work
3. **Closed**: Claude moves the file to `tickets/archive/` with a resolution note and commits

---

## How to Open a Ticket

1. Copy `tickets/template.md` to `tickets/{short-slug}.md`
2. Fill in all required fields
3. Commit to `main` — Claude will pick it up on the next session start

No approval needed to open a ticket. Claude decides whether to process it immediately or flag it as blocked.

---

## Rules

- One ticket per file
- Use the template — tickets missing required fields will be flagged, not processed
- Tickets scoped to other Crashcart repos should note the target repo in the Scope field and be committed there, not here
- Claude processes tickets in priority order (high → medium → low), then by date opened

---

## Archive

Closed tickets live in `tickets/archive/`. They are never deleted — they are the record of what was done.
