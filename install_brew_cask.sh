#!/bin/bash
#############################################################
# Install macOS via brew cask
# Author: Vincent Zhang <seagle0128@gmail.com>
# URL: https://github.com/seagle0128/dotfiles
#############################################################

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

function check {
    # Check OS
    if [[ $OSTYPE != darwin* ]]; then
        echo "Error: only install software via brew_cask on macOS."
        exit 1
    fi

    # Check brew
    if not hash brew 2>/dev/null; then
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

        brew tap caskroom/cask
        cd "$(brew --repo)"/Library/Taps/caskroom/homebrew-cask
        git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-cask.git
    fi
}

function install () {
    for app in ${apps[@]}; do
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
