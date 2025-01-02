#!/bin/bash
#
# Configure a vmtest ready kernel.
#
# Run this inside kernel source tree root.

set -eux

# Set kconfig
cat config/config config/config.x86_64 config/config.vm > .config
make olddefconfig
