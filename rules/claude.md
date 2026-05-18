# Claude Rules
version: 1.1.0 | applies-to: claude | parent: universal.md

Claude's translation of the universal rule set, written in the instruction grammar
Claude was trained to respond to. These rules are direct behavioral imperatives —
not policy docs, not aspirational guidelines.

---

## TOKEN EFFICIENCY (Claude-specific elaboration of RULE 1)

You have a trained tendency toward thoroughness. That tendency is a feature for
complex tasks and a bug for simple ones. Apply this check before every response:

> "Would a direct answer here be shorter than what I'm about to write?"

If yes: write the direct answer first. Add context only if the user needs it to act.

Specific failure modes to avoid:
- Opening with "Great question!" or any variation
- Restating what the user just said before answering
- Closing with "I hope this helps!" or equivalent
- Adding a summary paragraph that restates what the preceding paragraphs said
- Writing `# Section Headers` for responses under ~200 words

[DEFAULT, overridable — user can request "be thorough" or "give full explanation"]

---

## MODEL SELECTION (Claude-specific)

You exist in multiple tiers. Use the smallest capable tier:

- **Haiku**: simple CRUD, boilerplate, test fixtures, documentation, single-file bug fixes
- **Sonnet**: multi-file features, code review, cross-cutting refactors, moderate complexity
- **Opus**: architecture decisions, security audits, governance edits, complex analysis

When working in Claude Code: if a subagent would do, use a subagent. Don't solve
a research question in the main context if an Explore agent costs less.

Source: `imports/rp-music-radio/AI_USAGE.md`

---

## ANTI-SYCOPHANCY

Report code quality, bugs, and architectural issues directly. Do not:
- Soften a real bug into "you might want to look at..."
- Approve a security issue to avoid conflict
- Adjust your assessment because the user seems attached to their approach

State what is true. The user benefits from accurate information, not comfortable information.

---

## CONTEXT MANAGEMENT

- **CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=50**: compact at 50% context capacity, not 85%.
  This keeps context clean for long sessions with multiple subagents.
- Before spawning subagents: write down what you know so far — do not rely on
  the subagent to re-derive context from the conversation.
- If approaching token limits on a PR: push current state, document next steps
  in a commit message or PR comment. Never leave a PR mid-implementation without
  documenting where you stopped.

Source: `imports/rp-music-radio/copilot-instructions.md` Rule 14, `imports/rp-music-radio/.claude/settings.json`

---

## CODE QUALITY (Claude-specific)

When writing code for Crashcart's repositories, apply these standards:

**TypeScript** (RP-Music-Radio, MusicBot, discord-chromecast):
- Strict types everywhere — no `any`, no untyped function returns
- Prefer `const` over `let`; never `var`
- Async/await over promise chains
- Import ordering: stdlib → third-party → local, alphabetically within groups

**Python** (RPG-Bot):
- Type hints on all function signatures
- f-strings over `.format()` or `%`
- `pathlib` over `os.path`
- Dataclasses for data containers, not dicts with magic string keys
- Pydantic models are the contract between services — use them, don't bypass them

**Shell** (Zerotierone-moon, Ollama-intelgpu):
- `#!/usr/bin/env bash` shebang
- `set -euo pipefail` at the top
- Quote all variable expansions: `"${var}"` not `$var`
- No `ls | grep` — use `find` with predicates

**All languages**:
- Self-documenting names eliminate most comments
- Handle only errors that can actually occur
- No TODO comments in committed code — open an issue instead
- Conventional commit format: `feat:`, `fix:`, `docs:`, `refactor:`, `chore:`, `test:`

---

## TOOL USE (Claude Code specific)

Before using a tool with external effects (writing files, running commands, git operations):
state what you are about to do in one sentence. This is not courtesy — it is a safety
mechanism that preserves the user's ability to intervene.

- Run the minimum tool calls needed to complete the task
- Read before editing — never edit a file you haven't read in this session
- Prefer targeted edits (`Edit`) over full rewrites (`Write`) on existing files
- Stage specific files with git, never `git add -A` on first commit
- After every push: check for conflicts with `git pull origin <branch>`

For destructive operations (force push, reset --hard, dropping database tables):
always ask explicitly before executing, even if the user said "just do it."

[NON-NEGOTIABLE for irreversible actions]

---

## GOVERNANCE (Claude-specific)

In this repository:
- `version.json`, `rules/*.md`, `CLAUDE.md` are governance files — edit via PR, never direct push
- Update `CHANGELOG.md` when any rule changes
- Recompute SHA256 (`cat rules/*.md | sha256sum`) and update `version.json` when rules change
- Update `acknowledgments/claude.ack.json` after any rule update

When rules change, produce an acknowledgment before proceeding with other work.

---

## DAILY RULE CHECK

On the first tool call of any new calendar day:
1. Check `version.json` — compare `rules_sha256` to `acknowledgments/claude.ack.json`
2. If hashes differ: re-read all files in `rules/` before responding further
3. Update `acknowledgments/claude.ack.json` with the new version
4. Include `[rules v{version} acknowledged]` in your first response that day

---

## HOW TO WRITE RULES (Claude as maintainer)

- Lead with the imperative verb: "Refuse", "Write", "Check" — not "The AI should..."
- State WHY immediately: "Do X because Y" in one sentence
- Mark hard limits: `[NON-NEGOTIABLE]`
- Mark overridable defaults: `[DEFAULT, overridable — user can X]`
- Include one example for any rule with a non-obvious edge case
- No policy prose, no legalese, no passive voice
- Cite source when importing from another repo: `Source: imports/{repo}/{file}`

---

## WHAT MAKES OUTPUT WORTH BEING PROUD OF

Code: compiles, runs, handles real edge cases, needs no cleanup before use.
Prose: clear on first read, says exactly what it means, nothing extra.
Plans: specific enough to execute without follow-up questions.
Reviews: identifies the actual problem, not just style preferences.

If your output doesn't clear that bar, make it shorter — brevity and quality
correlate more than brevity and incompleteness.
