#!/bin/bash
#############################################################
# Install packages for Debian or its derived editions (e.g. Ubuntu, Mint).
# Support Ubuntu 24.04+
# Author: Vincent Zhang <seagle0128@gmail.com>
# URL: https://github.com/seagle0128/dotfiles
#############################################################

# Source common functions and variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Packages
packages=(
    # prerequisite
    build-essential

    # modern tools
    bat
    btm
    btop
    duf
    # dust
    eza                         # exa
    fd-find
    fzf
    git-delta
    tig                         # gitui
    gping
    hyperfine
    neofetch
    # procs
    ripgrep
    # sd
    # tealdeer
    topgrade
    zoxide

    # sudo add-apt-repository -y ppa:kelleyk/emacs
    # emacs                       # emacs-snapshot

    aspell                      # hunspell
    # parcellite                  # clipit
    # peek
    # screenkey

    # Quick launcher: synapse/albert/Ulauncher
    # sudo add-apt-repository ppa:agornostal/ulauncher
    # ulauncher
)

check() {
    if ! command -v git >/dev/null 2>&1; then
        echo "${RED}Error: git is not installed${NORMAL}" >&2
        exit 1
    fi

    if command -v apt >/dev/null 2>&1; then
        APT=apt
    elif command -v apt-get >/dev/null 2>&1; then
        APT=apt-get
    fi

    if [ ! "$OS" = "Linux" ] || [ -z "$APT" ]; then
        echo "${RED}Error: Not Debian or its derived edition${NORMAL}" >&2
        exit 1
    fi
}

install() {
    for p in "${packages[@]}"; do
        printf "${BLUE} ➜  Installing ${p}...${NORMAL}\n"
        sudo "$APT" upgrade -y "${p}"
    done
}

main() {
    check
    install
}

main
