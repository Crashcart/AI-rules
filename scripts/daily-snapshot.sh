#!/usr/bin/env bash
# Creates a versioned snapshot of the current rules when the calendar day changes.
# Dispatches to snapshot-external.sh (when snapshotTargetRepo is set) or
# snapshot-branch.sh (default). Run automatically via .claude/settings.json PreToolUse hook.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SETTINGS="${REPO_ROOT}/.claude/settings.json"
TODAY=$(date +%Y-%m-%d)
SCRIPTS_DIR="${REPO_ROOT}/scripts"

if command -v jq &>/dev/null; then
  LAST=$(jq -r '.lastSnapshotDate // ""' "${SETTINGS}" 2>/dev/null || echo "")
  TARGET_REPO=$(jq -r '.snapshotTargetRepo // ""' "${SETTINGS}" 2>/dev/null || echo "")
else
  LAST=$(grep -o '"lastSnapshotDate"[[:space:]]*:[[:space:]]*"[^"]*"' "${SETTINGS}" 2>/dev/null \
         | sed 's/.*: *"\(.*\)"/\1/' || echo "")
  TARGET_REPO=""
fi

if [[ "${LAST}" == "${TODAY}" ]]; then
  exit 0
fi

# Notify if origin/main has commits not yet pulled (never auto-pulls)
git -C "${REPO_ROOT}" fetch origin main --quiet 2>/dev/null || true
BEHIND=$(git -C "${REPO_ROOT}" rev-list HEAD..origin/main --count 2>/dev/null || echo "0")
if [[ "${BEHIND}" -gt 0 ]]; then
  echo "Rules update available: ${BEHIND} new commit(s) on origin/main — run: git pull origin main"
fi

if [[ -n "${TARGET_REPO}" ]]; then
  "${SCRIPTS_DIR}/snapshot-external.sh" "${REPO_ROOT}" "${TODAY}" "${TARGET_REPO}" || {
    echo "External snapshot failed — falling back to branch mode"
    TARGET_REPO=""
  }
fi

if [[ -z "${TARGET_REPO}" ]]; then
  "${SCRIPTS_DIR}/snapshot-branch.sh" "${REPO_ROOT}" "${TODAY}"
fi

# Update lastSnapshotDate in settings
if command -v jq &>/dev/null; then
  TMP=$(mktemp)
  jq --arg d "${TODAY}" '.lastSnapshotDate = $d' "${SETTINGS}" > "${TMP}"
  mv "${TMP}" "${SETTINGS}"
else
  sed -i "s/\"lastSnapshotDate\"[[:space:]]*:[[:space:]]*\"[^\"]*\"/\"lastSnapshotDate\": \"${TODAY}\"/" "${SETTINGS}"
fi

echo "Daily snapshot complete: ${TODAY}"
