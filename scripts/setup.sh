#!/bin/sh
set -eu

SCRIPT_DIR="$(cd "$(dirname -- "$0")" && pwd)"
. "$SCRIPT_DIR/lib/log.sh"
. "$SCRIPT_DIR/lib/select.sh"

trap 'log_error "Setup aborted."' EXIT

log_primary "[setup.sh] Start"

repo_path="$(cd "$SCRIPT_DIR/.." && pwd)"

usage() {
    log_error "Usage: $0 [-i homebrew|flatpak] [-d]"
    exit 1
}

installer=""
dry_run=""

while getopts 'i:d' opt; do
    case "$opt" in
        i) installer="$OPTARG" ;;
        d) dry_run="-d" ;;
        *) usage ;;
    esac
done
shift $((OPTIND - 1))

# ---------------------------------------------------------------------------
# Select which steps to run
# ---------------------------------------------------------------------------

chosen=$(printf 'install-pkgs\ninstall-dotfiles\nchange-shell\n' | select_lines "Select steps to run:")

# ---------------------------------------------------------------------------
# Run selected steps
# ---------------------------------------------------------------------------

if printf '%s\n' "$chosen" | grep -qxF 'install-pkgs'; then
    if [ -z "$installer" ]; then
        installer=$(printf 'homebrew\nflatpak\n' | select_line "Select a package manager:")
    fi
    [ -n "$installer" ] || { log_error "No package manager selected."; exit 1; }
    case "$installer" in
        homebrew) pkg_file="$repo_path/package-lists/macos.Brewfile" ;;
        flatpak)  pkg_file="$repo_path/package-lists/flatpak_list.txt" ;;
        *) log_error "Error: -i must be 'homebrew' or 'flatpak'"; usage ;;
    esac
    # $dry_run is intentionally unquoted: expands to "-d" or nothing.
    # shellcheck disable=SC2086
    "$SCRIPT_DIR/install-pkgs.sh" -i "$installer" $dry_run "$pkg_file"
fi

if printf '%s\n' "$chosen" | grep -qxF 'install-dotfiles'; then
    "$SCRIPT_DIR/install-dotfiles.sh"
fi

if printf '%s\n' "$chosen" | grep -qxF 'change-shell'; then
    "$SCRIPT_DIR/change-shell.sh"
fi

trap - EXIT
log_secondary "[setup.sh] Done"
