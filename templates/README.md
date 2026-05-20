# Repo Templates

Drop-in starter files for any new Crashcart repo using the AI-rules system.

---

## Which Template to Use

| Repo type | Template |
|-----------|----------|
| TypeScript (Discord bots, Node.js apps) | `typescript/` |
| Python (bots, scripts, ML) | `python/` |
| Shell / Docker / infrastructure | `shell/` |
| Mixed or unsure | Start with `base/` only |

---

## How to Apply

```bash
# From the ai-rules repo root:
bash templates/setup.sh <typescript|python|shell> /path/to/your/new-repo
```

Then open `/path/to/your/new-repo/CLAUDE.md` and fill in every line marked `{TODO}`.

That's it. The hooks, formatter, and branching policy are pre-wired.

---

## What Gets Copied

### Base layer (always applied)

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Claude Code instructions — session checklist, branching policy, repo context |
| `.claude/settings.json` | Autocompact at 50%, PostToolUse auto-formatter |
| `.github/copilot-instructions.md` | Copilot rules pointer + quick reference |

### Language overlay (applied on top of base)

Each language template overrides `CLAUDE.md` and `.claude/settings.json` with language-specific code standards and formatter config:

| Template | Formatter | Code standards |
|----------|-----------|----------------|
| `typescript/` | prettier (TS, TSX, JSON) | strict types, const, async/await, import order |
| `python/` | black | type hints, f-strings, pathlib, dataclasses, Pydantic |
| `shell/` | none | shebang, set -euo pipefail, quoted expansions |

---

## After Applying

1. Fill in `{TODO}` placeholders in `CLAUDE.md`
2. Install the formatter for your language:
   - TypeScript: `npm install --save-dev prettier`
   - Python: `pip install black`
   - Shell: no formatter needed
3. Commit the template files on your `dev` branch — never on `main`
4. Add your repo structure to the `## Repo Structure` section of `CLAUDE.md`

---

## Keeping Templates in Sync

When AI-rules bumps a version, check `MIGRATION.md` in this repo. If the version bump changes
`rulesVersion` or hook commands, update the `rulesVersion` field in your repo's `.claude/settings.json`.
