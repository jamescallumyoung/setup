
# This file is sourced by login shells. See the note in .zshenv or consult:
# https://gist.github.com/jamescallumyoung/c2baf1973457f8457d4886e7109a0230
# In general "login shell" means:
# 1) all shells in macOS
# 2) the shell where you log into (via a terminal or via a GUI) in linux


#
# Configure PATH and zsh's fpath
#

# Ensure path arrays do not contain duplicates.
typeset -gU path fpath

# Add the path to "User-specific executable files" per the XDG Base Directory Specification
# Added to end of path so as not to overwrite critical system executables
# Note: could not be added in .zshrc because macOS would overwrite it. (see comment in header of this file)
path+=("${HOME}/.local/bin")


#
# Create convenience variables for OS, arch, and package managers in use
#

macos_use_homebrew=1
linux_use_homebrew=1
source "${ZDOTDIR}/scripts/set_os_pm.zsh.inc"
unset macos_use_homebrew
unset linux_use_homebrew

#
# brew
#

if using_pm "brew"; then
    # Note: on macOS, homebrew's source directory differs per system architecture
    if [[ $os == *"Darwin"* && $arch == "arm64" ]]; then
        eval $(/opt/homebrew/bin/brew shellenv)
    elif [[ $os == *"Darwin"* && $arch == "x86_64" ]]; then
        eval $(/usr/local/bin/brew shellenv)
    elif [[ $os == *"Linux"* ]]; then
        eval $(/home/linuxbrew/.linuxbrew shellenv)
    else
        echo "No config provided for OS ${os} (arch ${arch}). Homebrew could not be set up. System may not behave as expected."
    fi
fi

#
# Node.js -- set up fnm (Node.js "fast package manager")
# (Note: also enables corepack, so yarn and pnpm are available)
#

case $os in
"Darwin")
    eval "$(fnm env --use-on-cd --version-file-strategy recursive --corepack-enabled --resolve-engines --shell zsh)" ;;
"Linux")
    path+=("$XDG_DATA_HOME/fnm")
    eval "$(fnm env --use-on-cd --version-file-strategy recursive --corepack-enabled --resolve-engines --shell zsh)" ;;
*)
    echo "No config provided for OS ${os}. fnm could not be set up. Node, npm, yarn, and pnpm may not be available. System may not behave as expected." ;;
esac


#
# macOS only -- use GNU utils shipped by brew instead of those shipped by macOS
#

[[ $os == *"Darwin"* ]] && source "${ZDOTDIR}/scripts/prepend_brew_gnu_utils_to_path.zsh.inc"
