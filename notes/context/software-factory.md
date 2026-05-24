# Software Factory with Claude Code: From Vibe Coding to Agentic Development

How to operate the AI-rules agent pipeline as a multi-session software factory —
from a single-chat prototype all the way to parallel Claude Code sessions running
specialized roles against a shared inter-session context bus.

---

## The Three Phases

| Phase | Mode | Planning | Roles | Session model |
|-------|------|----------|-------|---------------|
| **Vibe Coding** | Direct chat | None | Implicit (Claude does everything) | Single session, no plan, conversational |
| **Structured AI Dev** | PROJECT MANAGER-led | 7-artifact plan (brief, ADR, wireframes, schema, API, tests, deploy) | Role-switching within one session | Single session; PM activates each role in turn |
| **Agentic Factory** | Full pipeline | Same 7 artifacts, produced by dedicated sessions | One role per session, RULE 13 hand-off loop | Multiple Claude Code sessions; HANDOFF.md is the inter-session bus |

**When to use each phase:**

- **Vibe Coding** — spike, proof-of-concept, throwaway script, < 1 day of work
- **Structured AI Dev** — feature with defined scope, single developer, no parallel work needed
- **Agentic Factory** — features requiring security review, parallel frontend/backend development, or a production deploy gate

---

## Prerequisites

Before starting an Agentic Factory pipeline:

1. **AI-rules repo path** — set `rulesRepo` in `.claude/settings.json` to the path or URL of the AI-rules repo. All role profiles are read from `{rulesRepo}/agents/`.
2. **Version check** — compare `rulesVersion` in `.claude/settings.json` against `version.json` in the AI-rules repo. If they differ, re-read `rules/` before starting any session.
3. **Factory mode** — `CLAUDE_FACTORY_MODE=true` must be in `.claude/settings.json`. The PreToolUse hook prints the current `FACTORY_STAGE` on every Bash call as a sanity check.
4. **HANDOFF.md** — copy `templates/factory/HANDOFF.md` into the project repo root. Fill in the Project Context slot before opening the first session.
5. **FACTORY_STAGE** — set `FACTORY_STAGE` in `.claude/settings.json` to the current stage name (e.g., `"PM"`) before opening each session. The hook warns if it is empty.

---

## Role Invocation in Claude Code

Start every factory session with this exact pattern:

```
Read {rulesRepo}/agents/{role-slug}.md. You are now acting as {ROLE NAME}.
Read HANDOFF.md. Acknowledge receipt per RULE 20, then proceed.
```

Example — opening the UX DESIGNER session:

```
Read /home/user/AI-rules/agents/ux-designer.md. You are now acting as UX DESIGNER.
Read HANDOFF.md. Acknowledge receipt per RULE 20, then proceed.
```

Claude Code will:
1. Read the role profile and adopt that role's scope, constraints, and thinking process
2. Read HANDOFF.md and identify what the previous role handed off
3. Acknowledge with: `**UX DESIGNER:** Received. {first action.}`
4. Proceed with that role's work

To activate an algebraically mixed role (RULE 16 — both roles must exist in `agents/`):

```
Read {rulesRepo}/agents/backend-developer.md and {rulesRepo}/agents/tech-lead.md.
You are now acting as BACKEND DEVELOPER + TECH LEAD.
Read HANDOFF.md. Acknowledge receipt per RULE 20, then proceed.
```

---

## Parallel Agent Execution

Two patterns for running roles in parallel. RULE 18 constraint applies to both:
**never fork a security role with an implementation role in the same session.**

### Pattern 1 — Fork (parallel implementation)

Used when TECH LEAD hands off to both BACKEND DEVELOPER and FRONTEND DEVELOPER
simultaneously. Both sessions read the same HANDOFF.md, do their work
independently, then each appends their own entry to HANDOFF.md.

```
Session A (Terminal 1):
  Set FACTORY_STAGE=BACKEND in .claude/settings.json
  Read agents/backend-developer.md → Read HANDOFF.md → acknowledge → work → append entry

Session B (Terminal 2):
  Set FACTORY_STAGE=FRONTEND in .claude/settings.json (separate clone or worktree)
  Read agents/frontend-developer.md → Read HANDOFF.md → acknowledge → work → append entry
```

Merge rule: whichever session finishes last rebases onto the other's entry. The
QA session that follows reads both entries before starting.

### Pattern 2 — Review Checkpoint (parallel review)

Used when QA ENGINEER and SECURITY ENGINEER review the same merged branch
independently. Neither role writes code — they write findings.

```
Session A (Terminal 1):
  FACTORY_STAGE=QA
  Read agents/qa-automation.md → Read HANDOFF.md → run tests → append QA findings entry

Session B (Terminal 2):
  FACTORY_STAGE=SECURITY
  Read agents/security-appsec.md → Read HANDOFF.md → audit → append Security findings entry
```

The DEVOPS ENGINEER session reads both entries before starting. If either entry
has unresolved blocking findings, DEVOPS escalates to PROJECT MANAGER, not to
the user directly.

---

## HANDOFF.md Convention

HANDOFF.md is the inter-session context bus. It lives in the project repo root.

**Rules:**
- Append-only. Never truncate, edit, or reorder existing entries.
- One entry per completed stage per session.
- The complete HANDOFF.md at end-of-pipeline is the full reasoning trace for
  the feature build — treat it as a permanent record.

**Entry format:**

