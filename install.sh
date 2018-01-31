#!/bin/sh
#############################################################
# Set development environment on Linux/macOS/Cygwin quickly.
# Author: Vincent Zhang <seagle0128@gmail.com>
# URL: https://github.com/seagle0128/dotfiles
#############################################################

# Variables
DOTFILES=$HOME/.dotfiles
ZSH=$HOME/.antigen
TMUX=$HOME/.tmux

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

# Sync repository
sync_repo() {
    local repo_uri="$1"
    local repo_path="$2"

    if [ ! -e "$repo_path" ]; then
        mkdir -p "$repo_path"
        git clone "https://github.com/$repo_uri.git" "$repo_path"
    else
        cd "$repo_path" && git pull origin master >/dev/null 2>&1; cd - >/dev/null
    fi
}

# Clean all configurations
clean_dotfiles() {
    [ -f ~/.zshenv ] && mv ~/.zshenv ~/.zshenv.bak
    [ -f ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.bak
    [ -f ~/.zshrc.local ] && mv ~/.zshrc.local ~/.zshrc.local.bak
    [ -f ~/.vimrc ] && mv ~/.vimrc ~/.vimrc.bak
    [ -d ~/.emacs.d ] && mv ~/.emacs.d ~/.emacs.d.bak

    rm -rf $ZSH $TMUX ~/.fzf $DOTFILES
    rm -f ~/.tmux.conf ~/.tmux.local ~/.fzf.*
    rm -f ~/.gitconfig ~/.gitignore_global ~/.gitconfig.local
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

# Only enable exit-on-error after the non-critical colorization stuff,
# which may fail on systems lacking tput or terminfo
# set -e

# Check git
hash git >/dev/null 2>&1 || {
    echo "Error: git is not installed"
    exit 1
}

# Reset configurations
if [ -d $ZSH ] || [ -d $TMUX ] || [ -d ~/.fzf ] || [ -d ~/.emacs.d ]; then
    promote_yn "Do you want to reset all configurations?" "continue"
    if [ $continue -eq $YES ]; then
        clean_dotfiles
    fi
fi

# Brew
if [[ $OSTYPE == darwin* ]]; then
    printf "${BLUE}Installing Homebrew...${NORMAL}\n"
    if ! hash brew 2>/dev/null; then
        # Install homebrew
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

        # Tap cask and cask-upgrade
        brew tap caskroom/cask
        brew tap buo/cask-upgrade
    else
        # Set homebrew mirrors
        cd "$(brew --repo)"
        git remote set-url origin https://mirrors.ustc.edu.cn/brew.git
        cd - >/dev/null

        cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
        git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git
        cd - >/dev/null

        cd "$(brew --repo)"/Library/Taps/caskroom/homebrew-cask
        git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-cask.git
        cd - >/dev/null

        # Upgrade
        # brew update && brew upgrade && brew cleanup
        # brew cu --all --yes --no-brew-update --cleanup
    fi
fi

# Apt-Cyg
if [[ $OSTYPE == cygwin* ]]; then
    printf "${BLUE}Installing Apt-Cyg...${NORMAL}\n"
    if ! hash apt-cyg 2>/dev/null; then
        APT_CYG=/usr/local/bin/apt-cyg
        curl -fsSL https://raw.githubusercontent.com/transcode-open/apt-cyg/master/apt-cyg > $APT_CYG
        chmod +x $APT_CYG
    fi
fi

# Antigen: the plugin manager for zsh
printf "${BLUE}Installing Antigen...${NORMAL}\n"
if [ ! -e $ZSH ]; then mkdir -p $ZSH; fi
curl -fsSL git.io/antigen > ~/.antigen/antigen.zsh

# Dotfiles
printf "${BLUE}Installing Dotfiles...${NORMAL}\n"
sync_repo seagle0128/dotfiles $DOTFILES

ln -s -f $DOTFILES/.zshenv ~/.zshenv
ln -s -f $DOTFILES/.zshrc ~/.zshrc
ln -s -f $DOTFILES/.vimrc ~/.vimrc
ln -s -f $DOTFILES/.npmrc ~/.npmrc
ln -s -f $DOTFILES/.gemrc ~/.gemrc
ln -s -f $DOTFILES/.tmux.conf.local ~/.tmux.conf.local

cp -n $DOTFILES/.zshrc.local ~/.zshrc.local

[ ! -d ~/.pip ] && mkdir ~/.pip; ln -s -f $DOTFILES/.pip.conf ~/.pip/pip.conf

ln -s -f $DOTFILES/.gitconfig ~/.gitconfig
if [[ $OSTYPE == darwin* ]]; then
    cp -n $DOTFILES/.gitconfig_macOS_local ~/.gitconfig_local
elif [[ $OSTYPE == cygwin* ]]; then
    cp -n $DOTFILES/.gitconfig_cygwin_local ~/.gitconfig_local
else
    cp -n $DOTFILES/.gitconfig_local ~/.gitconfig_local
fi
ln -s -f $DOTFILES/.gitignore_global ~/.gitignore_global

if [[ $OSTYPE == cygwin* ]]; then
    ln -s -f $DOTFILES/.minttyrc ~/.minttyrc
fi

# Emacs
printf "${BLUE}Installing Emacs Configurations...${NORMAL}\n"
sync_repo seagle0128/.emacs.d ~/.emacs.d

# Oh My Tmux
printf "${BLUE}Installing Oh My Tmux...${NORMAL}\n"
sync_repo gpakosz/.tmux $TMUX
ln -s -f $TMUX/.tmux.conf ~/.tmux.conf
# cp $TMUX/.tmux.conf.local ~/.tmux.conf.local

# FZF
printf "${BLUE}Installing FZF...${NORMAL}\n"
if [[ $OSTYPE == darwin* ]]; then
    if hash brew 2>/dev/null && not hash fzf 2>/dev/null; then
        brew install fzf
    fi
    fZF_INSTALL=/usr/local/opt/fzf/install
elif [[ $OSTYPE == cygwin* ]]; then
    if hash apt-cyg 2>/dev/null && not hash fzf 2>/dev/null; then
        apt-cyg install fzf fzf-zsh fzf-zsh-completion
    fi
    FZF_INSTALL=~/.fzf/install
else
    if [ ! -e ~/.fzf ]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    else
        cd ~/.fzf && git pull && cd - >/dev/null
    fi
    FZF_INSTALL=~/.fzf/install
fi
[ -f $FZF_INSTALL ] && $FZF_INSTALL --all --no-update-rc --no-bash --no-fish >/dev/null 2>&1

# Peco
if [[ $OSTYPE != cygwin* ]]; then
    printf "${BLUE}Installing Peco...${NORMAL}\n"
    if [[ $OSTYPE == darwin* ]]; then
        if hash brew 2>/dev/null && ! hash peco 2>/dev/null; then
            brew install peco
        fi
    else
        printf "${GREEN}Please download from https://github.com/peco/peco/releases. $(NORMAL}\n)"
    fi
fi

# Entering zsh
printf "${BLUE}Done. Enjoy!${NORMAL}\n"
if hash zsh 2> /dev/null; then
    env zsh
fi
