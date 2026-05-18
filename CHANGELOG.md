# Changelog

Newest entries first. Format: `[VERSION] DATE — description`

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
