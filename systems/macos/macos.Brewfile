#
# Required for system setup
#

brew "stow"     # for managing dotfiles
# we don't want "node" after the initial install, as it conflicts with "fnm"


#
# MODERN SHELL UTILS
#

brew "bat"      # better cat
brew "fd"       # better find
brew "fzf"
brew "jq"
brew "pick"
brew "ripgrep"  # better search (grep, etc.)
brew "thefuck"
brew "ugrep"    # better grep, egrep, and fgrep
brew "yq"       # jq for yaml and xml


#
# GNU SHELL UTILS
# (macOS may already ship some/all of these, but macOS' version is old.)
# (where macOS already ships a version, brew installs the pkg with a "g" prefix.)
# (we source these in .zshrc so they're used instead of the freeBSD versions macOS ships.)
#

# brew "bash" # installed in the shells section
brew "coreutils"
brew "ed"
brew "findutils"
brew "gawk"
brew "grep" # we don't actually use GNU grep, as we use ugrep instead. But we install it for scripts to use.
brew "gnu-sed"
brew "gnu-tar"
brew "make"


#
# ZSH and other shells
#

brew "zsh"
brew "antidote"

brew "bash"     # it's worth updating bash as well
brew "fish"     # we have some fish scripts we still use


#
# GIT
#

brew "git"
brew "gh"
brew "git-extras"
brew "git-lfs"
brew "gitui"
brew "hub"


#
# Node.js
#

brew "fnm"


#
# Java / JVM
#

brew "jenv"                 # java virtual environment manager; allows switching java versions

# for up-to-date EOL dates for Java Temurin releases see: https://endoflife.date/eclipse-temurin
#cask "temurin"             # latest Eclipse Temurin version
#cask "temurin@25"          # java 25 - LTS until 30 Sept 2031
#cask "temurin@21"          # java 21 - LTS until 31 Dec 2029
#cask "temurin@17"          # java 17 - LTS until 31 Oct 2027
#cask "temurin@11"          # java 11 - LTS until 31 Oct 2027
#cask "temurin@8"           # java  8 - LTS until 30 Nov 2026


#
# Podman (instead of Docker), Kubernetes
#

brew "podman"               # the actual podman engine (can be installed by podman-desktop, but why not use brew?)
cask "podman-desktop"       # docker-desktop style GUI
tap "libkrun/krun"        
brew "krunkit"              # enables GPU support for podman containers; useful for AI workloads

brew "kubernetes-cli"       # kubectl, etc.
brew "helm"
brew "derailed/k9s/k9s"     # in-terminal k8s dashboard


#
# Dev tools
#

# DB IDEs
cask "azure-data-studio"    # for MS SQL
cask "redisinsight"         # for redis
cask "tableplus"            # for Postgress

# Code IDEs
cask "jetbrains-toolbox"    # install Intellij, Webstorm, etc.
cask "sublime-text"         # useful for big files; very good performance
cask "visual-studio-code"   # for LLM workflows

# Others
cask "bruno"                # a better Postman
cask "google-cloud-sdk"     # gcloud cli for GCP
cask "iterm2"               # better macOS terminal

#
# Mac Utilities
#

cask "rectangle"            # window manager for macOS
cask "rocket"               # emoji tool for macOS


#
# Everything else
#

cask "discord"
cask "firefox"
cask "google-chrome"        # for when a site doesn't work with firefox
cask "handbrake"
cask "ipfs"
cask "lagrange"             # gemini client
cask "plex"
cask "sonos"
cask "transmission"
cask "vlc"
cask "whatsapp"
