# Context: Zerotierone-moon

**Last updated**: 2026-05-30
**Repo**: https://github.com/Crashcart/Zerotierone-moon

## What This Is

ZeroTier moon server configuration and setup tooling for a Synology DS918+ NAS. A "moon" in ZeroTier is a private network root server that reduces latency and removes reliance on ZeroTier's public infrastructure. This repo sets up that moon on the user's home NAS.

## Stack

- Shell scripting (primary runtime environment)
- TypeScript (GitHub-detected language — likely config scripts or management tooling)
- ZeroTier CLI tooling
- Synology DSM (DiskStation Manager) as the OS

## Constraints

**IMPORTANT — Read `notes/context/ds918-zerotier-environment.md` before working on this repo.**

Key environment constraints:
- Synology DS918+ runs BusyBox Linux (not standard Debian/Ubuntu)
- `apt`, `systemd`, standard Docker — none of these exist
- Package management is via SPK (Synology Package Manager)
- Container Manager is a proprietary Docker wrapper; not vanilla Docker CLI
- Shell scripting must target BusyBox ash, not bash
- An active plan exists: `plans/active/zerotier-ds918.md`

## Open Issues at Onboard

2 open issues as of 2026-05-30. Pushed same day — actively being worked.
