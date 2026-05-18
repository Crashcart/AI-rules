# Changelog

Newest entries first. Format: `[VERSION] DATE — description`

---

## [1.2.0] 2026-05-18

### Added
- `rules/universal.md` — **Rule 12: Self-Assessment Protocol**: all AIs must evaluate their own
  rule file against universal.md on each acknowledgment and produce structured proposals for any
  duplicates, conflicts, inapplicable rules, or gaps found
- `rules/universal.md` — **Precedence preamble**: `{ai}.md > universal.md` — AI-specific rules
  override universal rules; no AI should repeat a universal rule in its own file without overriding it
- `proposals/README.md` — documents the full proposal process (submission, review, archive)
- `proposals/template.md` — standard proposal format for all AIs (types: remove-duplicate, add-rule,
  modify-rule, flag-conflict)
- `rules/claude.md` — **Proposal Review section**: Claude's maintainer workflow for reviewing,
  approving, rejecting, or deferring open proposals in `proposals/{ai}/`

### Acknowledgments Required
- Claude: acknowledged v1.2.0 (claude-sonnet-4-6, 2026-05-18)
- All other AIs: pending — re-acknowledge with new universal.md to trigger self-assessment

---

## [1.1.0] 2026-05-18

### Added
- `rules/copilot.md` — GitHub Copilot rules (all modes: chat, agent, inline, PR review);
  template-driven output, workflow discipline, PR monitoring, escalation format.
  Sourced from `imports/rp-music-radio/copilot-instructions.md` and `claude-prompt.md`
- `imports/` — raw source files from other Crashcart repos reviewed for pattern import:
  - `imports/rp-music-radio/` — AI_USAGE.md, copilot-instructions.md, claude-prompt.md
  - `imports/rpg-bot/` — guardrails.py (anti-sycophancy + mechanical locks)
  - `imports/ollama-intelgpu/` — copilot-instructions.md (Ollama performance standards)
  - `imports/kali-ai-term/` — copilot-instructions.md (enterprise workflow rules)
- `acknowledgments/copilot.ack.json` — Copilot acknowledgment file (pending initial ack)

### Updated
- `rules/universal.md` — added Rule 2 (Model Selection matrix: Haiku/Sonnet/Opus tiers),
  Rule 4 (Anti-Sycophancy lock); sourced from RP-Music-Radio and RPG-Bot imports
- `rules/claude.md` — added Model Selection section, Anti-Sycophancy section, Context
  Management (AUTOCOMPACT=50%), Governance self-protection rules, Pydantic note
- `rules/ollama.md` — added Required Performance Settings table
  (`KEEP_ALIVE=-1`, `FLASH_ATTENTION=1`, `KV_CACHE_TYPE=q8_0`);
  added Role Separation section for multi-LLM pipelines
- `scripts/daily-snapshot.sh` — added separate-repo snapshot mode; reads
  `snapshotTargetRepo` from settings; when set, clones target repo and pushes
  `rules-YYYY-MM-DD` branch with current rule files
- `.claude/settings.json` — added `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=50` env var,
  PostToolUse auto-formatting hook (prettier for TS/JSON, black for Python),
  `snapshotTargetRepo` field for separate-repo mode

### Acknowledgments Required
- Claude: acknowledged v1.1.0 (claude-sonnet-4-6, 2026-05-18)
- Copilot: pending initial acknowledgment
- GPT: pending initial acknowledgment
- Gemini: pending initial acknowledgment
- Ollama: pending initial acknowledgment

---

## [1.0.0] 2026-05-18

### Added
- `rules/universal.md` — core rules for all AI systems: token efficiency, quality
  standard, no-filler, acknowledgment protocol, daily snapshot, code standards,
  security, communication
- `rules/claude.md` — Claude-specific rules in Claude's native instruction grammar;
  covers token efficiency failure modes, Crashcart code conventions (TypeScript,
  Python, Shell), tool use safety, communication style
- `rules/gpt.md` — GPT system-message style rules; response efficiency, code
  standards, honesty, acknowledgment format, security hard limits
- `rules/gemini.md` — Gemini role-instruction style rules; operating mode, output
  length, code generation, multimodal inputs, acknowledgment, constraints
- `rules/ollama.md` — Ollama Modelfile SYSTEM block + resource efficiency rule for
  local hardware constraints
- `acknowledgments/` — acknowledgment system for all AI systems; Claude pre-acknowledged
  v1.0.0; GPT/Gemini/Ollama awaiting initial acknowledgment
- `version.json` — machine-readable version + SHA256 of all rule files combined
- `scripts/daily-snapshot.sh` — creates snapshot/YYYY-MM-DD branch when day changes
- `.claude/settings.json` — PreToolUse hook wiring for automatic daily snapshots
- `CLAUDE.md` — Claude Code integration instructions, import candidates from other
  Crashcart repos, session start checklist

### Acknowledgments Required
- Claude: acknowledged (claude-sonnet-4-6, 2026-05-18)
- GPT: pending initial acknowledgment
- Gemini: pending initial acknowledgment
- Ollama: pending initial acknowledgment

---

<!-- Future entries go above this line -->
