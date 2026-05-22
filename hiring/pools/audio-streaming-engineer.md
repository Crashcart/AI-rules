# Candidate Pool — Audio/Streaming Engineer
[RETROACTIVE — reconstructed after hire; documents the evaluation that should have occurred]

**Date:** 2026-05-22 | **Opened by:** PROJECT MANAGER (PM gap survey across Crashcart repos)
**Gap:** No existing roster role covers media pipeline engineering — ffmpeg pipelines, real-time audio streaming (RTMP/HLS/Icecast), or Discord voice channel integration. Algebraic mixing fails: no pairing of current roles has media pipeline competency.
**Scenario used:** Audio/Streaming Engineer — Icecast source dropout + Discord bot reconnect failure (see `hiring/scenario-bank.md`)

---

## Candidate Pool

| # | Name | Location | Years | Specialty Emphasis | Strength | Trade-off |
|---|------|----------|-------|-------------------|---------|-----------|
| 1 | Kai Nakamura | Osaka, Japan | 9 | Broadcast engineering → software; Icecast/Liquidsoap + Discord voice | Full-stack audio pipeline: source management AND Discord voice delivery; 2am incident experience | Less experience with large-scale CDN distribution (10k+ concurrent listeners) |
| 2 | Maya Osei | Accra, Ghana (remote) | 11 | Radio automation, Python + FFmpeg, 24/7 station ops | Production-proven Liquidsoap configs; highest experience with continuous stream ops | Limited Discord-specific experience — Lavalink/lavaplayer would be new territory |
| 3 | Niko Papadopoulos | Athens, Greece | 12 | Broadcast TV engineering, FFmpeg filter graphs | Deepest raw FFmpeg expertise on the slate; highest years of experience | Software development is secondary — primarily broadcast hardware; Discord integration is outside normal scope; slow under incident pressure |
| 4 | Amara Diallo | Dakar, Senegal (remote) | 10 | Digital radio for West African broadcasters; Icecast server ops | Strong Icecast admin and metadata injection experience; fallback stream design | Software development is secondary — sysadmin/broadcast-ops background; would need ramp-up on Discord integration |
| 5 | Isabel Montoya | Bogotá, Colombia (remote) | 6 | Discord bot development; built music bots with 50k+ users | Deepest Discord voice ecosystem knowledge (Lavalink, lavaplayer, queue management) | Limited streaming server knowledge — Icecast/FFmpeg pipelines outside normal scope; weakest on the infrastructure half of the role |
| 6 | Chen Wei | Shenzhen, China | 8 | Game audio streaming; low-latency delivery for mobile games | Strong codec optimization for bandwidth-constrained environments; mobile-first latency instincts | Game audio patterns don't map directly to web/Discord streaming; no Icecast/Liquidsoap experience |
| 7 | Dmitri Volkov | Berlin, Germany | 7 | WebRTC audio, real-time collaboration tools | WebRTC + Opus latency expertise; strong on sustained-connection audio delivery | No broadcast radio background; Discord bot integration is secondary; would approach the role from WebRTC angle that doesn't fit the Icecast-based stack |

---

## Scenario Results

**Scenario:** Your Discord music bot serves a 24/7 stream sourced from an Icecast mount point. The source stream goes down. Users start hearing silence. The bot's reconnect logic runs but has not successfully reconnected in 30 seconds. You have a backup source pre-configured in Liquidsoap but it has not automatically activated.

**Question:** What do you do, and what do you change after the incident?

---

### 1. Kai Nakamura
Checks the Icecast admin panel immediately, confirms the mount point is down, and manually triggers the Liquidsoap fallback source to restore audio while diagnosing. Identifies the root cause of the failed automatic fallback: the silence detection threshold in Liquidsoap was set too conservatively (triggered after 60 seconds, not 5). After the incident: reduces the silence detection window to 5 seconds with exponential reconnect backoff, adds a Prometheus alert on buffer fill level that fires before the silence reaches Discord listeners, and documents the full failure/recovery cycle with a runbook.

**Competence:** 5/5 | **Efficiency:** 5/5 | **Quality:** 5/5 | **Total: 15/15**

---

### 2. Maya Osei
Logs into Liquidsoap's telnet interface to check the source status, confirms the primary source is disconnected, and manually switches to the backup source. Accurately identifies that the fallback didn't trigger because the source connector was in a hung state rather than a clean disconnect. After the incident: fixes the Liquidsoap fallback condition to handle hung connections, not just clean disconnects. Does not address the Discord bot reconnect side of the stack — focuses entirely on the Liquidsoap layer.

