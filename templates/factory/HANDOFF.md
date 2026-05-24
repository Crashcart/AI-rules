# HANDOFF — {TODO: PROJECT NAME} — {TODO: FEATURE / SPRINT NAME}

> **Append-only.** Each role adds one entry to the Handoff Log when its stage is
> complete. Never truncate, overwrite, or reorder existing entries. The complete
> HANDOFF.md at end-of-pipeline is the reasoning trace for the entire feature build.

---

## Pipeline Status

| Stage | Role | Status | Completed Date |
|-------|------|--------|---------------|
| 1 | PROJECT MANAGER | ⬜ pending | — |
| 2 | UX DESIGNER | ⬜ pending | — |
| 3 | UI DESIGNER | ⬜ pending | — |
| 4 | TECH LEAD | ⬜ pending | — |
| 5 | BACKEND DEVELOPER | ⬜ pending | — |
| 6 | FRONTEND DEVELOPER | ⬜ pending | — |
| 7 | QA ENGINEER | ⬜ pending | — |
| 8 | SECURITY ENGINEER | ⬜ pending | — |
| 9 | DEVOPS ENGINEER | ⬜ pending | — |
| 10 | SRE | ⬜ pending | — |

> Update status to ✅ done when the outgoing role writes its handoff entry.
> Use 🔴 blocked if the quality gate cannot be cleared without a PM decision.

---

## Context Slots

### Project Context
> Fill this once at pipeline start (PROJECT MANAGER). All downstream roles read it.

**Repo:** {TODO}
**Feature description:** {TODO}
**Target persona:** {TODO}
**Success metric:** {TODO}
**Acceptance criteria:**
- {TODO}

**Constraints / non-negotiables:** {TODO}

---

### Open Blockers

> Any role appends a blocker here when it cannot proceed. Format:
> `- [ROLE] YYYY-MM-DD: {blocker description} — needs decision from {role or user}`

_(none)_

---

### Known Gaps

> Gaps that are intentionally deferred to post-launch. Format:
> `- [ROLE] YYYY-MM-DD: {gap description} — deferred because {reason}`

_(none)_

---

## Handoff Log

> One entry per completed stage. Append to the bottom. Never edit existing entries.
> Follow RULE 20 handshake format exactly — copy the comment block below:

<!--
RULE 20 handshake format (copy-paste for each entry):

## [OUTGOING ROLE → INCOMING ROLE] YYYY-MM-DD HH:MM UTC

**[OUTGOING ROLE] → [INCOMING ROLE]:** {what was completed}. Remaining: {what the next role must do}. Context: {non-obvious constraints, open questions, routing decisions made}. Target: working beta.

**[INCOMING ROLE]:** Received. {first action.}

---
-->

<!-- First entry goes here — PROJECT MANAGER starts the log -->
