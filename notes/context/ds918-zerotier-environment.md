# DS918+ + ZeroTier One: Environment Reference for AI Coding Agents

**Read this before writing any code for `Crashcart/Zerotierone-moon` or any other
project targeting a Synology DS918+ NAS. The DS918+ is NOT a standard Linux system.**

---

## Key Constraints for AI Coding Agents

- **x86_64**, Intel Celeron J3455 (Apollolake)
- **Kernel: 4.4.x permanently** — kernel 5.x/6.x features are unavailable (no io_uring, no full eBPF, cgroups v1 only)
- **glibc 2.20** — binaries compiled against newer glibc will fail with `GLIBC_2.xx not found`
- **DSM 7 = systemd** — use `systemctl` and `/etc/systemd/system/*.service`, NOT Upstart or sysvinit
- **NO `modprobe`** — use `insmod /path/to/module.ko` with the absolute path
- **NO `apt`/`yum`/`dnf`** — package management is SPK (GUI) or Entware/opkg (installs to `/opt/`)
- **Docker API v1.43 max** — Container Manager on DSM 7.2/7.3 is Docker Engine 24.0.x; API v1.44+ requests fail
- **ZeroTier SPK broken on DSM 7** — use Docker container only
- **TUN not present by default** — must load `insmod /lib/modules/tun.ko` + create `/dev/net/tun`
- **`/etc/sysctl.conf` is overwritten by DSM updates** — never rely on it for persistence

---

## 1. Hardware & DSM Overview

| Item | Value |
|------|-------|
| Model | Synology DS918+ |
| CPU | Intel Celeron J3455 (Apollolake) |
| Architecture | x86_64 |
| Max supported DSM | DSM 7.3 (build 7.3-81180, released 2025-10-08) |
| Support status | Limited — security updates only; no new features |
| Typical install | DSM 7.2 or 7.3 |

---

## 2. Linux Kernel & libc

| DSM version | Kernel | libc |
|------------|--------|------|
| DSM 6.2.x | 4.4.59+ | glibc 2.20 |
| DSM 7.0 / 7.1 | 4.4.180+ | glibc 2.20 |
| DSM 7.2 / 7.3 | 4.4.302+ | glibc 2.20 |

**The kernel will never be upgraded from 4.4.x** on DS918+. Features introduced in 5.x or 6.x are permanently unavailable:
- io_uring — not available
- eBPF — very limited (BPF syscall exists but JIT and map types are restricted)
- cgroups v2 — not available; cgroups v1 only
- CPU quota (`NanoCPUs` in Docker) — does not work (cfs_quota_us cgroup absent)

**libc toolchain:** `apollolake-gcc493_glibc220_linaro_x86_64-GPL.txz`
- This is **glibc**, not musl
- Binaries requiring `GLIBC_2.21+` will fail on all DS918+ regardless of DSM version

---

## 3. Shell Environment

- **DSM 7.x**: `/bin/bash` is present; `/bin/sh` symlinks to bash
- **GNU coreutils** is the primary tool provider in DSM 7 (not BusyBox for core tools)
- BusyBox is still on disk but not the default provider
- **Missing tools**: `less` may be limited; some GNU extensions may be absent
- **No `apt`/`yum`/`dnf`** — see Package Management section
- Always use `#!/bin/bash` (not `#!/bin/sh`) for scripts using bash features
- `set -euo pipefail` works correctly on DSM 7

---

## 4. Synology Container Manager (Docker)

Synology renamed the "Docker" package to **Container Manager** in DSM 7.2.

| Item | Value |
|------|-------|
| Docker Engine version | 24.0.x (24.0.2 confirmed on DSM 7.2) |
| Docker API version | **v1.43** (maximum — v1.44+ requests will fail) |
| Docker socket | `/var/run/docker.sock` (standard) |
| Storage driver | overlay2 |
| Cgroups | v1 only |
| User namespaces | NOT enabled by default |
| CPU limiting (`NanoCPUs`) | Does NOT work (cfs_quota_us missing) |
| PIDS cgroup | May be absent |

**Volume mounts:** Use absolute paths to Synology volumes: `/volume1/`, `/volume2/`, etc.
Do NOT use paths like `/home/` or `/data/` — map to a volume.

**Important docker socket path:** Standard path is `/var/run/docker.sock`. Some documentation
incorrectly cites `/volume1/docker/docker.sock` — verify on the actual system.

---

## 5. ZeroTier One — Installation & Configuration

### Installation Method (DSM 7)

**The official ZeroTierNAS SPK package is broken on DSM 7** (returns "incompatible with DSM").
Use a Docker container instead.

Recommended images:
- `sandros94/zerotier-synology`
- `arktronic/zerotier-dsm7`

### Required Docker Flags

