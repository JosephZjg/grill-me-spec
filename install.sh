#!/usr/bin/env bash
# Install grill-me-spec into an agent skills directory.
# Usage: ./install.sh [--tool claude|codex|zcode] [--dest <path>]
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
tool=""
dest=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --tool) tool="${2,,}"; shift 2 ;;
    --dest) dest="$2"; shift 2 ;;
    *) echo "unknown argument: $1" >&2; exit 1 ;;
  esac
done

if [[ -z "$dest" ]]; then
  if [[ -z "$tool" ]]; then
    if [[ -d "$HOME/.claude/skills" ]]; then tool="claude"
    elif [[ -d "$HOME/.codex/skills" ]]; then tool="codex"
    elif [[ -d "$HOME/.zcode/skills" ]]; then tool="zcode"
    fi
  fi
  case "$tool" in
    claude) dest="$HOME/.claude/skills/grill-me-spec" ;;
    codex)  dest="$HOME/.codex/skills/grill-me-spec" ;;
    zcode)  dest="$HOME/.zcode/skills/grill-me-spec" ;;
    *) echo "error: could not auto-detect a skills directory." >&2
       echo "pass --tool <claude|codex|zcode> or --dest <path>" >&2
       exit 1 ;;
  esac
fi

mkdir -p "$dest"
cp -r "$repo_dir/SKILL.md" "$repo_dir/reference.md" "$repo_dir/examples" "$dest/"
echo "installed grill-me-spec -> $dest"
