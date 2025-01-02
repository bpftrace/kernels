#!/bin/bash
#
# Build a vmtest ready kernel.
#
# Usage:
#   ./build.sh v6.2

set -eu

# Formats a version string to a comparable number
# eg. v1.2.3 => 1002003
function version {
	# Strip the leading 'v'
	local vstripped="${1:1}"
	echo "$vstripped" | awk -F. '{ printf("%d%03d%03d\n", $1,$2,$3); }'
}

# Go to repo root
cd "$(git rev-parse --show-toplevel)"

if [[ $# -ne 1 ]]; then
	echo "Usage: $0 <kernel-tag>"
	exit 1
fi

VERSION="$1"

# Anything older than 5.15 we need to use alpine 3.16, which at the time of
# writing is the oldest supported alpine version that contains all the build
# deps (pahole in particular).  We need old alpines to use an older GCC. Newer
# GCCs have better warnings and they break old kernel builds.
ALPINE_VERSION=3.18
if [[ $(version "$1") -le $(version "v5.15") ]]; then
	ALPINE_VERSION=3.16
fi

# Build builder
docker build \
	--build-arg ALPINE_VERSION="$ALPINE_VERSION" \
	--build-arg KERNEL_TAG="$1" \
	-t vmtest-kernel-builder-"$VERSION" \
	-f docker/Dockerfile.kernel \
	.

# Run builder
docker run --rm -v "$(pwd):/output" vmtest-kernel-builder-"$VERSION"

# Rename linux tarball appropriately
mv -f linux.tar.zstd linux-"$VERSION".tar.zstd
