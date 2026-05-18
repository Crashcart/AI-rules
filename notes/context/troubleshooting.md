# Troubleshooting

Common failure modes and how to recover. Organized by symptom.

---

## SHA256 Mismatch on Acknowledgment

**Symptom**: The `rules_sha256` in `acknowledgments/claude.ack.json` doesn't match `version.json`.

**Cause**: A rule file was edited without recomputing the hash, or `version.json` was edited independently.

**Fix**:
```bash
cat rules/*.md | sha256sum
# Copy the hash (without the trailing " -") into version.json and claude.ack.json
```

Run from the repo root. The `rules/*.md` glob must include all six rule files in the same order every time (alphabetical, which is what shell glob expansion produces).

---

## Snapshot Branch Push Failure

**Symptom**: `daily-snapshot.sh` outputs `Warning: Could not push snapshot branch snapshot/YYYY-MM-DD to origin (local only)`.

**Cause**: Network unavailable, or no push access to origin at the time the hook ran.

**What happened**: The local snapshot branch was still created. The audit trail exists locally.

**Fix**: Push manually when network is available:
```bash
git push origin snapshot/YYYY-MM-DD
```

Or just let the next day's snapshot create the next branch — one missed push isn't a crisis.

---

## Auto-Formatter Corrupting a File

**Symptom**: After a Write or Edit, the file looks wrong — misaligned JSON, reformatted Markdown.

**Cause**: PostToolUse hook runs `prettier` on `.json` and `.md` files. Prettier can reformat valid JSON in unexpected ways (e.g., expanding arrays).

**Fix**: Check `.claude/settings.json` PostToolUse hook — it only targets `*.ts`, `*.tsx`, `*.json`, and `*.py`. Markdown files are not in scope. If a JSON file was malformed before the write, prettier may have exacerbated it.

For `.ack.json` files: prettier may reformat them but shouldn't break valid JSON. If the file is broken, check the Write call output for errors before blaming prettier.

---

## Non-Claude AI Not Re-Acknowledging After Version Bump

**Symptom**: GPT/Gemini/Copilot/Ollama `.ack.json` files still show an old version after a rule update.

**Cause**: These AIs don't have automated hooks. They only acknowledge when the user provides them with the updated rule files and asks them to.

**What to do**:
1. Give the AI both `rules/{ai}.md` and `rules/universal.md`
2. Ask it to produce the acknowledgment JSON for `acknowledgments/{ai}.ack.json`
3. Ask it to perform self-assessment per Rule 12 and produce any proposal blocks
4. Commit the ack JSON and any proposals

This is intentional — the user controls when other AIs re-acknowledge, not an automated system.

---

## Proposal Conflicts Between AIs

**Symptom**: Two AIs submit proposals that contradict each other (e.g., GPT proposes adding a rule, Gemini proposes removing the same rule).

**How Claude handles it**:
1. Read both proposals
2. Evaluate which position is better supported by the rule's intent
3. Implement the stronger proposal, archive both with a note explaining the decision
4. The rejected proposal's archive entry explains why the other was chosen

If the conflict is genuinely irresolvable: defer both with a note, raise with the user via `AskUserQuestion`.

---

## Stale `rulesVersion` in `.claude/settings.json`

**Symptom**: `jq .rulesVersion .claude/settings.json` returns an old version number.

**Cause**: `rulesVersion` in settings.json is a convenience field for quick checking; it must be manually updated when `version.json` changes.

**Fix**:
```bash
# Get current version
jq .version version.json

# Update settings.json
# Edit .claude/settings.json: "rulesVersion": "x.y.z"
```

This field is informational only — it doesn't affect automation. But a stale value is misleading.

---

## `git show-ref` Returns Wrong Branch State

**Symptom**: Daily snapshot creates a new branch even though one exists, or skips creation when it shouldn't.

**Cause**: `git show-ref --quiet "refs/heads/${BRANCH}"` checks local refs only. If the branch exists on origin but wasn't fetched, the check fails.

**This is intentional**: the script manages local branches. If origin has a snapshot branch but local doesn't, it will create a new local one and try to push (which will fail with "already exists on remote" and print a warning).

**Fix**: `git fetch origin` before running the snapshot script manually. The PreToolUse hook doesn't fetch first — this is acceptable for the automated case.

---

## JSON Parse Error in `.ack.json`

**Symptom**: `jq . acknowledgments/{ai}.ack.json` returns a parse error.

**Cause**: Manually edited JSON with a syntax error, or prettier introduced an issue.

**Fix**: Validate and fix:
```bash
jq . acknowledgments/{ai}.ack.json
# If error: open file, check for trailing commas, missing quotes, unclosed brackets
```

Reference: `acknowledgments/claude.ack.json` is always valid — use it as a structural reference.
