#!/usr/bin/env bash
# check-messages.sh — Scan the PM message inbox and report pending messages.
#
# Used by:
#   - .github/workflows/messages-check.yml (runs 4×/day, alerts the user)
#   - the /messages slash command (on-demand review)
#
# Usage:
#   bash scripts/check-messages.sh            # human-readable summary to stdout
#   bash scripts/check-messages.sh --markdown # markdown block (for GitHub issue body)
#
# Exit codes:
#   0 = no pending messages
#   1 = one or more pending messages found (so CI can branch on it)

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INBOX="${REPO_ROOT}/messages/inbox"
MODE="${1:-text}"

# ── Collect pending messages ──────────────────────────────────────────────────
shopt -s nullglob
FILES=("${INBOX}"/*.md)
COUNT=${#FILES[@]}

field() {
  # field <file> <Field-Label> — pull the value after "**Label**:" on its line
  grep -m1 "^\*\*$2\*\*:" "$1" 2>/dev/null | sed "s/^\*\*$2\*\*:[[:space:]]*//" || true
}
title() {
  grep -m1 '^# Message:' "$1" 2>/dev/null | sed 's/^# Message:[[:space:]]*//' || true
}

if [ "$COUNT" -eq 0 ]; then
  if [ "$MODE" = "--markdown" ]; then
    echo "No pending messages. Inbox is clear."
  else
    echo "PM inbox clear — no pending messages."
  fi
  exit 0
fi

# ── Emit summary ──────────────────────────────────────────────────────────────
if [ "$MODE" = "--markdown" ]; then
  echo "## ⚑ ${COUNT} PM message(s) awaiting your approval"
  echo ""
  echo "PROJECT MANAGER has posted the following to \`messages/inbox/\`. Nothing is acted on"
  echo "until you approve it (RULE 16 / RULE 17)."
  echo ""
  echo "| Type | Priority | Title | File |"
  echo "|------|----------|-------|------|"
  for f in "${FILES[@]}"; do
    rel="messages/inbox/$(basename "$f")"
    echo "| $(field "$f" Type) | $(field "$f" Priority) | $(title "$f") | \`${rel}\` |"
  done
  echo ""
  echo "**To decide:** review each file, then tell Claude \"approve {file}\" or \"reject {file}\"."
  echo "PM will implement approved items and archive the message."
else
  echo "⚑ ${COUNT} pending PM message(s) in messages/inbox/:"
  echo ""
  for f in "${FILES[@]}"; do
    printf '  • [%s | %s] %s\n      → %s\n' \
      "$(field "$f" Type)" "$(field "$f" Priority)" "$(title "$f")" "messages/inbox/$(basename "$f")"
  done
fi

exit 1
