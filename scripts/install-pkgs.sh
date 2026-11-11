#!/bin/sh
# install-pkgs.sh
#
# Read a Brewfile-style list, strip comments/blank lines, let the user
# pick entries interactively, then install the selection using a supported
# package manager.
#
# Usage:
#   ./install-pkgs.sh -i homebrew [-d] FILE
#   ./install-pkgs.sh -i flatpak  [-d] FILE
#
# -d enables dry-run mode. The dry_run flag is passed into whichever
# install_* function is selected, and that function decides internally how
# to perform a dry run.
#
# select_lines picks the best available interactive selector at runtime:
# fzf (fuzzy, best UX) or a hand-rolled numbered menu using only `read`
# (zero dependencies, works anywhere).
#
# POSIX sh — no bashisms. Argument parsing uses the POSIX `getopts` builtin. 
# Only short options are supported (no --flag long form).

set -eu

SCRIPT_DIR="$(cd "$(dirname -- "$0")" && pwd)"
. "$SCRIPT_DIR/lib/log.sh"
. "$SCRIPT_DIR/lib/select.sh"

log_primary "[install-pkgs.sh] Start"

# ---------------------------------------------------------------------------
# Pipeline steps (each does exactly one job, named to match the pipeline)
# ---------------------------------------------------------------------------

read_file() {
    # $1: path to file
    cat -- "$1"
}

filter_comments() {
    # Drop lines starting with '#' and empty/whitespace-only lines.
    # Plain POSIX grep — no GNU extensions needed for these patterns.
    grep -v -e '^#' -e '^[[:space:]]*$'
}

install_homebrew() {
    # $1: dry_run flag ("1" if dry-run requested, "" otherwise)
    # Must be first: blocks until the pipe from select_lines is closed,
    # which only happens after fzf exits. Nothing else in this function
    # runs until then, preventing any terminal output while fzf is open.
    entries=$(cat)
    # `brew bundle install` has no native --dry-run flag (unlike `brew
    # install`), so simulate a dry run by showing what was selected.
    if [ "${1:-}" = "1" ]; then
        log_secondary "Dry run! Would have run 'brew bundle install' with these entries:"
        printf '%s\n' "$entries"
    else
        log_secondary "Installing packages with brew..."
        printf '%s\n' "$entries" | HOMEBREW_NO_COLOR=1 brew bundle install --file=-
    fi
}

install_flatpak() {
    # $1: dry_run flag ("1" if dry-run requested, "" otherwise)
    # Must be first — same reasoning as install_homebrew above.
    entries=$(cat)
    # `flatpak install` only accepts one package per invocation, so we use
    # xargs to run it once per selected line. flatpak has no --dry-run flag
    # for `install`, so dry-run mode prints the commands instead.
    if [ "${1:-}" = "1" ]; then
        log_secondary "Dry run! Would have run:"
        printf '%s\n' "$entries" | xargs -I{} echo "flatpak install {}"
    else
        printf '%s\n' 'Installing packages with flatpak...'
        printf '%s\n' "$entries" | xargs -L1 flatpak install
    fi
}

usage() {
    log_error "Usage: $0 -i homebrew|flatpak [-d] FILE"
    exit 1
}

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------

installer=""
file=""
dry_run=""

# "i:" — -i requires an argument. "d" — -d is a boolean flag (no argument).
while getopts 'i:d' opt; do
    case "$opt" in
        i) installer="$OPTARG" ;;
        d) dry_run=1 ;;
        *) usage ;;
    esac
done
shift $((OPTIND - 1))

# Remaining positional argument is the file
if [ $# -ge 1 ]; then
    file="$1"
fi

[ -n "$installer" ] || usage
[ -n "$file" ] || usage
[ -f "$file" ] || { log_error "Error: file not found: $file"; exit 1; }

case "$installer" in
    homebrew|flatpak) ;;
    *) log_error "Error: -i must be 'homebrew' or 'flatpak'"; usage ;;
esac

# ---------------------------------------------------------------------------
# Run the pipeline
# ---------------------------------------------------------------------------

case "$installer" in
    homebrew)
        read_file "$file" | filter_comments | select_lines "Select packages to install:" | install_homebrew "$dry_run"
        ;;
    flatpak)
        read_file "$file" | filter_comments | select_lines "Select packages to install:" | install_flatpak "$dry_run"
        ;;
esac

log_secondary "[install-pkgs.sh] Done"
