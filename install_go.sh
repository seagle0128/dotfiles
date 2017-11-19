#!/bin/sh
#############################################################
# Install and update go packages
# Author: Vincent Zhang <seagle0128@gmail.com>
# URL: https://github.com/seagle0128/dotfiles
#############################################################

if not hash go 2>/dev/null; then
    echo "Error: go is not installed"
fi

go get -u github.com/nsf/gocode
go get -u github.com/rogpeppe/godef
go get -u github.com/golang/lint/golint
go get -u golang.org/x/tools/cmd/goimports
go get -u golang.org/x/tools/cmd/guru
go get -u golang.org/x/tools/cmd/gorename
go get -u golang.org/x/tools/cmd/godoc
go get -u github.com/derekparker/delve/cmd/dlv
go get -u github.com/josharian/impl
go get -u sourcegraph.com/sqs/goreturns
