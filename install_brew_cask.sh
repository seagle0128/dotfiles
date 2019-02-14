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
    ezip          # compress & extract
    fliqlo        # Screen Saver
    hyperswitch
    iterm2
    keepingyouawake
    keycastr      # Show keys on the screen
    licecap       # Recording screen as gif
    mounty        # Mounty for NTFS read/write
    mos           # Smooth and reverse scroll. Alternative: scroll-reverser
    shadowsocksx-ng-r
    # shiftit       # Window management. Alternative: spectacle
    # vanilla       # Hide menu bar icons. Alternative: bartender

    iina          # Media player
    firefox
    google-chrome
    # karabiner-elements # karabiner: Keboard remapping
    # netspot       # Wifi signal analysis and scanner
    osxfuse
    veracrypt
    vox           # Music player
    sogouinput

    # Audio
    # sound-siphon  # 2.0.2
    # background-music
    soundflower
    soundflowerbed

    # Development
    # java          # optional
    # docker        # optional
    emacs
    fork            # Git Client: gitkraken, sourcetree
    typora        # Markdown editor
    visual-studio-code

    # Utilities
    # acrobat-reader
    aliwangwang
    baidunetdisk
    # neteasemusic
    # skype-for-business
    thunder
    aria2gui
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
        echo "${RED}Error: only install software via brew_cask on macOS.${NORMAL}" >&2
        exit 1
    fi

    # Check brew
    if ! command -v brew >/dev/null 2>&1; then
        printf "${BLUE} ➜  Installing Homebrew and Cask...${NORMAL}\n"

        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

        brew tap caskroom/cask
        brew tap caskroom/fonts
        cd "$(brew --repo)"/Library/Taps/caskroom/homebrew-cask
        git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-cask.git
    fi
}

function install () {
    for app in ${apps[@]}; do
        printf "${BLUE} ➜  Installing ${app}...${NORMAL}\n"
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
