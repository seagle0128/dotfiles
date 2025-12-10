#!/bin/sh

# Package installation module

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

install_homebrew() {
    if is_mac && ! command -v brew >/dev/null 2>&1; then
        printf "${GREEN}▓▒░ Installing Homebrew...${NORMAL}\n"

        # Use mirror
        export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
        export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
        export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
        export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"
        export HOMEBREW_PIP_INDEX_URL="https://mirrors.ustc.edu.cn/pypi/simple"

        /bin/bash -c "$(curl -fsSL https://github.com/Homebrew/install/raw/HEAD/install.sh)"

        if is_arm64; then
            echo >> $HOME/.zprofile
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    fi
}

install_apt_cyg() {
    if is_cygwin && ! command -v apt-cyg >/dev/null 2>&1; then
        printf "${GREEN}▓▒░ Installing Apt-Cyg...${NORMAL}\n"
        APT_CYG=/usr/local/bin/apt-cyg
        curl -fsSL https://raw.githubusercontent.com/transcode-open/apt-cyg/master/apt-cyg > $APT_CYG
        chmod +x $APT_CYG
    fi
}

install_core_packages() {
    # Check git
    if ! command -v git >/dev/null 2>&1; then
        printf "${GREEN}▓▒░ Installing git...${NORMAL}\n"
        install_package git
    fi

    # Check curl
    if ! command -v curl >/dev/null 2>&1; then
        printf "${GREEN}▓▒░ Installing curl...${NORMAL}\n"
        install_package curl
    fi

    # Check zsh
    if ! command -v zsh >/dev/null 2>&1; then
        printf "${GREEN}▓▒░ Installing zsh...${NORMAL}\n"
        install_package zsh
    fi
}

install_zinit() {
    printf "${GREEN}▓▒░ Installing Zinit...${NORMAL}\n"
    sh -c "$(curl -fsSL https://git.io/zinit-install)"
}

install_packages() {
    printf "${GREEN}▓▒░ Installing packages...${NORMAL}\n"
    if is_mac; then
        brew bundle --global
    elif is_arch; then
        "$SCRIPT_DIR/install_arch.sh"
    elif is_debian; then
        "$SCRIPT_DIR/install_debian.sh"
    else
        printf "Nothing to install!"
    fi
}
