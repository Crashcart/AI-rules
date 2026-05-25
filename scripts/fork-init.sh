#!/usr/bin/env bash
# Usage: bash fork-init.sh <project-upstream-url>
# Run from inside a freshly cloned fork repo.
# Example: bash /path/to/ai-rules/scripts/fork-init.sh https://github.com/original-owner/repo-name
set -euo pipefail

AI_RULES_URL="https://github.com/crashcart/ai-rules"
UPSTREAM_URL="${1:-}"

if [ -z "$UPSTREAM_URL" ]; then
  echo "Usage: bash fork-init.sh <project-upstream-url>"
  echo "Example: bash fork-init.sh https://github.com/original-owner/repo-name"
  exit 1
fi

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AI_RULES_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

cd "$REPO_ROOT"

echo "=== Fork Init: AI-rules subtree + config ==="
echo ""

# 1. Add upstream remote
if git remote get-url upstream &>/dev/null; then
  echo "✓ upstream remote already configured: $(git remote get-url upstream)"
else
  git remote add upstream "$UPSTREAM_URL"
  echo "✓ Added upstream remote: $UPSTREAM_URL"
fi

# 2. Embed AI-rules as git subtree at .ai-rules/
if [ -d ".ai-rules" ]; then
  echo "✓ .ai-rules/ already exists — skipping subtree add"
else
  echo "Embedding AI-rules as subtree at .ai-rules/ ..."
  echo "(This fetches from GitHub and may take a moment)"
  git subtree add --prefix=.ai-rules "$AI_RULES_URL" main --squash
  echo "✓ AI-rules embedded at .ai-rules/"
fi

# 3. Copy fork-starter config files
STARTER_DIR="${AI_RULES_ROOT}/templates/fork-starter"

if [ ! -d "$STARTER_DIR" ]; then
  echo "Error: templates/fork-starter/ not found at $STARTER_DIR"
  echo "Run this script from within the AI-rules repo, or pass the path correctly."
  exit 1
fi

mkdir -p .claude/hooks

# session-start.sh
if [ ! -f ".claude/hooks/session-start.sh" ]; then
  cp "${STARTER_DIR}/.claude/hooks/session-start.sh" .claude/hooks/session-start.sh
  chmod +x .claude/hooks/session-start.sh
  echo "✓ Copied .claude/hooks/session-start.sh"
else
  echo "  .claude/hooks/session-start.sh already exists — skipped"
fi

# settings.json
if [ ! -f ".claude/settings.json" ]; then
  cp "${STARTER_DIR}/.claude/settings.json" .claude/settings.json
  echo "✓ Copied .claude/settings.json"
else
  echo "  .claude/settings.json already exists — skipped"
fi

# FORK_MODULES.md
if [ ! -f "FORK_MODULES.md" ]; then
  cp "${STARTER_DIR}/FORK_MODULES.md" FORK_MODULES.md
  echo "✓ Copied FORK_MODULES.md"
else
  echo "  FORK_MODULES.md already exists — skipped"
fi

# CLAUDE.md
if [ ! -f "CLAUDE.md" ]; then
  cp "${STARTER_DIR}/CLAUDE.md" CLAUDE.md
  echo "✓ Copied CLAUDE.md"
else
  echo "  CLAUDE.md already exists — skipped"
fi

echo ""
echo "=== TODO ==="
echo "1. Fill {TODO} placeholders in CLAUDE.md and FORK_MODULES.md"
echo "2. Copy sync workflow:"
echo "   cp .ai-rules/templates/upstream-sync.yml .github/workflows/upstream-sync.yml"
echo "3. Set UPSTREAM_URL repo variable in GitHub Settings → Variables → Actions"
echo "4. Commit everything:"
echo "   git add -A && git commit -m 'chore: fork init — AI-rules subtree + config'"
echo ""
echo "=== Update commands (save these) ==="
echo "Update project upstream:  git pull upstream main"
echo "Update AI-rules:          git subtree pull --prefix=.ai-rules $AI_RULES_URL main --squash"
