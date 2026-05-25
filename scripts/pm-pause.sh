#!/usr/bin/env bash
# PM pause — activates PROJECT MANAGER and holds until user says "go"
# Usage: bash scripts/pm-pause.sh [optional context message]

set -euo pipefail

CONTEXT="${1:-}"

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║            PROJECT MANAGER — HOLDING                        ║"
echo "╠══════════════════════════════════════════════════════════════╣"
echo "║  Role:    PROJECT MANAGER                                    ║"
echo "║  Status:  PAUSED — awaiting authorization                    ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

if [ -n "$CONTEXT" ]; then
    echo "  Context: $CONTEXT"
    echo ""
fi

echo "  Type 'go' and press Enter to authorize PROJECT MANAGER to proceed."
echo "  Type 'abort' to cancel."
echo ""

while true; do
    read -r -p "  > " INPUT
    INPUT_LOWER=$(echo "$INPUT" | tr '[:upper:]' '[:lower:]' | xargs)

    case "$INPUT_LOWER" in
        go)
            echo ""
            echo "  ✓ Authorization received. PROJECT MANAGER is proceeding."
            echo ""
            exit 0
            ;;
        abort|cancel|stop|quit|exit)
            echo ""
            echo "  ✗ Aborted. PROJECT MANAGER standing down."
            echo ""
            exit 1
            ;;
        *)
            echo "  Waiting for 'go' or 'abort'."
            ;;
    esac
done
