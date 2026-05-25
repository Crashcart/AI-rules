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
| Multi-agent factory pipeline | `factory/` |

---

## How to Apply

```bash
# From the ai-rules repo root:
bash templates/setup.sh <typescript|python|shell|factory> /path/to/your/new-repo
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

## Factory Layer

For multi-agent pipelines running multiple Claude Code sessions against a shared
context bus. Unlike the base/language templates, the factory template is **standalone**
— it does not inherit from `base/` because its session start behavior (read HANDOFF.md
first, activate role-appropriate profile) fundamentally differs from base behavior
(default to PROJECT MANAGER, check TODO.md).

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Factory session checklist, role activation table, quality gate and working beta checklists |
| `.claude/settings.json` | `CLAUDE_FACTORY_MODE=true`, `FACTORY_STAGE` warning hook, `factoryPipeline` order array |
| `HANDOFF.md` | Inter-session context bus — Pipeline Status table, Context Slots, Handoff Log |

Apply the factory template:

```bash
bash templates/setup.sh factory /path/to/your/project-repo
```

Then:
1. Fill `{TODO}` placeholders in `CLAUDE.md` and `HANDOFF.md`
2. Set `FACTORY_STAGE` in `.claude/settings.json` to the first stage name (`"PM"`)
3. Fill the Project Context slot in `HANDOFF.md`
4. Read `notes/context/software-factory.md` in the AI-rules repo for the full guide

---

## Fork Templates

For repos that are GitHub forks adding custom modules on top of upstream.

| File | Purpose |
|------|---------|
| `fork-modules.md` | Manifest template — tracks custom additions vs. upstream files, conflict risk per module |
| `upstream-sync.yml` | Auto-merge daily sync (safe when all fork additions are `None`/`Low` conflict risk) |
| `upstream-sync-pr.yml` | PR-based daily sync (use when any module has `Medium`/`High` conflict risk) |

**Which sync workflow to use:**
- No custom modules or all `None`/`Low` risk → `upstream-sync.yml` (auto-merges silently)
- Any `Medium`/`High` conflict risk modules → `upstream-sync-pr.yml` (opens a PR for review)

**Setup:**

```bash
# 1. Copy fork-modules.md to your fork repo root
cp templates/fork-modules.md /path/to/fork/FORK_MODULES.md

# 2. Copy the appropriate sync workflow
cp templates/upstream-sync-pr.yml /path/to/fork/.github/workflows/upstream-sync.yml

# 3. Set upstream remote once
cd /path/to/fork
git remote add upstream https://github.com/original-owner/original-repo

# 4. For PR-based workflow: set UPSTREAM_URL as a repo variable in GitHub Settings → Variables → Actions
```

---

## Keeping Templates in Sync

When AI-rules bumps a version, check `MIGRATION.md` in this repo. If the version bump changes
`rulesVersion` or hook commands, update the `rulesVersion` field in your repo's `.claude/settings.json`.
