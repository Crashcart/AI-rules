#!/usr/bin/env bash
# sync-rules.sh — Pull the full AI-rules repo into any target repo.
#
# Run from ANOTHER repo to get all rules, agents, notes, plans, templates,
# scripts, proposals, acknowledgments — everything.
#
# Usage (from within another repo):
#   bash .ai-rules/sync-rules.sh               # refresh in-place
#   bash sync-rules.sh                         # if copied to repo root
#
# Usage (one-liner bootstrap from scratch):
#   curl -fsSL <raw-url>/sync-rules.sh | bash
#
# Usage (pointed at a specific target):
#   bash sync-rules.sh /path/to/other-repo
#
# Env overrides:
#   AI_RULES_REPO=<url-or-path>   override the source repo (default: GitHub)
#   AI_RULES_DEST=<path>          override the destination (default: .ai-rules/)
#   AI_RULES_BRANCH=<branch>      override the branch (default: main)

set -euo pipefail

# ── Config ───────────────────────────────────────────────────────────────────
SOURCE_REPO="${AI_RULES_REPO:-https://github.com/crashcart/ai-rules.git}"
SOURCE_BRANCH="${AI_RULES_BRANCH:-main}"
TARGET_ROOT="${1:-$(pwd)}"
DEST="${AI_RULES_DEST:-${TARGET_ROOT}/.ai-rules}"

DIRS_TO_SYNC="rules agents notes plans projects proposals templates scripts acknowledgments imports demo deploy hiring pipeline"
HIDDEN_DIRS=".claude .github"
FILES_TO_SYNC="version.json CHANGELOG.md MIGRATION.md README.md"

# ── Helpers ──────────────────────────────────────────────────────────────────
bold()  { printf '\033[1m%s\033[0m\n' "$*"; }
ok()    { printf '  \033[32m✓\033[0m  %s\n' "$*"; }
skip()  { printf '  \033[2m–\033[0m  %s (not found, skipped)\n' "$*"; }
err()   { printf '\033[31mERROR:\033[0m %s\n' "$*" >&2; }
die()   { err "$*"; exit 1; }

# ── Validate target ──────────────────────────────────────────────────────────
[ -d "$TARGET_ROOT" ] || die "Target directory '$TARGET_ROOT' does not exist."

# ── Detect if we're already inside AI-rules ──────────────────────────────────
SELF_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." 2>/dev/null && pwd || echo "")"
IN_AI_RULES=false
if [ -f "${SELF_ROOT}/version.json" ] && grep -q '"rules_sha256"' "${SELF_ROOT}/version.json" 2>/dev/null; then
  IN_AI_RULES=true
  SRC="$SELF_ROOT"
fi

# ── Acquire source ────────────────────────────────────────────────────────────
TMPDIR_WORK=""
if [ "$IN_AI_RULES" = false ]; then
  bold "=== AI-Rules Sync ==="
  echo "Source : $SOURCE_REPO (branch: $SOURCE_BRANCH)"
  echo "Target : $DEST"
  echo ""
  echo "Cloning AI-rules (shallow, branch: $SOURCE_BRANCH)..."
  TMPDIR_WORK=$(mktemp -d)
  trap 'rm -rf "$TMPDIR_WORK"' EXIT
  git clone --depth 1 --branch "$SOURCE_BRANCH" --quiet "$SOURCE_REPO" "${TMPDIR_WORK}/ai-rules" \
    || die "Clone failed. Check that AI_RULES_REPO is accessible: $SOURCE_REPO"
  SRC="${TMPDIR_WORK}/ai-rules"
  ok "Clone complete"
else
  bold "=== AI-Rules Sync (local copy) ==="
  echo "Source : $SRC"
  echo "Target : $DEST"
  echo ""
fi

# ── Create destination ────────────────────────────────────────────────────────
mkdir -p "$DEST"

