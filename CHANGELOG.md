# Changelog

Newest entries first. Format: `[VERSION] DATE — description`

---

## [1.4.1] 2026-05-19

**Rationale**: As the repo grew, three files were doing too much: `rules/claude.md` mixed behavioral, maintainer, and CEO operating contexts; `rules/universal.md` bundled orchestration governance with per-AI behavioral rules; `scripts/daily-snapshot.sh` contained two independent code paths behind one conditional. This patch splits each into focused, single-responsibility files and adds the CEO ticket system so other AIs can open work items for Claude to process on session start.

### Added
- `rules/claude-behavior.md` — behavioral rules extracted from claude.md (all sessions, all repos)
- `rules/claude-maintainer.md` — maintainer rules extracted from claude.md (AI-rules repo only)
- `rules/claude-ceo.md` — CEO ticket processing, hiring process, project oversight (AI-rules session start)
- `rules/agent-orchestration.md` — RULE 13 extracted from universal.md (multi-agent circular hand-off)
- `scripts/snapshot-branch.sh` — local-branch snapshot mode extracted from daily-snapshot.sh
- `scripts/snapshot-external.sh` — external-repo snapshot mode extracted from daily-snapshot.sh
- `tickets/` — CEO ticket system: README, template, archive/ directory

### Changed
- `rules/claude.md` — converted to routing stub pointing to three sub-files
- `rules/universal.md` — RULE 13 replaced with one-line reference to agent-orchestration.md
- `scripts/daily-snapshot.sh` — converted to thin dispatcher (reads config, calls sub-script)
- `version.json` — bumped to 1.4.1, new SHA256

---

## [1.4.0] 2026-05-18

**Rationale**: The repo had roles and rules but no way for multiple AI agents to collaborate on a project in a consistent, non-overlapping way. v1.4.0 adds the circular hand-off workflow as a universal rule and provides 19 fully-defined role profiles so any AI can be assigned a specific position in the development loop.

### Added
- `rules/universal.md` — Rule 13: Agent Circular Hand-off Workflow (PM → UX → UI → Tech Lead → Backend/Frontend/Mobile → QA → Security → DevOps → SRE → PM)
- `agents/` — 19 role profiles with invented personas, specialties, tools, and hand-off formats:
  - Core loop: product-manager, ux-designer, ui-designer, tech-lead, backend-developer, frontend-developer, fullstack-developer, qa-engineer, security-engineer, devops-engineer, sre
  - Mobile variants: mobile-developer-ios, mobile-developer-android
  - Specialists: data-engineer, ml-engineer, dba, technical-writer, cloud-engineer
  - Facilitator: scrum-master
- `agents/README.md` — circular workflow diagram, role index table, per-AI integration guide index
- `agents/project-manager.md` — Simone Adler, [NON-NEGOTIABLE] seven-artifact planning rule (scope, WBS, milestones, dependency map, risk register, resource allocation, definition of done) required before any work begins
- `agents/claude/README.md` — how Claude Code uses profiles (file tools, multi-session)
- `agents/gpt/README.md` — system message injection, manual hand-off workflow
- `agents/gemini/README.md` — role-instruction format, 1M context window usage
- `agents/copilot/README.md` — copilot-instructions.md injection, file-level comments
- `agents/ollama/README.md` — Modelfile SYSTEM block, model recommendations per role

### Updated
- `rules/universal.md` — Rule 13 appended (rule content changed → SHA256 updated)
- `CLAUDE.md` — repo structure map updated to include agents/, templates/, notes/, proposals/, MIGRATION.md
- `README.md` — repository layout updated to include agents/ and templates/ rows
- `version.json` — bumped to 1.4.0, new SHA256
- `acknowledgments/claude.ack.json` — updated to v1.4.0

---

## [1.3.0] 2026-05-18

**Rationale**: The repo had extensive rule content but no documented rationale, no cross-AI context for AIs reading cold, no migration guide, and an inconsistent SHA256 (computed in non-alphabetical file order). v1.3.0 fills those gaps without changing any rule behavior.

### Added
- `notes/` — three-layer documentation system:
  - `notes/decisions/` — five Architecture Decision Records (001–005) explaining why the system works the way it does
  - `notes/sessions/README.md` — format and retention policy for Claude's cross-session working notes
  - `notes/context/` — background for any AI reading cold: Crashcart overview, AI capability matrix, troubleshooting guide
- `MIGRATION.md` — per-version behavioral change guide so AIs know exactly what changed between versions
- `proposals/examples/` — approved and rejected example proposals with full format and outcome status
- `proposals/archive/.gitkeep` — pre-created archive directory so `git mv` works on first real proposal

### Updated
- `README.md` — added "Why This Exists" section; added `notes/`, `MIGRATION.md`, `proposals/` to repo layout
- `proposals/README.md` — added Timing, Cross-AI Conflicts, Moving to Archive, and Examples sections
- `acknowledgments/README.md` — added re-acknowledgment procedure for non-Claude AIs; linked to capability matrix
- `CHANGELOG.md` — added rationale lines to all prior version entries
- `version.json` — bumped to 1.3.0; corrected SHA256 to canonical alphabetical file order
- `acknowledgments/claude.ack.json` — updated to v1.3.0

### Fixed
- SHA256 in `version.json` and `claude.ack.json` was computed using non-alphabetical file order; corrected to `cat rules/*.md | sha256sum` (alphabetical). Rule content unchanged.

### Acknowledgments Required
- Claude: acknowledged v1.3.0 (claude-sonnet-4-6, 2026-05-18)
- All other AIs: re-acknowledge with new SHA256 (`c6af1b9d46ed0906c20aa87fc46fe34a2813d26992d498607175ec6db8b51021`)

---

## [1.2.0] 2026-05-18

**Rationale**: The system was static and top-down — other AIs could only receive rules, not propose improvements. v1.2.0 adds a feedback loop (Rule 12 self-assessment) so every AI can flag duplicates, conflicts, and gaps in its own rule file. Precedence clarified so there's no ambiguity when AI-specific and universal rules disagree.

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

**Rationale**: Four other Crashcart repos already had working AI rules in ad-hoc formats (copilot-instructions.md, guardrails.py, system prompts). v1.1.0 imports those proven patterns into a single normalized set rather than letting them drift independently. Copilot added as a first-class AI with its own rule file.

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

**Rationale**: No explicit behavioral contract existed across Crashcart repos — each AI operated on implicit expectations that varied by project and model. v1.0.0 establishes a baseline: versioned, per-AI rules written in each AI's native instruction grammar, with a SHA256-verified acknowledgment system so drift can be detected.

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
