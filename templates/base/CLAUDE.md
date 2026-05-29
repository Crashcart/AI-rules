# Claude Code Instructions — {TODO: REPO NAME}

## What This Repo Is

{TODO: one sentence describing what this repo does and who uses it}

## AI-Rules

This repo follows the Crashcart AI-rules system.

- Rules source: `https://github.com/crashcart/ai-rules` (set in `.claude/settings.json` as `rulesRepo`)
- Governing files: `.ai-rules/rules/claude.md` + `.ai-rules/rules/universal.md`
- Current version in force: check `rulesVersion` in `.claude/settings.json`

The PreToolUse hook in `.claude/settings.json` calls `scripts/check-rules-updates.sh` on every
Bash tool call (rate-limited to once per hour). If it prints "Rules updated to vX.Y.Z", stop
and re-read your rules before continuing.

## Session Start Checklist

1. Check hook output — if it says "Rules updated", re-read `.ai-rules/rules/` before anything else
2. **Read `.ai-rules/agents/project-manager.md`** — PROJECT MANAGER activates first on every session;
   follow the Session Activation Protocol defined there before delegating any work
3. Check for a `TODO.md` — if it exists, review open items from the last session
4. Confirm the active branch is `dev` (or a feature branch) — never `main`
5. Check for any resolved tickets that were opened by this repo's AI (hook output will say
   "Ticket TICK-NNN resolved")

## Agent Role Activation

Agent profiles live in `.ai-rules/agents/`. When activating any role, read its profile first:

```
Read .ai-rules/agents/project-manager.md — you are now PROJECT MANAGER. Follow the Session
Activation Protocol in that file before doing anything else.
```

Every role profile defines: Thinking Process, Role Scope, Escalation Triggers,
Hand-off Behavior. These are not optional — they define how the role operates.

Rules live in `.ai-rules/rules/` — `.ai-rules/rules/universal.md` applies to every AI;
`.ai-rules/rules/claude.md` applies specifically to Claude Code sessions in this repo.

## Branching Policy

- All work goes to `dev` or a feature branch off `dev`
- `dev` → `beta` → `main` via PR only — never push directly to `main`
- Branch naming: `type/short-description` (e.g., `feat/add-user-auth`, `fix/crash-on-startup`)

[NON-NEGOTIABLE]

## Rule-Edit Suggestions

If you want to suggest a change to any rule in ai-rules, do not modify the file directly.
Open a ticket in the ai-rules repo using `tickets/template.md`:
- Set **Scope** to `rule-edit`
- Set **Requesting AI** to your ai-id
- Claude (CEO) will discuss the change with you before implementing anything

## Private AI-Rules Repo

If your ai-rules repo is private, `scripts/check-rules-updates.sh` needs credentials to clone it.
Two options — set one in `.claude/settings.json` env:

**Option A — GitHub PAT (HTTPS)**
1. Create a PAT with `repo` (read) scope at GitHub → Settings → Developer settings
2. Set `AI_RULES_TOKEN` in `.claude/settings.json` env to your PAT
3. Keep `rulesRepo` as an HTTPS URL (`https://github.com/org/ai-rules`)

**Option B — SSH key**
1. Ensure the machine has an SSH key registered with GitHub
2. Set `rulesRepo` to the SSH URL: `git@github.com:org/ai-rules`
3. Leave `AI_RULES_TOKEN` empty (SSH key is used automatically)

## Repo Structure

{TODO: paste your directory layout here, e.g.:}

```
{repo-name}/
├── src/          ← source code
├── tests/        ← test files
├── scripts/      ← local scripts
│   └── check-rules-updates.sh  ← copy from ai-rules/scripts/
├── .claude/      ← Claude Code settings + hooks
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
