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

echo "=== END ACTIVE SESSION RULES ==="
echo "REMINDER: Announce role before EVERY task segment. Format: **ROLE NAME:** description."
