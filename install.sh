#!/bin/sh
#############################################################
# Set development environment on Linux/macOS/Cygwin quickly.
# Author: Vincent Zhang <seagle0128@gmail.com>
# URL: https://github.com/seagle0128/dotfiles
#############################################################

# Variables
DOTFILES=$HOME/.dotfiles
EMACSD=$HOME/.emacs.d
FZF=$HOME/.fzf
TMUX=$HOME/.tmux
ZSH=$HOME/.antigen

# Get OS name
SYSTEM=`uname -s`

# Only enable exit-on-error after the non-critical colorization stuff,
# which may fail on systems lacking tput or terminfo
# set -e

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

# Check git
hash git >/dev/null 2>&1 || {
    echo "${RED}Error: git is not installed${NORMAL}"
    exit 1
}

# Sync repository
sync_repo() {
    local repo_uri="$1"
    local repo_path="$2"
    local repo_branch="$3"

    if [ -z "$repo_branch" ]; then
        repo_branch="master"
    fi

    if [ ! -e "$repo_path" ]; then
        mkdir -p "$repo_path"
        git clone --depth 1 --branch $repo_branch "https://github.com/$repo_uri.git" "$repo_path"
    else
        cd "$repo_path" && git pull --rebase --stat origin $repo_branch; cd - >/dev/null
    fi
}

sync_brew_package() {
    if ! hash brew >/dev/null 2>&1; then
        echo "${RED}Error: brew is not installed${NORMAL}"
        return 1
    fi

    if ! hash ${1} >/dev/null 2>&1; then
        brew install ${1} >/dev/null
    else
        brew upgrade ${1} >/dev/null
    fi
}

sync_apt_package() {
    if ! hash apt-get >/dev/null 2>&1; then
        echo "${RED}Error: apt-get is not installed${NORMAL}"
        return 1
    fi

    sudo apt-get upgrade -y ${1} >/dev/null
}

sync_arch_package() {
    if ! hash pacman >/dev/null 2>&1; then
        echo "${RED}Error: pacman is not installed${NORMAL}"
        return 1
    fi

    sudo pacman -U --noconfirm ${1} >/dev/null
}

# Clean all configurations
clean_dotfiles() {
    confs="
    .gemrc
    .gitconfig
    .markdownlint.json
    .npmrc
    .tmux.conf
    .vimrc
    .zshenv
    .zshrc
    .zshrc.local
    "
    for c in ${confs}; do
        [ -f $HOME/${c} ] && mv $HOME/${c} $HOME/${c}.bak
    done

    [ -d $EMACSD ] && mv $EMACSD $EMACSD.bak

    rm -rf $ZSH $TMUX $FZF $DOTFILES

    rm -f $HOME/.fzf.*
    rm -f $HOME/.gitignore_global $HOME/.gitconfig_global
    rm -f $HOME/.tmux.conf $HOME/.tmux.local
}

YES=0
NO=1
promote_yn() {
    eval ${2}=$NO
    read -p "$1 [y/N]: " yn
    case $yn in
        [Yy]* )    eval ${2}=$YES;;
        [Nn]*|'' ) eval ${2}=$NO;;
        *)         eval ${2}=$NO;;
    esac
}

# Reset configurations
if [ -d $ZSH ] || [ -d $TMUX ] || [ -d ~$FZF ] || [ -d $EMACSD ]; then
    promote_yn "Do you want to reset all configurations?" "continue"
    if [ $continue -eq $YES ]; then
        clean_dotfiles
    fi
fi

# Brew
if [ "$SYSTEM" = "Darwin" ]; then
    printf "${BLUE} ➜  Installing Homebrew...${NORMAL}\n"
    if ! hash brew >/dev/null 2>&1; then
        # Install homebrew
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

        # Tap cask and cask-upgrade
        brew tap homebrew/cask
        brew tap homebrew/cask-fonts
        brew tap buo/cask-upgrade
        # else
        # Set homebrew mirrors
        # HOMEBREW_URL=https://mirrors.ustc.edu.cn

        # cd "$(brew --repo)"
        # git remote set-url origin $HOMEBREW_URL/brew.git
        # cd - >/dev/null

        # cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
        # git remote set-url origin $HOMEBREW_URL/homebrew-core.git
        # cd - >/dev/null

        # cd "$(brew --repo)/Library/Taps/homebrew/homebrew-cask"
        # git remote set-url origin $HOMEBREW_URL/homebrew-cask.git
        # cd - >/dev/null

        # Upgrade
        # brew update && brew upgrade && brew cleanup
        # brew cu --all --yes --no-brew-update --cleanup
    fi
fi

# Apt-Cyg
if [ "$OSTYPE" = "cygwin" ]; then
    printf "${BLUE} ➜  Installing Apt-Cyg...${NORMAL}\n"
    if ! hash apt-cyg >/dev/null 2>&1; then
        APT_CYG=/usr/local/bin/apt-cyg
        curl -fsSL https://raw.githubusercontent.com/transcode-open/apt-cyg/master/apt-cyg > $APT_CYG
        chmod +x $APT_CYG
    fi
fi

# Antigen: the plugin manager for zsh
printf "${BLUE} ➜  Installing Antigen...${NORMAL}\n"
if [ "$SYSTEM" = "Darwin" ]; then
    sync_brew_package antigen
elif [ "$SYSTEM" = "Linux" ]; then
    sync_apt_package zsh-antigen
else
    mkdir -p $ZSH
    curl -fsSL git.io/antigen > $ZSH/antigen.zsh.tmp && mv $ZSH/antigen.zsh.tmp $ZSH/antigen.zsh
