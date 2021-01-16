#!/bin/sh
#############################################################
# Set development environment on Linux/macOS/Cygwin quickly.
# Author: Vincent Zhang <seagle0128@gmail.com>
# URL: https://github.com/seagle0128/dotfiles
#############################################################

# Variables
DOTFILES=$HOME/.dotfiles
EMACSD=$HOME/.emacs.d
FZF=$HOME/.fzf
TMUX=$HOME/.tmux
ZSH=$HOME/.zinit

# Get OS informatio
OS=`uname -s`
OSREV=`uname -r`
OSARCH=`uname -m`

# Only enable exit-on-error after the non-critical colorization stuff,
# which may fail on systems lacking tput or terminfo
# set -e

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

# Check git
command -v git >/dev/null 2>&1 || {
    echo "${RED}Error: git is not installed${NORMAL}" >&2
    exit 1
}

# Check curl
command -v curl >/dev/null 2>&1 || {
    echo "${RED}Error: curl is not installed${NORMAL}" >&2
    exit 1
}

# Sync repository
sync_repo() {
    local repo_uri="$1"
    local repo_path="$2"
    local repo_branch="$3"

    if [ -z "$repo_branch" ]; then
        repo_branch="master"
    fi

    if [ ! -e "$repo_path" ]; then
        mkdir -p "$repo_path"
        git clone --depth 1 --branch $repo_branch "https://github.com/$repo_uri.git" "$repo_path"
    else
        cd "$repo_path" && git pull --rebase --stat origin $repo_branch; cd - >/dev/null
    fi
}

is_mac()
{
    [ "$OS" = "Darwin" ]
}

is_cygwin()
{
    [ "$OSTYPE" = "cygwin" ]
}

is_linux()
{
    [ "$OS" = "Linux" ]
}

is_debian() {
    command -v apt-get >/dev/null 2>&1
}

is_arch() {
    command -v yay >/dev/null 2>&1 || command -v pacman >/dev/null 2>&1
}

sync_brew_package() {
    if ! command -v brew >/dev/null 2>&1; then
        echo "${RED}Error: brew is not found${NORMAL}" >&2
        return 1
    fi

    if ! command -v ${1} >/dev/null 2>&1; then
        brew install ${1} >/dev/null
    else
        brew upgrade ${1} >/dev/null
    fi
}

sync_apt_package() {
    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get upgrade -y ${1} >/dev/null
    else
        echo "${RED}Error: apt and apt-get are not found${NORMAL}" >&2
        return 1
    fi
}

sync_arch_package() {
    if command -v yay >/dev/null 2>&1; then
        yay -Ssu --noconfirm ${1} >/dev/null
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -Ssu --noconfirm ${1} >/dev/null
    else
        echo "${RED}Error: pacman and yay are not found${NORMAL}" >&2
        return 1
    fi
}

# Clean all configurations
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
    "
    for c in ${confs}; do
        [ -f $HOME/${c} ] && mv $HOME/${c} $HOME/${c}.bak
    done

    [ -d $EMACSD ] && mv $EMACSD $EMACSD.bak

    rm -rf $ZSH $TMUX $FZF $DOTFILES

    rm -f $HOME/.fzf.*
    rm -f $HOME/.gitignore_global $HOME/.gitconfig_global
    rm -f $HOME/.tmux.conf $HOME/.tmux.local
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

# Reset configurations
if [ -d $ZSH ] || [ -d $TMUX ] || [ -d ~$FZF ] || [ -d $EMACSD ]; then
    promote_yn "Do you want to reset all configurations?" "continue"
    if [ $continue -eq $YES ]; then
        clean_dotfiles
    fi
fi

# Brew
if is_mac; then
    printf "${BLUE} ➜  Installing Homebrew...${NORMAL}\n"
    if ! command -v brew >/dev/null 2>&1; then
        # Install homebrew
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Tap cask and cask-upgrade
        brew tap homebrew/cask
        brew tap homebrew/cask-fonts
        brew tap buo/cask-upgrade
    fi
fi

# Apt-Cyg
if is_cygwin; then
    printf "${BLUE}▓▒░ Installing Apt-Cyg...${NORMAL}\n"
    if ! command -v apt-cyg >/dev/null 2>&1; then
        APT_CYG=/usr/local/bin/apt-cyg
        curl -fsSL https://raw.githubusercontent.com/transcode-open/apt-cyg/master/apt-cyg > $APT_CYG
        chmod +x $APT_CYG
    fi
