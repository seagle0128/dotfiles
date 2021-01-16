# Zsh configuration

# vars
DOTFILES=$HOME/.dotfiles

# Two regular plugins loaded without investigating.
### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
            print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
      zinit-zsh/z-a-rust \
      zinit-zsh/z-a-as-monitor \
      zinit-zsh/z-a-patch-dl \
      zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk

# Oh My Zsh
zinit snippet OMZL::history.zsh
zinit snippet OMZL::key-bindings.zsh

zinit snippet OMZP::common-aliases
zinit snippet OMZP::colored-man-pages
zinit snippet OMZP::cp
zinit snippet OMZP::extract
zinit snippet OMZP::fancy-ctrl-z
zinit snippet OMZP::sudo

zinit light-mode for \
      zsh-users/zsh-autosuggestions \
      zsh-users/zsh-history-substring-search \
      hlissner/zsh-autopair \
      agkozak/zsh-z

zinit ice wait lucid atinit"zicompinit; zicdreplay"
zinit light zdharma/fast-syntax-highlighting

# Completion enhancements
zinit ice wait lucid atload"zicompinit; zicdreplay" blockf
zinit light zsh-users/zsh-completions
zinit snippet $DOTFILES/completion.zsh

# Load the pure theme, with zsh-async library that's bundled with it.
zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure

#
# Utilities
#

# Scripts that are built at install (there's single default make target, "install",
# and it constructs scripts by `cat'ing a few files). The make'' ice could also be:
# `make"install PREFIX=$ZPFX"`, if "install" wouldn't be the only, default target.
zinit ice as"program" pick"$ZPFX/bin/git-*" make"PREFIX=$ZPFX"
zinit light tj/git-extras

zinit as"null" wait lucid from"gh-r" for \
      mv"bat* -> bat" cp"bat/bat.1 -> $ZPFX/share/man/man1/" sbin"bat/bat" @sharkdp/bat \
      mv"exa* -> exa" sbin ogham/exa \
      mv"fd* -> fd" cp"fd/fd.1 -> $ZPFX/share/man/man1/" sbin"fd/fd" @sharkdp/fd \
      mv"ripgrep* -> rg" cp"rg/doc/rg.1 -> $ZPFX/share/man/man1/" sbin"rg/rg" BurntSushi/ripgrep \
      mv"fzf* -> fzf" sbin junegunn/fzf

# Load FZF
# zinit ice from"gh-r" as"program"
# zinit load junegunn/fzf

if [[ $OSTYPE == cygwin* ]]; then
    [ -f /etc/profile.d/fzf.zsh ] && source /etc/profile.d/fzf.zsh;
else
    zinit light-mode for \
          OMZP::fzf \
          urbainvaes/fzf-marks
    export FZFZ_PREVIEW_COMMAND='tree -NC -L 2 -x --noreport --dirsfirst {}'
fi

export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git || git ls-tree -r --name-only HEAD || rg --hidden --files || find ."
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview '(bat --style=numbers --color=always {} || cat {} || tree -NC {}) 2> /dev/null | head -200'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview' --exact"
export FZF_ALT_C_OPTS="--preview 'tree -NC {} | head -200'"

# For GNU ls (the binaries can be gls, gdircolors, e.g. on OS X when installing the
# coreutils package from Homebrew; you can also use https://github.com/ogham/exa)
zinit ice atclone"dircolors -b LS_COLORS > c.zsh" atpull'%atclone' pick"c.zsh" nocompile'!'
zinit light trapd00r/LS_COLORS

# OS bundles
if [[ $OSTYPE == darwin* ]]; then
    # zinit snippet OMZP::osx
    if (( $+commands[brew] )); then
        alias bu='brew update && brew upgrade'
        alias bcu='brew cu --all --yes --cleanup'
        alias bua='bu && bcu'
    fi
elif [[ $OSTYPE == linux* ]]; then
    if (( $+commands[apt-get] )); then
        zinit snippet OMZP::ubuntu
        alias agua='aguu -y && agar -y && aga -y'
        alias kclean+='sudo aptitude remove -P "?and(~i~nlinux-(ima|hea),\
                                ?not(?or(~n`uname -r | cut -d'\''-'\'' -f-2`,\
                                ~nlinux-generic,\
                                ~n(linux-(virtual|headers-virtual|headers-generic|image-virtual|image-generic|image-`dpkg --print-architecture`)))))"'
    elif (( $+commands[pacman] )); then
        zinit snippet OMZP::archlinux
    fi
fi

# Local customizations, e.g. theme, plugins, aliases, etc.
[ -f $HOME/.zshrc.local ] && source $HOME/.zshrc.local

#
# Aliases
#

# Unalias the original fd in oh-my-zsh
# alias fd >/dev/null && unalias fd

# General
alias zshconf="$EDITOR $HOME/.zshrc; $EDITOR $HOME/.zshrc.local"
alias h='history'
alias c='clear'
alias ip="curl -i http://ip.taobao.com/service/getIpInfo.php\?ip\=myip"

alias gtr='git tag -d $(git tag) && git fetch --tags' # Refresh local tags from remote

(( $+commands[bat] )) && alias cat='bat -p --wrap character'
(( $+commands[htop] )) && alias top='htop'

if (( $+commands[exa] )); then
    alias ls='exa --group-directories-first'
    alias la='ls -laFh'
else
    if [[ $OSTYPE == darwin* ]]; then
        (( $+commands[gls] )) && alias ls='gls --color=tty --group-directories-first'
    else
        alias ls='ls --color=tty --group-directories-first'
    fi
fi

# Emacs
alias me="emacs -Q -l ~/.emacs.d/init-mini.el" # mini emacs
alias mte="emacs -Q -nw -l ~/.emacs.d/init-mini.el" # mini terminal emacs
alias e="$EDITOR -n"
alias ec="$EDITOR -n -c"
alias ef="$EDITOR -c"
alias te="$EDITOR -a '' -nw"
alias rte="$EDITOR -e '(let ((last-nonmenu-event nil) (kill-emacs-query-functions nil)) (save-buffers-kill-emacs t))' && te"

# Upgrade
alias upgrade_repo='git pull --rebase --stat origin master'
alias upgrade_dotfiles='cd $DOTFILES && upgrade_repo; cd - >/dev/null'
alias upgrade_emacs='emacs -Q --batch -L "$HOME/.emacs.d/lisp/" -l "init-funcs.el" -l "init-package.el" --eval "(update-config-and-packages t)"'
alias upgrade_oh_my_tmux='cd $HOME/.tmux && upgrade_repo; cd - >/dev/null'
alias upgrade_env='upgrade_dotfiles; sh $DOTFILES/install.sh'

alias upgrade_cargo='cargo install-update -a' # cargo install cargo-update
alias upgrade_gem='gem update && gem cleanup'
alias upgrade_go='GO111MODULE=on && $DOTFILES/install_go.sh'
alias upgrade_npm='for package in $(npm -g outdated --parseable --depth=0 | cut -d: -f2); do npm -g install "$package"; done'
alias upgrade_pip="pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U"
alias upgrade_pip3="pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip3 install -U"
[[ $OSTYPE == darwin* ]] && alias upgrade_brew='/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'; alias upgrade_brew_cask='$DOTFILES/install_brew_cask.sh'
alias upgrade_zinit='sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"'
