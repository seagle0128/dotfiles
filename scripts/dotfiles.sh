#!/bin/sh

# Dotfiles setup module

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

setup_dotfiles() {
    printf "${GREEN}▓▒░ Installing Dotfiles...${NORMAL}\n"
    sync_repo seagle0128/dotfiles $DOTFILES

    # Create symlinks for configuration files
    ln -sf $DOTFILES/shell/.zshenv $HOME/.zshenv
    ln -sf $DOTFILES/shell/.zshrc $HOME/.zshrc
    ln -sf $DOTFILES/Brewfile $HOME/.Brewfile
    ln -sf $DOTFILES/config/.vimrc $HOME/.vimrc
    ln -sf $DOTFILES/config/.tmux.conf.local $HOME/.tmux.conf.local
    ln -sf $DOTFILES/config/.markdownlintrc $HOME/.markdownlintrc
    ln -sf $DOTFILES/config/starship.toml $HOME/.config/starship.toml
    mkdir -p $HOME/.config/ghostty && ln -sf $DOTFILES/config/ghostty.config $HOME/.config/ghostty/config

    # Copy files that should be customized locally
    cp -n $DOTFILES/config/.npmrc $HOME/.npmrc
    cp -n $DOTFILES/config/.gemrc $HOME/.gemrc
    mkdir -p $HOME/.cargo && cp -n $DOTFILES/config/cargo.toml $HOME/.cargo/config.toml
    cp -n $DOTFILES/shell/.zshrc.local $HOME/.zshrc.local
    mkdir -p $HOME/.pip; cp -n $DOTFILES/config/.pip.conf $HOME/.pip/pip.conf

    # Git configuration
    ln -sf $DOTFILES/config/.gitignore_global $HOME/.gitignore_global
    ln -sf $DOTFILES/config/.gitconfig_global $HOME/.gitconfig_global
    if is_mac; then
        cp -n $DOTFILES/config/.gitconfig_macOS $HOME/.gitconfig
    else
        cp -n $DOTFILES/config/.gitconfig_linux $HOME/.gitconfig
    fi
}

setup_emacs() {
    printf "${GREEN}▓▒░ Installing Centaur Emacs...${NORMAL}\n"
    sync_repo seagle0128/.emacs.d $EMACSD
}

setup_tmux() {
    printf "${GREEN}▓▒░ Installing Oh My Tmux...${NORMAL}\n"
    sync_repo gpakosz/.tmux $TMUX
    ln -sf $TMUX/.tmux.conf $HOME/.tmux.conf
}

generate_locale() {
    if is_linux; then
        locale -a | grep en_US.utf8 > /dev/null || localedef -v -c -i en_US -f UTF-8 en_US.UTF-8
    fi
}
