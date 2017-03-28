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
fi

# Cask
brew cask install aliwangwang
brew cask install baidunetdisk
brew cask install bwana
brew cask install cheatsheet
brew cask install clipy
brew cask install firefox
brew cask install google-chrome
brew cask install hyperswitch
brew cask install iterm2
brew cask install java
brew cask install mplayerx
brew cask install scroll-reverser
brew cask install shiftit
brew cask install skype-for-business
brew cask install sogouinput
brew cask install sourcetree
brew cask install thunder
brew cask install veracrypt
brew cask install visual-studio-code
