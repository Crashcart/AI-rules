# Fork Modules — {TODO: PROJECT NAME}

**Upstream:** {TODO: https://github.com/original-owner/repo-name}
**This fork:** {TODO: https://github.com/your-username/repo-name}

---

## Custom Modules

> Add a row each time your fork introduces a new file, directory, or config.
> Reference: `templates/fork-modules.md` in AI-rules for field definitions.

| Path | Type | Description | Conflict Risk |
|------|------|-------------|---------------|
| _(none yet)_ | | | |

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
# Add upstream remote if not already configured
git remote add upstream {TODO: upstream URL}
git remote -v  # verify

# Discover what's already different from upstream
git fetch upstream
git diff --name-only upstream/main...HEAD
```

Copy the appropriate workflow to `.github/workflows/upstream-sync.yml`:
- No custom modules yet → `templates/upstream-sync.yml` (auto-merge, no review needed)
- Custom modules present → `templates/upstream-sync-pr.yml` (opens PR for review)
