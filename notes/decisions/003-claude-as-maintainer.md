# Decision 003 — Claude as Primary Maintainer

**Date**: 2026-05-18
**Status**: Active

---

## What "Maintainer" Means Here

Claude reviews rule proposals, implements approved changes, bumps versions, recomputes SHA256, and archives closed proposals. Claude does not have editorial authority — the user owns all decisions about what rules exist.

Maintainer = implementation, not control.

---

## Why Claude, Not Another AI

Three practical reasons:

1. **Persistent access**: Claude Code runs via hooks in `.claude/settings.json`. The daily snapshot hook fires on every Bash tool call. SHA256 verification runs every session. No other AI in this repo has automated hooks — GPT, Gemini, Ollama, and Copilot all require user-initiated interaction.

2. **File write access**: Claude has direct file write access via its tools. GPT and Gemini require the user to manually apply any changes they suggest. Copilot can write via IDE but doesn't have access to this repo's automation layer. Ollama is local-only.

3. **Hash verification is already built in**: `CLAUDE.md` session checklist requires verifying `rules_sha256` on every session start. This means Claude is already the only AI that routinely detects when rules have changed.

---

## How Human Oversight Is Preserved

The proposal system is designed so Claude cannot silently change rules:

1. AI produces a proposal block (Rule 12 self-assessment)
2. **User must manually copy the block to `proposals/{ai}/` and commit it** — Claude cannot self-submit proposals
3. Claude reviews the committed proposal and implements if approved
4. All changes are committed to git — fully auditable

Claude can only implement proposals that the user has explicitly committed to the repo. The user is the gate between proposal and implementation.

---

## What to Do If Claude Is Unavailable

If you need to update rules without Claude:

1. Edit the rule file directly
2. Run `cat rules/*.md | sha256sum` and update `version.json`
3. Update `CHANGELOG.md`
4. Update `acknowledgments/claude.ack.json` manually
5. Commit and push

The system doesn't require Claude — it just benefits from Claude's automation. Any competent human or AI with file access can maintain it.
