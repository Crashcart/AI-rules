# AI-rules

Versioned behavioral rules for AI systems. Written in AI-native language —
direct imperatives, not policy documents.

Current version: **1.0.0**

---

## Core Rule

> **Minimum tokens. Maximum value. Every time.**
>
> The smallest response that fully solves the problem is the correct response.
> Code should be shippable. Output should be something you'd show off.

---

## Structure

```
rules/universal.md    — applies to all AI systems
rules/claude.md       — Claude-specific (written by Claude)
rules/gpt.md          — GPT / OpenAI
rules/gemini.md       — Gemini / Google
rules/ollama.md       — Local models via Ollama
```

`version.json` holds the current version and a SHA256 of all rule files.
When the hash changes, all AI systems must re-read rules and update their
acknowledgment in `acknowledgments/`.

---

## Acknowledgment Status

| AI | Version | Status |
|----|---------|--------|
| Claude | 1.0.0 | Acknowledged 2026-05-18 |
| GPT | — | Pending |
| Gemini | — | Pending |
| Ollama | — | Pending |

To get GPT/Gemini/Ollama to acknowledge: provide them with their respective
rule file (`rules/{ai}.md`) and `rules/universal.md`, then ask them to
produce the acknowledgment JSON for `acknowledgments/{ai}.ack.json`.

---

## Daily Snapshots

Each day, `scripts/daily-snapshot.sh` creates a `snapshot/YYYY-MM-DD` branch
with the current rule state. This is wired automatically via `.claude/settings.json`
when using Claude Code. Snapshots create an immutable audit trail.

---

## Importing Rules from Other Repos

See `CLAUDE.md` for the list of Crashcart repos to scan for importable patterns.
Copy files to `imports/{repo-name}/` for review before normalizing into `rules/`.

---

## Making Changes

1. Edit the relevant file(s) in `rules/`
2. Recompute SHA256: `cat rules/*.md | sha256sum`
3. Bump `version.json` (patch / minor / major per semver)
4. Add entry to `CHANGELOG.md`
5. Update `acknowledgments/claude.ack.json`
6. Commit and push

Claude Code handles steps 2–5 automatically when asked to update rules.
