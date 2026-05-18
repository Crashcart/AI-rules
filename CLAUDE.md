# Claude Code Instructions — AI-rules

## What This Repo Is

A versioned rule set for AI systems. You are both subject to these rules
and a maintainer of them. Read `rules/claude.md` before working here.

## Session Start Checklist

1. Check `version.json` → compare `rules_sha256` to `acknowledgments/claude.ack.json`
2. If hash differs: re-read all files in `rules/` before doing anything else
3. Update `acknowledgments/claude.ack.json` with the new version + timestamp
4. The daily snapshot hook runs automatically via `.claude/settings.json`

## How to Update Rules

When the user asks to create or change a rule:

1. Edit the relevant file in `rules/`
2. Recompute the SHA256: `cat rules/*.md | sha256sum`
3. Bump `version.json` (patch for wording, minor for new rule, major for schema change)
4. Update `CHANGELOG.md` with a new entry at the top
5. Update `acknowledgments/claude.ack.json`
6. Commit to `claude/add-user-credits-S3Fd4`, push

## How to Write Rules (AI-Native Language)

- Lead with the imperative verb: "Refuse", "Write", "Check" — not "The AI should..."
- State WHY immediately: "Do X because Y" in one sentence
- Mark hard limits: `[NON-NEGOTIABLE]`
- Mark overridable defaults: `[DEFAULT, overridable — user can X]`
- Include one example for any rule with a non-obvious edge case
- No policy prose, no legalese, no passive voice

## Importing Rules from Other Repos

The following Crashcart repos may contain importable patterns. The user
needs to grant GitHub MCP access to read them, or provide files manually:

| Repo | Why it's relevant |
|------|------------------|
| `Crashcart/Kali-AI-term` | AI terminal rules, tool-calling patterns |
| `Crashcart/RPG-Bot` | Python code quality, Discord bot conventions |
| `Crashcart/RP-Music-Radio` | TypeScript patterns |
| `Crashcart/Ollama-intelgpu` | Local model config patterns |
| `Crashcart/Claud` | Existing Claude project rules |

Copy imported files to `imports/{repo-name}/` for review before normalizing.

## Daily Snapshot Rule

The script `scripts/daily-snapshot.sh` runs automatically via the PreToolUse hook.
When `snapshotTargetRepo` in `.claude/settings.json` is set to a git URL, it clones
that repo and pushes a `rules-YYYY-MM-DD` branch with the current rule files.
When unset, it creates a `snapshot/YYYY-MM-DD` branch in this repo instead.

`lastSnapshotDate` in `.claude/settings.json` tracks the last snapshot date.

## Repo Structure

```
AI-rules/
├── CLAUDE.md              ← you are here
├── CHANGELOG.md           ← rule change history
├── version.json           ← current version + hash
├── README.md              ← user-facing overview
├── rules/
│   ├── universal.md       ← all AIs
│   ├── claude.md          ← Claude-specific
│   ├── gpt.md             ← GPT-specific
│   ├── gemini.md          ← Gemini-specific
│   ├── ollama.md          ← Local models
│   └── copilot.md         ← GitHub Copilot
├── acknowledgments/
│   ├── README.md          ← how acks work
│   ├── claude.ack.json    ← Claude's current ack
│   ├── copilot.ack.json   ← Copilot's ack (user-updated)
│   ├── gpt.ack.json       ← GPT's ack (user-updated)
│   ├── gemini.ack.json    ← Gemini's ack (user-updated)
│   └── ollama.ack.json    ← Ollama's ack (user-updated)
├── imports/               ← raw files from other Crashcart repos
│   ├── rp-music-radio/    ← AI_USAGE.md, copilot-instructions.md, claude-prompt.md
│   ├── rpg-bot/           ← guardrails.py
│   ├── ollama-intelgpu/   ← copilot-instructions.md
│   └── kali-ai-term/      ← copilot-instructions.md
└── scripts/
    └── daily-snapshot.sh  ← day-change snapshot (branch or separate repo)
```
