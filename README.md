# AI-rules

> **Minimum tokens. Maximum value. Every time.**

Versioned behavioral rules for AI systems — written in each AI's native instruction grammar.
Not policy documents. Not aspirational guidelines. Direct imperatives each system actually processes.

**Current version:** `1.3.0` · [Changelog](CHANGELOG.md) · [version.json](version.json)

---

## Why This Exists

AIs behave inconsistently across repos when they have no explicit contract. Without versioned rules,
token efficiency varies by whim, code style drifts, and there's no way to detect when an AI has
silently changed behavior. This repo provides a versioned, auditable behavioral contract each AI
can explicitly acknowledge — and a mechanism for AIs to propose rule improvements when they notice
drift. See [`notes/decisions/001-why-this-repo.md`](notes/decisions/001-why-this-repo.md).

---

## Rule Files

| AI System | File | Format |
|-----------|------|--------|
| All systems | [`rules/universal.md`](rules/universal.md) | Direct imperatives |
| Claude | [`rules/claude.md`](rules/claude.md) | Claude instruction grammar |
| GPT / OpenAI | [`rules/gpt.md`](rules/gpt.md) | System-message grammar |
| Gemini | [`rules/gemini.md`](rules/gemini.md) | Role-instruction grammar |
| Ollama / Local | [`rules/ollama.md`](rules/ollama.md) | Modelfile SYSTEM block |
| GitHub Copilot | [`rules/copilot.md`](rules/copilot.md) | `.github/copilot-instructions.md` |

---

## Quick Start

**Claude (Code):** Rules load automatically via hooks in `.claude/settings.json`. Point `CLAUDE.md` at this repo.

**GPT:** Paste relevant sections of `rules/gpt.md` into your system message.

**Gemini:** Include sections of `rules/gemini.md` in your system instruction.

**Copilot:** Copy `rules/copilot.md` contents to `.github/copilot-instructions.md` in your repo.

**Ollama:** Copy the `MODELFILE SYSTEM BLOCK` section from `rules/ollama.md` into your Modelfile.
Set the required performance env vars from the performance settings table before deploying.

---

## Acknowledgment Status

Each AI records when it has ingested the current rules. An acknowledgment is a receipt — compliance is measured by behavior.

| AI | Version | Status | Last Acknowledged |
|----|---------|--------|-------------------|
| Claude | 1.3.0 | ✅ Acknowledged | 2026-05-18 |
| Copilot | — | ⏳ Pending | — |
| GPT | — | ⏳ Pending | — |
| Gemini | — | ⏳ Pending | — |
| Ollama | — | ⏳ Pending | — |

To trigger acknowledgment: give the AI its `rules/{ai}.md` + `rules/universal.md`, then ask it to produce the acknowledgment JSON for `acknowledgments/{ai}.ack.json`. See [`acknowledgments/README.md`](acknowledgments/README.md).

---

## Daily Snapshots

`scripts/daily-snapshot.sh` archives the rule state whenever the calendar day changes.
Runs automatically via the Claude Code PreToolUse hook — zero maintenance required.

| Mode | Config | Result |
|------|--------|--------|
| Branch mode (default) | `snapshotTargetRepo` empty | Creates `snapshot/YYYY-MM-DD` in this repo |
| Separate repo mode | `snapshotTargetRepo` set to a git URL | Pushes `rules-YYYY-MM-DD` branch to archive repo |

Both modes produce an immutable, dated audit trail.

---

## Updating Rules

1. Edit the relevant file in `rules/`
2. Recompute SHA256: `cat rules/*.md | sha256sum`
3. Bump `version.json` (patch · minor · major per semver)
4. Add entry to `CHANGELOG.md`
5. Update `acknowledgments/claude.ack.json`
6. Commit and push

Claude Code handles steps 2–5 automatically when asked to update rules.

---

## Importing Patterns

`imports/` holds raw source files from other Crashcart repos reviewed for pattern extraction.
All imported patterns are cited in the rule files that use them. See [`imports/README.md`](imports/README.md).

---

## Repository Layout

```
rules/           — rule files per AI system + universal
acknowledgments/ — per-AI acknowledgment records
proposals/       — open proposals from AIs; archive/ for closed
notes/           — decisions (ADRs), session notes, cross-AI context
imports/         — raw source files from other repos (read-only reference)
scripts/         — automation (daily snapshot)
.claude/         — Claude Code hooks and settings
version.json     — current version + SHA256 of all rule files
CHANGELOG.md     — full version history
MIGRATION.md     — per-version behavioral change guide for AIs
CLAUDE.md        — Claude Code integration instructions
```
