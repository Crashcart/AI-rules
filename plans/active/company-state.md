# Company State — All Crashcart Repos

## Status
active

## Goal
Maintain a current snapshot of all Crashcart repos so PROJECT MANAGER and TECH LEAD
can make decisions without re-scanning GitHub every session.

## Next Action
TECH LEAD: assess RPG-Bot 43 open issues — triage into buckets (bug/feature/debt)
and create a sprint plan. This is the largest active backlog.

## Context
- AI-rules is at v1.28.0 with repo-as-memory architecture now live
- Zerotierone-moon has DS918+ environment research documented — check
  `notes/context/ds918-zerotier-environment.md` before any code changes
- Crashcart/Claud anomaly: default branch is `claude/brainarr-4E1zf` — investigate
  whether this was intentional or a stuck session; do not push to that branch without user confirmation
- Hiring authority: user granted open authority to recommend hires when needed

---

## Repo Inventory (scanned 2026-05-26)

| Repo | Type | Last Push | Status | Notes |
|------|------|-----------|--------|-------|
| `Crashcart/AI-rules` | Rules system | 2026-05-26 | Active | v1.28.0; this repo |
| `Crashcart/Zerotierone-moon` | ZeroTier moon server | 2026-05-24 | Active | 1 open issue; Shell; DS918+ target |
| `Crashcart/RPG-Bot` | Discord RPG bot | Recent | Active | **43 open issues** — largest backlog |
| `Crashcart/RP-Music-Radio` | Music gen + AI DJ | Recent | Active | TypeScript; universal pipeline consumer |
| `Crashcart/Kali-AI-term` | AI terminal Kali | Recent | Active | Shell; AI tool-calling patterns |
| `Crashcart/Ollama-intelgpu` | Ollama Intel GPU | Recent | Active | Shell; local model config |
| `Crashcart/Claud` | Claude project | Recent | Anomalous | Default branch = `claude/brainarr-4E1zf` |

### AI-rules (this repo) — v1.28.0
- Universal software pipeline (broker, bus, adapters, Docker) — shipped v1.27.0
- Plan persistence system (RULE 23, plans/ directory) — shipped v1.28.0
- DS918+/ZeroTier environment reference — notes/context/ds918-zerotier-environment.md
- 22 rules in universal.md + claude-specific, gpt, gemini, ollama, copilot rules
- 19+ agent profiles in agents/

### Zerotierone-moon
- ZeroTier moon server setup scripts for Synology DS918+
- **MUST read** `notes/context/ds918-zerotier-environment.md` before any code work
- Key constraints: DSM 7 + kernel 4.4.x + glibc 2.20 + Docker API v1.43
- 1 open issue — check before starting

### RPG-Bot (43 open issues — priority backlog)
- Discord bot, Python
- 43 open issues is the largest backlog in the company
- Needs triage before sprint planning
- Assign: BACKEND DEVELOPER + QA ENGINEER joint session

### RP-Music-Radio
- TypeScript music generation + AI DJ pipeline
- Universal pipeline bus (pipeline/) now available as integration point
- Check AI_USAGE.md (in imports/rp-music-radio/) for existing AI rules context

### Kali-AI-term
- Kali Linux AI terminal, shell-based tool calling
- Rules already synced via deploy/ package (v1.6.0+)

### Ollama-intelgpu
- Intel GPU Ollama configuration
- Rules already synced

### Claud (anomalous default branch)
- Purpose unclear from scan
- Default branch `claude/brainarf-4E1zf` suggests a stuck Claude Code session set this
- **Do not push without user clarification**
