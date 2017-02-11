#!/bin/sh
# Get dotfiles and set intial configurations

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# oh-my-tmux
git clone https://github.com/gpakosz/.tmux.git ~/.tmux
ln -s -f ~/.tmux/.tmux.conf ~/.tmux.conf
# cp ~/.tmux/.tmux.conf.local ~/

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Emacs
git clone https://github.com/seagle0128/.emacs.d.git ~/.emacs.d

# dotfiles
git clone https://github.com/seagle0128/dotfiles.git ~/.dotfiles
ln -s -f ~/.dotfiles/.zshrc ~/.zshrc
ln -s -f ~/.dotfiles/.tmux.conf.local ~/.tmux.conf.local
ln -s -f ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s -f ~/.dotfiles/.gitignore_global ~/.gitignore_global
ln -s -f ~/.dotfiles/.hgignore_global ~/.hgignore_global
