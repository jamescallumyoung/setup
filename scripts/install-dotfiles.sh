#!/bin/sh
# install-dotfiles.sh
#
# Symlink dotfile packages into $HOME using GNU Stow.
#
# Usage:
#   ./install-dotfiles.sh
#
# POSIX sh — no bashisms.

set -eu

SCRIPT_DIR="$(cd "$(dirname -- "$0")" && pwd)"
. "$SCRIPT_DIR/lib/log.sh"

log_primary "[install-dotfiles.sh] Start"

# ---------------------------------------------------------------------------
# Stow each dotfile package
# ---------------------------------------------------------------------------

repo_path="$(cd "$SCRIPT_DIR/.." && pwd)"
stow_dir="$repo_path/dotfiles"
log_secondary "Stowing dotfile packages from $stow_dir..."

stow --dir="$stow_dir" --target="$HOME" fish
stow --dir="$stow_dir" --target="$HOME" git
stow --dir="$stow_dir" --target="$HOME" nvim
stow --dir="$stow_dir" --target="$HOME" ssh
stow --dir="$stow_dir" --target="$HOME" zsh

log_secondary "[install-dotfiles.sh] Done"