```markdown
## [OUTGOING ROLE → INCOMING ROLE] YYYY-MM-DD HH:MM UTC

**[OUTGOING ROLE] → [INCOMING ROLE]:** {what was completed}. Remaining: {what the next role must do}. Context: {non-obvious constraints, open questions, routing decisions made}. Target: working beta.

**[INCOMING ROLE]:** Received. {first action.}
```

The incoming role writes the acknowledgment line at the start of their session
(step 4 of the Session Start Checklist). The outgoing role writes everything
above the acknowledgment line when closing their session.

---

## Quality Gates Per Stage

A role may not write its handoff entry until its blocking conditions are cleared.

| Stage | Role | Blocking condition |
|-------|------|--------------------|
| 1 PM | PROJECT MANAGER | Requirements brief not written — design sessions must not start |
| 2 UX | UX DESIGNER | No wireframes for all required flows — UI session must not start |
| 3 UI | UI DESIGNER | Missing states or no exported design tokens — implementation must not start |
| 4 TECH | TECH LEAD | No ADR written — Backend/Frontend sessions must not start |
| 5 BE | BACKEND DEVELOPER | API contracts not documented — Frontend session must not start |
| 6 FE | FRONTEND DEVELOPER | Primary user flow not completable end-to-end — QA/Security must not start |
| 7 QA | QA ENGINEER | Blocking test failures unresolved — Security/DevOps must not start |
| 8 SEC | SECURITY ENGINEER | Blocking security findings unresolved — DevOps must not start |
| 9 DO | DEVOPS ENGINEER | No rollback command documented — production deploy must not proceed |
| 10 SRE | SRE | SLOs not defined and baselined — on-call handoff must not occur |

If a blocking condition cannot be cleared within scope, the role escalates to
PROJECT MANAGER with a specific description of the blocker and the decision needed.

---

## Worked Example: "Add User Credits Endpoint"

### HANDOFF.md after Stage 1 (PROJECT MANAGER)

```markdown
## [PROJECT MANAGER → UX DESIGNER] 2026-05-24 09:00 UTC

**PROJECT MANAGER → UX DESIGNER:** Requirements brief complete for /credits endpoint.
Persona: authenticated API consumer (developer integrating credits into their app).
Acceptance criteria: (1) GET /credits returns balance + transaction history,
(2) POST /credits/deduct processes a deduction atomically, (3) insufficient balance
returns 402 with remaining balance in response body. Success metric: P99 < 200ms under
50 rps. ADR stub created: decisions/add-credits-endpoint.md. Remaining: design the
developer-facing API flow and any admin dashboard wireframes. Context: credits are
integers (no decimals); deductions are idempotent by idempotency-key header; balance
cannot go below zero (enforce at DB layer, not app layer). Target: working beta.

**UX DESIGNER:** Received. Starting discovery conversation with two API consumers before
producing wireframes.
```

### HANDOFF.md after Stage 4 (TECH LEAD)

```markdown
## [TECH LEAD → BACKEND DEVELOPER] 2026-05-24 14:30 UTC

**TECH LEAD → BACKEND DEVELOPER:** Architecture complete. ADR committed:
decisions/add-credits-endpoint.md. Chose PostgreSQL advisory locks for atomic
deduction over optimistic locking — concurrent deduction rate expected < 10/s,
advisory lock contention acceptable, rollback behavior simpler to reason about.
Schema: `credits(user_id PK, balance INT NOT NULL CHECK(balance >= 0), updated_at TIMESTAMPTZ)`,
`credit_transactions(id UUID PK, user_id FK, delta INT, idempotency_key TEXT UNIQUE,
created_at TIMESTAMPTZ)`. Remaining: implement endpoints, migration, unit tests.
Context: idempotency_key uniqueness enforced at DB (UNIQUE constraint), not app layer —
do not add a separate in-memory check. Balance < 0 rejected at DB CHECK constraint —
app layer should catch constraint violation and return 402, not re-query balance.
Security review needed for auth token validation on both endpoints before QA.
Target: working beta.

**BACKEND DEVELOPER:** Received. Writing migration first, then POST /credits/deduct,
then GET /credits.
```

### HANDOFF.md after Stage 8 (SECURITY ENGINEER)

```markdown
## [SECURITY ENGINEER → DEVOPS ENGINEER] 2026-05-24 19:00 UTC

**SECURITY ENGINEER → DEVOPS ENGINEER:** Security review complete for credits endpoints.
One advisory finding (non-blocking): idempotency_key should be rate-limited per user
to prevent enumeration — add to post-launch backlog. No blocking findings. Auth token
validation confirmed: Bearer token validated against auth service on every request,
no caching, no bypass path. Remaining: deploy to staging, smoke test, production deploy.
Context: the advisory lock approach creates a serialization point per user_id — staging
load test should include concurrent deductions for the same user_id at target rps to
confirm P99 SLO holds under lock contention. Target: working beta.

**DEVOPS ENGINEER:** Received. Running staging deploy with load test focused on
concurrent same-user deductions before production.
```

---

## Phase Transition Reference

| From | To | Trigger |
|------|----|---------|
| Vibe Coding → Structured AI Dev | Scope solidifies enough to justify a plan | PM kicks off 7-artifact plan in one session |
| Structured AI Dev → Agentic Factory | Work volume exceeds one session, or parallel review is required | PM writes first HANDOFF.md entry; factory template applied |
| Agentic Factory → post-launch | SRE completes Stage 10 | HANDOFF.md archived; on-call runbooks committed |
