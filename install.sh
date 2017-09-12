#!/bin/sh
#############################################################
# Set development environment on Linux/macOS/Cygwin quickly.
# Author: Vincent Zhang <seagle0128@gmail.com>
# URL: https://github.com/seagle0128/dotfiles
#############################################################

# Get OS name
sysOS=`uname -s`

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

# Only enable exit-on-error after the non-critical colorization stuff,
# which may fail on systems lacking tput or terminfo
# set -e

# Check git
hash git >/dev/null 2>&1 || {
    echo "Error: git is not installed"
    exit 1
}

# Sync repository
sync_repo() {
    local repo_uri="$1"
    local repo_path="$2"

    if [ ! -e "$repo_path" ]; then
        mkdir -p "$repo_path"
        git clone "$repo_uri" "$repo_path"
    else
        cd "$repo_path" && git pull origin master && cd - >/dev/null
    fi
}

# Clean all configurations
clean_dotfiles() {
    [ -f ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.bak
    [ -f ~/.vimrc ] && mv ~/.vimrc ~/.vimrc.bak
    [ -d ~/.emacs.d ] && mv ~/.emacs.d ~/.emacs.d.bak

    rm -rf ~/.oh-my-zsh ~/.tmux ~/.fzf ~/.dotfiles
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

if [ -d ~/.oh-my-zsh ] || [ -d ~/.tmux ] || [ -d ~/.fzf ] || [ -d ~/.emacs.d ]; then
    promote_yn "Do you want to reset all configurations?" "continue"
    if [ $continue -eq $YES ]; then
        clean_dotfiles
    fi
fi

# Brew
if [ "$sysOS" = "Darwin" ]; then
    if not hash brew 2>/dev/null; then
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
        brew update && brew upgrade && brew cleanup
        brew cu --all --yes --no-brew-update --cleanup
    fi
fi

# Oh My Zsh
printf "${BLUE}Installing Oh My Zsh...${NORMAL}\n"
printf "${BLUE}You need to input password to change the default shell to zsh.${NORMAL}\n"
if [ ! -e ~/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sed 's/env zsh/ /g')" > /dev/null
else
    cd ~/.oh-my-zsh && git pull origin master && cd - >/dev/null
fi

sync_repo https://github.com/djui/alias-tips.git ~/.oh-my-zsh/custom/plugins/alias-tips
sync_repo https://github.com/supercrabtree/k ~/.oh-my-zsh/custom/plugins/k
sync_repo https://github.com/chrissicool/zsh-256color ~/.oh-my-zsh/custom/plugins/zsh-256color
sync_repo https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
sync_repo https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
sync_repo https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions

# Oh My Tmux
printf "${BLUE}Installing Oh My Tmux...${NORMAL}\n"
sync_repo https://github.com/gpakosz/.tmux.git ~/.tmux
ln -s -f ~/.tmux/.tmux.conf ~/.tmux.conf
# cp ~/.tmux/.tmux.conf.local ~/.tmux.conf.local

# FZF
printf "${BLUE}Installing FZF...${NORMAL}\n"
if [ "$sysOS" = "Darwin" ]; then
    if hash brew 2>/dev/null && not hash fzf 2>/dev/null; then
        brew install fzf
    fi
    fzf_install=/usr/local/opt/fzf/install
else
    if [ ! -e ~/.fzf ]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    else
        cd ~/.fzf && git pull && cd - >/dev/null
    fi
    fzf_install=~/.fzf/install
fi
[ -f $fzf_install ] && $fzf_install --all >/dev/null 2>&1

# Emacs
printf "${BLUE}Installing Emacs Configurations...${NORMAL}\n"
sync_repo https://github.com/seagle0128/.emacs.d.git ~/.emacs.d

# Dotfiles
printf "${BLUE}Installing dotfiles...${NORMAL}\n"
sync_repo https://github.com/seagle0128/dotfiles.git ~/.dotfiles

ln -s -f ~/.dotfiles/.zshrc ~/.zshrc
ln -s -f ~/.dotfiles/.vimrc ~/.vimrc
ln -s -f ~/.dotfiles/.npmrc ~/.npmrc
ln -s -f ~/.dotfiles/.gemrc ~/.gemrc
ln -s -f ~/.dotfiles/.tmux.conf.local ~/.tmux.conf.local

cp -n ~/.dotfiles/.zshrc.theme.local ~/.zshrc.theme.local

[ ! -d ~/.pip ] && mkdir ~/.pip; ln -s -f ~/.dotfiles/.pip.conf ~/.pip/pip.conf

ln -s -f ~/.dotfiles/.gitconfig ~/.gitconfig
if [ "$sysOS" = "Darwin" ]; then
    cp -n ~/.dotfiles/.gitconfig_macOS_local ~/.gitconfig_local
else
    cp -n ~/.dotfiles/.gitconfig_local ~/.gitconfig_local
fi
ln -s -f ~/.dotfiles/.gitignore_global ~/.gitignore_global

if [ "$OSTYPE" = "cygwin" ]; then
    ln -s -f ~/.dotfiles/.minttyrc ~/.minttyrc
fi

if [ ! -f ~/.zshrc.local ]; then
    touch ~/.zshrc.local
    echo "# Please add your personal configurations here" > ~/.zshrc.local
fi

# Entering zsh
printf "${BLUE}Done. Enjoy!${NORMAL}\n"
if hash zsh 2> /dev/null; then
    env zsh
fi
