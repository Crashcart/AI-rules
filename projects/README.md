# Project Portfolio Tracking

PROJECT MANAGER owns this directory. One file per tracked project. No reports generated
automatically — use `/report` to generate on demand.

---

## Directory Structure

```
projects/
├── README.md          ← this file
├── template.md        ← copy for each new project
├── _registry.json     ← manifest of all tracked projects (PM reads this first)
└── {repo-name}.md     ← one tracking file per project
```

---

## Commands

| Command | What it does |
|---------|-------------|
| `/report` | Generate full portfolio report for all tracked projects |
| `/report <repo-name>` | Generate report for one project |
| `/new-project <repo-name>` | Onboard a new project — assess team, create tracking file |
| `/help` | List all available commands |
| `/update-rules` | Pull latest AI-rules into this repo |

---

## How Scoring Works

Score reflects **bug-fix velocity and project health** — not feature output.

**Score formula (per period):**
```
Fix Rate = bugs_closed / max(bugs_opened, 1) * 100
```

**Score bands:**
| Score | Status | Symbol |
|-------|--------|--------|
| 80–100 | Healthy | 🟢 |
| 60–79 | Needs attention | 🟡 |
| 40–59 | At risk | 🟠 |
| < 40 | Critical | 🔴 |

**Leeway rules (do not penalize harshly when):**
- Project is in `new` or `development` phase — score shown with `(leeway)` tag
- Project is < 30 days old — same grace period
- Bug count is rising because of active QA discovery (expected early in development)
- PRs are merging regularly even if bugs are piling up (team is moving)

New features and initial development **do not count against** the score.
What counts: unresolved bugs aging out, zero activity for > 14 days, fix rate below 30% in maintenance phase.

---

## Hire Flags

When a role gap is identified, PROJECT MANAGER adds a Hire Flag to the project file.
PM does NOT act on hire flags independently — they surface them to the user in copy-paste format.

**Copy-paste format for hire requests:**
```
=== HIRE REQUEST ===
Project: {repo-name}
Role needed: {ROLE NAME}
Reason: {one sentence — what specific work is not getting done}
Gap evidence: {metric or observation that shows the gap}
Suggested test: {role-appropriate test from hiring/test-bank.md}
=== END HIRE REQUEST ===
```

Paste this to the user and wait for approval before activating HIRING MANAGER.

---

## PM Check-In Protocol

PM does a lightweight scan on every session start:
1. Read `projects/_registry.json` — note projects with score < 60 or last_updated > 7 days ago
2. For flagged projects, read the project file and note open hire flags
3. Update `last_updated` in `_registry.json` if any data was refreshed
4. Do NOT generate a report — just note internal state

Time budget: ~2–3 minutes per project, max 10 minutes total per session.
