#!/bin/bash
#
# Build kernel and associated modules from inside container.
#
# Note this script expects the bind mounted output directly to be mounted
# at /output.

set -eux

# Stage everything in a temporary directory
mkdir /assets

# Build kernel + modules
make -j "$(nproc)" all

# Stage bzImage
bzimage=$(find . -type f -name bzImage)
cp "$bzimage" /assets

# Stage kernel modules
make INSTALL_MOD_PATH=/assets modules_install

# Tar up and compress assets into output directory
tar --zstd -cf /output/linux.tar.zstd /assets
