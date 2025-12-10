#!/bin/bash
#############################################################
# Install fonts
# Author: Vincent Zhang <seagle0128@gmail.com>
# URL: https://github.com/seagle0128/dotfiles
#############################################################

# Source common functions and variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

check() {
    if ! command -v git >/dev/null 2>&1; then
        echo "${RED}Error: git is not installed${NORMAL}" >&2
        exit 1
    fi
    if [ "$OSTYPE" = "cygwin" ]; then
        echo "${RED}Error: Cygwin is not supported${NORMAL}" >&2
        exit 1
    fi
}

install() {
    printf "${BLUE} ➜  Installing fonts...${NORMAL}\n"

    if [ "$OS" = "Linux" ]; then
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

main() {
    check
    install
}

main
