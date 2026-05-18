# Decision 001 — Why This Repo Exists

**Date**: 2026-05-18
**Status**: Active

---

## Problem

When multiple AI assistants work across multiple repos without explicit behavioral contracts, three failure modes emerge:

1. **Drift**: Token efficiency, code style, and safety practices vary run-to-run and repo-to-repo, depending on which system prompt or context was active.
2. **Invisible assumptions**: Each AI applies its defaults. Those defaults differ across providers, model versions, and system prompts. No one can tell which rules are active at any time.
3. **No audit trail**: When an AI produces bad output — wasteful, insecure, stylistically wrong — there's no record of what rules it was operating under. You can't diff the problem.

## What "Crashcart" Is

Crashcart is a single developer's collection of AI-assisted projects:
- `RPG-Bot` — Discord RPG game (Python, Discord.py)
- `RP-Music-Radio` — DJ music bot (TypeScript, Discord.js)
- `Ollama-intelgpu` — Local LLM server (Intel GPU, Docker)
- `Kali-AI-term` — AI-enhanced terminal for security research
- `Claud` — Claude project files

These repos share a developer and an AI assistant (Claude). Without a shared rule set, every repo needed its own AI instructions — and they drifted.

## The Solution: Versioned Rule Files

Instead of embedding AI instructions in each repo's README or CLAUDE.md:
- Write rules once, in `rules/`, one file per AI system
- Version the rules with semver
- Hash all rule files so AIs can detect drift
- Require acknowledgment when versions change

This gives:
- **Explicit contracts**: AIs know exactly which rules they're operating under
- **Diffable history**: `git diff v1.0.0..v1.2.0 rules/` shows exactly what changed
- **Cross-repo consistency**: every Crashcart repo points to the same rule set

## Why a Git Repo

- Immutable history: you can always check out the rules as of any date
- Branching: experiments go on feature branches, don't pollute main
- Snapshot branches (`snapshot/YYYY-MM-DD`): daily audit trail without requiring tags
- Proposals live in the repo — change requests are version-controlled alongside the rules they propose to change
