# PM Message Inbox

The channel PROJECT MANAGER uses to send **rule-change suggestions** to RULE ARCHITECT
(the rule-making PM) and **new-hire requests** to the user/CEO. Nothing here is acted on
automatically — every message waits for explicit user approval (RULE 16, RULE 17).

PROJECT MANAGER owns this directory. One file per message.

---

## Directory Structure

```
messages/
├── README.md          ← this file
├── template.md        ← copy for each new message
├── inbox/             ← pending messages (awaiting user approval)
└── archive/           ← processed messages (approved or rejected)
```

---

## Message Types

| Type | From → To | What it is |
|------|-----------|------------|
| `rule-suggestion` | PROJECT MANAGER → RULE ARCHITECT | A proposed rule change or new rule. RULE ARCHITECT drafts; user decides (RULE 17). |
| `hire-request` | PROJECT MANAGER → CEO / user | A request to hire a role the roster cannot cover by algebraic mixing (RULE 16). |

---

## How It Works

1. **PM writes a message** — copy `template.md` to `inbox/{type}-{slug}-{YYYY-MM-DD}.md`, fill it in.
2. **Scheduled check (4×/day)** — `.github/workflows/messages-check.yml` runs every 6 hours
   (00:00, 06:00, 12:00, 18:00 UTC). If `inbox/` has any pending messages, it opens or updates
   a single GitHub issue labeled `pending-approval` that alerts the user.
3. **User reviews and decides** — approve or reject. Nothing is implemented before approval.
4. **PM archives** — on a decision, move the message file to `archive/` with a
   `## Decision: approved|rejected — YYYY-MM-DD` line appended.

Run the check locally any time with `/messages` or `bash scripts/check-messages.sh`.

---

## Approval Gate [NON-NEGOTIABLE]

- A `rule-suggestion` is a **request**, not a change. The rule is not edited until the user
  approves it (RULE 17 — user holds sole authority over rule changes).
- A `hire-request` is a **request**, not a hire. No role is created, named, or used until the
  user approves it (RULE 16).
- The 4×/day check **alerts** the user. It never approves, edits a rule, or creates a role.

Silence is not approval. A message sits in `inbox/` until the user explicitly decides.
