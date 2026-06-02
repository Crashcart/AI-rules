Scan all git branches for unauthorized rule changes by rogue AI PMs.

Runs `scripts/audit-branches.sh` and interprets results.

Argument (optional):
- (no arg)          → full scan of all branches
- `quick`           → scan only branches modified in the last 7 days
- `branch <name>`   → scan one named branch only
- `delete <branch>` → delete a rogue branch after user confirms

---

**Steps:**

**Full scan (no arg):**
1. Run: `bash scripts/audit-branches.sh`
2. Report every flagged issue in plain language:
   - ❌ Rogue rule change — rules/*.md modified without RULE 17 user approval
   - ❌ Rogue agent — agents/*.md added without RULE 16 registry entry
   - ❌ Missing Risk Notes — commit touches rules/ but skips the commit standard
   - ❌ SHA mismatch — rules content doesn't match version.json hash on that branch
   - ⚠️  Rules changed + version bumped — possibly legitimate; still requires user review
3. If clean: "✅ All branches clean — no rogue rule changes found."
4. If issues found: list them clearly. Offer three responses per branch:
   - "Delete branch `<name>`" — removes the rogue branch (confirm first)
   - "Show diff for `<name>`" — run `git diff main...<name> -- rules/`
   - "Raise for approval" — open a `/messages new` hire-request or rule-suggestion

**Quick scan:**
- Run: `bash scripts/audit-branches.sh` but pre-filter to branches with commits in last 7 days:
  `git branch -a --sort=-committerdate` — check only the top N recent ones

**Single branch:**
- `git diff --name-only main...<branch> -- rules/ agents/`
- Apply the same four checks manually and report

**Delete `<branch>`:**
1. Confirm with the user: "Delete branch `<name>`? This cannot be undone."
2. On confirmation: `git branch -d <name> && git push origin --delete <name>` (use -D only if -d fails)
3. Report result.

---

**What counts as a rogue change:**

| Pattern | Verdict | Action |
|---------|---------|--------|
| `rules/*.md` modified, no `version.json` bump | ❌ ROGUE | Delete or get RULE 17 approval |
| `rules/*.md` SHA ≠ `version.json` hash on branch | ❌ ROGUE | Same |
| New `rules/*.md` file added outside `main` | ❌ ROGUE | Must go through RULE 17 |
| New `agents/*.md` not in `registry.json` | ❌ ROGUE | Must go through RULE 16 |
| Commit touches `rules/` but no `Risk Notes:` | ❌ NON-COMPLIANT | Amend or corrective commit |
| `rules/` changed + `version.json` bumped | ⚠️ REVIEW | May be legitimate — needs your approval |

**Rules that govern this:**
- RULE 16 — no agent file without registry + user approval
- RULE 17 — user holds sole authority over rule changes
- RULE 15 — compliance enforcement (non-negotiable)
- CLAUDE.md commit standard — Risk Notes required on every commit

---

This command does NOT delete anything without explicit user confirmation. It is read-only unless you run `/audit delete <branch>`.
