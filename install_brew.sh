#!/bin/bash
#############################################################
# Install macOS via brew cask
# Author: Vincent Zhang <seagle0128@gmail.com>
# URL: https://github.com/seagle0128/dotfiles
#############################################################

# Cask applications
packages=(
    # prerequisite
    git
    zsh
    unzip

    # modern tools
    bat
    bottom
    btop
    delta
    duf
    dust
    fd
    fzf
    gitui
    gping
    hyperfine
    neofetch
    procs
    ripgrep
    sd
    tealdeer
    zoxide
)

# Use colors, but only if connected to a terminal, and that terminal
# supports them.
if command -v tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    BOLD="$(tput bold)"
    NORMAL="$(tput sgr0)"
else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    NORMAL=""
fi

function check {
    # Check OS
    if [[ $OSTYPE != darwin* ]]; then
        echo "${RED}Error: only install software via brew on macOS.${NORMAL}" >&2
        exit 1
    fi

    # Check brew
    if ! command -v brew >/dev/null 2>&1; then
        printf "${BLUE} ➜  Installing Homebrew...${NORMAL}\n"

        xcode-select --install
        /bin/bash -c "$(curl -fsSL https://cdn.jsdelivr.net/gh/Homebrew/install@HEAD/install.sh)"
    fi
}

function install () {
    for app in ${packages[@]}; do
        printf "${BLUE} ➜  Installing ${app}...${NORMAL}\n"
        brew install ${app}
    done
}

function cleanup {
    brew cleanup
}

function main {
    check
    install
    cleanup
}

main
