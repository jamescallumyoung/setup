#!/bin/sh
# change-shell.sh
#
# Prompt the user to select a shell (bash, zsh or fish), add it to
# /etc/shells (if not already present), and set it as the default
# shell for the current user via chsh.
#
# Usage:
#   ./change-shell.sh
#
# Exit codes:
#   0   success
#   2   pick was not found in PATH
#   3   the selected shell was not found in PATH
#   4   the user didn't select a shell
#   *   other: a command failed (set -e)
#
# POSIX sh — no bashisms.

set -eu

info() { printf '%s\n' "$*" >&2; }
err()  { printf 'error: %s\n' "$*" >&2; }

if ! command -v pick >/dev/null 2>&1; then
    err 'pick not found in PATH'
    exit 2
fi

# ---------------------------------------------------------------------------
# Select target shell
# ---------------------------------------------------------------------------

printf '%s\n' 'Select target shell' >/dev/tty
shell_name=$(printf '%s\n' bash fish zsh | pick -X) || shell_name=

if [ -z "$shell_name" ]; then
    err 'No shell selected. Aborting.'
    exit 4
fi
info "User selected $shell_name"

shell_path=$(command -v "$shell_name") || { err "$shell_name not found in PATH"; exit 3; }

if ! grep -qxF "$shell_path" /etc/shells; then
    info "Adding $shell_path to /etc/shells"
    printf '%s\n' "$shell_path" | sudo tee -a /etc/shells >/dev/null
fi

chsh -s "$shell_path"

info "Done. Shell was changed to $shell_name"
