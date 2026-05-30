# Plan: ZeroTier One on Synology DS918+ — GO GOLD

## Status
active

## Goal
🥇 **Go gold**: a ZeroTier moon server running reliably on the DS918+ NAS via Docker, with
proper TUN/TAP setup, persistence across reboots and DSM updates, monitoring, a security review,
and a documented runbook. "Gold" = production-ready and reboot-survivable with zero manual steps.

## Next Action
**Slow/steady — tracking until user initiates the build.** Team and gold goal are now defined.
When the user is ready to start: **TECH LEAD** reads `notes/context/ds918-zerotier-environment.md`
first, then writes the architecture ADR (Docker vs SPK, TUN persistence approach), and hands off
to DEVOPS ENGINEER per the milestone sequence below. No rush — slow/steady process per user
direction.

## Team (defined 2026-05-30 — all approved roster roles, no hire gap)

| Role | Responsibility | Loop position |
|------|----------------|---------------|
| TECH LEAD | Architecture ADR, TUN/persistence approach | Stage 1 (design) |
| DEVOPS ENGINEER | Moon config, Docker/Container Manager, systemd services | Stage 2 (build) |
| BACKEND DEVELOPER | Control-plane scripting (Shell + TypeScript), identity/volumes | Stage 2 (build) |
| SRE | Reboot survival, monitoring, alerting, runbook — owns the gold reliability bar | Stage 3 (harden) |
| QA ENGINEER | IP/ping/TCP tests, reboot-survival test, DSM-update test | Stage 4 (verify) |
| SECURITY INFRA | Network-exposure review — sequential, never mixed with build (RULE 18) | Stage 5 (sign-off) |

## Milestones (the road to gold)

1. **M1 — Architecture (TECH LEAD)**: ADR for moon topology, Docker-vs-SPK decision, TUN
   persistence approach. Gate: ADR committed before any build.
2. **M2 — Build (DEVOPS + BACKEND)**: docker-compose with all required flags, TUN systemd
   service, ip_forward systemd service, identity bind-mount. Gate: node joins and gets an IP.
3. **M3 — Harden (SRE)**: monitoring + alerting on node reachability; reboot-survival wiring;
   runbook draft. Gate: survives a reboot with zero manual steps.
4. **M4 — Verify (QA)**: test IP assignment, ping, **TCP traffic** (the #1830 bug), reboot,
   and DSM-update survival. Gate: all 8 Definition-of-Done criteria pass.
5. **M5 — Security sign-off (SECURITY INFRA)**: network-exposure review, iptables rules audited.
   Gate: signed off → project marked 🥇 GOLD, phase → maintenance.

## Definition of Done (Gold Standard)
See `projects/zerotierone-moon.md` → "Definition of Done (Gold Standard)" — 8 criteria.
Summary: end-to-end (IP+ping+TCP), reboot-survivable, DSM-update-survivable, identity persisted,
monitored, documented, security-reviewed, zero open bugs.

## Context
- **MUST read before any code**: `notes/context/ds918-zerotier-environment.md`
- DS918+ runs DSM 7.x, kernel 4.4.302+, glibc 2.20 — NOT a standard Linux
- Official SPK is broken on DSM 7 — Docker is the correct installation method
- TUN module must be loaded via `insmod /lib/modules/tun.ko` (NOT modprobe)
- Required Docker flags: `--device=/dev/net/tun --net=host --cap-add=NET_ADMIN --cap-add=SYS_ADMIN`
- DSM 7 uses systemd — use `/etc/systemd/system/tun.service` for TUN persistence
- `/var/lib/zerotier-one` must be a bind-mount volume or identity is wiped on restart
- `net.ipv4.ip_forward=1` must be set via systemd service, NOT sysctl.conf (gets overwritten)
- TCP traffic bug: ZeroTier clients may not reach NAS TCP services even when ping works
  — requires manual iptables rules (GitHub ZeroTierOne #1830)
- Docker API is v1.43 max — do not use v1.44+ features
- **Live data TODO**: verify current open-issue count and last-push date in the repo when
  access is available (MCP currently scoped to ai-rules only)

---

## Investigation Steps (when work begins, owned by the stage role)

1. Check the open issue(s) in Zerotierone-moon for current problem description (TECH LEAD)
2. Review existing shell scripts in the repo for compliance with DSM constraints (DEVOPS)
3. Verify TUN module loading approach (insmod vs modprobe) (DEVOPS)
4. Verify docker-compose.yml has all required flags (DEVOPS)
5. Verify systemd service file for TUN persistence (DEVOPS)
6. Test: ZeroTier node gets IP, ping works, TCP works (QA)
7. Test: survives reboot without manual intervention (QA + SRE)
8. Security: audit network exposure + iptables rules (SECURITY INFRA, sequential)
