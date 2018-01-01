#!/bin/sh
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

function check {
    if not hash go 2>/dev/null; then
        echo "Error: go is not installed"
        exit 1
    fi
}

function install () {
    for p in ${packages[@]}; do
        go get -u ${p}
    done
}

check
install
