#!/bin/sh

# Common functions and variables for installation scripts

DOTFILES="$HOME"/.dotfiles
EMACSD="$HOME"/.emacs.d
TMUX="$HOME"/.tmux
ZSH="$HOME"/.local/share/zinit

# OS detection
OS=$(uname -s)
OSREV=$(uname -r)
OSARCH=$(uname -m)

# Color support
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

# OS detection functions
is_mac() {
    [ "$OS" = "Darwin" ]
}

is_linux() {
    [ "$OS" = "Linux" ]
}

is_debian() {
    command -v apt-get >/dev/null 2>&1
}

is_arch() {
    command -v pacman >/dev/null 2>&1
}

is_x86_64() {
    [ "$OSARCH" = "x86_64" ]
}

is_arm64() {
    [ "$OSARCH" = "arm64" ]
}

# Utility functions
sync_repo() {
    repo_uri="${1}"
    repo_path="${2}"
    repo_branch="${3}"

    if [ -z "$repo_branch" ]; then
        repo_branch="master"
    fi

    if [ ! -e "$repo_path" ]; then
        mkdir -p "$repo_path"
        git clone --depth 1 --single-branch --branch "$repo_branch" "https://github.com/$repo_uri.git" "$repo_path"
    else
        cd "$repo_path" && git pull --rebase --stat origin "$repo_branch"; cd - || return
    fi
}

install_package() {
    if ! command -v "${1}" >/dev/null 2>&1; then
        if is_mac; then
            brew -q install "${1}"
        elif is_debian; then
            sudo apt-get install -y "${1}"
        elif is_arch; then
            pacman -Ssu --noconfirm "${1}"
        fi
    else
        if is_mac; then
            brew upgrade -q "${1}"
        elif is_debian; then
            sudo apt-get upgrade -y "${1}"
        elif is_arch; then
            pacman -Ssu --noconfirm "${1}"
        fi
    fi
}

YES=0
NO=1
promote_yn() {
    eval "${2}"="$NO"
    read -p "$1 [y/N]: " yn
    case $yn in
        [Yy]* )    eval "${2}"="$YES";;
        [Nn]*|'' ) eval "${2}"="$NO";;
        *)         eval "${2}"="$NO";;
    esac
}
