#!/bin/bash
#############################################################
# Install and update go packages
# Author: Vincent Zhang <seagle0128@gmail.com>
# URL: https://github.com/seagle0128/dotfiles
#############################################################

# Go packages
packages=(
    # go tools
    golang.org/x/tools/cmd/godoc
    golang.org/x/tools/cmd/goimports
    golang.org/x/tools/cmd/gorename
    golang.org/x/tools/cmd/gotype
    golang.org/x/tools/cmd/guru

    # 3rd party
    github.com/nsf/gocode
    github.com/rogpeppe/godef
    github.com/golang/lint/golint
    github.com/derekparker/delve/cmd/dlv
    github.com/aarzilli/gdlv
    github.com/josharian/impl
    github.com/cweill/gotests/...
    github.com/fatih/gomodifytags
    github.com/davidrjenni/reftools/cmd/fillstruct
)

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

function check {
    if not hash go >/dev/null 2>&1; then
        echo "${RED}Error: go is not installed${NORMAL}"
        exit 1
    fi
}

function install {
    for p in ${packages[@]}; do
        echo "${BLUE} ➜  Installing ${p}...${NORMAL}"
        go get -u ${p}
    done
}

function main {
    check
    install
}

main
