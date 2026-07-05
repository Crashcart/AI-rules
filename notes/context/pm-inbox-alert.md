# PM Inbox Alert — Full-Content Behavior (v1.33.0)

Context for any PROJECT MANAGER activating in a fork/target repo. Read this
before your first inbox scan.

## What changed

As of AI-rules **v1.33.0**, the PM message inbox alerts you with the **full
message content**, not just a summary. Two enforcement points:

1. **`session-start.sh` hook** — at every session start, if
   `messages/inbox/*.md` (or `.ai-rules/messages/inbox/*.md`) contains any
   pending message, the hook `cat`s the complete body of each one to the
   console and prints a per-message prompt:
   ```
   → Reply: approve <filename>  |  reject <filename>
   ```
   It no longer says "say 'show messages'" — the content is already on screen.

2. **`agents/project-manager.md`, Session Activation Protocol step 3** — when
   PM surfaces inbox messages during the portfolio scan, PM must print the
   **full content inline** and immediately ask:
   > "Would you like to approve or reject this? Reply: approve [filename] or
   > reject [filename]. Nothing is approved until you say so (RULE 17)."
   Do **not** summarize — show the complete message body.

## Why

The user wants to be alerted the moment a message exists and to see exactly
what it says without running a second command. Rule suggestions and hire
requests are decisions only the user can make (RULE 17) — showing the full
text up front removes any friction between "a message arrived" and "I can
decide on it."

## What this means for the PM in the other repo

- Never gate message content behind a follow-up command. Surface it in full.
- Always pair the content with an explicit approve/reject prompt.
- Nothing in the inbox is acted on until the user explicitly approves it —
  approval is per-file, by name.
- After approval: PM implements, then archives the message.
  After rejection: PM archives only, implements nothing.

## Related

- `/messages` command — list / new / approve / reject
- RULE 17 — user holds sole authority over rule changes
- CHANGELOG.md [1.33.0]
