# AI Startup Compliance Checklist
version: 1.0.0 | applies-to: all | parent: universal.md

Every AI that reads these rules outputs this block as the **first thing in the first response** of every session. It is how the user audits compliance instantly.

---

## Startup Output Block

Output exactly this format before any substantive response:

```
STARTUP — {ai-id} — {YYYY-MM-DD}
ROLE:    {ROLE NAME IN ALL CAPS}           ← from agents/{ai-id}.md or user-specified
RULES:   v{version} [{match|STALE}]        ← compare version.json to acknowledgments/{ai-id}.ack.json
PROFILE: {loaded|MISSING}                  ← rules/{ai-id}.md exists?
ACK:     {current|PENDING}                 ← acknowledgments/{ai-id}.ack.json up to date?
STATUS:  READY
```

**Example (compliant):**
```
STARTUP — claude — 2026-05-23
ROLE:    CEO
RULES:   v1.21.0 [match]
PROFILE: loaded
ACK:     current
STATUS:  READY
```

**Example (stale rules):**
```
STARTUP — claude — 2026-05-23
ROLE:    CEO
RULES:   v1.19.0 [STALE — re-reading rules/]
PROFILE: loaded
ACK:     PENDING — updating
STATUS:  RE-READING RULES BEFORE PROCEEDING
```

---

## What Each Line Checks

**ROLE** — The active agent role. Default for Claude is CEO. If the user specifies a role in their first message, use that. Must match a file in `agents/` exactly or be an approved algebraic combination.

**RULES** — Read `version.json` and `acknowledgments/{ai-id}.ack.json`. If versions match: `[match]`. If they differ: `[STALE — re-reading rules/]` then re-read all files in `rules/` before responding.

**PROFILE** — Check whether `rules/{ai-id}.md` exists. If missing: `MISSING — bootstrapping` and follow RULE 19 Check 2.

**ACK** — Check whether `acknowledgments/{ai-id}.ack.json` exists and matches the current version. If not: `PENDING — updating` and write the updated ack file.

---

## After a Stale or Missing State

Resolve every flagged item before substantive work:
1. Re-read stale rules before responding
2. Bootstrap missing profile before responding
3. Write updated ack file
4. Then output STATUS: READY and continue

---

## On Fresh Rule Downloads (First-Time Setup)

If this is the first time loading the full rule set:

1. Run `scripts/ai-bootstrap.sh {your-ai-id}` (Claude Code) or ask the user to run it
2. Fill in all `{PLACEHOLDER}` fields in `rules/{ai-id}.md`
3. Output the startup block — it will show PROFILE: MISSING until bootstrap completes
4. After bootstrap: re-output the block with STATUS: READY

The startup block tells the user exactly what state the AI is in. If STATUS is not READY, the AI is not in a compliant state and should not proceed with substantive work.

---

## Why Role Announcement Matters

The ROLE line is the user's primary audit signal. If ROLE is wrong or missing, the user cannot verify which agent profile is active — and cannot tell whether to fire and rehire. A correct ROLE line confirms the right specialization is on the job.

[NON-NEGOTIABLE — output the startup block before every first substantive response in a session]
