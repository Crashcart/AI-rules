#!/usr/bin/env bash
# Creates a dated snapshot branch when the calendar day changes.
# Run this at the start of each Claude Code session (wired via .claude/settings.json).
set -euo pipefail

SETTINGS=".claude/settings.json"
TODAY=$(date +%Y-%m-%d)

# Read last snapshot date from settings
if command -v jq &>/dev/null; then
  LAST=$(jq -r '.lastSnapshotDate // ""' "${SETTINGS}" 2>/dev/null || echo "")
else
  LAST=$(grep -o '"lastSnapshotDate"[[:space:]]*:[[:space:]]*"[^"]*"' "${SETTINGS}" 2>/dev/null \
         | sed 's/.*: *"\(.*\)"/\1/' || echo "")
fi

if [[ "${LAST}" == "${TODAY}" ]]; then
  exit 0
fi

BRANCH="snapshot/${TODAY}"

# Create snapshot branch from current HEAD if it doesn't exist
if ! git show-ref --quiet "refs/heads/${BRANCH}"; then
  git branch "${BRANCH}"
  echo "Created snapshot branch: ${BRANCH}"
fi

# Update lastSnapshotDate in settings
if command -v jq &>/dev/null; then
  TMP=$(mktemp)
  jq --arg d "${TODAY}" '.lastSnapshotDate = $d' "${SETTINGS}" > "${TMP}"
  mv "${TMP}" "${SETTINGS}"
else
  sed -i "s/\"lastSnapshotDate\"[[:space:]]*:[[:space:]]*\"[^\"]*\"/\"lastSnapshotDate\": \"${TODAY}\"/" "${SETTINGS}"
fi

echo "Daily snapshot complete: ${BRANCH}"