# ── Clean up stray AI-rules-managed directories at target repo root ───────────
# PM or other agents may have incorrectly created these at root level of the
# target repo. They belong in .ai-rules/ — remove them from root if found.
# Only runs when TARGET_ROOT != DEST (i.e. syncing into a foreign repo).
if [ "$TARGET_ROOT" != "$DEST" ] && [ "$IN_AI_RULES" = false ] || \
   { [ "$IN_AI_RULES" = true ] && [ "$TARGET_ROOT" != "$SELF_ROOT" ]; }; then
  STRAY_DIRS="agents rules notes proposals hiring pipeline"
  for stray in $STRAY_DIRS; do
    STRAY_PATH="${TARGET_ROOT}/${stray}"
    if [ -d "$STRAY_PATH" ]; then
      # Only remove if it contains AI-rules fingerprint files
      if find "$STRAY_PATH" -maxdepth 1 -name "universal.md" -o \
              -name "project-manager.md" -o -name "claude-behavior.md" \
              2>/dev/null | grep -q .; then
        printf '  \033[33m!\033[0m  Removing stray AI-rules dir from repo root: %s/\n' "$stray"
        rm -rf "${STRAY_PATH:?}"
      fi
    fi
  done
fi

# ── Sync directories ──────────────────────────────────────────────────────────
echo "Syncing directories..."
for dir in $DIRS_TO_SYNC; do
  if [ -d "${SRC}/${dir}" ]; then
    rm -rf "${DEST:?}/${dir}"
    cp -r "${SRC}/${dir}" "${DEST}/${dir}"
    ok "${dir}/"
  else
    skip "${dir}/"
  fi
done

# plans/active/ contains repo-specific work items — strip from sync so
# active plans never leave AI-rules or overwrite a target repo's own work
rm -rf "${DEST:?}/plans/active"

# tickets/ is repo-specific — never sync it to target repos
rm -rf "${DEST:?}/tickets"

# ── Sync hidden dirs (.claude, .github) ──────────────────────────────────────
for dir in $HIDDEN_DIRS; do
  if [ -d "${SRC}/${dir}" ]; then
    rm -rf "${DEST:?}/${dir}"
    cp -r "${SRC}/${dir}" "${DEST}/${dir}"
    ok "${dir}/"
  else
    skip "${dir}/"
  fi
done

