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
brew cask install cheatsheet
brew cask install clipy
brew cask install emacs
brew cask install fliqlo        # Screen Saver
# brew cask install hyperswitch
brew cask install iina          # Replace mplayerx
brew cask install iterm2
brew cask install keycastr      # Show keys on the screen
brew cask install licecap       # Recording screen as gif
brew cask install mounty          # Mounty for NTFS read/write
# brew cask install scroll-reverser # Alternative: MOS
brew cask install shadowsocksx-ng
brew cask install sound-siphon
brew cask install soundflower
brew cask install soundflowerbed
brew cask install spectacle
# brew cask install vanilla       # Hide menu bar icons, buggy

# brew cask install firefox
brew cask install google-chrome
# brew cask install karabiner-elements # karabiner: Keboard remapping
# brew cask install netspot       # Wifi signal analysis and scanner
brew cask install sourcetree
brew cask install osxfuse veracrypt
brew cask install visual-studio-code
brew cask install sogouinput

# Optional
# brew cask install acrobat-reader
brew cask install aliwangwang
brew cask install baidunetdisk
# brew cask install bwana
brew cask install java
# brew cask install neteasemusic
# brew cask install skype-for-business
brew cask install thunder

# Cleanup
brew cask cleanup
