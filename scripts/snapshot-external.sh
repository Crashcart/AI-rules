#!/usr/bin/env bash
# External repo mode: clone target repo and push a rules-YYYY-MM-DD branch.
# Called by daily-snapshot.sh when snapshotTargetRepo is set.
# Exits 0 on success; exits 1 on clone failure (caller falls back to branch mode).
set -euo pipefail

REPO_ROOT="${1:?Usage: snapshot-external.sh <repo-root> <today> <target-repo>}"
TODAY="${2:?Usage: snapshot-external.sh <repo-root> <today> <target-repo>}"
TARGET_REPO="${3:?Usage: snapshot-external.sh <repo-root> <today> <target-repo>}"

TMPDIR_SNAP=$(mktemp -d)
trap 'rm -rf "${TMPDIR_SNAP}"' EXIT

git clone --quiet "${TARGET_REPO}" "${TMPDIR_SNAP}/snap-repo" 2>/dev/null || {
  echo "Warning: Could not clone snapshot repo '${TARGET_REPO}'. Caller should fall back to branch mode."
  exit 1
}

SNAP_BRANCH="rules-${TODAY}"
cd "${TMPDIR_SNAP}/snap-repo"

git checkout -b "${SNAP_BRANCH}" 2>/dev/null || git checkout "${SNAP_BRANCH}"
cp -r "${REPO_ROOT}/rules/" ./rules/
cp "${REPO_ROOT}/version.json" ./version.json
cp "${REPO_ROOT}/CHANGELOG.md" ./CHANGELOG.md

git add -A
git diff --cached --quiet || git commit -m "snapshot: rules as of ${TODAY}"
git push origin "${SNAP_BRANCH}" --quiet

echo "Snapshot pushed to ${TARGET_REPO} branch ${SNAP_BRANCH}"
