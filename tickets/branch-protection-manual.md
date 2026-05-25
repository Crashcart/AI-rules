# Ticket — Enable GitHub branch protection on main (manual step)

**ID**: TICK-001
**Opened by**: claude
**Requesting AI**: —
**Date**: 2026-05-25
**Priority**: medium
**Scope**: other

## Description

The `main` branch on `Crashcart/AI-rules` needs GitHub platform-level branch protection enabled. Three programmatic layers are already in place (RULE 22 in `rules/universal.md`, `.github/CODEOWNERS`, `.github/workflows/protect-rules.yml`), but the fourth layer — GitHub's branch protection API enforcement — requires a one-time action in the GitHub Settings UI that cannot be done via `GITHUB_TOKEN` in a GitHub Actions workflow (permission restriction on free personal accounts).

## Acceptance criteria

- [ ] `main` shows `protected: true` in the GitHub API (`mcp__github__list_branches`)
- [ ] Settings: require PR before merging, require Code Owner review, 1 approving review

## Context

**One-step fix — do this in your browser:**

```
https://github.com/Crashcart/AI-rules/settings/branch_protection_rules/new
```

1. Branch name pattern: `main`
2. Check ✅ "Require a pull request before merging"
3. Required approvals: `1`
4. Check ✅ "Require review from Code Owners"
5. Click **Create**

Done. The stop hook goal "my github rules always be protected" will clear automatically
once `mcp__github__list_branches` returns `main: protected: true`.

The workflow `.github/workflows/setup-branch-protection.yml` was removed (6 failed attempts)
because `GITHUB_TOKEN` cannot call the branch protection API on personal accounts without
first granting "Read and write" workflow permissions in Settings → Actions → General.

---

*Do not edit below this line — Claude fills in resolution on close.*

**Status**: open
**Resolution**: —
**Closed**: —
