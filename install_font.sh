#!/bin/bash
#############################################################
# Install and update go packages
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
    if ! command -v git >/dev/null 2>&1; then
        echo "${RED}Error: git is not installed${NORMAL}" >&2
        exit 1
    fi
    if [ "$OSTYPE" = "cygwin" ]; then
        echo "${RED}Error: Cygwin is not supported${NORMAL}" >&2
        exit 1
    fi
}

function install {
    printf "${BLUE} ➜  Installing fonts...${NORMAL}\n"

    if [ "$SYSTEM" = "Linux" ]; then
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

        if command -v apt-get >/dev/null 2>&1; then
            # Ubuntu/Debian
            fonts=(
                fonts-hack-ttf
                fonts-powerline
                fonts-wqy-microhei
                fonts-wqy-zenhei
                # ttf-mscorefonts-installer
            )

            for f in ${fonts[@]}; do
                sudo apt-get upgrade -y ${f}
            done
        else
            if [ ! -f "${font_dir}/Hack Regular Nerd Font Complete.ttf" ]; then
                sh -c "$(curl -fsSL https://github.com/ryanoasis/nerd-fonts/raw/master/install.sh) Hack"
            fi
        fi
    fi
}

function main {
    check
    install
}

main
