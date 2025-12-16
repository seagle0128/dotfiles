#!/bin/sh
#############################################################
# Set development environment on Linux/macOS quickly.
# Author: Vincent Zhang <seagle0128@gmail.com>
# URL: https://github.com/seagle0128/dotfiles
#############################################################

# Source common functions and variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

clean_dotfiles() {
    confs="
    .gemrc
    .gitconfig
    .markdownlintrc
    .npmrc
    .tmux.conf
    .vimrc
    .zshenv
    .zshrc
    .zshrc.local
    .Brewfile
    "
    for c in ${confs}; do
        [ -f $HOME/${c} ] && mv $HOME/${c} $HOME/${c}.bak
    done

    if [ -f $HOME/.config/starship.toml ]; then
        mv $HOME/.config/starship.toml $HOME/.config/starship.toml.bak
    fi

    [ -d $EMACSD ] && mv $EMACSD $EMACSD.bak

    rm -rf $ZSH $TMUX $DOTFILES
    rm -rf $HOME/.pip

    rm -f $HOME/.gitignore_global
    rm -f $HOME/.tmux.conf
}

# Source modules
source "$SCRIPT_DIR/packages.sh"
source "$SCRIPT_DIR/dotfiles.sh"

# Clean or not?
if [ -d "$ZSH" ] || [ -d "$TMUX" ] || [ -d "$EMACSD" ]; then
    promote_yn "${YELLOW}Do you want to reset all configurations?${NORMAL}" "continue"
    if [ "$continue" -eq "$YES" ]; then
        clean_dotfiles
    fi
fi

# Generate locale
generate_locale

# Install package managers
install_homebrew

# Install core packages
install_core_packages

# Install ZSH plugin manager
install_zinit

# Setup dotfiles
setup_dotfiles

# Setup Emacs
setup_emacs

# Setup Tmux
setup_tmux

# Install additional packages
install_packages

# Entering zsh
printf "${GREEN}▓▒░ Done. Enjoy!${NORMAL}\n"
if command -v zsh >/dev/null 2>&1; then
    if [ "$SHELL" != "$(which zsh)" ]; then
        chsh -s "$(which zsh)"
        printf "${GREEN} You need to logout and login to enable zsh as the default shell.${NORMAL}\n"
    fi
    env zsh
else
    echo "${RED}Error: zsh is not installed${NORMAL}" >&2
    exit 1
fi
