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

    if [ ! -e "$repo_path" ]; then
        mkdir -p "$repo_path"
        git clone --depth 1 "https://github.com/$repo_uri.git" "$repo_path"
    else
        cd "$repo_path" && git pull --rebase --stat origin master; cd - >/dev/null
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

# Clean all configurations
clean_dotfiles() {
    confs="
    .gemrc
    .gitconfig
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
    rm -f $HOME/.gitignore_global $HOME/.gitconfig.local
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
        brew tap caskroom/cask
        brew tap buo/cask-upgrade
    else
        # Set homebrew mirrors
        BREW_URL=https://mirrors.ustc.edu.cn

        cd "$(brew --repo)"
        git remote set-url origin $BREW_URL/brew.git
        cd - >/dev/null

        cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
        git remote set-url origin $BREW_URL/homebrew-core.git
        cd - >/dev/null

        cd "$(brew --repo)/Library/Taps/caskroom/homebrew-cask"
        git remote set-url origin $BREW_URL/homebrew-cask.git
        cd - >/dev/null

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
mkdir -p $ZSH
curl -fsSL git.io/antigen > $ZSH/antigen.zsh.tmp
mv $ZSH/antigen.zsh.tmp $ZSH/antigen.zsh

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

cp -n $DOTFILES/.npmrc $HOME/.npmrc
cp -n $DOTFILES/.gemrc $HOME/.gemrc
cp -n $DOTFILES/.zshrc.local $HOME/.zshrc.local
mkdir -p $HOME/.pip; cp -n $DOTFILES/.pip.conf $HOME/.pip/pip.conf

ln -sf $DOTFILES/.gitconfig $HOME/.gitconfig
if [ "$SYSTEM" = "Darwin" ]; then
    cp -n $DOTFILES/.gitconfig_macOS_local $HOME/.gitconfig_local
elif [ "$OSTYPE" = "cygwin" ]; then
    cp -n $DOTFILES/.gitconfig_cygwin_local $HOME/.gitconfig_local
else
    cp -n $DOTFILES/.gitconfig_local $HOME/.gitconfig_local
fi
ln -sf $DOTFILES/.gitignore_global $HOME/.gitignore_global

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

# FZF
printf "${BLUE} ➜  Installing FZF...${NORMAL}\n"
if [ "$SYSTEM" = "Darwin" ]; then
    sync_brew_package fzf
    FZF=/usr/local/opt/fzf
elif [ "$OSTYPE" = "cygwin" ]; then
    if ! hash fzf >/dev/null 2>&1 && hash apt-cyg >/dev/null 2>&1; then
        apt-cyg install fzf fzf-zsh fzf-zsh-completion
    fi
else
    sync_repo junegunn/fzf $FZF
fi
[ -f $FZF/install ] && $FZF/install --all --no-update-rc --no-bash --no-fish >/dev/null

# Peco
if [ "$OSTYPE" != "cygwin" ]; then
    printf "${BLUE} ➜  Installing Peco...${NORMAL}\n"
    if [ "$SYSTEM" = "Darwin" ]; then
        sync_brew_package peco
    elif [ "$SYSTEM" = "Linux" ]; then
        # Only support Linux x64 binary
        if ! hash peco >/dev/null 2>&1 && [ "`uname -m`" = "x86_64" ]; then
            curl -fsSL https://github.com/peco/peco/releases/download/v0.5.2/peco_linux_amd64.tar.gz | tar xzf -
            chmod +x peco_linux_amd64/peco
            sudo mv peco_linux_amd64/peco /usr/local/bin
            rm -rf peco_linux_amd64
        fi
    fi
fi

# Powerline fonts
if [ "$OSTYPE" != "cygwin" ]; then
    printf "${BLUE} ➜  Installing Powerline fonts...${NORMAL}\n"

    if hash apt >/dev/null 2>&1; then
        apt-get install fonts-powerline
    else
        if [ "$SYSTEM" = "Darwin" ]; then
            font_dir="$HOME/Library/Fonts"
        else
            font_dir="$HOME/.local/share/fonts"
        fi

        if [ ! -f "${font_dir}/Hack-Regular.ttf" ]; then
            sync_repo powerline/fonts
            cd fonts
            ./install.sh
            cd ..
            rm -rf fonts
        fi
    fi
fi

# Entering zsh
printf "Done. Enjoy!\n"
if hash zsh >/dev/null 2>&1; then
    env zsh
fi
