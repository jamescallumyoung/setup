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

die() {
    printf '%s\n' "$*" >&2
    exit 1
}

# check for brewfile path arg

[ $# -ge 1 ] && [ -n "$1" ] || die "usage: $0 path/to/Brewfile"
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

command -v vim  >/dev/null 2>&1 || die "error: vim not found in PATH"
[ -f "$brewfile" ] && [ -r "$brewfile" ] || die "error: cannot read Brewfile: $brewfile"
[ -r /dev/tty ] || die "error: this script needs an interactive terminal"

# --- Confirm -----------------------------------------------------------------

printf 'This will open %s in vim so you can choose what to install,\n' "$brewfile"
printf 'then run "brew bundle" on the result.\n'
printf 'Proceed? [y/N] '
read -r answer </dev/tty || answer=
case $answer in
    [Yy] | [Yy][Ee][Ss]) ;;
    *) echo "Aborted."; exit 0 ;;
esac

# --- Temporary copy ----------------------------------------------------------
tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/brew-install.XXXXXX") || # mktemp will replace the XXXXXX with random chars
    die "error: could not create temporary directory"

# Remove the temp copy however the script ends (EXIT trap is POSIX: signal 0).
trap 'rm -rf "$tmpdir"' 0
trap 'exit 130' INT
trap 'exit 143' TERM HUP

tmpfile=$tmpdir/Brewfile

{
    echo '# Delete or comment out (#) lines you do NOT want installed.'
    echo '# Save and quit with :wq to install.  Quit with :cq to abort.'
    echo '# Changes made here are temporary and will not be saved.'
    echo
    cat "$brewfile"
} >"$tmpfile"

# --- Edit the Brewfile -------------------------------------------------------
# Talk to the terminal directly so this works even if stdin/stdout are redirected.
if ! vim -c 'set filetype=ruby' "$tmpfile" </dev/tty >/dev/tty; then
    echo "vim exited with an error (:cq?) — nothing installed."
    exit 1
fi

# Bail out if nothing is left except comments and blank lines.
if ! grep -v -e '^[[:space:]]*#' -e '^[[:space:]]*$' "$tmpfile" >/dev/null; then
    echo "No entries left in the Brewfile — nothing to install."
    exit 0
fi

# --- Apply -------------------------------------------------------------------
echo "Running brew bundle..."
brew bundle --file="$tmpfile"