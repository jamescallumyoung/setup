# Prerequisite: Installing Package Managers

> This document was written for a previous version of this project and may be out of date.

Before `setup.sh` can be run, we must have every package manager we intend to use installed.

Which package managers you use is up to you. However, there are recommendations: 

- for macOS: [Homebrew](https://brew.sh/),
- for Debian-based Linux: [APT](https://wiki.debian.org/Apt), [Flatpak](https://flatpak.org/),
  and [Snap](https://snapcraft.io/about).

Homebrew can also be used on Linux but these dotfiles currently assume an APT-based setup on Linux.
Additionally, non-Debian-based Linux distros are not currently supported.

## Installing

### Homebrew

[Homebrew installation instructions](https://brew.sh/).

Post install, check Homebrew is installed correctly by running `brew doctor`.

### APT

APT is already installed on Debian-based Linux distros.

### Flatpak

[Flatpak installation instructions](https://flatpak.org/setup/). (Differ per distro.)

### Snap

Snap is already installed on Ubuntu and Ubuntu-based distros.

Snap is comprised of a daemon, and a GUI package store.

[Snapd installation instructions](https://snapcraft.io/snapd). (Differ per distro.)

[Snap Store installation instructions](https://snapcraft.io/snap-store).
