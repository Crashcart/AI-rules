# Claude Code Instructions — {TODO: REPO NAME}

## What This Repo Is

{TODO: one sentence describing what this repo does and who uses it}

## AI-Rules

This repo follows the Crashcart AI-rules system.

- Rules source: https://github.com/crashcart/ai-rules
- Governing files: `rules/claude.md` + `rules/universal.md`
- Current version in force: `1.3.0` — check `acknowledgments/claude.ack.json` in ai-rules for updates

On session start: if the version in ai-rules has changed since your last session, re-read `rules/claude.md` and `rules/universal.md` before doing anything else.

## Session Start Checklist

1. Read this file (`CLAUDE.md`)
2. Check for a `TODO.md` — if it exists, review open items from the last session
3. Confirm the active branch is `dev` (or a feature branch) — never `main`

## Branching Policy

- All work goes to `dev` or a feature branch off `dev`
- `dev` → `beta` → `main` via PR only — never push directly to `main`
- Branch naming: `type/short-description` (e.g., `feat/add-healthcheck`, `fix/env-missing`)

[NON-NEGOTIABLE]

## Shell / Docker Standards

- `#!/usr/bin/env bash` shebang on every script
- `set -euo pipefail` at the top of every script
- Quote all variable expansions: `"${var}"` not `$var`
- No `ls | grep` — use `find` with predicates
- Dockerfile: pin base image versions (`image:1.2.3`, not `image:latest`)
- `.env.example` must exist and list every required env var with a comment explaining it
- Never commit real `.env` files — only `.env.example`

## Repo Structure

{TODO: paste your directory layout here, e.g.:}

```
{repo-name}/
├── scripts/
│   └── *.sh
├── docker-compose.yml
├── Dockerfile
├── .env.example
├── .claude/      ← Claude Code settings
├── .github/      ← Copilot instructions, workflows
└── CLAUDE.md     ← you are here
```

## How to Commit

Use Conventional Commits:
- `feat:` — new feature
- `fix:` — bug fix
- `docs:` — documentation only
- `refactor:` — code change that isn't a fix or feature
- `chore:` — tooling, deps, config

## Key Contacts / Context

{TODO: anything Claude should know about this project that isn't obvious from the code}
