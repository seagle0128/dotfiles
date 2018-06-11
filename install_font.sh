#!/bin/bash
#############################################################
# Install and update go packages
# Author: Vincent Zhang <seagle0128@gmail.com>
# URL: https://github.com/seagle0128/dotfiles
#############################################################

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


function check {
    if not hash git >/dev/null 2>&1; then
        echo "${RED}Error: git is not installed${NORMAL}"
        exit 1
    fi
    if [ "$OSTYPE" = "cygwin" ]; then
        echo "${RED}Error: Cygwin is not supported${NORMAL}"
        exit 1
    fi
}

function install {
    printf "${BLUE} ➜  Installing fonts...${NORMAL}\n"

    if [ "$SYSTEM" = "Darwin" ]; then
        # macOS
        font_dir="$HOME/Library/Fonts"

        fonts=(
            font-wenquanyi-micro-hei
            font-wenquanyi-micro-hei-lite
            font-wenquanyi-zen-hei

            font-source-code-pro
            font-dejavu-sans
            font-inconsolata
            font-ubuntu
            font-roboto

            font-hack
            font-anonymice-powerline
            font-consolas-for-powerline
            font-dejavu-sans-mono-for-powerline
            font-droid-sans-mono-for-powerline
            font-fira-mono-for-powerline
            font-inconsolata-dz-for-powerline
            font-inconsolata-for-powerline
            font-inconsolata-g-for-powerline
            font-liberation-mono-for-powerline
            font-menlo-for-powerline
            font-meslo-for-powerline
            font-monofur-for-powerline
            font-noto-mono-for-powerline
            font-roboto-mono-for-powerline
            font-source-code-pro-for-powerline
            font-ubuntu-mono-derivative-powerline
        )

        if [ ! -f "${font_dir}/SourceCodePro-Regular.otf" ]; then
            for f in ${fonts[@]}; do
                brew cask install ${f}
            done
        fi
        brew cask cleanup
    else
        # Linux
        font_dir="$HOME/.local/share/fonts"
        mkdir -p $font_dir

        # Source Code Pro
        if [ ! -f "${font_dir}/SourceCodePro-Regular.otf" ]; then
            sync_repo adobe-fonts/source-code-pro $font_dir/source-code-pro release
            echo "Copying fonts..."
            find "$font_dir/source-code-pro" \( -name "$prefix*.[ot]tf" -or -name "$prefix*.pcf.gz" \) -type f -print0 | xargs -0 -n1 -I % cp "%" "$font_dir/"
            rm -rf $font_dir/source-code-pro
            fc-cache -f $font_dir
        fi

        if hash apt-get >/dev/null 2>&1; then
            # Ubuntu/Debian
            fonts=(
                fonts-wqy-microhei
                fonts-wqy-zenhei
                fonts-powerline
            )

            for f in ${fonts[@]}; do
                sudo apt-get install ${f}
            done
        else
            if [ ! -f "${font_dir}/Hack-Regular.ttf" ]; then
                sync_repo powerline/fonts
                ./fonts/install.sh
                rm -rf fonts
            fi
        fi
    fi
}

function main {
    check
    install
}

main
