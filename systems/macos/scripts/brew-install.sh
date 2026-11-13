#!/bin/sh
# brew-install.sh
#
# Interactively pick packages from a Brewfile, then install them.
#
# Usage:
#   ./brew-install.sh path/to/Brewfile
#
# The Brewfile is copied to a temporary location and opened in vim. Delete or
# comment out (#) any lines you don't want, then save and quit (:wq).
# Quit with :cq to abort without installing anything.
# Your edits are never written back to the original Brewfile.
#
# POSIX sh — no bashisms.

set -eu

# Resolve dependency paths relative to this script, so it works from anywhere.
script_dir=$(cd "$(dirname -- "$0")" && pwd)
. "$script_dir/../../../scripts/lib/vim-edit.sh"

# check for brewfile path arg

if [ $# -lt 1 ] || [ -z "$1" ]; then
    printf '%s\n' "usage: $0 path/to/Brewfile" >&2
    exit 1
fi
brewfile=$1

# check brew is available

if ! command -v brew >/dev/null 2>&1; then
    cat >&2 <<'EOF'
error: brew not found in PATH.

Install Homebrew with:

    curl -sSfL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | sh -s

then rerun this setup script.
EOF
    exit 1
fi

# check for vim, a readable brewfile, and an interactive terminal

vim_edit_check "$brewfile" || exit 1

# --- Edit a temporary copy of the Brewfile -----------------------------------
echo 'We will now open a brewfile for editing.'
echo 'After editing, "brew bundle" will install whatever is left.'
status=0
tmpfile=$(vim_edit_copy "$brewfile" ruby) || status=$?

case $status in
    0) ;;
    2) echo "vim exited with an error (:cq?) — nothing installed."; exit 1 ;;
    3) echo "No entries left in the Brewfile — nothing to install."; exit 0 ;;
    4) echo "Aborted by user."; exit 0 ;;
    *) echo "An unknown error occured — nothing installed." exit 1 ;;
esac

# --- Apply -------------------------------------------------------------------
echo "Running brew bundle..."
brew bundle --file="$tmpfile"