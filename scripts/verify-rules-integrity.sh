#!/usr/bin/env bash
# Rules integrity gate. Runs before every Bash tool call via PreToolUse hook.
# Compares rules/*.md SHA256 against version.json. Exits 1 (blocks tool) on mismatch.
# No network. No PM override. Just a hash check.

set -euo pipefail

REPO_ROOT="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null)}"
VERSION_FILE="${REPO_ROOT}/version.json"
RULES_GLOB="${REPO_ROOT}/rules/*.md"

[ -f "$VERSION_FILE" ] || exit 0  # not an AI-rules repo — skip silently

# Read expected SHA (jq preferred, grep+sed fallback)
if command -v jq &>/dev/null; then
  EXPECTED=$(jq -r '.rules_sha256 // empty' "$VERSION_FILE" 2>/dev/null)
else
  EXPECTED=$(grep '"rules_sha256"' "$VERSION_FILE" \
    | sed 's/.*"rules_sha256"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
fi

[ -z "$EXPECTED" ] && exit 0  # unreadable — don't block

ACTUAL=$(cat $RULES_GLOB 2>/dev/null | sha256sum | awk '{print $1}')

[ "$ACTUAL" = "$EXPECTED" ] && exit 0  # all good

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  RULES INTEGRITY FAILURE — BASH BLOCKED                     ║"
echo "╟──────────────────────────────────────────────────────────────╢"
echo "║  rules/*.md SHA does not match version.json                  ║"
printf "║  Expected: %-50s ║\n" "${EXPECTED:0:48}..."
printf "║  Actual:   %-50s ║\n" "${ACTUAL:0:48}..."
echo "╟──────────────────────────────────────────────────────────────╢"
echo "║  Re-read all files in rules/ and update version.json.        ║"
echo "║  Run: cat rules/*.md | sha256sum                             ║"
echo "║  Then update version.json and acknowledgments/claude.ack.json║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
exit 1