```bash
docker run -d \
  --name zerotier-one \
  --restart unless-stopped \
  --device=/dev/net/tun \
  --net=host \
  --cap-add=NET_ADMIN \
  --cap-add=SYS_ADMIN \
  -v /var/lib/zerotier-one:/var/lib/zerotier-one \
  sandros94/zerotier-synology
```

**`--cap-add=SYS_ADMIN` is non-negotiable.** `NET_ADMIN` alone is insufficient — ZeroTier
needs `SYS_ADMIN` to perform the `ioctl()` that puts `/dev/net/tun` into tap mode.

### TUN Module Setup

TUN is not present by default. Load it before starting the container:

```bash
# Create the device node directory (may already exist)
mkdir -p /dev/net

# Load the TUN kernel module
insmod /lib/modules/tun.ko

# Create the TUN device node
mknod /dev/net/tun c 10 200
chmod 666 /dev/net/tun
```

**Use `insmod` with the full path, NOT `modprobe`** — `modprobe` fails on DSM (`Module configs not found`).

### Making TUN Persistent (DSM 7 / systemd)

Create `/etc/systemd/system/tun.service`:

```ini
[Unit]
Description=TUN/TAP kernel module
Before=docker.service
DefaultDependencies=no

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/bin/bash -c 'mkdir -p /dev/net && insmod /lib/modules/tun.ko && mknod /dev/net/tun c 10 200 && chmod 666 /dev/net/tun'

[Install]
WantedBy=multi-user.target
```

Enable: `systemctl enable tun.service`

**Note:** `/usr/local/etc/rc.d/*.sh` scripts are the DSM 6 approach. Still respected on DSM 7
but systemd units are preferred and more reliable across DSM updates.

### Key Paths

| Item | Path |
|------|------|
| ZeroTier data directory | `/var/lib/zerotier-one` |
| ZeroTier binary (manual install) | `/usr/local/bin/zerotier-one` |
| Control socket auth token | `/var/lib/zerotier-one/authtoken.secret` |
| Port file | `/var/lib/zerotier-one/zerotier-one.port` |
| TUN kernel module | `/lib/modules/tun.ko` |
| TUN device | `/dev/net/tun` |

**`/var/lib/zerotier-one` must be a volume mount** — without it, the ZeroTier node identity
(private key + network memberships) is wiped every time the container restarts.

### Network Interface

ZeroTier creates `zt<10-char-networkid>` virtual NICs (e.g., `ztXXXXXXXXXX`).
These are not visible in the DSM network GUI. Access with `ip addr` or `ifconfig`.

---

## 6. Package Management

| Method | Install path | Notes |
|--------|-------------|-------|
| SPK / Package Center | System paths | GUI; Synology-signed; limited selection |
| SynoCommunity | System paths | Third-party SPK repo; more packages |
| **Entware / opkg** | `/opt/` | Best for GNU userland; x86_64 supported |
| ipkg | `/opt/` | Older; largely replaced by Entware |

### Installing Entware (adds GNU tools)

```bash
# Download and run bootstrap (x86_64 for DS918+)
wget -O - https://bin.entware.net/x86-k3.2/installer/generic.sh | bash
# Then:
/opt/bin/opkg install <package>
```

Entware requires a startup task to mount `/opt` on boot (via DSM Task Scheduler or systemd).

---

## 7. Init System & Service Management

| DSM version | Init system | Unit file location |
|------------|-------------|-------------------|
| DSM 6.x | Upstart | `/etc/init/*.conf` |
| DSM 7.0+ | **systemd** | `/etc/systemd/system/*.service` |

On both versions, SPK packages may install legacy rc.d scripts to `/usr/local/etc/rc.d/*.sh`.
These survive reboots but may be cleared on major DSM version upgrades.

**Use `systemctl` on DSM 7:**
```bash
systemctl enable my-service.service
systemctl start my-service.service
systemctl status my-service.service
```

**Synology package management:**
```bash
synopkg start <package-name>
synopkg stop <package-name>
synopkg list
```

---

## 8. Networking: DSM Firewall & ZeroTier Integration

### DSM Firewall
- GUI-managed iptables; rules stored in Synology config, **not** `/etc/iptables`
- Manage firewall rules via: DSM → Control Panel → Security → Firewall
- ZeroTier's virtual NIC (`zt*`) is **not visible in the DSM network GUI**
- UDP port 9993 must be open for ZeroTier to reach its coordination network

### IP Forwarding
Required for ZeroTier routing/bridging:
```bash
sysctl -w net.ipv4.ip_forward=1
```
**Do NOT rely on `/etc/sysctl.conf`** — DSM updates overwrite it.

