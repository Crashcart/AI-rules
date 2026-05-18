# Crashcart: Context for AIs Reading This Repo

This file explains what "Crashcart" is and why rules need to be consistent across it.
Read this first if you are an AI encountering this repo without prior context.

---

## What Crashcart Is

Crashcart is a single developer's collection of AI-assisted software projects. All repos share:
- One owner/developer
- AI assistants as primary collaborators (Claude, Copilot, GPT)
- Active development rather than archived/demo status

---

## The Repos

| Repo | Language | Purpose |
|------|----------|---------|
| `RPG-Bot` | Python, Discord.py | Text-based RPG game running in a Discord server |
| `RP-Music-Radio` | TypeScript, Discord.js | Automated DJ music bot with AI-generated commentary |
| `Ollama-intelgpu` | Docker, Shell | Local LLM server optimized for Intel Arc GPU |
| `Kali-AI-term` | Python, Shell | AI-enhanced terminal for security research workflows |
| `Claud` | Various | Claude project files and configuration |
| `AI-rules` | Markdown | This repo — versioned behavioral rules for all AIs |

---

## Why Rules Must Be Consistent

Each repo uses AI differently, but the same developer is using the same AI assistants across all of them. Without a shared rule set:

- "No backwards-compat shims" applies in RP-Music-Radio but not RPG-Bot (different instruction sets)
- Token efficiency varies depending on which system prompt was most recently updated
- Code style drifts: TypeScript conventions in RP-Music-Radio might not match what Claude applies to a new TS file in another repo

AI-rules provides a single source of truth. Each repo can reference it rather than duplicating AI instructions.

---

## What "Crashcart Conventions" Means

When rule files or decision records reference "Crashcart conventions" or "Crashcart repos", they mean:
- TypeScript: strict types, `const` over `let`, no `any`, functional patterns
- Python: type hints, f-strings, Pydantic for data validation, pytest for tests
- Shell: `#!/usr/bin/env bash`, `set -euo pipefail`, always quote expansions
- Git: conventional commits (`feat:`, `fix:`, `docs:`), feature branches, PR review before main

These conventions are the baseline unless a specific repo's rules override them.

---

## How AI-rules Relates to Each Repo

AI-rules is the central rule authority. Individual repos may have a `CLAUDE.md` that references or imports from AI-rules, but AI-rules is the canonical source. When rules conflict:

```
individual repo's CLAUDE.md  >  AI-rules/{ai}.md  >  AI-rules/universal.md
```

The most specific context wins.
