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

# Install dnf packages
printf 'Do you want to install dnf packages? [y/N] ' >/dev/tty
read -r dnf_answer </dev/tty || dnf_answer=
case $dnf_answer in
    [Yy] | [Yy][Ee][Ss]) sh "$script_dir/../../scripts/install-packages.sh" -m dnf -f "$script_dir/dnf-packages.conf" ;;
    *) ;;
esac

# Install flatpak packages
printf 'Do you want to install flatpak packages? [y/N] ' >/dev/tty
read -r flatpak_answer </dev/tty || flatpak_answer=
case $flatpak_answer in
    [Yy] | [Yy][Ee][Ss]) sh "$script_dir/../../scripts/install-packages.sh" -m flatpak -f "$script_dir/flatpaks.conf" ;;
    *) ;;
esac
