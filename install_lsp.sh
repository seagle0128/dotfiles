#!/bin/bash
#############################################################
# Install language servers.
# Author: Vincent Zhang <seagle0128@gmail.com>
# URL: https://github.com/seagle0128/dotfiles
#############################################################

# Language servers
langservers=(

)

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

if command -v go >/dev/null 2>&1; then
    printf "${BLUE} ➜  Installing Go language server...${NORMAL}\n"
    go get -u github.com/sourcegraph/go-langserver
fi

# if command -v pip >/dev/null 2>&1; then
#     printf "${BLUE} ➜  Installing Python language server...${NORMAL}\n"
#     pip install python-language-server
# fi

if command -v pip >/dev/null 2>&1; then
    printf "${BLUE} ➜  Installing Ruby language server...${NORMAL}\n"
    sudo gem install solargraph

    printf "${BLUE} ➜  Installing Javascript/Typescript language server...${NORMAL}\n"
    sudo npm i -g javascript-typescript-langserver

    printf "${BLUE} ➜  Installing CSS language server...${NORMAL}\n"
    sudo npm i -g vscode-css-languageserver-bin

    printf "${BLUE} ➜  Installing HTML language server...${NORMAL}\n"
    sudo npm i -g vscode-html-languageserver-bin

    printf "${BLUE} ➜  Installing Bash language server...${NORMAL}\n"
    sudo npm i -g bash-language-server@1.4.0
fi

if command -v pip >/dev/null 2>&1; then
    printf "${BLUE} ➜  Installing PHP language server...${NORMAL}\n"
    composer require felixfbecker/language-server
fi

if command -v pip >/dev/null 2>&1; then
    printf "${BLUE} ➜  Installing C/C++/ObjectiveC language server...${NORMAL}\n"
    brew install cquery
fi
