
# This file is sourced in *all* zsh shells.
# $ZDOTDIR/.zprofile is sourced by _login_ shells.
# $ZDOTDIR/.zshrc is only sourced by _interactive login_ shells.
#
# Note however that zsh on macOS (but not other OSes) reorders the PATH after sourcing this file. In order for these
# dotfiles to be consistent across environments, we only set a few basics here and use .zprofile for everything else.
# For more info on this problem, see: https://gist.github.com/jamescallumyoung/c2baf1973457f8457d4886e7109a0230


#
# Set common variables expected by many programs
#

export VISUAL=vim
export EDITOR="$VISUAL"
export GIT_EDITOR="$VISUAL"

export PAGER=less


#
# Set directories for the XDG Base Directory Specification
#
# The values used are the defaults per the spec. They are explicitly set because:
# 1) Some programs incorrectly implement the spec and do not use the default values when a variable is unset.
# 2) Some environments (including macOS) do not define these variables by default.
#
# See the spec at: https://specifications.freedesktop.org/basedir-spec/latest/
#

# home dirs
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_STATE_HOME="${HOME}/.local/state"
export XDG_CACHE_HOME="${HOME}/.cache"

# $HOME/.local/bin is added to PATH in .zprofile to avoid macOS overwriting it (see comment in .zprofile)

# other dirs
export XDG_DATA_DIRS=${XDG_DATA_DIRS:-"/usr/local/share/:/usr/share/"}
export XDG_CONFIG_DIRS=${XDG_CONFIG_DIRS:-"/etc/xdg"}
# XDG_RUNTIME_DIR is complex is not set here


#
# Set the ZDOTDIR where zsh will look for the rest of its configs
#

export ZDOTDIR="${XDG_CONFIG_HOME:-"${HOME}/.config"}/zsh"
