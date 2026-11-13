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
# Exit codes:
#   0       success, or nothing left in the list to install
#   2       unknown option or unexpected argument
#   3       -m was not given
#   4       unsupported package manager
#   5       -f was not given
#   6       brew not found in PATH
#   7       dnf not found in PATH
#   8       flatpak not available (directly or via flatpak-spawn)
#   9       vi exited with an error (e.g. the user quit with :cq)
#   10-16   passed through from lib/vi-edit.sh (see that file)
#   20      the user declined at the confirmation prompt
#   21      unknown error while preparing the package list
#   *       other: a command failed (set -e), e.g. the install itself
#
# POSIX sh — no bashisms.

set -eu

# Resolve dependency paths relative to this script, so it works from anywhere.
script_dir=$(cd "$(dirname -- "$0")" && pwd)
. "$script_dir/lib/confirm.sh"  # required by vi-edit.sh
. "$script_dir/lib/vi-edit.sh"

info() { printf '%s\n' "$*" >&2; }
err()  { printf 'error: %s\n' "$*" >&2; }

# get the -m and -f options

usage="usage: $0 -m brew|dnf|flatpak -f path/to/file"

manager=
filepath=
while getopts m:f: opt; do
    case $opt in
        m) manager=$OPTARG ;;
        f) filepath=$OPTARG ;;
        *) info "$usage"; exit 2 ;;  # getopts has printed the error
    esac
done
shift $((OPTIND - 1))

# no positional args are accepted
if [ $# -gt 0 ]; then
    err "unexpected argument: $1"
    info "$usage"
    exit 2
fi

case $manager in
    brew | dnf | flatpak) ;;
    '') err '-m brew|dnf|flatpak is required'; exit 3 ;;
    *) err "unsupported package manager: $manager (expected brew, dnf, or flatpak)"; exit 4 ;;
esac

# check the "-f" option was given

if [ -z "$filepath" ]; then
    err '-f path/to/file is required'
    exit 5
fi

# check package manager is available

if [ "$manager" = brew ] && ! command -v brew >/dev/null 2>&1; then
    cat >&2 <<'EOF'
error: brew not found in PATH.

Install Homebrew with:

    curl -sSfL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | sh -s

then rerun this setup script.
EOF
    exit 6
fi

if [ "$manager" = dnf ] && ! command -v dnf >/dev/null 2>&1; then
    cat >&2 <<'EOF'
error: dnf not found in PATH.
Consult your OS docs for support for dnf.
EOF
    exit 7
fi

if [ "$manager" = flatpak ]; then
    if command -v flatpak >/dev/null 2>&1; then
        run_flatpak() { flatpak "$@"; }
    
    # test if flatpak can be run via flatpak-spawn
    elif command -v flatpak-spawn >/dev/null 2>&1 &&
        flatpak-spawn --host flatpak --version >/dev/null 2>&1; then
            info 'flatpak not found in container — using host flatpak via flatpak-spawn.'
            run_flatpak() { flatpak-spawn --host flatpak "$@"; }
    
    else
        cat >&2 <<'EOF'
error: flatpak not found in PATH.
error: can not run flatpak directly or via flatpak-spawn
(If you are inside a toolbox/distrobox container, try running this script on the host directly.)
Consult the docs at: https://flathub.org/setup
EOF
        exit 8
    fi
fi

# check for vi, a readable filepath, and an interactive terminal

vi_edit_check "$filepath" || exit  # pass its exit code (10-13) through

# --- Edit a temporary copy of the package list ------------------------------
info 'We will now open the package list for editing.'
status=0

# brew bundle understands comments, so keep them
if [ "$manager" = brew ]; then
    info 'After editing, "brew bundle" will install whatever is left.'
    tmpfile=$(vi_edit_copy "$filepath" ruby) || status=$?
fi

# dnf takes bare package names, so strip comments
if [ "$manager" = dnf ]; then
    info 'After editing, "dnf install" will install whatever is left.'
    info 'Comments in the file will automatically be stripped out.'
    tmpfile=$(vi_edit_copy -s "$filepath" conf) || status=$?
fi

# flatpak takes bare package ids, so strip comments
if [ "$manager" = flatpak ]; then
    info 'After editing, "flatpak install" will install whatever is left.'
    info 'Comments in the file will automatically be stripped out.'
    tmpfile=$(vi_edit_copy -s "$filepath" conf) || status=$?
fi

case $status in
    0) ;;
    2) err 'vi exited with an error (:cq?) — nothing installed.'; exit 9 ;;
    3) info 'No entries left in the package list — nothing to install.'; exit 0 ;;
    4) err 'Aborted by user.'; exit 20 ;;
    1[0-6]) exit "$status" ;;  # vi-edit.sh has printed the error
    *) err 'An unknown error occurred — nothing installed.'; exit 21 ;;
esac

# --- Apply -------------------------------------------------------------------

if [ "$manager" = brew ]; then
    info 'Running brew bundle...'
    brew bundle --file="$tmpfile"
fi

if [ "$manager" = dnf ]; then
    info 'Running dnf install...'
    # One package name per line. Disable globbing so names are taken literally,
    # then let word splitting turn the lines into arguments for dnf.
    set -f
    # shellcheck disable=SC2046
    set -- $(cat "$tmpfile")
    set +f
    sudo dnf install "$@"
fi

if [ "$manager" = flatpak ]; then
    info 'Running flatpak install...'
    # One package name per line. Disable globbing so names are taken literally,
    # then let word splitting turn the lines into arguments for flatpak.
    set -f
    # shellcheck disable=SC2046
    set -- $(cat "$tmpfile")
    set +f
    run_flatpak install "$@"
fi
