#!/bin/sh
# Get dotfiles and set intial configurations

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

# Clean all configurations
clean_dotfiles() {
    rm -rf ~/.oh-my-zsh ~/.tmux ~/.fzf ~/.emacs.d ~/.dotfiles
    rm -f ~/.zshrc ~/.tmux.conf ~/.tmux.local ~/.fzf.*
    rm -f ~/.gitconfig ~/.gitignore_global ~/.hgignore_global
}

YES=0
NO=1
promote_yn() {
    eval ${2}=$NO
    read -p "$1 [Yn]: " yn
    case $yn in
        [Yy]*|'' ) eval ${2}=$YES;;
        [Nn]* )    eval ${2}=$NO;;
        *)         eval ${2}=$NO;;
    esac
}

if [ -d ~/.oh-my-zsh ] || [ -d ~/.tmux ] || [ -d ~/.fzf ] || [ -d ~/.emacs.d ]; then
    promote_yn "Do you want to clean all configurations?" "continue"
    if [ $continue -eq $YES ]; then
        clean_dotfiles
    fi
fi

# Brew
if [ $sysOS == "Darwin" ] && not hash brew 2>/dev/null; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Oh My Zsh
printf "${BLUE}Installing Oh My Zsh...${NORMAL}\n"
printf "${BLUE}You need to input password to change the default shell to zsh.${NORMAL}\n"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sed 's/env zsh/ /g')" > /dev/null
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/djui/alias-tips.git ${ZSH_CUSTOM1:-$ZSH/custom}/plugins/alias-tips

# Oh My Tmux
printf "${BLUE}Installing Oh My Tmux...${NORMAL}\n"
git clone https://github.com/gpakosz/.tmux.git ~/.tmux
ln -s -f ~/.tmux/.tmux.conf ~/.tmux.conf
# cp ~/.tmux/.tmux.conf.local ~/.tmux.conf.local

# FZF
printf "${BLUE}Installing FZF...${NORMAL}\n"
if [ $sysOS == "Darwin" ]; then
    if hash brew 2>/dev/null && not hash fzf 2>/dev/null; then
        brew install fzf
    fi
    fzf_install=/usr/local/opt/fzf/install
else
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    fzf_install=~/.fzf/install
fi
[ -f $fzf_install ] && $fzf_install --all

# Emacs
printf "${BLUE}Installing Emacs Configurations...${NORMAL}\n"
git clone https://github.com/seagle0128/.emacs.d.git ~/.emacs.d

# Dotfiles
printf "${BLUE}Installing dotfiles...${NORMAL}\n"
git clone https://github.com/seagle0128/dotfiles.git ~/.dotfiles
ln -s -f ~/.dotfiles/.zshrc ~/.zshrc
ln -s -f ~/.dotfiles/.tmux.conf.local ~/.tmux.conf.local
ln -s -f ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s -f ~/.dotfiles/.gitignore_global ~/.gitignore_global
ln -s -f ~/.dotfiles/.hgignore_global ~/.hgignore_global

# Entering zsh
printf "${BLUE}Done. Enjoy!${NORMAL}\n"
env zsh
