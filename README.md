# setup

This repo includes resources used to set up a new system to my specifications.

It is expected to be used in conjunction with [my dotfiles repo](https://github.com/jamescallumyoung/dotfiles).

## macOS

macOS is currently the only supported platform.

This repo provides scripts to setup a macOS system. These can:

- install desired packages with Homebrew
- configure the default shell

## Usage Guide

### Prerequisites

**Git**

Git must be installed.
macOS ships a version of Git that is good enough for our purposes.
The setup process will install a more modern version.

To detect if Git is installed, run `which git`.

**fzf**

If fzf is installed, some scripts will use it. This provides an improved user experience and is strongly recommended.
If fzf is not installed, scripts will degrade to a fallback mechanism.

To detect if fzf is installed, run `which fzf`.

### 1 - Clone this repo

Clone this repo, so we can run the setup script.
The clone location doesn't matter but it's best to put it somewhere where it's clearly infrastructure and not a regular git repo.

```shell
# using SSH (recommended)
git clone git@github.com:jamescallumyoung/setup.git $HOME/.setuprepo

# using HTTPS
git clone https://github.com/jamescallumyoung/setup.git $HOME/.setuprepo
```

### 2 - Run the scripts

Install packages with:

```shell
cd $HOME/.setuprepo
chmod +x ./systems/macos/setup-macos.sh
./systems/macos/setup-macos.sh
```

Change the default shell with:

```shell
cd $HOME/.setuprepo
chmod +x ./scripts/change-shell.sh
./scripts/change-shell.sh
```

### 3 - Additional manual steps

There are additional manual steps you may want to take.
These are currently recorded in my dotfiles repo.

> ## 🖖 Notice
> This repo was forked from my previous dotfiles, which contained system setup scripts. The history has been squashed.
