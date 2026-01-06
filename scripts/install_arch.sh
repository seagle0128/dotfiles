#!/bin/bash
#############################################################
# Install packages for Archlinux or its derived editions (e.g. Manjaro).
# Author: Vincent Zhang <seagle0128@gmail.com>
# URL: https://github.com/seagle0128/dotfiles
#############################################################

# Source common functions and variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Packages
packages=(
    # modern tools
    bat
    bottom
    btop
    delta
    duf
    dust
    eza
    fd
    fzf
    git-delta
    gitui
    gping
    hyperfine
    lsd
    neofetch
    procs
    ripgrep
    sd
    starship
    tealdeer
    topgrade
    zoxide
)

check() {
    if ! command -v pacman >/dev/null 2>&1; then
        echo "${RED}Error: not Archlinux or its derived edition.${NORMAL}" >&2
        exit 1
    fi
}

install() {
    printf "\n${BLUE}➜ Refreshing database...${NORMAL}\n"
    sudo pacman -Syu
    printf "\n"

    for p in "${packages[@]}"; do
        printf "\n${BLUE}➜ Installing ${p}...${NORMAL}\n"
        sudo pacman -Sc --needed --noconfirm "${p}"
    done
}

main() {
    check
    install
}

main
