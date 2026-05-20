#!/usr/bin/env bash
set -euo pipefail

# Apply AI-rules v1.6.0 template to Crashcart repos.
#
# Run from the root of your local ai-rules clone:
#   bash deploy/apply.sh
#
# Auth options (pick one):
#   A) GITHUB_TOKEN=<pat> bash deploy/apply.sh   (PAT with repo read+write scope)
#   B) Ensure your SSH key is registered with GitHub and use SSH URLs (edit BASE_URL below)
#
# What it does per repo:
#   1. Clones the repo (depth 1)
#   2. Creates or checks out the 'dev' branch
#   3. Applies base + language template from templates/
#   4. Overlays the repo-specific CLAUDE.md from deploy/repos/{repo}/
#   5. Copies scripts/check-rules-updates.sh
#   6. Sets rulesVersion to 1.6.0 in .claude/settings.json
#   7. Commits and pushes to 'dev'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AI_RULES_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
WORK_DIR=$(mktemp -d)
trap 'rm -rf "${WORK_DIR}"' EXIT

# ── Auth ──────────────────────────────────────────────────────────────────────
# Option A: HTTPS with PAT
BASE_URL="https://github.com/Crashcart"
if [[ -n "${GITHUB_TOKEN:-}" ]]; then
  BASE_URL="https://${GITHUB_TOKEN}@github.com/Crashcart"
fi
# Option B: SSH — uncomment and comment out the two lines above
# BASE_URL="git@github.com:Crashcart"

# ── Repos to set up ───────────────────────────────────────────────────────────
# Format: "RepoName:language"   language = typescript | python | shell | base
REPOS=(
  "Kali-AI-term:shell"
  "RPG-Bot:python"
  "Ollama-intelgpu:shell"
  "Claud:base"
)

# ── Helper ────────────────────────────────────────────────────────────────────
apply_repo() {
  local repo_spec="$1"
  local repo="${repo_spec%%:*}"
  local lang="${repo_spec##*:}"
  local target="${WORK_DIR}/${repo}"
  local repo_lower
  repo_lower=$(echo "${repo}" | tr '[:upper:]' '[:lower:]')

  echo ""
  echo "══════════════════════════════════════"
  echo "  ${repo}  (${lang})"
  echo "══════════════════════════════════════"

  git clone --depth 1 "${BASE_URL}/${repo}" "${target}" 2>&1 | sed 's/^/  /'
  cd "${target}"

  # Create or switch to dev branch
  if git ls-remote --heads origin dev 2>/dev/null | grep -q "refs/heads/dev"; then
    git checkout dev 2>&1 | sed 's/^/  /'
    git pull origin dev 2>&1 | sed 's/^/  /'
  else
    git checkout -b dev 2>&1 | sed 's/^/  /'
    echo "  Created new dev branch"
  fi

  # Apply base template
  echo "  Applying base template..."
  cp -r "${AI_RULES_ROOT}/templates/base/." "${target}/"

  # Apply language overlay
  if [[ "${lang}" != "base" && -d "${AI_RULES_ROOT}/templates/${lang}" ]]; then
    echo "  Applying ${lang} overlay..."
    cp -r "${AI_RULES_ROOT}/templates/${lang}/." "${target}/"
  fi

  # Overlay repo-specific CLAUDE.md
  local custom_claude="${SCRIPT_DIR}/repos/${repo_lower}/CLAUDE.md"
  if [[ -f "${custom_claude}" ]]; then
    echo "  Installing custom CLAUDE.md..."
    cp "${custom_claude}" "${target}/CLAUDE.md"
  fi

  # Copy check-rules-updates.sh
  echo "  Copying check-rules-updates.sh..."
  mkdir -p "${target}/scripts"
  cp "${AI_RULES_ROOT}/scripts/check-rules-updates.sh" "${target}/scripts/check-rules-updates.sh"
  chmod +x "${target}/scripts/check-rules-updates.sh"

  # Update rulesVersion to 1.6.0
  local settings="${target}/.claude/settings.json"
  if [[ -f "${settings}" ]] && command -v jq &>/dev/null; then
    jq '.rulesVersion = "1.6.0"' "${settings}" > "${settings}.tmp" && mv "${settings}.tmp" "${settings}"
    echo "  Set rulesVersion = 1.6.0"
  fi

  # Stage and commit
  git add CLAUDE.md .claude/settings.json scripts/check-rules-updates.sh 2>/dev/null || true
  # .github/ may or may not exist yet
  [[ -d "${target}/.github" ]] && git add .github/ 2>/dev/null || true

  if ! git diff --cached --quiet 2>/dev/null; then
    git commit -m "chore: apply Crashcart AI-rules v1.6.0 template

Adds:
- CLAUDE.md (session start checklist, branching policy, rule-edit protocol)
- .claude/settings.json (PreToolUse hook for rule update checks)
- .github/copilot-instructions.md (Copilot quick-reference)
- scripts/check-rules-updates.sh (hourly ai-rules version checker)

Rules source: https://github.com/crashcart/ai-rules"
    git push -u origin dev
    echo "  ✓ Pushed to ${repo}/dev"
  else
    echo "  ✓ No changes needed — ${repo}/dev is already up to date"
  fi

  cd "${AI_RULES_ROOT}"
}

# ── Run ───────────────────────────────────────────────────────────────────────
echo "AI-rules deploy — applying v1.6.0 to $(echo "${REPOS[@]}" | wc -w | tr -d ' ') repos"
echo "Working directory: ${WORK_DIR}"

for repo_spec in "${REPOS[@]}"; do
  apply_repo "${repo_spec}"
done

echo ""
echo "════════════════════════════════════════════════════════"
echo "  Done."
echo ""
echo "  Each repo now has a 'dev' branch with the rule set."
echo "  Open them in Claude Code — the session start checklist"
echo "  will load automatically."
echo ""
echo "  ⚠️  RP-Music-Radio was excluded (accidental rule change)."
echo "      Review that session and run:"
echo "        git diff HEAD        ← see what changed"
echo "        git checkout -- .    ← revert all uncommitted changes"
echo "════════════════════════════════════════════════════════"
