# ADR-008 — Docker Music Generation: Approach Undecided

**Author**: PROJECT MANAGER
**Date**: 2026-05-28
**Ticket**: —
**Status**: Open — no decision made; research complete as of 2026-05-28

---

## Context

RP-Music-Radio (AetherWave) is a radio station system with AI-generated DJ personalities.
The project needs a strategy for high-quality music generation or processing in Docker.
The `AI_USAGE.md` in that repo explicitly names "Lyria 3 / Gemini 3" as the AI API
integration target for music, suggesting an API-first (not self-hosted) path is already
assumed by that project's governance.

Research was completed 2026-05-28 into the best Docker setup for self-hosted AI music
generation. The primary candidates evaluated were:

- **Meta AudioCraft / MusicGen** — open source, self-hostable, CUDA-dependent
- **Stable Audio Open** — Stability AI, self-hostable
- **AudioLDM2** — open source (deprecated/superseded in 2026)
- **ACE-Step 1.5** — 2026 state-of-the-art, open-source, Apache 2.0
- **YuE** — full song with vocals, very hardware-intensive
- **Magenta RealTime** — Google open-weights, real-time streaming, 40 GB VRAM required
- **Riffusion** — obsolete/abandoned for broadcast use
- **Google Lyria 3** — API-only, not self-hostable (matches RP-Music-Radio's stated plan)
- **Icecast + Liquidsoap** — streaming layer, not generation
- **Post-processing chain** — ffmpeg+soxr, sox, pedalboard (Spotify) for broadcast output

## Research Findings (2026-05-28)

### Model Comparison

| Model | Native Rate | VRAM (min) | VRAM (recommended) | Speed (RTX 4090) | Clip Limit | Status |
|-------|------------|-----------|-------------------|-----------------|-----------|--------|
| MusicGen-small | 32 kHz mono | 4–6 GB | 6 GB | ~50 steps/sec | 120s | Active |
| MusicGen-medium | 32 kHz mono | 8 GB | 16 GB | ~50 steps/sec | 120s | Active |
| MusicGen-large | 32 kHz mono | 16 GB | 24 GB | ~50 steps/sec | 120s | Active |
| Stable Audio Open | **44.1 kHz stereo** | 8 GB | 12–16 GB | 8 steps/sec | **47s max** | Active |
| AudioLDM2 | 16 kHz default | 8 GB | 12 GB | moderate | none | Superseded |
| ACE-Step 2B turbo | **48 kHz stereo** | 6 GB | 8 GB | **34× real-time** | unlimited | Active (best) |
| ACE-Step XL 4B | **48 kHz stereo** | 16 GB | 24 GB | ~20× real-time | unlimited | Active |
| YuE (quantized) | ~24 kHz stereo | 12 GB | 16 GB | ~4 min / 1 min audio | song length | Active |
| YuE (full 7B) | ~24 kHz stereo | 80 GB | 80 GB | ~6 min / 30s audio | song length | Active |
| Magenta RealTime | **48 kHz stereo** | **40 GB** | 40 GB | real-time streaming | unlimited | Active |
| Riffusion | 44.1 kHz | 4–6 GB | 6 GB | fast | 5s clips | Obsolete |

**Key finding:** MusicGen is capped at 32 kHz by its EnCodec tokenizer — this is a hard limit, not
a config option. Upsampling to 44.1 kHz is required for broadcast use. ACE-Step 1.5 outputs
48 kHz stereo natively and is the strongest self-hosted candidate (Apache 2.0, active development,
purpose-built radio fork available: [ACE-Step-RADIO](https://github.com/PasiKoodaa/ACE-Step-RADIO)).

### Self-Hosted Architecture Pattern (if chosen)

The correct architecture for continuous radio generation with any model:

```
Redis (broker) → Celery GPU worker (model loaded once) → track output dir
                                                              ↓
                                          Liquidsoap (watch dir) → Icecast → listeners
```

- Celery worker: `worker_max_tasks_per_child=10` to prevent VRAM fragmentation
- Buffer manager: maintains 4–5 tracks ahead minimum
- Post-processing sidecar: `ffmpeg -resampler soxr -precision 28` → 44.1 kHz/24-bit FLAC
- ACE-Step-RADIO fork implements this queue natively with configurable buffer depth

### API-First (Lyria 3) Trade-offs

- No GPU hardware required
- Lyria 3 is confirmed API-only — weights are not released; no self-hosted path exists
- At radio scale (continuous 24/7), per-call costs and rate limits become significant unknowns
- RP-Music-Radio's `AI_USAGE.md` already names this path, but predates any cost/volume analysis

---

## The Open Question

**Neither direction has been confirmed as the right path:**

1. **Self-hosted generation in Docker** (AudioCraft et al.) — full control, no API cost,
   but requires GPU infrastructure, CUDA management, model caching, and ongoing maintenance.
   Quality ceiling varies per model; native output often needs upsampling to 44.1 kHz/24-bit
   for broadcast.

2. **API-first generation** (Lyria 3 / Google AI) — already the stated direction in
   RP-Music-Radio's own governance file. No GPU infra needed. But adds external dependency,
   per-call cost, and potential rate limits during continuous radio generation.

The user's position as of 2026-05-28: **unsure which approach is better**.

## Why No Decision Was Made

- RP-Music-Radio is not controlled by this repo — no changes can be made there without
  explicit authorization.
- The existing `AI_USAGE.md` in RP-Music-Radio already leans toward API-first (Lyria 3),
  but that was written before a full infrastructure cost/quality analysis.
- A self-hosted Docker stack would require knowing what GPU hardware is available
  (the DS918+ NAS is the known server; its GPU situation is documented in
  `notes/context/ds918-zerotier-environment.md` — it has no discrete GPU, which is a
  significant constraint against self-hosted model inference).

## Constraints That Inform Any Future Decision

- **DS918+ has no discrete GPU** — CPU-only inference for large generative models is
  extremely slow (minutes per track). Self-hosted high-quality generation is likely
  not viable on current hardware without a separate GPU node.
- **RP-Music-Radio is a separate repo** — any implementation must go through that
  project's own PR and governance process.
- **Continuous radio generation** requires either a large prebuffer, fast inference,
  or pre-generated library — all three have different Docker architecture implications.

## Next Steps (When a Decision Is Needed)

1. Clarify hardware: is a GPU node available or planned beyond the DS918+?
2. Clarify API budget: is Lyria 3 / Google AI API cost acceptable at radio-scale volume?
3. If self-hosted: benchmark ACE-Step 2B turbo (not AudioCraft — MusicGen's 32 kHz ceiling
   is a disqualifier for broadcast) on available hardware. The ACE-Step-RADIO fork is the
   most ready-to-deploy option; it requires a minimum 6–8 GB VRAM dedicated GPU.
4. If API-first: design a queue + prebuffer architecture that handles rate limits gracefully.
5. Any implementation goes to RP-Music-Radio via its own feature branch — not here.

## What This Repo Can Do

- Document the architecture decision once made (update this ADR to Accepted/Rejected)
- Add relevant Docker patterns to `templates/` if a self-hosted stack is chosen
- Sync this context to RP-Music-Radio via `scripts/sync-rules.sh` so the PM there has it
