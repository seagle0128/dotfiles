#!/bin/bash
#############################################################
# Install and update go packages
# Author: Vincent Zhang <seagle0128@gmail.com>
# URL: https://github.com/seagle0128/dotfiles
#############################################################

# Source common functions and variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Go packages
packages=(
    # Essential
    # golang.org/x/tools/gopls
    # github.com/go-delve/delve/cmd/dlv
    # honnef.co/go/tools/cmd/staticcheck

    golang.org/x/tools/cmd/goimports
    # github.com/aarzilli/gdlv
    github.com/zmb3/gogetdoc
    github.com/josharian/impl
    github.com/cweill/gotests/...
    github.com/fatih/gomodifytags
    github.com/davidrjenni/reftools/cmd/fillstruct
    github.com/google/gops
    github.com/haya14busa/goplay/cmd/goplay
)

function check() {
    if ! command -v go >/dev/null 2>&1; then
        echo "${RED}Error: go is not installed${NORMAL}" >&2
        exit 1
    fi
}

function install() {
    for p in "${packages[@]}"; do
        printf "${BLUE} ➜  Installing ${p}...${NORMAL}\n"
        GO111MODULE=on go install "${p}"@latest
    done
}

goclean() {
    rm -rf $GOPATH/src/$1
    rm -rf $GOPATH/pkg/mod/{$1}*
}

clean() {
    for p in "${packages[@]}"; do
        goclean "${p}"
    done
}

main() {
    check
    install
}

main