# ── Install Claude Code commands at target repo root ─────────────────────────
# Claude Code scans {project-root}/.claude/commands/ — NOT .ai-rules/.claude/commands/.
# Copy the base template commands to the target root so /update-rules and other
# commands are available without a sync. Only runs when syncing into a foreign repo.
# PERSONAL FILE PROTECTION: any command file already present is left untouched
# (the user may have a custom version). Missing files are installed from the template.
# A blank stub is written first so the user can see the slot exists even if they
# replace the file with their own version.
if [ "$TARGET_ROOT" != "$DEST" ]; then
  CMD_SRC="${SRC}/templates/base/.claude/commands"
  CMD_DEST="${TARGET_ROOT}/.claude/commands"
  if [ -d "$CMD_SRC" ]; then
    mkdir -p "$CMD_DEST"
    for src_file in "${CMD_SRC}"/*.md; do
      fname="$(basename "$src_file")"
      dest_file="${CMD_DEST}/${fname}"
      if [ -f "$dest_file" ]; then
        # Personal file exists — leave it alone
        printf '  \033[2m–\033[0m  .claude/commands/%s (personal copy preserved)\n' "$fname"
      else
        # Slot is empty — install the template version
        cp "$src_file" "$dest_file"
        ok ".claude/commands/${fname} → installed"
      fi
    done
  fi

  # ── Protect personal .claude/settings.json ───────────────────────────────
  # If the repo root has no .claude/settings.json yet, install a blank stub so
  # the AI-rules version inside .ai-rules/.claude/ is never mistaken for the
  # project's personal settings. User fills it in (or runs /update-config).
  PERSONAL_SETTINGS="${TARGET_ROOT}/.claude/settings.json"
  if [ ! -f "$PERSONAL_SETTINGS" ]; then
    mkdir -p "${TARGET_ROOT}/.claude"
    printf '{\n  "// NOTE": "Add your project-specific Claude Code settings here. AI-rules settings live in .ai-rules/.claude/settings.json"\n}\n' \
      > "$PERSONAL_SETTINGS"
    ok ".claude/settings.json → blank stub installed (fill in project settings)"
  else
    printf '  \033[2m–\033[0m  .claude/settings.json (personal copy preserved)\n'
  fi
fi

# Strip compiled Python bytecode — not useful, wastes space
find "${DEST}/pipeline" -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
find "${DEST}/pipeline" -name "*.pyc" -delete 2>/dev/null || true

# ── Sync top-level files ──────────────────────────────────────────────────────
echo ""
echo "Syncing files..."
for f in $FILES_TO_SYNC; do
  if [ -f "${SRC}/${f}" ]; then
    cp "${SRC}/${f}" "${DEST}/${f}"
    ok "$f"
  else
    skip "$f"
  fi
done

# ── Write sync manifest ───────────────────────────────────────────────────────
VERSION=$(grep '"version"' "${DEST}/version.json" 2>/dev/null \
  | head -1 | sed 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/' || echo "unknown")
SHA=$(grep '"rules_sha256"' "${DEST}/version.json" 2>/dev/null \
  | head -1 | sed 's/.*"rules_sha256"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/' || echo "unknown")

cat > "${DEST}/.sync-info" <<EOF
synced_at=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
source=${SOURCE_REPO}
branch=${SOURCE_BRANCH}
version=${VERSION}
rules_sha256=${SHA}
EOF

# ── Verify integrity ──────────────────────────────────────────────────────────
echo ""
echo "Verifying rules integrity..."
ACTUAL_SHA=$(cat "${DEST}/rules/"*.md 2>/dev/null | sha256sum | awk '{print $1}')
if [ "$ACTUAL_SHA" = "$SHA" ]; then
  ok "SHA256 verified: ${SHA:0:16}..."
else
  printf '  \033[33m!\033[0m  SHA mismatch — expected %s, got %s\n' \
    "${SHA:0:16}..." "${ACTUAL_SHA:0:16}..."
  echo "    The rules files may have changed since version.json was last updated."
fi

# ── Done ─────────────────────────────────────────────────────────────────────
echo ""
bold "=== Sync complete — v${VERSION} ==="
echo ""
echo "All AI-rules content is now at:"
echo "  ${DEST}/"
echo ""
echo "Directories available:"
for dir in $DIRS_TO_SYNC $HIDDEN_DIRS; do
  [ -d "${DEST}/${dir}" ] && echo "  ${DEST}/${dir}/"
done
echo ""
echo "Quick-start reads:"
echo "  ${DEST}/rules/universal.md     — rules for all AIs"
echo "  ${DEST}/rules/claude.md        — Claude-specific rules"
echo "  ${DEST}/agents/README.md       — role index and handoff workflow"
echo "  ${DEST}/notes/context/         — background context docs"
echo "  ${DEST}/hiring/                — role definitions, scenario + test banks"
echo ""
echo "Not synced (stays in AI-rules only or is repo-specific):"
echo "  tickets/                       — open tickets (repo-specific)"
echo "  plans/active/                  — active plans (repo-specific)"
echo "  TODO.md                        — repo-specific task list (never overwritten)"
echo "  HANDOFF.md                     — session handoff file (repo-specific)"
echo "  CLAUDE.md                      — repo-specific Claude instructions (never overwritten)"
echo ""
echo "  projects/ syncs as read-only context (registry + template + scoring docs)."
echo "  Target repos use .ai-rules/projects/ for their own /report and /new-project commands."
echo ""
echo "To keep rules current, re-run this script any time:"
if [ "$IN_AI_RULES" = true ]; then
  echo "  bash ${BASH_SOURCE[0]}"
else
  echo "  bash ${DEST}/scripts/sync-rules.sh"
fi
echo ""
echo "To gitignore synced rules (recommended for most repos):"
echo "  echo '.ai-rules/' >> ${TARGET_ROOT}/.gitignore"
echo ""
echo "To commit rules into the repo (pin a specific version):"
echo "  git add ${DEST} && git commit -m 'chore: pin AI-rules v${VERSION}'"
