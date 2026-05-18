# Migration Guide

When the rule version changes, this guide tells each AI exactly what behavior to update.

Read the entry for your current version → target version pair. Apply all listed behavior changes before acknowledging the new version.

---

## v1.2.0 → v1.3.0

_No behavior change required — v1.3.0 adds documentation only (notes/, MIGRATION.md, proposal examples, README/CHANGELOG/proposals updates). No rule files changed._

**SHA256 note**: The v1.3.0 SHA256 differs from v1.2.0 because the hash was recalculated using canonical alphabetical file order (`cat rules/*.md | sha256sum`). The v1.2.0 hash was computed in a different order. Rule content is identical.

**Action**: Re-acknowledge with the v1.3.0 SHA256:
```
c6af1b9d46ed0906c20aa87fc46fe34a2813d26992d498607175ec6db8b51021
```

---

## v1.1.0 → v1.2.0

**SHA256 for v1.2.0**: `a01a59d4def735e77ec318fa11e565ed58270b74692bed4992756ec7a8968a03`

### New Behavior Required

**Rule 12 — Self-Assessment Protocol** (added to `rules/universal.md`):
- On every acknowledgment, evaluate your own `rules/{ai}.md` against `rules/universal.md`
- Find duplicates (your file repeats a universal rule without changing it) → produce `remove-duplicate` proposal
- Find conflicts (your file contradicts a universal rule) → produce `flag-conflict` proposal; your file wins
- Find inapplicable rules (references tools or systems you don't have) → produce `remove-duplicate` or `modify-rule` proposal
- Find gaps (behavior you apply that isn't captured anywhere) → produce `add-rule` proposal
- Use `proposals/template.md` format for all proposals

**Precedence Preamble** (added to `rules/universal.md`):
- Your AI-specific rule file overrides universal.md where they conflict
- Do not repeat a universal rule in your file unless you are explicitly changing its behavior

### Files That Changed
- `rules/universal.md` — added precedence preamble + Rule 12
- `rules/claude.md` — added Proposal Review section (Claude-specific)
- `proposals/README.md` — new file
- `proposals/template.md` — new file

### No Change Required For
- Model selection tiers (unchanged from v1.1.0)
- Anti-sycophancy behavior (unchanged)
- Code standards (unchanged)
- Governance rules (unchanged)

---

## v1.0.0 → v1.1.0

**SHA256 for v1.1.0**: _Not recorded — version.json SHA256 tracking began at v1.2.0. Recompute if needed: `cat rules/*.md | sha256sum` on the v1.1.0 git tag._

### New Behavior Required

**Rule 2 — Model Selection** (added to `rules/universal.md`):
- Use Haiku for simple, single-file, no-side-effect tasks
- Use Sonnet for multi-file, multi-step, judgment-required tasks
- Use Opus for architecture decisions and security-sensitive changes
- This applies when you are choosing which model to use for a subagent or API call

**Rule 4 — Anti-Sycophancy** (added to `rules/universal.md`):
- Flag real issues even when the user seems committed to an approach
- Do not validate bad ideas to avoid conflict
- When something is wrong or risky, say so directly — one sentence is enough

**Ollama-specific**: Required performance settings (added to `rules/ollama.md`):
- `OLLAMA_KEEP_ALIVE=-1` — prevent cold starts
- `OLLAMA_FLASH_ATTENTION=1` — 2-3x inference speedup
- `OLLAMA_KV_CACHE_TYPE=q8_0` — 50% VRAM reduction
- These are non-negotiable for production Ollama deployments

### Files That Changed
- `rules/universal.md` — added Rules 2 and 4
- `rules/claude.md` — added Model Selection, Anti-Sycophancy, Context Management, Governance sections
- `rules/ollama.md` — added Required Performance Settings, Role Separation sections
- `rules/copilot.md` — new file (GitHub Copilot rules)
- `scripts/daily-snapshot.sh` — added separate-repo snapshot mode
- `.claude/settings.json` — added AUTOCOMPACT env var, PostToolUse formatting hook

---

## Initial Setup (v1.0.0)

**SHA256 for v1.0.0**: _Not recorded in version.json (SHA256 tracking added in v1.2.0). Recompute if needed._

First-time setup for each AI system:

1. Read `rules/universal.md` — applies to all AIs
2. Read `rules/{ai}.md` — your AI-specific rules
3. Check for conflicts with your provider's policies → add to `"conflicts"` array in your `.ack.json`
4. Produce the acknowledgment JSON for `acknowledgments/{ai}.ack.json`
5. (If you can write files) update the file; otherwise give the JSON to the user to commit

See `acknowledgments/README.md` for the exact JSON format.
