Manage the PM message inbox — rule-change suggestions and new-hire requests.

PROJECT MANAGER uses this channel to send rule suggestions to RULE ARCHITECT and hire requests
to the user/CEO. Nothing is acted on without explicit user approval (RULE 16 / RULE 17).

Argument (optional):
- (no arg)            → list all pending messages in `messages/inbox/`
- `new`               → create a new message (PM drafts one into `messages/inbox/`)
- `approve <file>`    → user approved: implement the request, then archive the message
- `reject <file>`     → user rejected: archive the message with the decision, implement nothing

Steps:

**List (no arg):**
1. Run `bash scripts/check-messages.sh` (or read `messages/inbox/*.md` directly)
2. Print each pending message: type, priority, title, file path, and a one-line summary
3. If none: "PM inbox clear — no pending messages."

**New:**
1. Determine type: `rule-suggestion` (→ RULE ARCHITECT) or `hire-request` (→ CEO/user)
2. Copy `messages/template.md` to `messages/inbox/{type}-{slug}-{YYYY-MM-DD}.md`
3. Fill in Summary, Detail, Evidence, Recommendation. For a hire-request, reference the
   suggested test from `hiring/test-bank.md` and confirm no algebraic mix of existing roles
   covers the gap (RULE 16). For a rule-suggestion, include the exact proposed wording (RULE 17).
4. Leave `## Decision` blank — the user fills it on review
5. Do NOT implement the rule change or hire — this is a request only. Commit the message file.
6. **Tell the user and show it** — PROJECT MANAGER must announce that a message was created and
   print the full message content inline in the chat, so the user always sees what was sent.
   Never write a message silently. Format:

   > **PROJECT MANAGER:** I've posted a {type} to the inbox: `messages/inbox/{file}`.
   > {then paste the full message body}

**Approve `<file>`:**
1. Confirm the user actually approved (this command is the approval action)
2. Implement the request:
   - `rule-suggestion` → activate RULE ARCHITECT to make the rule change per the standard
     rule-update flow (edit rules/, recompute SHA, bump version, CHANGELOG, ack)
   - `hire-request` → activate HIRING MANAGER per the Candidate Pool Process
3. Append `## Decision: approved — {today}` to the message and move it to `messages/archive/`

**Reject `<file>`:**
1. Append `## Decision: rejected — {today} — {one-line reason}` to the message
2. Move it to `messages/archive/`. Implement nothing.

The 4×/day workflow (`.github/workflows/messages-check.yml`) alerts the user via a GitHub issue
whenever `messages/inbox/` is non-empty. This command is the on-demand equivalent.
