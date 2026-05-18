#!/usr/bin/env bash
# Creates a versioned snapshot of the current rules when the calendar day changes.
# Supports two modes:
#   1. Branch mode (default): creates snapshot/YYYY-MM-DD branch in this repo and pushes it
#   2. Separate repo mode: pushes snapshot to a dedicated archive repo
#      Set snapshotTargetRepo in .claude/settings.json to enable.
#
# Run automatically via .claude/settings.json PreToolUse hook.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SETTINGS="${REPO_ROOT}/.claude/settings.json"
TODAY=$(date +%Y-%m-%d)

# Read last snapshot date from settings
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

BRANCH="snapshot/${TODAY}"

if [[ -n "${TARGET_REPO}" ]]; then
  # Separate repo mode: push rules/ to a dedicated snapshot repository
  TMPDIR_SNAP=$(mktemp -d)
  trap 'rm -rf "${TMPDIR_SNAP}"' EXIT

  git clone --quiet "${TARGET_REPO}" "${TMPDIR_SNAP}/snap-repo" 2>/dev/null || {
    echo "Warning: Could not clone snapshot repo '${TARGET_REPO}'. Falling back to branch mode."
    TARGET_REPO=""
  }

  if [[ -n "${TARGET_REPO}" ]]; then
    SNAP_BRANCH="rules-${TODAY}"
    cd "${TMPDIR_SNAP}/snap-repo"

    git checkout -b "${SNAP_BRANCH}" 2>/dev/null || git checkout "${SNAP_BRANCH}"
    cp -r "${REPO_ROOT}/rules/" ./rules/
    cp "${REPO_ROOT}/version.json" ./version.json
    cp "${REPO_ROOT}/CHANGELOG.md" ./CHANGELOG.md

    git add -A
    git diff --cached --quiet || git commit -m "snapshot: rules as of ${TODAY}"
    git push origin "${SNAP_BRANCH}" --quiet

    cd "${REPO_ROOT}"
    echo "Snapshot pushed to ${TARGET_REPO} branch ${SNAP_BRANCH}"
  fi
fi

if [[ -z "${TARGET_REPO}" ]]; then
  # Branch mode: create snapshot/YYYY-MM-DD branch and push for a persistent audit trail
  cd "${REPO_ROOT}"
  if ! git show-ref --quiet "refs/heads/${BRANCH}"; then
    git branch "${BRANCH}"
    git push origin "${BRANCH}" --quiet 2>/dev/null || \
      echo "Warning: Could not push snapshot branch ${BRANCH} to origin (local only)"
    echo "Created snapshot branch: ${BRANCH}"
  fi
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
