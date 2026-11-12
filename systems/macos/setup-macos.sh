#!/bin/sh
# setup-macos.sh
#
# Setup a macos system.
#
# Usage:
#   ./setup-macos.sh
#
# POSIX sh — no bashisms.

set -eu

# Resolve paths relative to this script, so it works from any directory.
script_dir=$(cd "$(dirname -- "$0")" && pwd)

sh "$script_dir/scripts/brew-install.sh" "$script_dir/macos.Brewfile"
