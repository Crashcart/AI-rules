#!/usr/bin/env bash
set -euo pipefail

# Usage: setup.sh <typescript|python|shell> <target-repo-path>
#
# Copies base/ template into the target repo, then overlays the
# language-specific template on top. Existing files are overwritten.

LANG="${1:?Usage: setup.sh <typescript|python|shell|factory> <target-path>}"
TARGET="${2:?Usage: setup.sh <typescript|python|shell|factory> <target-path>}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "${LANG}" in
  typescript|python|shell|factory) ;;
  *) echo "Error: unknown template '${LANG}'. Choose: typescript, python, shell, factory" >&2; exit 1 ;;
esac

if [ ! -d "${TARGET}" ]; then
  echo "Error: target directory '${TARGET}' does not exist" >&2
  exit 1
fi

if [ "${LANG}" = "factory" ]; then
  echo "Applying factory template (standalone — no base layer)..."
  cp -r "${SCRIPT_DIR}/factory/." "${TARGET}/"
  echo ""
  echo "Done. Next steps:"
  echo "  1. Fill {TODO} placeholders in ${TARGET}/CLAUDE.md and ${TARGET}/HANDOFF.md"
  echo "  2. Set FACTORY_STAGE to \"PM\" in ${TARGET}/.claude/settings.json"
  echo "  3. Fill the Project Context slot in ${TARGET}/HANDOFF.md"
  echo "  4. Read notes/context/software-factory.md in the AI-rules repo for the full guide"
  exit 0
fi

echo "Applying base template..."
cp -r "${SCRIPT_DIR}/base/." "${TARGET}/"

echo "Applying ${LANG} overlay..."
cp -r "${SCRIPT_DIR}/${LANG}/." "${TARGET}/"

echo ""
echo "Done. Next steps:"
echo "  1. Fill in {TODO} placeholders in ${TARGET}/CLAUDE.md"
echo "  2. Add your repo layout to the ## Repo Structure section"
echo "  3. Commit on your dev branch (never main)"
