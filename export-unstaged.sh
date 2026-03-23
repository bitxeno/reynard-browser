#!/usr/bin/env bash

set -euo pipefail

usage() {
	cat >&2 <<'EOF'
Usage: export-unstaged.sh <target-dir> [repo-root]

Writes per-file diff patches for all unstaged tracked files from the current git
working tree into <target-dir>, preserving their relative paths.
EOF
	exit 1
}

if [[ ${1:-} == "-h" || ${1:-} == "--help" ]]; then
	usage
fi

TARGET_DIR="${1:-}"
REPO_DIR="${2:-}"

if [[ -z "$TARGET_DIR" ]]; then
	usage
fi

if [[ -z "$REPO_DIR" ]]; then
	REPO_DIR="$(git rev-parse --show-toplevel)"
else
	REPO_DIR="$(cd "$REPO_DIR" && pwd)"
fi

cd "$REPO_DIR"
mkdir -p "$TARGET_DIR"

files=()
while IFS= read -r -d '' file; do
	files+=("$file")
done < <(git ls-files -m -z)

if (( ${#files[@]} == 0 )); then
	echo "No unstaged files found."
	exit 0
fi

generated=0
for file in "${files[@]}"; do
	dest="$TARGET_DIR/${file}.patch"
	mkdir -p "$(dirname "$dest")"
	git diff --no-ext-diff --binary -- "$file" > "$dest"
	((generated++))
done

echo "Generated ${generated} patch file(s) in ${TARGET_DIR}"
