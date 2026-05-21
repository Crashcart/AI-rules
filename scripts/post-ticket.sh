#!/usr/bin/env bash
# Post a ticket to the AI-rules repo from any Crashcart repo.
#
# Usage:
#   GITHUB_TOKEN=<pat> bash scripts/post-ticket.sh \
#     --title "Fix X" \
#     --scope "rule-edit" \
#     --opened-by "claude" \
#     --description "We need to change rule Y because Z." \
#     [--priority medium] \
#     [--criteria "- [ ] Rule updated"] \
#     [--context "Background info"]
#
# The PAT needs: Contents: read on this repo (to trigger dispatch only).
# The AI-rules repo handles the write — no write token needed in source repos.
#
# GITHUB_TOKEN must have permission to trigger repository_dispatch on
# Crashcart/AI-rules (repo: read+write on AI-rules, or use a fine-grained
# token with Actions: read and Contents: write on AI-rules only).

set -euo pipefail

API="https://api.github.com"
TARGET_REPO="Crashcart/AI-rules"
TOKEN="${GITHUB_TOKEN:?GITHUB_TOKEN must be set}"
SOURCE_REPO="${GITHUB_REPOSITORY:-unknown}"

TITLE="" SCOPE="" OPENED_BY="" DESCRIPTION=""
PRIORITY="medium" CRITERIA="" CONTEXT=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --title)        TITLE="$2";       shift 2 ;;
    --scope)        SCOPE="$2";       shift 2 ;;
    --opened-by)    OPENED_BY="$2";   shift 2 ;;
    --description)  DESCRIPTION="$2"; shift 2 ;;
    --priority)     PRIORITY="$2";    shift 2 ;;
    --criteria)     CRITERIA="$2";    shift 2 ;;
    --context)      CONTEXT="$2";     shift 2 ;;
    *) echo "Unknown arg: $1"; exit 1 ;;
  esac
done

for required in TITLE SCOPE OPENED_BY DESCRIPTION; do
  if [[ -z "${!required}" ]]; then
    echo "ERROR: --$(echo "$required" | tr '[:upper:]' '[:lower:]' | tr '_' '-') is required"
    exit 1
  fi
done

PAYLOAD=$(jq -n \
  --arg event_type "submit-ticket" \
  --arg title       "$TITLE" \
  --arg scope       "$SCOPE" \
  --arg opened_by   "$OPENED_BY" \
  --arg description "$DESCRIPTION" \
  --arg priority    "$PRIORITY" \
  --arg criteria    "$CRITERIA" \
  --arg context     "$CONTEXT" \
  --arg repo        "$SOURCE_REPO" \
  '{
    "event_type": $event_type,
    "client_payload": {
      "title":               $title,
      "scope":               $scope,
      "opened_by":           $opened_by,
      "description":         $description,
      "priority":            $priority,
      "acceptance_criteria": $criteria,
      "context":             $context,
      "repo":                $repo
    }
  }')

HTTP_CODE=$(curl -o /dev/null -w "%{http_code}" -s -X POST \
  -H "Authorization: token ${TOKEN}" \
  -H "Accept: application/vnd.github+json" \
  -H "Content-Type: application/json" \
  -d "$PAYLOAD" \
  "${API}/repos/${TARGET_REPO}/dispatches")

if [[ "$HTTP_CODE" == "204" ]]; then
  echo "Ticket submitted to ${TARGET_REPO} (scope: ${SCOPE})"
else
  echo "ERROR: dispatch returned HTTP ${HTTP_CODE}"
  exit 1
fi
