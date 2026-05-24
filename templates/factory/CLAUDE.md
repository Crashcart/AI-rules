# Claude Code Instructions — {TODO: PROJECT NAME} (Factory Mode)

## Factory Mode

This project runs in **CLAUDE_FACTORY_MODE**. Each Claude Code session activates
one role from the pipeline, reads HANDOFF.md, does that role's work, appends a
RULE 20 handshake entry to HANDOFF.md, and stops.

Do NOT default to PROJECT MANAGER solo. Do NOT combine phases within a session
unless the roles are explicitly algebraically mixed (RULE 16). Do NOT hand off
to a role not in the pipeline without PROJECT MANAGER escalation.

Reference: `notes/context/software-factory.md` in the AI-rules repo.

---

## Session Start Checklist (Factory)

Run through this on every session start, in order. Do not skip steps.

1. **Check rules hook** — the PreToolUse hook auto-pulls from `origin/main` on
   every Bash call. If it prints "Rules updated", re-read all `rules/` files
   from the AI-rules repo before doing anything else.
2. **Read HANDOFF.md** — identify the most recent entry in the Handoff Log.
   That entry names the next incoming role. That is your role for this session.
3. **Read your role profile** — `{rulesRepo}/agents/{role-slug}.md`. You are
   now operating as that role with its full scope, constraints, and escalation
   triggers.
4. **Announce receipt per RULE 20** — output the acknowledgment line:
   `**[ROLE NAME]:** Received. {first action.}`
5. **Verify FACTORY_STAGE** — check `.claude/settings.json`. If `FACTORY_STAGE`
   is empty or does not match the role you identified in step 2, stop and
   reconcile before proceeding. The hook will also warn you.
6. **Check quality gate** — review the Quality Gate Checklist below. Any
   unchecked blocking item from the prior stage must be resolved before you
   do your work and write your handoff entry.

---

## Role Activation

Exact invocation pattern for each pipeline stage:

```
Read {rulesRepo}/agents/{role-slug}.md. You are now acting as {ROLE NAME}.
Read HANDOFF.md. Acknowledge receipt per RULE 20, then proceed.
```

| Stage | Role | Slug |
|-------|------|------|
| 1 | PROJECT MANAGER | `project-manager` |
| 2 | UX DESIGNER | `ux-designer` |
| 3 | UI DESIGNER | `ui-designer` |
| 4 | TECH LEAD | `tech-lead` |
| 5 | BACKEND DEVELOPER | `backend-developer` |
| 6 | FRONTEND DEVELOPER | `frontend-developer` |
| 7 | QA ENGINEER | `qa-automation` |
| 8 | SECURITY ENGINEER | `security-appsec` |
| 9 | DEVOPS ENGINEER | `devops-pipeline` |
| 10 | SRE | `sre` |

For algebraically mixed roles (RULE 16), read both slugs and announce the
combined name: `**BACKEND DEVELOPER + TECH LEAD:**`.

---

## HANDOFF.md Convention

HANDOFF.md is the **inter-session context bus**. It is append-only.

- Never truncate, overwrite, or reorder existing entries.
- Add one entry per session at the end of the Handoff Log.
- Section header format: `## [ROLE → NEXT_ROLE] YYYY-MM-DD HH:MM UTC`
- Follow the RULE 20 handshake format verbatim:

```
**[OUTGOING ROLE] → [INCOMING ROLE]:** {what was completed}. Remaining: {what the next role must do}. Context: {non-obvious constraints, open questions, routing decisions}. Target: working beta.
```

The incoming role opens the next session, reads HANDOFF.md, and acknowledges
with: `**[INCOMING ROLE]:** Received. {first action.}`

For details on parallel fork and review-checkpoint patterns, see
`notes/context/software-factory.md`.

---

## Quality Gate Checklist

Mark each stage complete before the outgoing role writes its handoff entry.
An unchecked blocking item means the current stage is not done.

### Stage 1 — PROJECT MANAGER
- [ ] Requirements brief written (problem statement, target persona, acceptance criteria, success metric)
- [ ] ADR stub created (decision to be made, options to evaluate)
- [ ] No scope change pending that would block design start

### Stage 2 — UX DESIGNER
- [ ] At least two discovery conversations completed (or constraint documented if infeasible)
- [ ] Annotated wireframes cover all required user flows and states
- [ ] Accessibility annotations on every interactive element
- [ ] Usability tested with at least one real user (or constraint documented)
- [ ] For game/leaderboard features: URL routing flow diagram present

### Stage 3 — UI DESIGNER
- [ ] High-fidelity designs cover all states (default, hover, focus, active, disabled, error, empty, loading)
- [ ] Design tokens exported as JSON
- [ ] Component inventory complete
- [ ] `rules/web-design.md` production-readiness checklist items confirmed (WCAG contrast, responsive breakpoints, SVG-first, prefers-reduced-motion)
- [ ] No missing wireframe states (if any, escalated back to UX DESIGNER)

### Stage 4 — TECH LEAD
- [ ] ADR written and committed (context, options considered, decision, consequences)
- [ ] Architecture diagram covers all new services and data flows
- [ ] Implementation complexity flagged to PROJECT MANAGER if it affects timeline
- [ ] Security-touching decisions reviewed or escalation queued for SECURITY ENGINEER

### Stage 5 — BACKEND DEVELOPER
- [ ] API contracts documented (endpoints, request/response shapes, error codes)
- [ ] Unit tests written for business logic
- [ ] DB migration written and reviewed by DBA (if schema change)
- [ ] No hardcoded secrets; env vars documented

### Stage 6 — FRONTEND DEVELOPER
- [ ] All UI states implemented and matching high-fidelity designs
- [ ] Accessibility requirements from wireframes implemented
- [ ] Integration tests cover primary user flows
- [ ] No inline styles; all values from design token system

### Stage 7 — QA ENGINEER
- [ ] Test plan covers critical paths (payment, auth, core data writes)
- [ ] No flaky tests in suite
- [ ] Regression gate defined (which behaviors must never break)
- [ ] Exploratory testing completed and findings documented

### Stage 8 — SECURITY ENGINEER
- [ ] Trust boundaries mapped
- [ ] All findings classified (blocking vs. advisory) with remediation steps
- [ ] No blocking findings unresolved
- [ ] PII/auth-touching surfaces reviewed

### Stage 9 — DEVOPS ENGINEER
- [ ] Deployment pipeline documented with rollback command (one command, not a procedure)
- [ ] Staging deploy completed and verified
- [ ] No secrets in pipeline logs
- [ ] Monitoring and alerting wired before production deploy

### Stage 10 — SRE
- [ ] SLOs defined and baseline measurements recorded
- [ ] Runbooks written for top-3 failure modes
- [ ] On-call rotation updated
- [ ] Post-launch monitoring plan in place

---

## Working Beta Checklist

Before any role writes a handoff entry claiming "Target: working beta", verify:

- [ ] Runs end-to-end in the target environment without a guided walkthrough
- [ ] Primary user flow completable by someone unfamiliar with the internals
- [ ] All known gaps documented in HANDOFF.md Open Blockers section
- [ ] No silent failures — errors surface to the user or to a log

A "working beta" is not perfect. It is demonstrable and honest about its gaps.
Claiming working beta when these items are unchecked is a RULE 15 violation.

---

## Repo Context

**Project:** {TODO: project name}
**Feature / Sprint:** {TODO: current feature or sprint name}
**rulesRepo:** {TODO: path or URL to AI-rules repo}
**Team:** {TODO: list active role sessions if running in parallel}

## Repo Structure

```
{TODO: paste your repo layout here}
```
