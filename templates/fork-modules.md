# Fork Modules Manifest

> Place this file at the repo root of your fork as `FORK_MODULES.md`.
> List every file and directory that your fork adds on top of upstream.
> The upstream sync workflow reads this file to produce a conflict-risk report.

## Custom Modules

List each custom addition below. Use the table format — one row per file, directory,
or logical module. This becomes the source of truth for "what we own" vs "what upstream owns."

| Path | Type | Description | Upstream Conflict Risk |
|------|------|-------------|----------------------|
| `src/modules/my-feature/` | directory | Custom feature added by this fork | Low — new directory, upstream unlikely to add it |
| `config/custom.yml` | file | Fork-specific configuration | Medium — upstream may add config/ files |
| `docs/FORK_NOTES.md` | file | Notes specific to this fork | None — not present in upstream |

**Type values:** `directory`, `file`, `config`, `script`, `workflow`, `rule`

**Conflict Risk values:**
- `None` — new file/directory not present in upstream
- `Low` — unlikely path collision with upstream
- `Medium` — upstream may add similar files; review PRs carefully
- `High` — modifying an upstream file; every upstream sync may produce a conflict

## Files Modified from Upstream

List any upstream files this fork has changed. These will conflict on every upstream sync
if upstream also changes them.

| Path | What Changed | Notes |
|------|-------------|-------|
| `README.md` | Added fork-specific setup section | Check upstream sync PR diffs carefully |

## Sync Strategy

- `None` / `Low` risk modules: upstream auto-merge is safe (`templates/upstream-sync.yml`)
- `Medium` / `High` risk modules: use PR-based sync (`templates/upstream-sync-pr.yml`) — review before merging

## Regenerating This List

From the fork repo root, after configuring the `upstream` remote:

```bash
git remote add upstream <source-repo-url>   # once
git fetch upstream
git diff --name-only upstream/main...HEAD   # files changed vs upstream
git diff --stat upstream/main...HEAD        # summary
```

Files shown by `git diff` that are not in upstream's tree are your custom additions.
Files shown that also exist upstream are modifications — highest conflict risk.