fi

# Zsh plugin manager
printf "${BLUE}▓▒░ Installing Zinit...${NORMAL}\n"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"

# Dotfiles
printf "${BLUE} ➜  Installing Dotfiles...${NORMAL}\n"
sync_repo seagle0128/dotfiles $DOTFILES

chmod +x $DOTFILES/install.sh
chmod +x $DOTFILES/install_brew_cask.sh
chmod +x $DOTFILES/install_go.sh

ln -sf $DOTFILES/.zshenv $HOME/.zshenv
ln -sf $DOTFILES/.zshrc $HOME/.zshrc
ln -sf $DOTFILES/.vimrc $HOME/.vimrc
ln -sf $DOTFILES/.tmux.conf.local $HOME/.tmux.conf.local
ln -sf $DOTFILES/.markdownlintrc $HOME/.markdownlintrc

cp -n $DOTFILES/.npmrc $HOME/.npmrc
cp -n $DOTFILES/.gemrc $HOME/.gemrc
mkdir -p $HOME/.cargo && cp -n $DOTFILES/cargo.config $HOME/.cargo/config
cp -n $DOTFILES/.zshrc.local $HOME/.zshrc.local
mkdir -p $HOME/.pip; cp -n $DOTFILES/.pip.conf $HOME/.pip/pip.conf

ln -sf $DOTFILES/.gitignore_global $HOME/.gitignore_global
ln -sf $DOTFILES/.gitconfig_global $HOME/.gitconfig_global
if is_mac; then
    cp -n $DOTFILES/.gitconfig_macOS $HOME/.gitconfig
elif is_cygwin; then
    cp -n $DOTFILES/.gitconfig_cygwin $HOME/.gitconfig
else
    cp -n $DOTFILES/.gitconfig_linux $HOME/.gitconfig
fi

if is_cygwin; then
    ln -sf $DOTFILES/.minttyrc $HOME/.minttyrc
fi

# Emacs Configs
printf "${BLUE} ➜  Installing Centaur Emacs...${NORMAL}\n"
sync_repo seagle0128/.emacs.d $EMACSD

# Oh My Tmux
printf "${BLUE} ➜  Installing Oh My Tmux...${NORMAL}\n"
sync_repo gpakosz/.tmux $TMUX
ln -sf $TMUX/.tmux.conf $HOME/.tmux.conf

# Ripgrep
printf "${BLUE} ➜  Installing ripgrep (rg)...${NORMAL}\n"
if is_mac; then
    sync_brew_package ripgrep
elif is_linux; then
    if is_arch; then
        sync_arch_package ripgrep
    elif is_debian; then
        # FIXME: @See https://github.com/BurntSushi/ripgrep/issues/1562
        # sync_apt_package ripgrep
        apt-get download ripgrep && sudo dpkg --force-overwrite -i ripgrep*.deb && rm -f ripgrep*.deb
    elif [ "$OSARCH" = "x86_64" ]; then
        # Only support Linux x64 binary
        RG_UPDATE=1
        RG_RELEASE_URL="https://github.com/BurntSushi/ripgrep/releases"
        RG_VERSION_PATTERN='[[:digit:]]+\.[[:digit:]]+.[[:digit:]]*'

        RG_RELEASE_TAG=$(curl -fs "${RG_RELEASE_URL}/latest" | grep -oE $RG_VERSION_PATTERN)

        if command -v rg >/dev/null 2>&1; then
            RG_UPDATE=0

            RG_VERSION=$(rg --version | grep -oE $RG_VERSION_PATTERN)
            if [ "$RG_VERSION" != "$RG_RELEASE_TAG" ]; then
                RG_UPDATE=1
            fi
        fi

        if [ $RG_UPDATE -eq 1 ]; then
            RG_PACKAGE=ripgrep_${RG_RELEASE_TAG}_amd64.deb
            curl -LO ${RG_RELEASE_URL}/download/${RG_RELEASE_TAG}/${RG_PACKAGE} &&
                sudo dpkg -i ${RG_PACKAGE}
            rm -f ${RG_PACKAGE}
        fi
    fi
fi

# BAT
printf "${BLUE} ➜  Installing BAT...${NORMAL}\n"
if is_mac; then
    sync_brew_package bat
