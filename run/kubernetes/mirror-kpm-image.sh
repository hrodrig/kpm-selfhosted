#!/bin/sh
# Mirror one name:tag into a private repository.
# Pushes the same tag (suggested pin) and sha256-<hex> from RepoDigests.
# A tag cannot contain "sha256:", so the colon is a hyphen.
#
# Usage:
#   docker login my-private.azcr.io
#   ./mirror-kpm-image.sh ghcr.io/hrodrig/kpm:v1.1.0 my-private.azcr.io/customer/kpm
#
# Optional: DOCKER_PLATFORM=linux/amd64 when the laptop arch is not the node arch.
# Pulls one platform. It does not copy a multi-arch index.

set -eu

src=${1:?source image, name:tag}
dest=${2:?destination repository, no tag}
platform=${DOCKER_PLATFORM:-}

if [ -n "$platform" ]; then
  docker pull --platform "$platform" "$src"
else
  docker pull "$src"
fi

raw=$(docker image inspect --format '{{index .RepoDigests 0}}' "$src")
hex=${raw##*sha256:}
if [ -z "$hex" ] || [ "$hex" = "$raw" ]; then
  echo "mirror-kpm-image: no RepoDigests on $src" >&2
  exit 1
fi

upstream_tag=${src##*:}
if [ "$upstream_tag" = "$src" ] || [ -z "$upstream_tag" ]; then
  echo "mirror-kpm-image: source must be name:tag, not a digest ref" >&2
  exit 1
fi

docker tag "$src" "${dest}:${upstream_tag}"
docker tag "$src" "${dest}:sha256-${hex}"
docker push "${dest}:${upstream_tag}"
docker push "${dest}:sha256-${hex}"

echo "pushed ${dest}:${upstream_tag}"
echo "pushed ${dest}:sha256-${hex}"
