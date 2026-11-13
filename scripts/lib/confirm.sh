# lib/confirm.sh — sourced, not executed directly.
# Provides: confirm (yes/no prompt)
#
# POSIX sh — no bashisms.

confirm() {
    # $1: the question to ask, e.g. "Install dnf packages?"
    # Asks the question on the terminal with " [y/N] " appended.
    # Returns 0 if the user answers y or yes (any case), 1 otherwise.
    # The default is no: an empty answer, end of input, or no terminal all
    # return 1.
    #
    # Talks to /dev/tty directly so it works even when stdin/stdout are
    # redirected or captured.
    #
    # Usage:
    #   if confirm "Install dnf packages?"; then
    #       ...
    #   fi
    printf '%s [y/N] ' "$1" >/dev/tty
    read -r confirm_answer </dev/tty || confirm_answer=
    case $confirm_answer in
        [Yy] | [Yy][Ee][Ss]) return 0 ;;
        *) return 1 ;;
    esac
}