elif is_linux; then

    if is_arch; then
        sync_arch_package bat
    elif is_debian; then
        sync_apt_package bat
    elif [ "$OSARCH" = "x86_64" ]; then
        # Only support Linux x64 binary
        BAT_UPDATE=1
        BAT_RELEASE_URL="https://github.com/sharkdp/bat/releases"
        BAT_VERSION_PATTERN='[[:digit:]]+\.[[:digit:]]+.[[:digit:]]*'

        BAT_RELEASE_TAG=$(curl -fs "${BAT_RELEASE_URL}/latest" | grep -oE $BAT_VERSION_PATTERN)

        if command -v fd >/dev/null 2>&1; then
            BAT_UPDATE=0

            BAT_VERSION=$(fd --version | grep -oE $BAT_VERSION_PATTERN)
            if [ "$BAT_VERSION" != "$BAT_RELEASE_TAG" ]; then
                BAT_UPDATE=1
            fi
        fi

        if [ $BAT_UPDATE -eq 1 ]; then
            BAT_NAME=bat-v${BAT_RELEASE_TAG}-x86_64-unknown-linux-gnu
            BAT_PACKAGE=${BAT_NAME}.tar.gz

            curl -LO ${BAT_RELEASE_URL}/download/v${BAT_RELEASE_TAG}/${BAT_PACKAGE} &&
                tar zxvf $BAT_PACKAGE >/dev/null 2>&1 &&
                sudo cp ${BAT_NAME}/bat /usr/local/bin/bat &&
                sudo cp ${BAT_NAME}/bat.1 /usr/local/bin/bat.1 &&
                sudo chmod +x /usr/local/bin/bat

            rm -f ${BAT_PACKAGE}
            rm -rf ${BAT_NAME}
        fi
    fi
fi

# FD
printf "${BLUE} ➜  Installing FD...${NORMAL}\n"
if is_mac; then
    sync_brew_package fd
elif is_linux; then
    if is_arch; then
        sync_arch_package fd
    elif is_debian; then
        sync_apt_package fd-find
    elif [ "$OSARCH" = "x86_64" ]; then
        # Only support Linux x64 binary
        FD_UPDATE=1
        FD_RELEASE_URL="https://github.com/sharkdp/fd/releases"
        FD_VERSION_PATTERN='[[:digit:]]+\.[[:digit:]]+.[[:digit:]]*'

        FD_RELEASE_TAG=$(curl -fs "${FD_RELEASE_URL}/latest" | grep -oE $FD_VERSION_PATTERN)

        if command -v fd >/dev/null 2>&1; then
            FD_UPDATE=0

            FD_VERSION=$(fd --version | grep -oE $FD_VERSION_PATTERN)
            if [ "$FD_VERSION" != "$FD_RELEASE_TAG" ]; then
                FD_UPDATE=1
            fi
        fi

        if [ $FD_UPDATE -eq 1 ]; then
            FD_PACKAGE=fd_${FD_RELEASE_TAG}_amd64.deb
            curl -LO ${FD_RELEASE_URL}/download/v${FD_RELEASE_TAG}/${FD_PACKAGE} &&
                sudo dpkg -i ${FD_PACKAGE}
            rm -f ${FD_PACKAGE}
        fi
    fi
fi

# FZF
printf "${BLUE} ➜  Installing FZF...${NORMAL}\n"
if is_cygwin; then
    if ! command -v fzf >/dev/null 2>&1 && command -v apt-cyg >/dev/null 2>&1; then
        apt-cyg install fzf fzf-zsh fzf-zsh-completion
    fi
else
    if is_mac; then
        sync_brew_package fzf
    elif is_linux; then
        if is_arch; then
            sync_arch_package fzf
        elif command -v apt-get >/dev/null 2>&1; then
            sync_apt_package fzf
        else
            sync_repo junegunn/fzf $FZF
        fi
        # [ -f $FZF/install ] && $FZF/install --all --no-update-rc --no-bash --no-fish >/dev/null
    fi
fi

# Entering zsh
printf "Done. Enjoy!\n"
if command -v zsh >/dev/null 2>&1; then
    if [ "$OSTYPE" != "cygwin" ] && [ "$SHELL" != "$(which zsh)" ]; then
        chsh -s $(which zsh)
        printf "${BLUE} You need to logout and login to enable zsh as the default shell.${NORMAL}\n"
    fi
    env zsh
else
    echo "${RED}Error: zsh is not installed${NORMAL}" >&2
    exit 1
fi
