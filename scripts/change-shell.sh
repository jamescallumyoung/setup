#!/bin/sh
# change-shell.sh
#
# Prompt the user to select zsh or fish, add it to /etc/shells (if not already
# present), and set it as the default shell for the current user via chsh.
#
# Usage:
#   ./change-shell.sh
#
# POSIX sh — no bashisms.

set -eu

SCRIPT_DIR="$(cd "$(dirname -- "$0")" && pwd)"
. "$SCRIPT_DIR/lib/log.sh"
. "$SCRIPT_DIR/lib/select.sh"

log_primary "[change-shell.sh] Start"

# ---------------------------------------------------------------------------
# Select target shell
# ---------------------------------------------------------------------------

shell_name="$(printf 'zsh\nfish\n' | select_line "Select target shell")"

if [ -z "$shell_name" ]; then
    log_secondary "No shell selected, aborting."
    exit 0
fi

log_secondary "Changing default shell to $shell_name"

shell_path="$(command -v "$shell_name")"

if ! grep -qxF "$shell_path" /etc/shells; then
    log_secondary "Adding $shell_path to /etc/shells"
    sudo sh -c "echo '$shell_path' >> /etc/shells"
fi

chsh -s "$shell_path"

log_secondary "[change-shell.sh] Done"