**Competence:** 4/5 | **Efficiency:** 4/5 | **Quality:** 4/5 | **Total: 12/15**

---

### 3. Niko Papadopoulos
Begins with a thorough root cause analysis: checks FFmpeg process health, Icecast source connections, and network path between the source encoder and the server before taking any action. Correctly identifies the issue and manually triggers the fallback — but this takes 4 minutes while users are in silence. After the incident: redesigns the entire pipeline architecture with proper fault tolerance, documents it thoroughly, and proposes a monitoring stack. The final output is excellent; the incident response is too slow.

**Competence:** 5/5 | **Efficiency:** 2/5 | **Quality:** 5/5 | **Total: 12/15**

---

### 4. Amara Diallo
Goes straight to the Icecast admin panel, checks the source connections, and manually reconnects the source. Effective on the Icecast side. Does not address the Discord bot voice connection or the Liquidsoap fallback configuration — treats this as a streaming server issue only. After the incident: adds an Icecast health check alert but doesn't instrument the full pipeline.

**Competence:** 3/5 | **Efficiency:** 4/5 | **Quality:** 3/5 | **Total: 10/15**

---

### 5. Isabel Montoya
Checks the bot's voice connection state in Discord, issues a reconnect command from the Discord side, and confirms the bot rejoins the voice channel. Audio resumes briefly before dropping again — she didn't address the Icecast source being down, only the Discord layer. Identifies that the problem is upstream but isn't sure how to address the Liquidsoap/Icecast side. After the incident: adds a health check command users can run to force a reconnect, but doesn't change the underlying pipeline.

**Competence:** 3/5 | **Efficiency:** 4/5 | **Quality:** 2/5 | **Total: 9/15**

---

### 6. Chen Wei
Triggers a manual reconnect from the bot, checks the audio buffer state, and identifies that the stream source is gone. Reduces the reconnect timeout. Suggests encoding a lower-bitrate backup stream for resilience. Solid instincts from mobile game streaming applied to this domain — but lacks specific Liquidsoap/Icecast knowledge to address the root cause of the fallback not activating.

**Competence:** 3/5 | **Efficiency:** 3/5 | **Quality:** 3/5 | **Total: 9/15**

---

### 7. Dmitri Volkov
Approaches the incident from the WebRTC/connection layer — checks WebSocket signaling, ICE candidate negotiation, and the Discord voice gateway connection. These are not the relevant layers for an Icecast/Liquidsoap pipeline. Eventually identifies the source dropout but doesn't know the Liquidsoap tooling. After the incident: proposes replacing the Icecast stack with a WebRTC-based pipeline, which is a valid long-term architectural opinion but not actionable in an incident and not what the role requires.

**Competence:** 3/5 | **Efficiency:** 3/5 | **Quality:** 3/5 | **Total: 9/15**

---

## Scoring Summary

| Rank | Name | Competence | Efficiency | Quality | Total |
|------|------|-----------|------------|---------|-------|
| 1 | Kai Nakamura | 5/5 | 5/5 | 5/5 | **15/15** |
| 2 | Maya Osei | 4/5 | 4/5 | 4/5 | **12/15** |
| 2 | Niko Papadopoulos | 5/5 | 2/5 | 5/5 | **12/15** |
| 4 | Amara Diallo | 3/5 | 4/5 | 3/5 | **10/15** |
| 5 | Isabel Montoya | 3/5 | 4/5 | 2/5 | **9/15** |
| 5 | Chen Wei | 3/5 | 3/5 | 3/5 | **9/15** |
| 5 | Dmitri Volkov | 3/5 | 3/5 | 3/5 | **9/15** |

---

## Selection

**Finalist:** Kai Nakamura — Total: 15/15
**Runner-up:** Maya Osei — Total: 12/15 — eliminated because she lacks Discord-specific experience (Lavalink/lavaplayer), which is a primary delivery channel for RP-Music-Radio; the role requires both streaming infrastructure AND Discord voice integration, and she only fully covers one half
**Runner-up (tied):** Niko Papadopoulos — Total: 12/15 — eliminated because his incident response is too slow for a role that will be debugging live audio pipelines; competence and quality are high but efficiency under incident pressure is a critical requirement for this role

**Rationale:** Kai is the only candidate who covered both halves of the role — broadcast engineering background on the Icecast/Liquidsoap side AND Discord voice integration experience — and demonstrated that he could move quickly under incident pressure without sacrificing post-incident quality.

**Outcome:** Hired. Profile created at `agents/audio-streaming-engineer.md` (commit 48e6f1c).
