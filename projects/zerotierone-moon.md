# Project: Zerotierone-moon

**Repo**: https://github.com/Crashcart/Zerotierone-moon
**Status**: active
**Phase**: development
**Stack**: Shell + TypeScript (ZeroTier moon server, Synology DS918+ NAS)
**Added**: 2026-05-30
**Last PM check**: 2026-05-30
**Goal**: 🥇 **GO GOLD** — production-ready, reliable, reboot-survivable ZeroTier moon

---

## Mission: Go Gold

This project's target is the **Gold Standard** (see Definition of Done below): a ZeroTier moon
server that runs reliably on the DS918+, survives reboots and DSM updates with zero manual
intervention, is monitored, is security-reviewed, and has a documented runbook. Work proceeds
**slow/steady** per user direction — the team and goal are defined and ready; active work begins
when the user initiates.

---

## Team

| Role | Status | Responsibility |
|------|--------|----------------|
| TECH LEAD | active | Architecture: Docker vs SPK decision, TUN/persistence approach, ADR for the moon topology |
| DEVOPS ENGINEER | active | ZeroTier moon config, Docker/Container Manager setup, systemd persistence services |
| BACKEND DEVELOPER | active | Control-plane scripting (Shell + TypeScript), identity/volume management |
| SRE | active | Reliability: reboot survival, monitoring, alerting, the runbook — owns the "gold" reliability bar |
| QA ENGINEER | active | Verification: IP assignment, ping, TCP traffic, reboot-survival test, DSM-update test |
| SECURITY INFRA | **sequential** | Network-exposure review before gold sign-off (RULE 18 — never mixed with implementation; reviews after the build) |

**Gaps**: _(none — full team covered by approved roster. DS918+ BusyBox/DSM environment has
unusual constraints; every role MUST read `notes/context/ds918-zerotier-environment.md` before
touching code.)_

---

## Definition of Done (Gold Standard) [the bar for 🥇]

1. **Runs end-to-end** — ZeroTier node joins, gets an IP, ping works, **TCP traffic works**
   (the known TCP bug, ZeroTierOne #1830, is resolved or documented with a working iptables fix)
2. **Survives reboot** — node comes back online after a reboot with **no manual intervention**
3. **Survives DSM update** — TUN module + ip_forward persist across a DSM upgrade
4. **Identity persisted** — `/var/lib/zerotier-one` is a bind-mount; identity is never wiped
5. **Monitored** — SRE has alerting on node reachability; a downed moon pages, it does not go silent
6. **Documented** — a runbook exists: setup, restart, recovery, and the DS918+ constraints
7. **Security-reviewed** — SECURITY INFRA has signed off on network exposure (sequential review)
8. **Zero open bugs** — all open issues closed; fix rate ≥ 80 in maintenance phase (🟢)

When all 8 hold, the project moves to `maintenance` phase and is marked 🥇 GOLD.

---

## Score Card

> Score = bug-fix velocity. New/development phase has leeway — see `projects/README.md`.

| Date | Phase | Bugs Opened | Bugs Closed | Fix Rate | Score | Notes |
|------|-------|-------------|-------------|----------|-------|-------|
| 2026-05-30 | development | 2 | — | — | — (leeway) | Initial entry; open-issue count to be verified live (plan said 1, onboard scan said 2) |

**Current score**: — _(leeway — development phase; gold goal set)_

---

## Session Notes

- 2026-05-30: Project added to tracking. ZeroTier moon server on Synology DS918+.
- 2026-05-30: **Team defined and gold goal set.** Full 6-role team assembled (TECH LEAD, DEVOPS,
  BACKEND, SRE, QA, SECURITY INFRA sequential). No hire gap. Definition of Done = Gold Standard
  (8 criteria). Active plan `plans/active/zerotier-ds918.md` updated with team + milestones.
  Work remains slow/steady per user direction — tracking until user initiates the build.
- **TODO (live data)**: verify current open-issue count and last-push date directly in the repo
  when access is available — MCP is currently scoped to ai-rules only.

---

## Hire Flags

_(none — full team covered)_
