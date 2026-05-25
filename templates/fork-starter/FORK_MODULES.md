# Fork Modules — {TODO: PROJECT NAME}

**Upstream:** {TODO: https://github.com/original-owner/repo-name}
**This fork:** {TODO: https://github.com/your-username/repo-name}

---

## Custom Modules

> Add a row each time your fork introduces a new file, directory, or config.
> Reference: `templates/fork-modules.md` in AI-rules for field definitions.

| Path | Type | Description | Conflict Risk |
|------|------|-------------|---------------|
| `.ai-rules/` | directory | AI-rules system (git subtree — do not edit directly) | None — upstream project will not have this directory |

**Conflict Risk:** `None` · `Low` · `Medium` · `High`
**Type:** `directory` · `file` · `config` · `script` · `workflow` · `rule`

---

## Files Modified from Upstream

> List any upstream file your fork has edited. These will conflict when upstream changes the same file.

| Path | What Changed | Notes |
|------|-------------|-------|
| _(none yet)_ | | |

---

## Sync Strategy

**Current:** auto-merge (`upstream-sync.yml`) — safe while all modules are `None`/`Low` risk.

Switch to PR-based sync (`upstream-sync-pr.yml`) before adding any `Medium` or `High` risk module.

---

## Setup (run once)

```bash
# TODO: Run this to initialize the fork (from inside your fork repo):
# bash /path/to/ai-rules/scripts/fork-init.sh <upstream-url>
#
# The script will:
#   1. Add the upstream remote
#   2. Embed AI-rules as a subtree at .ai-rules/
#   3. Copy this file, CLAUDE.md, and .claude/ config into the repo
#   4. Print the TODO list and update commands

# Add upstream remote if not already configured
git remote add upstream {TODO: upstream URL}
git remote -v  # verify

# Discover what's already different from upstream
git fetch upstream
git diff --name-only upstream/main...HEAD
```

Copy the appropriate workflow to `.github/workflows/upstream-sync.yml`:
- No custom modules yet → `.ai-rules/templates/upstream-sync.yml` (auto-merge, no review needed)
- Custom modules present → `.ai-rules/templates/upstream-sync-pr.yml` (opens PR for review)

```bash
# Update AI-rules (run when AI-rules releases a new version):
git subtree pull --prefix=.ai-rules https://github.com/crashcart/ai-rules main --squash

# Update project upstream:
git pull upstream main
```
