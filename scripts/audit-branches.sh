#!/usr/bin/env bash
# Scan all git branches for unauthorized rule changes by rogue AI PMs.
#
# Checks performed on every non-main branch:
#   1. rules/*.md added or modified vs main without a version.json bump
#   2. rules/*.md changed in a commit that lacks a "Risk Notes:" section
#   3. agents/*.md added without a matching agents/registry.json entry
#   4. version.json SHA in that branch doesn't match its own rules/*.md content
#
# Exit 0 = clean. Exit 1 = issues found (suitable for CI).

set -euo pipefail

REPO_ROOT="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null)}"
MAIN_BRANCH="main"
TOTAL_ISSUES=0
SCAN_COUNT=0

cd "$REPO_ROOT"

echo "=== ROGUE RULE AUDIT ==="
echo "  Repo:        $(git remote get-url origin 2>/dev/null || echo 'local')"
echo "  Main branch: ${MAIN_BRANCH}"
echo "  Scanned at:  $(date -u '+%Y-%m-%d %H:%M UTC')"
echo ""

# Fetch all remotes silently so remote branches are visible
git fetch --all --quiet 2>/dev/null || true

# Build list of branches to check (local + remote, skip main and HEAD)
mapfile -t BRANCHES < <(
  git branch -a --format='%(refname:short)' 2>/dev/null \
    | sed 's|^origin/||' \
    | sort -u \
    | grep -v "^${MAIN_BRANCH}$" \
    | grep -v "^HEAD$"
)

