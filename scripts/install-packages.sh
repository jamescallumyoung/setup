#!/bin/sh
# install-packages.sh
#
# Interactively pick packages from a list, then install them using the
# selected package manager.
#
# Supported package managers are:
#   brew (`brew bundle`)
#   dnf (`dnf install`)
#   flatpak (`flatpak install`)
#
# Can strip comments from the list, for package managers that do not
# support comments. Comments are lines starting with "#", and any
# trailing comments starting with "#".
#
# Usage:
#   ./install-packages.sh -m brew|dnf|flatpak -f path/to/file
#
# The list is copied to a temporary location and opened in vi. Delete or
# comment out (#) any lines you don't want, then save and quit (:wq).
# Quit with :cq to abort without installing anything.
# Your edits are never written back to the original file.
#
# POSIX sh — no bashisms.

set -eu

# Resolve dependency paths relative to this script, so it works from anywhere.
script_dir=$(cd "$(dirname -- "$0")" && pwd)
. "$script_dir/lib/confirm.sh"
. "$script_dir/lib/vi-edit.sh"

# get the "-m" and "-f" options

usage="usage: $0 -m brew|dnf|flatpak -f path/to/file"

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
    brew | dnf | flatpak) ;;
    '') printf '%s\n' "error: -m brew|dnf|flatpak is required" >&2; exit 1 ;;
    *) printf '%s\n' "error: unsupported package manager: $manager (expected brew, dnf, or flatpak)" >&2; exit 1 ;;
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

if [ "$manager" = dnf ] && ! command -v dnf >/dev/null 2>&1; then
    cat >&2 <<'EOF'
error: dnf not found in PATH.
Consult your OS docs for support for dnf.
EOF
    exit 1
fi

if [ "$manager" = flatpak ] && ! command -v flatpak >/dev/null 2>&1; then
    cat >&2 <<'EOF'
error: flatpak not found in PATH.
Consult the docs at: https://flathub.org/setup
EOF
    exit 1
fi

# check for vi, a readable filepath, and an interactive terminal

vi_edit_check "$filepath" || exit 1

# --- Edit a temporary copy of the package list ------------------------------
echo 'We will now open the package list for editing.'
status=0

# brew bundle understands comments, so keep them
if [ "$manager" = brew ]; then
    echo 'After editing, "brew bundle" will install whatever is left.'
    tmpfile=$(vi_edit_copy "$filepath" ruby) || status=$?
fi

# dnf takes bare package names, so strip comments
if [ "$manager" = dnf ]; then
    echo 'After editing, "dnf install" will install whatever is left.'
    echo 'Comments in the file will automatically be stripped out.'
    tmpfile=$(vi_edit_copy -s "$filepath" conf) || status=$?
fi

# flatpak takes bare package ids, so strip comments
if [ "$manager" = flatpak ]; then
    echo 'After editing, "flatpak install" will install whatever is left.'
    echo 'Comments in the file will automatically be stripped out.'
    tmpfile=$(vi_edit_copy -s "$filepath" conf) || status=$?
fi

case $status in
    0) ;;
    2) echo "vi exited with an error (:cq?) — nothing installed."; exit 1 ;;
    3) echo "No entries left in the package list — nothing to install."; exit 0 ;;
    4) echo "Aborted by user."; exit 0 ;;
    *) echo "An unknown error occured — nothing installed."; exit 1 ;;
esac

# --- Apply -------------------------------------------------------------------

if [ "$manager" = brew ]; then
    echo "Running brew bundle..."
    brew bundle --file="$tmpfile"
fi

if [ "$manager" = dnf ]; then
    echo "Running dnf install..."
    # One package name per line. Disable globbing so names are taken literally,
    # then let word splitting turn the lines into arguments for dnf.
    set -f
    # shellcheck disable=SC2046
    set -- $(cat "$tmpfile")
    set +f
    sudo dnf install "$@"
fi

if [ "$manager" = flatpak ]; then
    echo "Running flatpak install..."
    # One package name per line. Disable globbing so names are taken literally,
    # then let word splitting turn the lines into arguments for flatpak.
    set -f
    # shellcheck disable=SC2046
    set -- $(cat "$tmpfile")
    set +f
    flatpak install "$@"
fi
