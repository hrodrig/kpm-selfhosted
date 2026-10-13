#!/usr/bin/env bash
# Print Keep a Changelog body for one version (excludes the ## [x.y.z] header line).
set -euo pipefail

version="${1:?usage: extract-changelog.sh <semver> [CHANGELOG.md]}"
file="${2:-CHANGELOG.md}"

if [[ ! -f "$file" ]]; then
  echo "error: $file not found" >&2
  exit 1
fi

awk -v ver="$version" '
  BEGIN { found=0 }
  $0 ~ "^## \\[" ver "\\]" { found=1; next }
  found && /^## \[/ { exit }
  found { print }
' "$file" | sed -e '/./,$!d'
