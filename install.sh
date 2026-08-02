#!/usr/bin/env bash
# Install the OSINT skills into your Cursor / Claude skills directory.
#
# Usage:
#   ./install.sh                 # symlink every skill into ~/.cursor/skills
#   ./install.sh --copy          # copy instead of symlink
#   ./install.sh --target DIR    # install into a custom skills dir
#   ./install.sh --claude        # install into ~/.claude/skills
#
# Symlinking (default) lets `git pull` update every skill in place.

set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/skills" && pwd)"
TARGET="${HOME}/.cursor/skills"
MODE="link"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --copy) MODE="copy"; shift ;;
    --claude) TARGET="${HOME}/.claude/skills"; shift ;;
    --target) TARGET="$2"; shift 2 ;;
    -h|--help) grep '^#' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "unknown arg: $1" >&2; exit 1 ;;
  esac
done

mkdir -p "$TARGET"
count=0
for dir in "$SRC"/*/; do
  name="$(basename "$dir")"
  dest="$TARGET/$name"
  rm -rf "$dest"
  if [[ "$MODE" == "copy" ]]; then
    cp -R "$dir" "$dest"
  else
    ln -s "$dir" "$dest"
  fi
  count=$((count + 1))
  echo "  installed $name"
done

echo ""
echo "Installed $count skills into $TARGET ($MODE mode)."
echo "Restart Cursor (or your agent) to pick them up."
