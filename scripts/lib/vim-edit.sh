# lib/vim-edit.sh — sourced, not executed directly.
# Provides: vim_edit_check (preconditions), vim_edit_copy (copy + edit)
# Requires: lib/confirm.sh, sourced before this file.
#
# Ask for confirmation, copy a file to a temporary location, open the copy in
# vi, and print the path of the edited copy. The original file is never
# modified.
#
# Intended for "pick what to install" flows: a package list (Brewfile, dnf
# list, ...) is opened so the user can delete or comment out (#) entries.
#
# Exit codes (shared by both functions):
#   0   success
#   1   not used here: reserved for unexpected failures from the shell itself
#   2   vi exited non-zero (e.g. the user quit with :cq)
#   3   nothing left except comments and blank lines
#   4   the user declined at the confirmation prompt
#   10  usage error (unknown option or no file given)
#   11  vi not found in PATH
#   12  cannot read the source file
#   13  no interactive terminal
#   14  could not create the temporary directory
#   15  could not write the temporary copy
#   16  could not strip comments from the temporary copy
# Codes 10 and above also print an error message to stderr.
#
# POSIX sh — no bashisms.

vim_edit_check() {
    # $1: path to the source file
    # Check for vi, a readable source file, and an interactive terminal.
    # Returns 0 if all is well; otherwise prints an error to stderr and
    # returns 10-13 (see the exit codes above). vim_edit_copy calls this
    # itself; call it directly to fail early, e.g. before other setup work.
    if [ -z "${1:-}" ]; then
        printf '%s\n' "error: no file given" >&2
        return 10
    fi
    if ! command -v vi >/dev/null 2>&1; then
        printf '%s\n' "error: vi not found in PATH" >&2
        return 11
    fi
    if ! { [ -f "$1" ] && [ -r "$1" ]; }; then
        printf '%s\n' "error: cannot read file: $1" >&2
        return 12
    fi
    # Actually open /dev/tty: [ -r /dev/tty ] only checks permissions, and
    # passes even when there is no controlling terminal. The subshell stops
    # a failed redirection on ":" from exiting the calling script.
    if ! (: </dev/tty) 2>/dev/null; then
        printf '%s\n' "error: this script needs an interactive terminal" >&2
        return 13
    fi
}

vim_edit_copy() {
    # Options (must come before the positional arguments):
    #   -s  strip comments from the edited copy: removes comment lines,
    #       trailing "# ..." comments, and blank lines. Use for formats that
    #       don't understand comments (e.g. a plain package list).
    #
    # $1: path to the source file
    # $2: optional vim filetype for syntax highlighting, e.g. "ruby"
    # $3: optional instructions (one or more lines) written as '# ' comments
    #     at the top of the copy. Defaults to generic edit instructions.
    #
    # Always asks "Proceed? [y/N]" on the terminal before doing anything.
    #
    # Copies a file and opens it with vi so the user can edit it.
    # On success, prints the path of the edited copy to stdout. On failure,
    # prints nothing to stdout. The copy lives under $TMPDIR (or /tmp) and is
    # not removed; the OS cleans it up eventually.
    #
    # Usage:
    #   file=$(vim_edit_copy "$list") || exit
    #   file=$(vim_edit_copy -s "$list" conf) || exit
    #
    # Returns 0 when the edited copy is ready (path printed to stdout),
    # otherwise one of the exit codes listed at the top of this file.

    # Parse options. Reset OPTIND so repeated calls start from the beginning.
    vim_edit_strip=
    OPTIND=1
    while getopts s vim_edit_opt; do
        case $vim_edit_opt in
            s) vim_edit_strip=1 ;;
            *) return 10 ;;  # getopts has already printed an error
        esac
    done
    shift $((OPTIND - 1))

    vim_edit_src="${1:-}"
    vim_edit_filetype="${2:-}"
    vim_edit_header="${3:-Delete or comment out (#) lines you do NOT want.
Save and quit with :wq to continue.  Quit with :cq to abort.
Changes made here are temporary and will not be saved.}"

    # check prerequisites
    vim_edit_check "$vim_edit_src" || return  # pass its exit code through

    # --- Confirm -------------------------------------------------------------
    # Prompt on the terminal: stdout is reserved for the returned path.
    printf 'This will open %s in vi so you can choose what to keep.\n' "$vim_edit_src" >/dev/tty
    confirm 'Proceed?' || return 4

    # --- Temporary copy ------------------------------------------------------
    # mktemp will replace the XXXXXX with random chars
    if ! vim_edit_dir=$(mktemp -d "${TMPDIR:-/tmp}/vim-edit.XXXXXX"); then
        printf '%s\n' "error: could not create temporary directory" >&2
        return 14
    fi

    # Keep the original basename so the file is recognisable in vi.
    vim_edit_file=$vim_edit_dir/${vim_edit_src##*/}

    if ! {
        printf '%s\n' "$vim_edit_header" | sed 's/^/# /'
        echo
        cat "$vim_edit_src"
    } >"$vim_edit_file"; then
        printf '%s\n' "error: could not write temporary copy" >&2
        return 15
    fi

    # --- Edit the copy -------------------------------------------------------
    # Talk to the terminal directly: stdout is reserved for the returned path,
    # and stdin/stdout may be captured by $(...) or a pipeline.
    if [ -n "$vim_edit_filetype" ]; then
        vi -c "set filetype=$vim_edit_filetype" "$vim_edit_file" </dev/tty >/dev/tty
    else
        vi "$vim_edit_file" </dev/tty >/dev/tty
    fi || return 2

    # Optionally strip comments: drop everything from "#" to end of line
    # (with any whitespace before it), then delete lines left blank.
    # sed -i isn't POSIX, so write to a second file and move it into place.
    if [ -n "$vim_edit_strip" ]; then
        if ! sed -e 's/[[:space:]]*#.*//' -e '/^[[:space:]]*$/d' \
                "$vim_edit_file" >"$vim_edit_file.stripped" ||
            ! mv "$vim_edit_file.stripped" "$vim_edit_file"; then
            printf '%s\n' "error: could not strip comments from temporary copy" >&2
            return 16
        fi
    fi

    # Report if nothing is left except comments and blank lines.
    if ! grep -v -e '^[[:space:]]*#' -e '^[[:space:]]*$' "$vim_edit_file" >/dev/null; then
        return 3
    fi

    printf '%s\n' "$vim_edit_file"
}
