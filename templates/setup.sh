#!/usr/bin/env bash
set -euo pipefail

# Usage: setup.sh <typescript|python|shell> <target-repo-path>
#
# Copies base/ template into the target repo, then overlays the
# language-specific template on top. Existing files are overwritten.

LANG="${1:?Usage: setup.sh <typescript|python|shell> <target-path>}"
TARGET="${2:?Usage: setup.sh <typescript|python|shell> <target-path>}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "${LANG}" in
  typescript|python|shell) ;;
  *) echo "Error: unknown language '${LANG}'. Choose: typescript, python, shell" >&2; exit 1 ;;
esac

if [ ! -d "${TARGET}" ]; then
  echo "Error: target directory '${TARGET}' does not exist" >&2
  exit 1
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
