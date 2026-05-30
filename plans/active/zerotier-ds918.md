# Plan: ZeroTier One on Synology DS918+

## Status
active

## Goal
Get ZeroTier moon server running reliably on the DS918+ NAS via Docker, with proper
TUN/TAP setup and persistence across reboots and DSM updates.

## Next Action
DEVOPS ENGINEER: When user is ready to work on ZeroTier — read `notes/context/ds918-zerotier-environment.md` first, then review the current state of `Crashcart/Zerotierone-moon` repo. No rush — slow/steady process per user direction. Tracking only until user initiates work.

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

---

## Investigation Steps (when work begins)

1. Check the 1 open issue in Zerotierone-moon for current problem description
2. Review existing shell scripts in the repo for compliance with DSM constraints
3. Verify TUN module loading approach (insmod vs modprobe)
4. Verify docker-compose.yml has all required flags
5. Verify systemd service file for TUN persistence
6. Test: ZeroTier node gets IP, ping works, TCP works
7. Test: survives reboot without manual intervention
