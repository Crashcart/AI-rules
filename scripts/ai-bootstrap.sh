#!/usr/bin/env bash
# Usage: ./scripts/ai-bootstrap.sh <ai-id> [ai-display-name]
# Example: ./scripts/ai-bootstrap.sh chatgpt-4o "ChatGPT-4o"
#
# Initializes a new AI type in the AI-rules system:
#   - Creates rules/{ai-id}.md from templates/ai-rules-bootstrap.md
#   - Creates acknowledgments/{ai-id}.ack.json with version "pending"
#   - Prints the highest-level injection instructions for this AI type

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATE="$REPO_ROOT/templates/ai-rules-bootstrap.md"
RULES_DIR="$REPO_ROOT/rules"
ACK_DIR="$REPO_ROOT/acknowledgments"

usage() {
  echo "Usage: $0 <ai-id> [ai-display-name]"
  echo "  ai-id           Lowercase identifier, used for filenames (e.g. chatgpt-4o, mistral)"
  echo "  ai-display-name Human-readable name (e.g. \"ChatGPT-4o\"). Defaults to ai-id."
  echo ""
  echo "Example: $0 chatgpt-4o \"ChatGPT-4o\""
  exit 1
}

if [[ $# -lt 1 ]]; then
  usage
fi

AI_ID="$1"
AI_NAME="${2:-$AI_ID}"
RULES_FILE="$RULES_DIR/${AI_ID}.md"
ACK_FILE="$ACK_DIR/${AI_ID}.ack.json"

# Validate ai-id: lowercase letters, digits, hyphens only
if ! [[ "$AI_ID" =~ ^[a-z0-9-]+$ ]]; then
  echo "Error: ai-id must contain only lowercase letters, digits, and hyphens." >&2
  exit 1
fi

# Refuse to overwrite an existing rules file
if [[ -f "$RULES_FILE" ]]; then
  echo "Error: $RULES_FILE already exists. To update it, edit the file directly." >&2
  exit 1
fi

# Ensure the template exists
if [[ ! -f "$TEMPLATE" ]]; then
  echo "Error: Template not found at $TEMPLATE" >&2
  exit 1
fi

echo "Initializing AI type: $AI_NAME (id: $AI_ID)"
echo ""

# Copy template → rules file, replacing {AI_ID} placeholder
sed \
  -e "s/{AI_NAME}/$AI_NAME/g" \
  -e "s/{AI_ID}/$AI_ID/g" \
  "$TEMPLATE" > "$RULES_FILE"

echo "Created: $RULES_FILE"
echo "  → Fill in: {APPLIES_TO}, {GRAMMAR_NOTE}, and any section placeholders"

# Create pending ack file
cat > "$ACK_FILE" <<EOF
{
  "ai": "$AI_ID",
  "version": "pending",
  "rules_sha256": "pending",
  "acknowledged_at": null,
  "acknowledged_by": null
}
EOF

echo "Created: $ACK_FILE"
echo ""

# Print highest-level injection instructions
echo "── Injection instructions for $AI_NAME ──────────────────────────────"
case "$AI_ID" in
  chatgpt*|gpt*)
    echo "ChatGPT (chat): Settings → Personalization → Custom instructions"
    echo "  → Paste rules/gpt.md (or rules/${AI_ID}.md once complete) in the"
    echo "    'What would you like ChatGPT to know about you?' field."
    echo "ChatGPT (API):  Include rules content as a {\"role\": \"system\"} message"
    echo "  in every API call."
    ;;
  gemini*)
    echo "Gemini Advanced: Create a Gem → set rules/gemini.md (or rules/${AI_ID}.md)"
    echo "  as the Gem system instruction."
    echo "Gemini API: Pass rules content in the system_instruction field of every"
    echo "  API request."
    ;;
  ollama*|llama*|mistral*|phi*)
    echo "Ollama: Add rules content to the SYSTEM block in the Modelfile, then"
    echo "  run: ollama create <model-name> -f Modelfile"
    echo "See rules/ollama.md for the full Modelfile template."
    ;;
  copilot*)
    echo "GitHub Copilot: Save rules content to .github/copilot-instructions.md"
    echo "  in each target repository."
    echo "See templates/base/.github/copilot-instructions.md for the base template."
    ;;
  claude*)
    echo "Claude Code: Add rules content to CLAUDE.md and configure a PreToolUse hook."
    echo "Claude API: Pass rules content as the system prompt in every API call."
    ;;
  *)
    echo "No specific injection template found for '$AI_ID'."
    echo "General guidance from RULE 19 (rules/universal.md):"
    echo "  - Find the highest-persistence instruction level for this model"
    echo "  - Inject rules there so they survive across sessions/calls"
    echo "  - If no system-level injection is available, paste at conversation start"
    ;;
esac

echo ""
echo "── Next steps ────────────────────────────────────────────────────────"
echo "1. Edit $RULES_FILE"
echo "   Fill in: {APPLIES_TO}  — model identifiers this file targets"
echo "            {GRAMMAR_NOTE} — which instruction format this AI processes best"
echo "2. Update the SHA256 and version after editing:"
echo "   cat rules/*.md | sha256sum"
echo "3. Update version.json and CHANGELOG.md (bump minor version)"
echo "4. Commit: feat: add rules for $AI_NAME"
