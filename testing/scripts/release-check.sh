#!/usr/bin/env bash
# Pre-release validation: VERSION file, README badge, CHANGELOG section.
# Optional: RELEASE_TAG=v0.1.0 must match VERSION (strip leading v).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"

VERSION="$(tr -d '[:space:]' < VERSION)"
if [[ -z "$VERSION" ]]; then
  echo "error: VERSION file is empty" >&2
  exit 1
fi

if [[ -n "${RELEASE_TAG:-}" ]]; then
  expected="${RELEASE_TAG#v}"
  if [[ "$VERSION" != "$expected" ]]; then
    echo "error: VERSION ($VERSION) does not match tag ($RELEASE_TAG → $expected)" >&2
    exit 1
  fi
fi

if ! grep -Fq "version-${VERSION}-blue" README.md; then
  echo "error: README Version badge does not match VERSION ($VERSION)" >&2
  exit 1
fi

if ! grep -Fq "## [${VERSION}]" CHANGELOG.md; then
  echo "error: CHANGELOG.md missing section ## [${VERSION}]" >&2
  exit 1
fi

echo "release-check ok (VERSION=${VERSION})"
