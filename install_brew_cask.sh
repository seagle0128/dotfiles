#!/bin/bash
#############################################################
# Install macOS via brew cask
# Author: Vincent Zhang <seagle0128@gmail.com>
# URL: https://github.com/seagle0128/dotfiles
#############################################################

# Cask applications
apps=(
    betterdisplay              # Retina display management: avibrazil-rdm
    captin                     # Caps Lock status
    cheatsheet
    maccy                      # Clipboard: clipy
    maczip                     # Compress & extract
    fliqlo                     # Screen Saver
    paper                      # Wallpaper
    alt-tab                    # hyperswitch
    iterm2                     # Terminal
    # keepingyouawake
    keycastr                   # Show keys on the screen
    licecap                    # Recording screen as gif
    # mounty                     # Mounty for NTFS read/write
    monitorcontrol             # Controls external display brightness and volume
    mos                        # Smooth and reverse scroll
    # raycast                    # Spotlight/Alfred replacement.
    rectangle                  # Window management
    hiddenbar                  # Hide menu bar icons. Alternative: bartender, vanilla

    clashx                     # Proxy: v2rayx, shadowsocksx-ng-r
    iina                       # Media player
    microsoft-edge             # Browser: google-chrome
    karabiner-elements         # karabiner: Keboard remapping
    # hammersppon                # Ultimate tools
    # netspot                    # Wifi signal analysis and scanner
    macfuse                    # File system
    veracrypt                  # File crypt
    # vox                        # Music player
    squirrel                   # Pinyin Input: sogouinput
    handbrake                  # Video Transcoder: transcoder

    # Audio
    # soundflower
    # soundflowerbed

    # Development
    # java                       # optional
    # docker                     # optional
    # fork                       # Git Client: gitkraken, sourcetree
    # mark-text                    # Markdown editor: typora
    visual-studio-code

    # Utilities
    # aliwangwang
    # baidunetdisk
    motrix                     # Downloader: ariang
    macgesture
    qq
    wechat
    tencent-lemon

    neteasemusic
    youdaodict
    youdaonote

    yesplaymusic
    zy-player
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

        xcode-select --install
        /bin/bash -c "$(curl -fsSL https://cdn.jsdelivr.net/gh/Homebrew/install@HEAD/install.sh)"

        brew tap homebrew/cask
        brew tap homebrew/cask-versions
        brew tap homebrew/cask-fonts
        brew tap buo/cask-upgrade
    fi
}

function install () {
    for app in ${apps[@]}; do
        printf "${BLUE} ➜  Installing ${app}...${NORMAL}\n"
        brew install --cask ${app}
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
