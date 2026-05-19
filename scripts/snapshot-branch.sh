#!/usr/bin/env bash
# Branch mode: create snapshot/YYYY-MM-DD branch in this repo and push it.
# Called by daily-snapshot.sh when snapshotTargetRepo is unset.
set -euo pipefail

REPO_ROOT="${1:?Usage: snapshot-branch.sh <repo-root> <today>}"
TODAY="${2:?Usage: snapshot-branch.sh <repo-root> <today>}"
BRANCH="snapshot/${TODAY}"

cd "${REPO_ROOT}"

if ! git show-ref --quiet "refs/heads/${BRANCH}"; then
  git branch "${BRANCH}"
  git push origin "${BRANCH}" --quiet 2>/dev/null || \
    echo "Warning: Could not push snapshot branch ${BRANCH} to origin (local only)"
  echo "Created snapshot branch: ${BRANCH}"
else
  echo "Snapshot branch ${BRANCH} already exists — skipping"
fi