fi

# Dotfiles
printf "${BLUE} ➜  Installing Dotfiles...${NORMAL}\n"
sync_repo seagle0128/dotfiles $DOTFILES

chmod +x $DOTFILES/install.sh
chmod +x $DOTFILES/install_brew_cask.sh
chmod +x $DOTFILES/install_go.sh

ln -sf $DOTFILES/.zshenv $HOME/.zshenv
ln -sf $DOTFILES/.zshrc $HOME/.zshrc
ln -sf $DOTFILES/.vimrc $HOME/.vimrc
ln -sf $DOTFILES/.tmux.conf.local $HOME/.tmux.conf.local
ln -sf $DOTFILES/.markdownlint.json $HOME/.markdownlint.json

cp -n $DOTFILES/.npmrc $HOME/.npmrc
cp -n $DOTFILES/.gemrc $HOME/.gemrc
cp -n $DOTFILES/.zshrc.local $HOME/.zshrc.local
mkdir -p $HOME/.pip; cp -n $DOTFILES/.pip.conf $HOME/.pip/pip.conf

ln -sf $DOTFILES/.gitignore_global $HOME/.gitignore_global
ln -sf $DOTFILES/.gitconfig_global $HOME/.gitconfig_global
if [ "$SYSTEM" = "Darwin" ]; then
    cp -n $DOTFILES/.gitconfig_macOS $HOME/.gitconfig
elif [ "$OSTYPE" = "cygwin" ]; then
    cp -n $DOTFILES/.gitconfig_cygwin $HOME/.gitconfig
else
    cp -n $DOTFILES/.gitconfig_linux $HOME/.gitconfig
fi

if [ "$OSTYPE" = "cygwin" ]; then
    ln -sf $DOTFILES/.minttyrc $HOME/.minttyrc
fi

# Emacs Configs
printf "${BLUE} ➜  Installing Centaur Emacs...${NORMAL}\n"
sync_repo seagle0128/.emacs.d $EMACSD

# Oh My Tmux
printf "${BLUE} ➜  Installing Oh My Tmux...${NORMAL}\n"
sync_repo gpakosz/.tmux $TMUX
ln -sf $TMUX/.tmux.conf $HOME/.tmux.conf

# Search tools
printf "${BLUE} ➜  Installing Search tools...${NORMAL}\n"
if [ "$SYSTEM" = "Darwin" ]; then
    sync_brew_package ripgrep
elif [ "$SYSTEM" = "Linux" ] && ! hash rg >/dev/null 2>&1 && hash dpkg >/dev/null 2>&1; then
    curl -LO https://github.com/BurntSushi/ripgrep/releases/download/0.8.1/ripgrep_0.8.1_amd64.deb &&
        sudo dpkg -i ripgrep_0.8.1_amd64.deb
    rm ripgrep_0.8.1_amd64.deb
fi

# FZF
printf "${BLUE} ➜  Installing FZF...${NORMAL}\n"
if [ "$OSTYPE" = "cygwin" ]; then
    if ! hash fzf >/dev/null 2>&1 && hash apt-cyg >/dev/null 2>&1; then
        apt-cyg install fzf fzf-zsh fzf-zsh-completion
    fi
else
    if [ "$SYSTEM" = "Darwin" ]; then
        sync_brew_package fzf
        FZF=/usr/local/opt/fzf
    elif [ "$SYSTEM" = "Linux" ] && hash apt-get >/dev/null 2>&1; then
        sync_repo junegunn/fzf $FZF
    fi
    [ -f $FZF/install ] && $FZF/install --all --no-update-rc --no-bash --no-fish >/dev/null
fi

# Peco
if [ "$OSTYPE" != "cygwin" ]; then
    printf "${BLUE} ➜  Installing Peco...${NORMAL}\n"
    if [ "$SYSTEM" = "Darwin" ]; then
        sync_brew_package peco
    elif [ "$SYSTEM" = "Linux" ] && [ "`uname -m`" = "x86_64" ]; then
        # Only support Linux x64 binary
        PECO_UPDATE=1
        PECO_RELEASE_URL="https://github.com/peco/peco/releases"
        PECO_VERSION_PATTERN='v[[:digit:]]+\.[[:digit:]]+.[[:digit:]]*'

        PECO_RELEASE_TAG=$(curl -fs "${PECO_RELEASE_URL}/latest" | grep -oE $PECO_VERSION_PATTERN)

        if hash peco >/dev/null 2>&1; then
            PECO_UPDATE=0

            PECO_VERSION=$(peco --version | grep -oE $PECO_VERSION_PATTERN)
            if [ "$PECO_VERSION" != "$PECO_RELEASE_TAG" ]; then
                PECO_UPDATE=1
            fi
        fi

        if [ $PECO_UPDATE -eq 1 ]; then
            curl -fsSL ${PECO_RELEASE_URL}/download/${PECO_RELEASE_TAG}/peco_linux_amd64.tar.gz | tar xzf - &&
                chmod +x peco_linux_amd64/peco && sudo mv peco_linux_amd64/peco /usr/local/bin
            rm -rf peco_linux_amd64
        fi
    fi
fi

# Entering zsh
printf "Done. Enjoy!\n"
if hash zsh >/dev/null 2>&1; then
    if [ "$OSTYPE" != "cygwin" ] && [ "$SHELL" != "$(which zsh)" ]; then
        chsh -s $(which zsh)
        printf "${BLUE} You need to logout and login to enable zsh as the default shell.${NORMAL}\n"
    fi
    env zsh
else
    echo "${RED}Error: zsh is not installed${NORMAL}"
    exit 1
fi
