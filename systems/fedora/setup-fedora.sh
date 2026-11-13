#!/bin/sh
# setup-fedora.sh
#
# Setup a Fedora system.
#
# Usage:
#   ./setup-fedora.sh
#
# POSIX sh — no bashisms.

set -eu

# Resolve paths relative to this script, so it works from any directory.
script_dir=$(cd "$(dirname -- "$0")" && pwd)
. "$script_dir/../../scripts/lib/confirm.sh"

# Install dnf packages
if confirm 'Do you want to install dnf packages?'; then
    sh "$script_dir/../../scripts/install-packages.sh" -m dnf -f "$script_dir/dnf-packages.conf"
fi

# Install flatpak packages
if confirm 'Do you want to install flatpak packages?'; then
    sh "$script_dir/../../scripts/install-packages.sh" -m flatpak -f "$script_dir/flatpaks.conf"
fi
