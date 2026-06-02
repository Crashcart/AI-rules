#!/usr/bin/env bash
set -euo pipefail

RULES_DIR="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null)}/rules"

echo "=== ACTIVE SESSION RULES (NON-NEGOTIABLE) ==="
echo ""
echo "--- AGENT ROLE REFERENCES ---"
awk '/^## AGENT ROLE REFERENCES/,/^\[NON-NEGOTIABLE/' "${RULES_DIR}/claude-behavior.md" 2>/dev/null || true
echo ""
echo "--- ROLE ANNOUNCEMENT ---"
awk '/^## ROLE ANNOUNCEMENT/,/^\[NON-NEGOTIABLE\]/' "${RULES_DIR}/claude-behavior.md" 2>/dev/null || true
echo ""
echo "--- RULE 20: MANAGER HANDOFF AND BETA DELIVERY STANDARD ---"
awk '/^## RULE 20/,/^\[NON-NEGOTIABLE — handoff required/' "${RULES_DIR}/universal.md" 2>/dev/null || true
echo ""
# Upstream sync check (RULE 21 — rate-limited, non-fatal)
REPO_ROOT="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null)}"
bash "${REPO_ROOT}/scripts/check-upstream.sh" 2>/dev/null || true

# Surface active plans (RULE 23)
PLANS_DIR="${REPO_ROOT}/plans/active"
if [ -d "$PLANS_DIR" ] && [ -n "$(ls -A "$PLANS_DIR" 2>/dev/null)" ]; then
  echo ""
  echo "=== ACTIVE PLANS ==="
  for f in "$PLANS_DIR"/*.md; do
    [ -f "$f" ] || continue
    name=$(basename "$f" .md)
    next=$(grep -A1 "^## Next Action" "$f" 2>/dev/null | tail -1 | sed 's/^[[:space:]]*//')
    echo "  • $name: $next"
  done
  echo "=== END ACTIVE PLANS ==="
fi

# Alert: pending PM messages awaiting user approval
INBOX_DIR="${REPO_ROOT}/messages/inbox"
if [ -d "$INBOX_DIR" ]; then
  shopt -s nullglob
  MSG_FILES=("${INBOX_DIR}"/*.md)
  MSG_COUNT=${#MSG_FILES[@]}
  if [ "$MSG_COUNT" -gt 0 ]; then
    echo ""
    echo "=== ⚠️  PM INBOX: ${MSG_COUNT} MESSAGE(S) AWAITING YOUR APPROVAL ==="
    for f in "${MSG_FILES[@]}"; do
      msg_name=$(basename "$f")
      msg_type=$(grep -m1 "^Type:" "$f" 2>/dev/null | sed 's/Type:[[:space:]]*//' || echo "unknown")
      msg_title=$(grep -m1 "^Title:" "$f" 2>/dev/null | sed 's/Title:[[:space:]]*//' || basename "$f" .md)
      echo "  • [${msg_type}] ${msg_title}"
      echo "    File: messages/inbox/${msg_name}"
    done
    echo "  → Type /messages to review, or say 'show messages' to see full content."
    echo "=== END PM INBOX ALERT ==="
  fi
fi

echo "=== END ACTIVE SESSION RULES ==="
echo "REMINDER: Announce role before EVERY task segment. Format: **ROLE NAME:** description."
