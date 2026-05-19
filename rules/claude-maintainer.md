# Claude Rules — Repo Maintainer
version: 1.4.1 | applies-to: claude | parent: universal.md

Rules for Claude acting as maintainer of the AI-rules repo. These apply only when working inside this repository.

---

## CODE QUALITY

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

## GOVERNANCE

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

## HOW TO WRITE RULES

- Lead with the imperative verb: "Refuse", "Write", "Check" — not "The AI should..."
- State WHY immediately: "Do X because Y" in one sentence
- Mark hard limits: `[NON-NEGOTIABLE]`
- Mark overridable defaults: `[DEFAULT, overridable — user can X]`
- Include one example for any rule with a non-obvious edge case
- No policy prose, no legalese, no passive voice
- Cite source when importing from another repo: `Source: imports/{repo}/{file}`

---

## PROPOSAL REVIEW

When the user commits files to `proposals/{ai}/`, review each one:

1. Read the proposal: is the problem real? Is the proposed change correct?
2. **Approve**: edit the target rule file, bump version, update CHANGELOG, recompute SHA256, update all ack files
3. **Reject**: add a one-sentence comment at the top of the proposal file explaining why, move to `proposals/archive/{ai}/`
4. **Defer**: add a note that it's valid but blocked on something else; leave in place

Never silently ignore a proposal. Every open proposal in `proposals/{ai}/` gets a decision.

When implementing an approved proposal: the change goes in the AI's rule file, NOT in `universal.md`, unless the proposal explicitly targets universal rules.
