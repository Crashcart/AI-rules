# ADR-008 — Docker Music Generation: Approach Undecided

**Author**: PROJECT MANAGER
**Date**: 2026-05-28
**Ticket**: —
**Status**: Open — no decision made; research incomplete

---

## Context

RP-Music-Radio (AetherWave) is a radio station system with AI-generated DJ personalities.
The project needs a strategy for high-quality music generation or processing in Docker.
The `AI_USAGE.md` in that repo explicitly names "Lyria 3 / Gemini 3" as the AI API
integration target for music, suggesting an API-first (not self-hosted) path is already
assumed by that project's governance.

Research was initiated 2026-05-28 into the best Docker setup for self-hosted AI music
generation. The primary candidates considered were:

- **Meta AudioCraft / MusicGen** — open source, self-hostable, CUDA-dependent
- **Stable Audio Open** — Stability AI, self-hostable
- **AudioLDM2** — open source
- **Google Lyria 3** — API-only, not self-hostable (matches RP-Music-Radio's stated plan)
- **Icecast + Liquidsoap** — streaming layer, not generation
- **Post-processing chain** — ffmpeg, sox, pedalboard for broadcast-quality output

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
3. If self-hosted: benchmark AudioCraft on available hardware to get realistic per-track times.
4. If API-first: design a queue + prebuffer architecture that handles rate limits gracefully.
5. Any implementation goes to RP-Music-Radio via its own feature branch — not here.

## What This Repo Can Do

- Document the architecture decision once made (update this ADR to Accepted/Rejected)
- Add relevant Docker patterns to `templates/` if a self-hosted stack is chosen
- Sync this context to RP-Music-Radio via `scripts/sync-rules.sh` so the PM there has it