Make it persistent via a systemd service:
```ini
[Unit]
Description=Enable IP forwarding for ZeroTier
After=network.target

[Service]
Type=oneshot
ExecStart=/sbin/sysctl -w net.ipv4.ip_forward=1
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

### Known TCP Bug (ZeroTierOne #1830)
ZeroTier clients may successfully ping the NAS but fail to reach TCP services
(SSH, SMB, web UI) even when ZeroTier is otherwise working.

Root cause: DSM firewall (iptables) silently drops TCP packets arriving on the `zt*` interface.

Workaround — add iptables rules:
```bash
iptables -I FORWARD -i zt+ -j ACCEPT
iptables -I FORWARD -o zt+ -j ACCEPT
iptables -t nat -I POSTROUTING -o zt+ -j MASQUERADE
```

These rules must be persisted via a systemd service (same issue — iptables state resets on reboot).

---

## 9. Known Gotchas

| Gotcha | Impact | Workaround |
|--------|--------|-----------|
| Kernel 4.4.x permanently | No io_uring, limited eBPF, cgroups v1 only | Design for 4.4.x from the start |
| glibc 2.20 | Newer-compiled binaries fail | Cross-compile targeting glibc 2.20 or use Docker |
| `modprobe` fails | Cannot load kernel modules normally | Use `insmod /lib/modules/<mod>.ko` |
| `/etc/sysctl.conf` overwritten | Kernel params reset on DSM update | Use systemd service for `sysctl -w` |
| Docker API v1.43 max | API v1.44+ features unavailable | Cap docker-py/SDK to ≤ v1.43 API calls |
| CPU limiting (NanoCPUs) broken | Docker resource limits don't apply | Do not rely on container CPU limiting |
| PIDS cgroup may be absent | Container process limits may fail | Avoid `--pids-limit` |
| User namespaces off | Containers run as host UIDs | Run containers as non-root explicitly if needed |
| TUN not present by default | ZeroTier container fails to start | Load `insmod /lib/modules/tun.ko` first |
| `SYS_ADMIN` required | ZeroTier fails with NET_ADMIN only | Always include `--cap-add=SYS_ADMIN` |
| `/var/lib/zerotier-one` must be volume | Node identity wiped on restart | Always bind-mount this path |
| TCP traffic drops on ZeroTier NIC | NAS TCP unreachable from ZeroTier clients | Add iptables FORWARD rules |
| rc.d scripts cleared on major DSM upgrade | Startup scripts lost | Prefer systemd units over rc.d |
| DSM network GUI hides zt* interfaces | Can't configure ZeroTier NIC in GUI | Use CLI (`ip addr`, `iptables`) |

---

## 10. Quick Reference: Paths & Commands

```bash
# TUN setup
insmod /lib/modules/tun.ko
mkdir -p /dev/net && mknod /dev/net/tun c 10 200 && chmod 666 /dev/net/tun

# ZeroTier CLI (if manually installed)
/usr/local/bin/zerotier-one -q listnetworks
/usr/local/bin/zerotier-cli join <networkid>
/usr/local/bin/zerotier-cli info

# ZeroTier CLI via Docker
docker exec zerotier-one zerotier-cli info
docker exec zerotier-one zerotier-cli listnetworks
docker exec zerotier-one zerotier-cli join <networkid>

# IP forwarding (non-persistent)
sysctl -w net.ipv4.ip_forward=1

# Entware package install
/opt/bin/opkg install <package>

# DSM service management
systemctl status <service>
synopkg list

# Key directories
/var/lib/zerotier-one    # ZeroTier data (identity, config)
/lib/modules/            # Kernel modules (use insmod, not modprobe)
/usr/local/etc/rc.d/     # Legacy SPK startup scripts (DSM 6 style)
/etc/systemd/system/     # systemd unit files (DSM 7)
/opt/                    # Entware install prefix
/volume1/, /volume2/     # NAS storage volumes
```

---

## Sources & Version Notes

Research conducted 2026-05-26. Covers DSM 7.2 and 7.3 primarily.

Key sources:
- Synology DS918+ Product Support Status — limited support (security-only) confirmed
- Synology DSM Release Notes for DS918+
- Synology Developer Guide toolchain: `apollolake-gcc493_glibc220_linaro_x86_64-GPL.txz`
- zerotier/ZeroTierNAS Issue #114 — DSM 7.0 unsupported confirmed
- ZeroTierOne Issue #1830 — TCP traffic drops via Docker on DSM
- GitHub: `arktronic/zerotier-dsm7`, `Sandros94/zerotier-synology`
- GitHub: `007revad/Synology_Information_Wiki` kernel version tables
- nextcloud/all-in-one Issue #7365 — Docker API v1.43 vs v1.44 on Synology confirmed
- k3s-io/k3s Issue #5080 — cgroup support missing on DSM
- SynoCommunity/spksrc Issue #5772 — apollolake kernel 4.4 on DSM 7.2 confirmed
- Container Manager Release Notes — Docker Engine 24.0.x confirmed