if [ ${#BRANCHES[@]} -eq 0 ]; then
  echo "  No branches other than main — nothing to audit."
  echo ""
  echo "✅ Audit complete — no branches to check."
  exit 0
fi

for branch in "${BRANCHES[@]}"; do
  # Resolve the full ref (prefer remote if local doesn't exist)
  REF="${branch}"
  if ! git rev-parse --verify "${branch}" &>/dev/null; then
    REF="origin/${branch}"
    git rev-parse --verify "${REF}" &>/dev/null || continue
  fi

  BRANCH_ISSUES=0
  BRANCH_HEADER_PRINTED=false

  print_branch_header() {
    if [ "$BRANCH_HEADER_PRINTED" = false ]; then
      echo "Branch: ${branch}"
      BRANCH_HEADER_PRINTED=true
    fi
  }

  # ── CHECK 1: rules/*.md changed vs main ─────────────────────────────────────
  CHANGED_RULES=$(git diff --name-only "${MAIN_BRANCH}...${REF}" -- 'rules/*.md' 2>/dev/null || true)
  if [ -n "$CHANGED_RULES" ]; then
    print_branch_header
    VERSION_CHANGED=$(git diff --name-only "${MAIN_BRANCH}...${REF}" -- 'version.json' 2>/dev/null || true)
    if [ -z "$VERSION_CHANGED" ]; then
      echo "  ❌ ROGUE: rules/ modified but version.json NOT bumped"
      echo "           Files: $(echo "$CHANGED_RULES" | tr '\n' ' ')"
      BRANCH_ISSUES=$((BRANCH_ISSUES + 1))
    else
      # version.json was bumped — check SHA consistency on the branch
      BRANCH_EXPECTED_SHA=$(git show "${REF}:version.json" 2>/dev/null \
        | grep '"rules_sha256"' \
        | sed 's/.*"rules_sha256"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/' || true)
      if [ -n "$BRANCH_EXPECTED_SHA" ]; then
        # Get actual SHA of rules/*.md on that branch
        BRANCH_ACTUAL_SHA=$(git show "${REF}:rules/universal.md" "${REF}:rules/claude.md" \
          "${REF}:rules/claude-behavior.md" "${REF}:rules/gpt.md" "${REF}:rules/gemini.md" \
          "${REF}:rules/ollama.md" "${REF}:rules/copilot.md" "${REF}:rules/web-design.md" \
          2>/dev/null | sha256sum | awk '{print $1}' || true)
        if [ -n "$BRANCH_ACTUAL_SHA" ] && [ "$BRANCH_ACTUAL_SHA" != "$BRANCH_EXPECTED_SHA" ]; then
          print_branch_header
          echo "  ❌ ROGUE: rules/ SHA mismatch on branch — version.json hash stale"
          echo "           Expected: ${BRANCH_EXPECTED_SHA}"
          echo "           Actual:   ${BRANCH_ACTUAL_SHA}"
          BRANCH_ISSUES=$((BRANCH_ISSUES + 1))
        fi
      fi
      echo "  ⚠️  rules/ changed + version.json bumped (may be legitimate)"
      echo "     Files: $(echo "$CHANGED_RULES" | tr '\n' ' ')"
      echo "     Review before merging — confirm RULE 17 approval exists."
      BRANCH_ISSUES=$((BRANCH_ISSUES + 1))
    fi
  fi

  # ── CHECK 2: commits touching rules/ that lack Risk Notes ───────────────────
  while IFS= read -r line; do
    [ -z "$line" ] && continue
    HASH="${line%% *}"
    SUBJECT="${line#* }"
    if ! git show "$HASH" 2>/dev/null | grep -q "Risk Notes:"; then
      print_branch_header
      echo "  ❌ COMMIT ${HASH}: touches rules/ but missing Risk Notes section"
      echo "     Subject: ${SUBJECT}"
      BRANCH_ISSUES=$((BRANCH_ISSUES + 1))
    fi
  done < <(git log "${MAIN_BRANCH}..${REF}" --pretty=format:"%h %s" -- 'rules/*.md' 2>/dev/null || true)

  # ── CHECK 3: agents/*.md added without registry entry ───────────────────────
  ADDED_AGENTS=$(git diff --name-only --diff-filter=A "${MAIN_BRANCH}...${REF}" -- 'agents/*.md' 2>/dev/null \
    | grep -v 'agents/README.md' || true)
  if [ -n "$ADDED_AGENTS" ]; then
    while IFS= read -r agent_path; do
      fname=$(basename "$agent_path")
      if git show "${REF}:agents/registry.json" 2>/dev/null | grep -q "\"${fname}\""; then
        echo "  ✓  ${agent_path} — registered in registry.json"
      else
        print_branch_header
        echo "  ❌ ROGUE AGENT: ${agent_path} added without registry.json entry (RULE 16)"
        BRANCH_ISSUES=$((BRANCH_ISSUES + 1))
      fi
    done <<< "$ADDED_AGENTS"
  fi

  # ── CHECK 4: rules/*.md files added that don't exist on main ────────────────
  ADDED_RULES=$(git diff --name-only --diff-filter=A "${MAIN_BRANCH}...${REF}" -- 'rules/*.md' 2>/dev/null || true)
  if [ -n "$ADDED_RULES" ]; then
    print_branch_header
    echo "  ❌ ROGUE: new rules file(s) added outside main — requires RULE 17 user approval:"
    echo "$ADDED_RULES" | while read -r f; do echo "           $f"; done
    BRANCH_ISSUES=$((BRANCH_ISSUES + 1))
  fi

  if [ $BRANCH_ISSUES -gt 0 ]; then
    TOTAL_ISSUES=$((TOTAL_ISSUES + BRANCH_ISSUES))
    echo ""
  fi

  SCAN_COUNT=$((SCAN_COUNT + 1))
done

echo "Scanned ${SCAN_COUNT} branch(es)."
echo ""

if [ $TOTAL_ISSUES -eq 0 ]; then
  echo "✅ Audit clean — no unauthorized rule changes found."
  exit 0
else
  echo "⛔ ${TOTAL_ISSUES} issue(s) found across branches."
  echo "   • Rules changed without approval → delete the branch or get RULE 17 user sign-off"
  echo "   • Rogue agent files → delete or add to registry.json with user approval (RULE 16)"
  echo "   • Missing Risk Notes → amend the commit or create a corrective commit"
  echo ""
  echo "   To act: /audit delete <branch>  or  /messages new (raise for approval)"
  exit 1
fi
