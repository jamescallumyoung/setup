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

brew "podman"           # the actual podman engine (can be installed by podman-desktop, but why not use brew?)
cask "podman-desktop"   # docker-desktop style GUI
tap libkrun/krun        
brew krunkit            # enables GPU support for podman containers; useful for AI workloads

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
cask "visual-studio-code"   # just in case!

# Others
brew "liquibase"            # db migration tool; used for work
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
cask "plex"                 # plex client
cask "sonos"
cask "spotify"
cask "transmission"
cask "vlc"
cask "whatsapp"
