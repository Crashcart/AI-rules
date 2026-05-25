# Claude Code Instructions — {TODO: REPO NAME}

## What This Repo Is

{TODO: one sentence — this fork of [upstream] that adds [what]}

**Upstream:** {TODO: https://github.com/original-owner/repo-name}

## AI-Rules (Embedded Subtree)

Rules live at `.ai-rules/rules/` — embedded via git subtree from `https://github.com/crashcart/ai-rules`.

If the SessionStart hook output says "Rules updated to vX.Y.Z": re-read `.ai-rules/rules/` before doing anything else.

To update AI-rules to the latest version:
```bash
git subtree pull --prefix=.ai-rules https://github.com/crashcart/ai-rules main --squash
```

## Session Start Checklist

1. Check hook output — "Rules updated" → re-read `.ai-rules/rules/` before anything
2. Read `FORK_MODULES.md` — understand protected custom additions and conflict risks
3. Check upstream sync status (RULE 21 — automatic via session-start hook)
4. Confirm branch is `dev` or `feature/...` — never work directly on `main`

## Branching Policy

- Work on `dev` or `feature/...` branches — never push directly to `main`

[NON-NEGOTIABLE]

## Fork Structure

```
{TODO: describe your repo structure here}
.ai-rules/          ← AI-rules subtree (do not edit — update via git subtree pull)
FORK_MODULES.md     ← custom additions manifest (track every file your fork adds)
```

## Commit Message Standard

Every commit must include a **Risk Notes** section. Required format:

```
<type>: <short summary>

<what changed>

Risk Notes:
- <file>: <what could break>

https://claude.ai/code/session_...
```

## How to Update Rules

If AI-rules releases a new version:
```bash
git subtree pull --prefix=.ai-rules https://github.com/crashcart/ai-rules main --squash
```

If the upstream project has new commits:
```bash
git pull upstream main
```
