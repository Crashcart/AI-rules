# Imports

Raw source files from other Crashcart repos, preserved as-is for reference.
These files are not used directly — patterns extracted from them are normalized
into `rules/` with source citations.

## Sourced Files

| Source | File | Patterns Extracted |
|--------|------|--------------------|
| `Crashcart/RP-Music-Radio` | `rp-music-radio/AI_USAGE.md` | Model selection matrix (Haiku/Sonnet/Opus tiers) → `rules/universal.md` Rule 2 |
| `Crashcart/RP-Music-Radio` | `rp-music-radio/copilot-instructions.md` | Governance rules, security rules → `rules/copilot.md`, `rules/universal.md` |
| `Crashcart/RP-Music-Radio` | `rp-music-radio/claude-prompt.md` | Structured output rules → `rules/copilot.md` |
| `Crashcart/RPG-Bot` | `rpg-bot/guardrails.py` | Anti-sycophancy lock, role separation → `rules/universal.md` Rule 4, `rules/ollama.md` |
| `Crashcart/Ollama-intelgpu` | `ollama-intelgpu/copilot-instructions.md` | Performance settings table → `rules/ollama.md` |
| `Crashcart/Kali-AI-term` | `kali-ai-term/copilot-instructions.md` | Enterprise workflow rules → `rules/copilot.md` |

## Policy

- Never edit files in `imports/` — they are read-only reference material
- When a source repo updates, re-import the file and evaluate whether `rules/` needs updating
- All citations in `rules/` must reference the file in `imports/` that sourced them
