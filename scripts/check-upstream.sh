#!/usr/bin/env bash
set -euo pipefail

CACHE_FILE="${HOME}/.cache/crashcart-ai-rules/upstream-check.json"
mkdir -p "$(dirname "$CACHE_FILE")"

# Rate limit: check at most once per hour
NOW=$(date +%s)
if [ -f "$CACHE_FILE" ]; then
  LAST=$(jq -r '.last_check // 0' "$CACHE_FILE" 2>/dev/null || echo 0)
  [ $((NOW - LAST)) -lt 3600 ] && exit 0
fi

# Exit silently if no upstream remote configured
UPSTREAM_URL=$(git remote get-url upstream 2>/dev/null || true)
[ -z "$UPSTREAM_URL" ] && exit 0

# Fetch upstream (non-destructive — does not merge or modify working tree)
git fetch upstream --quiet 2>/dev/null || {
  echo "upstream-check: upstream unreachable — skipping" >&2
  exit 0
}

# Detect upstream default branch
UPSTREAM_BRANCH=$(git remote show upstream 2>/dev/null | awk '/HEAD branch/ {print $NF}' || echo "main")
BEHIND=$(git rev-list "HEAD..upstream/${UPSTREAM_BRANCH}" --count 2>/dev/null || echo 0)

# Update cache regardless of result
echo "{\"last_check\": ${NOW}}" > "$CACHE_FILE"

if [ "$BEHIND" -gt 0 ]; then
  echo ""
  echo "UPSTREAM SYNC: This repo is ${BEHIND} commit(s) behind upstream."
  echo "  Upstream: ${UPSTREAM_URL}"
  echo "  To sync:  git pull upstream ${UPSTREAM_BRANCH}"
  echo "  Or:       use GitHub's 'Sync fork' button in the browser."
  echo ""
fi
