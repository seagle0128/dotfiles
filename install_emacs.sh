#!/bin/bash
#############################################################
# Install latest stable Emacs
# Author: Vincent Zhang <seagle0128@gmail.com>
# URL: https://github.com/seagle0128/dotfiles
#############################################################

# Get OS name
SYSTEM=`uname -s`

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

printf "${BLUE} ➜  Installing Emacs...${NORMAL}\n"
if [ "$SYSTEM" = "Darwin" ] && command -v brew >/dev/null 2>&1; then
    brew tap d12frosted/emacs-plus
    brew install emacs-plus@30 --with-xwidgets --with-c9rgreen-sonoma-icon
    # brew cask install emacs
elif [ "$SYSTEM" = "Linux" ] && command -v add-apt-repository >/dev/null 2>&1; then
    sudo add-apt-repository -y ppa:kelleyk/emacs
    # sudo add-apt-repository -y ppa:ubuntu-elisp/ppa
    sudo apt-get update
    sudo apt-get install -y emacs26
fi
