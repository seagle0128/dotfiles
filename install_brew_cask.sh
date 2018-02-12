#!/bin/bash
#############################################################
# Install macOS via brew cask
# Author: Vincent Zhang <seagle0128@gmail.com>
# URL: https://github.com/seagle0128/dotfiles
#############################################################

# Cask applications
apps=(
    cheatsheet
    clipy
    fliqlo        # Screen Saver
    # hyperswitch
    iterm2
    keycastr      # Show keys on the screen
    licecap       # Recording screen as gif
    mounty        # Mounty for NTFS read/write
    mos           # Smooth and reverse scroll. alternative: scroll-reverser
    shadowsocksx-ng
    spectacle     # Window management
    # vanilla       # Hide menu bar icons, buggy

    iina          # Media player
    firefox
    google-chrome
    # karabiner-elements # karabiner: Keboard remapping
    # netspot       # Wifi signal analysis and scanner
    osxfuse
    veracrypt
    vox2          # Music player
    sogouinput

    # Audio
    # sound-siphon
    soundflower
    soundflowerbed

    # Development
    # java          # optional
    docker
    emacs
    sourcetree
    typora        # Markdown editor
    visual-studio-code

    # # Utils
    # acrobat-reader
    aliwangwang
    baidunetdisk
    # neteasemusic
    # skype-for-business
    thunder
)

# Use colors, but only if connected to a terminal, and that terminal
# supports them.
if which tput >/dev/null 2>&1; then
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
        echo "${RED}Error: only install software via brew_cask on macOS.${NORMAL}"
        exit 1
    fi

    # Check brew
    if not hash brew 2>/dev/null; then
        echo "${BLUE} ➜  Installing Homebrew and Cask...${NORMAL}"

        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

        brew tap caskroom/cask
        cd "$(brew --repo)"/Library/Taps/caskroom/homebrew-cask
        git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-cask.git
    fi
}

function install () {
    for app in ${apps[@]}; do
        echo "${BLUE} ➜  Installing ${app}...${NORMAL}"
        brew cask install ${app}
    done
}

function cleanup {
    brew cask cleanup
}

function main {
    check
    install
    cleanup
}

main
