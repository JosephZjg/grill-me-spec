#!/usr/bin/env bash
# Install grill-me-spec into an agent skills directory.
#
# Usage:
#   ./install.sh [--tool claude|codex|zcode] [--dest <path>]     # from a local clone
#   curl -fsSL <raw-url>/install.sh | bash -s -- [--tool ...]    # one-liner
#
# Compatible with bash 3.2 (macOS system bash) and newer.
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"
if [[ -z "$repo_dir" || ! -f "$repo_dir/SKILL.md" ]]; then
  # Piped install (curl ... | bash): fetch the repo from GitHub instead.
  fetch_dir="$(mktemp -d)"
  if ! curl -fsSL "https://github.com/zhoujugui-web/grill-me-spec/archive/refs/heads/main.tar.gz" \
       | tar -xz -C "$fetch_dir"; then
    echo "error: could not download from github.com (network restricted?)" >&2
    echo "fallback: git clone https://github.com/zhoujugui-web/grill-me-spec ~/grill-me-spec && ~/grill-me-spec/install.sh" >&2
    exit 1
  fi
  repo_dir="$fetch_dir/grill-me-spec-main"
fi

tool=""
dest=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --tool) tool="$(printf '%s' "$2" | tr '[:upper:]' '[:lower:]')"; shift 2 ;;
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
