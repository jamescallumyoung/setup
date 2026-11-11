# lib/log.sh — sourced, not executed directly.
# All output goes to stderr so callers are safe to use in pipelines.

log_primary() {
    printf "\033[0;32m%s\033[0m\n" "$1" >&2
}
log_secondary() {
    printf "\033[0;37m%s\033[0m\n" "$1" >&2
}
log_error() {
    printf "\033[0;31m%s\033[0m\n" "$1" >&2
}
