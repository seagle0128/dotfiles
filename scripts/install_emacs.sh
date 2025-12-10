#!/bin/bash
#############################################################
# Install latest stable Emacs
# Author: Vincent Zhang <seagle0128@gmail.com>
# URL: https://github.com/seagle0128/dotfiles
#############################################################

# Source common functions and variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

printf "${BLUE} ➜  Installing Emacs...${NORMAL}\n"
if [ "$OS" = "Linux" ] && command -v add-apt-repository >/dev/null 2>&1; then
    sudo add-apt-repository -y ppa:kelleyk/emacs
    # sudo add-apt-repository -y ppa:ubuntu-elisp/ppa
    sudo apt-get update
    sudo apt-get install -y emacs30
fi
