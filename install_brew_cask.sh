#!/bin/sh
#############################################################
# Install macOS via brew cask
# Author: Vincent Zhang <seagle0128@gmail.com>
# URL: https://github.com/seagle0128/dotfiles
#############################################################

# Check OS
sysOS=`uname -s`
if [ "$sysOS" != "Darwin" ] ; then
    echo "Error: only install software via brew_cask on macOS."
    exit 1
fi

# Brew
if not hash brew 2>/dev/null; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    brew tap caskroom/cask
    cd "$(brew --repo)"/Library/Taps/caskroom/homebrew-cask
    git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-cask.git
fi

# Cask
brew cask install iterm2
brew cask install emacs
brew cask install clipy
brew cask install cheatsheet
brew cask install hyperswitch
brew cask install scroll-reverser # Replaced by Mos
brew cask install shadowsocksx-ng
brew cask install fliqlo        # Screen Saver
# brew cask install shiftit       # Replaced by spectacle
brew cask install spectacle
# brew cask install sogouinput
brew cask install vanilla       # Hide menu bar icons

brew cask install google-chrome
brew cask install firefox
# brew cask install karabiner-elements # karabiner: Keboard remapping
brew cask install iina
# brew cask install mplayerx
brew cask install osx-fuse
brew cask install veracrypt
brew cask install soundflower   # Need soundflowerbed
brew cask install sourcetree
brew cask install visual-studio-code

brew cask install aliwangwang
brew cask install thunder
brew cask install baidunetdisk
brew cask install bwana
# brew cask install skype-for-business
brew cask install java

# Cleanup
brew cask cleanup
