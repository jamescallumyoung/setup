#!/bin/sh
# install-packages.sh
#
# Interactively pick packages from a list, then install them using the
# selected package manager.
#
# Supported package managers are:
#   brew (`brew bundle`)
#
# Can strip comments from the list, for package managers that do not
# support comments. Comments are lines starting with "#", and any
# trailing comments starting with "#".
#
# Usage:
#   ./install-packages.sh -m brew -f path/to/file
#
# The list is copied to a temporary location and opened in vim. Delete or
# comment out (#) any lines you don't want, then save and quit (:wq).
# Quit with :cq to abort without installing anything.
# Your edits are never written back to the original file.
#
# POSIX sh — no bashisms.

set -eu

# Resolve dependency paths relative to this script, so it works from anywhere.
script_dir=$(cd "$(dirname -- "$0")" && pwd)
. "$script_dir/lib/vim-edit.sh"

# get the "-m" and "-f" options

usage="usage: $0 -m brew -f path/to/file"

manager=
filepath=
while getopts m:f: opt; do
    case $opt in
        m) manager=$OPTARG ;;
        f) filepath=$OPTARG ;;
        *) printf '%s\n' "$usage" >&2; exit 1 ;;  # getopts has printed the error
    esac
done
shift $((OPTIND - 1))

# no positional args are accepted
if [ $# -gt 0 ]; then
    printf '%s\n' "error: unexpected argument: $1" "$usage" >&2
    exit 1
fi

case $manager in
    brew) ;;
    '') printf '%s\n' "error: -m brew is required" >&2; exit 1 ;;
    *) printf '%s\n' "error: unsupported package manager: $manager (expected brew)" >&2; exit 1 ;;
esac

# check the "-f" option was given

if [ -z "$filepath" ]; then
    printf '%s\n' "error: -f path/to/file is required" >&2
    exit 1
fi

# check package manager is available

if [ "$manager" = brew ] && ! command -v brew >/dev/null 2>&1; then
    cat >&2 <<'EOF'
error: brew not found in PATH.

Install Homebrew with:

    curl -sSfL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | sh -s

then rerun this setup script.
EOF
    exit 1
fi

# check for vim, a readable filepath, and an interactive terminal

vim_edit_check "$filepath" || exit 1

# --- Edit a temporary copy of the package list ------------------------------
echo 'We will now open the package list for editing.'
status=0

# brew bundle understands comments, so keep them
if [ "$manager" = brew ]; then
    echo 'After editing, "brew bundle" will install whatever is left.'
    tmpfile=$(vim_edit_copy "$filepath" ruby) || status=$?
fi

case $status in
    0) ;;
    2) echo "vim exited with an error (:cq?) — nothing installed."; exit 1 ;;
    3) echo "No entries left in the package list — nothing to install."; exit 0 ;;
    4) echo "Aborted by user."; exit 0 ;;
    *) echo "An unknown error occured — nothing installed."; exit 1 ;;
esac

# --- Apply -------------------------------------------------------------------

if [ "$manager" = brew ]; then
    echo "Running brew bundle..."
    brew bundle --file="$tmpfile"
fi
