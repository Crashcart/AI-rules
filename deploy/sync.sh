#!/usr/bin/env bash
set -euo pipefail

# Sync AI-rules files to all target Crashcart repos via GitHub Contents API.
#
# Called by .github/workflows/sync-rules.yml on every version.json push to main.
# Can also be run manually:
#   GITHUB_TOKEN=<pat> RULES_VERSION=1.6.1 bash deploy/sync.sh
#
# Updates per repo (does NOT touch CLAUDE.md — may be repo-customized):
#   1. scripts/check-rules-updates.sh
#   2. .claude/settings.json  (rulesVersion field only)
#   3. .github/copilot-instructions.md

API="https://api.github.com"
ORG="Crashcart"
TOKEN="${GITHUB_TOKEN:?GITHUB_TOKEN must be set}"
VERSION="${RULES_VERSION:?RULES_VERSION must be set}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AI_RULES_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

REPOS=(
  "Kali-AI-term"
  "RPG-Bot"
  "Ollama-intelgpu"
  "Claud"
)

BRANCH="dev"

# ── Helpers ───────────────────────────────────────────────────────────────────

api_get() {
  local repo="$1" path="$2" ref="${3:-${BRANCH}}"
  curl -fsSL \
    -H "Authorization: token ${TOKEN}" \
    -H "Accept: application/vnd.github+json" \
    "${API}/repos/${ORG}/${repo}/contents/${path}?ref=${ref}"
}

api_put() {
  local repo="$1" path="$2" message="$3" content_b64="$4" sha="$5" branch="$6"
  local payload
  if [[ -n "${sha}" ]]; then
    payload=$(jq -n \
      --arg msg "${message}" \
      --arg content "${content_b64}" \
      --arg sha "${sha}" \
      --arg branch "${branch}" \
      '{"message":$msg,"content":$content,"sha":$sha,"branch":$branch}')
  else
    payload=$(jq -n \
      --arg msg "${message}" \
      --arg content "${content_b64}" \
      --arg branch "${branch}" \
      '{"message":$msg,"content":$content,"branch":$branch}')
  fi
  curl -fsSL -X PUT \
    -H "Authorization: token ${TOKEN}" \
    -H "Accept: application/vnd.github+json" \
    -H "Content-Type: application/json" \
    -d "${payload}" \
    "${API}/repos/${ORG}/${repo}/contents/${path}"
}

ensure_dev_branch() {
  local repo="$1"
  local http_code
  http_code=$(curl -o /dev/null -w "%{http_code}" -sL \
    -H "Authorization: token ${TOKEN}" \
    -H "Accept: application/vnd.github+json" \
    "${API}/repos/${ORG}/${repo}/git/ref/heads/${BRANCH}" 2>/dev/null || echo "000")

  if [[ "${http_code}" == "200" ]]; then
    return 0
  fi

  local default_branch sha
  default_branch=$(curl -fsSL \
    -H "Authorization: token ${TOKEN}" \
    -H "Accept: application/vnd.github+json" \
    "${API}/repos/${ORG}/${repo}" | jq -r '.default_branch')

  sha=$(curl -fsSL \
    -H "Authorization: token ${TOKEN}" \
    -H "Accept: application/vnd.github+json" \
    "${API}/repos/${ORG}/${repo}/git/ref/heads/${default_branch}" | jq -r '.object.sha')

  curl -fsSL -X POST \
    -H "Authorization: token ${TOKEN}" \
    -H "Accept: application/vnd.github+json" \
    -H "Content-Type: application/json" \
    -d "{\"ref\":\"refs/heads/${BRANCH}\",\"sha\":\"${sha}\"}" \
    "${API}/repos/${ORG}/${repo}/git/refs" > /dev/null

  echo "  Created ${BRANCH} branch from ${default_branch}"
}

sync_file() {
  local repo="$1" remote_path="$2" local_path="$3" commit_msg="$4"
  local response sha content_b64

  response=$(api_get "${repo}" "${remote_path}" "${BRANCH}" 2>/dev/null || echo "{}")
  sha=$(echo "${response}" | jq -r '.sha // empty')
  content_b64=$(base64 -w 0 "${local_path}")

  api_put "${repo}" "${remote_path}" "${commit_msg}" "${content_b64}" "${sha}" "${BRANCH}" > /dev/null
}

sync_settings_json() {
  local repo="$1"
  local remote_path=".claude/settings.json"
  local commit_msg="chore: sync AI-rules v${VERSION} — update rulesVersion"
  local response sha

  response=$(api_get "${repo}" "${remote_path}" "${BRANCH}" 2>/dev/null || echo "{}")
  sha=$(echo "${response}" | jq -r '.sha // empty')

  if [[ -z "${sha}" ]]; then
    echo "  .claude/settings.json not found — uploading base template"
    sync_file "${repo}" "${remote_path}" \
      "${AI_RULES_ROOT}/templates/base/.claude/settings.json" \
      "${commit_msg}"
    return
  fi

  local existing_b64 patched_content patched_b64
  existing_b64=$(echo "${response}" | jq -r '.content' | tr -d '\n')
  patched_content=$(echo "${existing_b64}" | base64 -d | jq --arg v "${VERSION}" '.rulesVersion = $v')
  patched_b64=$(echo "${patched_content}" | base64 -w 0)

  api_put "${repo}" "${remote_path}" "${commit_msg}" "${patched_b64}" "${sha}" "${BRANCH}" > /dev/null
}

# ── Main ──────────────────────────────────────────────────────────────────────

COMMIT_MSG="chore: sync AI-rules v${VERSION}"

echo "AI-rules sync — pushing v${VERSION} to ${#REPOS[@]} repos"
echo ""

FAILED=()

for repo in "${REPOS[@]}"; do
  echo "── ${repo} ──────────────────────────────"

  if ! ensure_dev_branch "${repo}"; then
    echo "  ERROR: could not ensure ${BRANCH} branch — skipping"
    FAILED+=("${repo}")
    continue
  fi

  if sync_file "${repo}" \
      "scripts/check-rules-updates.sh" \
      "${AI_RULES_ROOT}/scripts/check-rules-updates.sh" \
      "${COMMIT_MSG}"; then
    echo "  OK  scripts/check-rules-updates.sh"
  else
    echo "  FAIL scripts/check-rules-updates.sh"
    FAILED+=("${repo}")
  fi

  if sync_settings_json "${repo}"; then
    echo "  OK  .claude/settings.json (rulesVersion -> ${VERSION})"
  else
    echo "  FAIL .claude/settings.json"
    FAILED+=("${repo}")
  fi

  if sync_file "${repo}" \
      ".github/copilot-instructions.md" \
      "${AI_RULES_ROOT}/templates/base/.github/copilot-instructions.md" \
      "${COMMIT_MSG}"; then
    echo "  OK  .github/copilot-instructions.md"
  else
    echo "  FAIL .github/copilot-instructions.md"
    FAILED+=("${repo}")
  fi

  echo ""
done

echo "════════════════════════════════════"
if [[ ${#FAILED[@]} -eq 0 ]]; then
  echo "  All repos synced to v${VERSION}."
else
  echo "  FAILED repos: ${FAILED[*]}"
  exit 1
fi
