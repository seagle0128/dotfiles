# Zsh configuration

# vars
DOTFILES=$HOME/.dotfiles
EMACSD=$HOME/.emacs.d

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone --depth=1 https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
            print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode depth"1" for \
      zdharma-continuum/zinit-annex-as-monitor \
      zdharma-continuum/zinit-annex-bin-gem-node \
      zdharma-continuum/zinit-annex-patch-dl \
      zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# Oh My Zsh
zinit for \
      OMZL::correction.zsh \
      OMZL::directories.zsh \
      OMZL::history.zsh \
      OMZL::key-bindings.zsh \
      OMZL::theme-and-appearance.zsh

zinit wait lucid for \
      OMZP::common-aliases \
      OMZP::colored-man-pages \
      OMZP::cp \
      OMZP::extract \
      OMZP::fancy-ctrl-z \
      OMZP::git \
      OMZP::sudo

# Bing GNU coreutils
if type gls &>/dev/null; then
    zinit wait lucid for OMZP::gnu-utils
fi

# Completion enhancements
zinit wait lucid depth"1" for \
      atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
      zdharma-continuum/fast-syntax-highlighting \
      blockf \
      zsh-users/zsh-completions \
      atload"!_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions

zinit wait lucid light-mode depth"1" for \
      zsh-users/zsh-history-substring-search \
      hlissner/zsh-autopair \
      agkozak/zsh-z

if [[ $OSTYPE != linux* && $CPUTYPE != aarch* ]]; then
    zinit ice wait lucid from'gh-r' as'program'
    zinit light sei40kr/fast-alias-tips-bin
    zinit ice wait lucid depth"1"
    zinit light sei40kr/zsh-fast-alias-tips
fi

#
# Utilities
#

# Scripts that are built at install (there's single default make target, "install",
# and it constructs scripts by `cat'ing a few files). The make'' ice could also be:
# `make"install PREFIX=$ZPFX"`, if "install" wouldn't be the only, default target.
zinit ice wait lucid as"program" depth"1" pick"$ZPFX/bin/git-*" make"PREFIX=$ZPFX"
zinit light tj/git-extras

# Homebrew completion
if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    autoload -Uz compinit
    compinit
fi

# Modern Unix commands
# See https://github.com/ibraheemdev/modern-unix
zinit as"null" wait lucid from"gh-r" for \
      atinit"alias ls='exa --color=auto --group-directories-first'; alias la='ls -laFh'" cp"**/exa.1 -> $ZPFX/share/man/man1" mv"**/exa.zsh -> $ZINIT[COMPLETIONS_DIR]/_exa" sbin"**/exa" if'[[ $OSTYPE != linux* && $CPUTYPE != aarch* ]]' ogham/exa \
      atload"alias cat='bat -p --wrap character'" mv"**/bat.1 -> $ZPFX/share/man/man1" cp"**/autocomplete/bat.zsh -> $ZINIT[COMPLETIONS_DIR]/_bat" sbin"**/bat" @sharkdp/bat \
      mv"**/fd.1 -> $ZPFX/share/man/man1" cp"**/autocomplete/_fd -> $ZINIT[COMPLETIONS_DIR]" sbin"**/fd" @sharkdp/fd \
      mv"**/hyperfine.1 -> $ZPFX/share/man/man1" cp"**/autocomplete/_hyperfine -> $ZINIT[COMPLETIONS_DIR]" sbin"**/hyperfine" @sharkdp/hyperfine \
      cp"**/completion/_btm -> $ZINIT[COMPLETIONS_DIR]" atload"alias top=btm" sbin ClementTsang/bottom \
      atload"alias help=cheat" mv"cheat* -> cheat" sbin cheat/cheat \
      atload"alias diff=delta" sbin"**/delta" dandavison/delta \
      atload"unalias duf; alias df=duf" sbin muesli/duf \
      atload"alias du=dust" sbin"**/dust" bootandy/dust \
      atload"alias ping=gping" sbin orf/gping \
      atload"alias ps=procs" sbin dalance/procs

# Don't use sbin or fbin since it's incompatible with magit-todos
if [[ $CPUTYPE == arm* || $CPUTYPE == aarch* ]]; then
    zinit ice as"program" from"gh-r" bpick"*aarch*"
else
    zinit ice as"program" from"gh-r"
fi
zinit light microsoft/ripgrep-prebuilt

zinit ice as"null" from"gh-r" wait lucid cp"**/doc/rg.1 -> $ZPFX/share/man/man1" mv"**/complete/_rg -> $ZINIT[COMPLETIONS_DIR]"
zinit light BurntSushi/ripgrep

# For GNU ls (the binaries can be gls, gdircolors, e.g. on OS X when installing the
# coreutils package from Homebrew; you can also use https://github.com/ogham/exa)
# (( $+commands[gdircolors] )) && alias dircolors=gdircolors
# zinit ice depth"1" atclone"dircolors -b LS_COLORS > c.zsh" atpull'%atclone' pick"c.zsh" nocompile'!'
# zinit light trapd00r/LS_COLORS

# FZF: fuzzy finder
if [[ $CPUTYPE == arm* || $CPUTYPE == aarch* ]]; then
    zinit ice \
          dl'https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.zsh -> _fzf_completion;
             https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.zsh -> key-bindings.zsh;
             https://raw.githubusercontent.com/junegunn/fzf/master/man/man1/fzf-tmux.1 -> $ZPFX/share/man/man1/fzf-tmux.1;
             https://raw.githubusercontent.com/junegunn/fzf/master/man/man1/fzf.1 -> $ZPFX/share/man/man1/fzf.1' \
          from"gh-r" lucid nocompile src'key-bindings.zsh' bpick"*arm*" sbin
else
    zinit ice \
          dl'https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.zsh -> _fzf_completion;
             https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.zsh -> key-bindings.zsh;
             https://raw.githubusercontent.com/junegunn/fzf/master/man/man1/fzf-tmux.1 -> $ZPFX/share/man/man1/fzf-tmux.1;
             https://raw.githubusercontent.com/junegunn/fzf/master/man/man1/fzf.1 -> $ZPFX/share/man/man1/fzf.1' \
          from"gh-r" lucid nocompile src'key-bindings.zsh' sbin
fi
zinit light junegunn/fzf

zinit ice wait lucid depth"1" atload"zicompinit; zicdreplay" blockf
zinit light Aloxaf/fzf-tab

zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:complete:*:options' sort false
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,comm -w -w'
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:complete:(cd|ls|exa|bat|cat|emacs|nano|vi|vim):*' fzf-preview 'ls -1 --color=always $realpath'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
       '[[ $group == "[process ID]" ]] &&
        if [[ $OSTYPE == darwin* ]]; then
           ps -p $word -o comm="" -w -w
        elif [[ $OSTYPE == linux* ]]; then
           ps --pid=$word -o cmd --no-headers -w -w
        fi'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags '--preview-window=down:3:wrap'
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git || git ls-tree -r --name-only HEAD || rg --files --hidden --follow --glob '!.git' || find ."
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_CTRL_T_OPTS="--preview '(bat --style=numbers --color=always {} || cat {} || tree -NC {}) 2> /dev/null | head -200'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview' --exact"
export FZF_ALT_C_OPTS="--preview 'tree -NC {} | head -200'"

# GIT heart FZF
# @see https://junegunn.kr/2016/07/fzf-git/
is_in_git_repo() {
    git rev-parse HEAD > /dev/null 2>&1
}

fzf-down() {
    fzf --height 50% --min-height 20 --border --bind ctrl-/:toggle-preview "$@"
}

_gf() {
    is_in_git_repo || return
    git -c color.status=always status --short |
        fzf-down -m --ansi --nth 2..,.. \
                 --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1})' |
        cut -c4- | sed 's/.* -> //'
}

_gb() {
    is_in_git_repo || return
    git branch -a --color=always | grep -v '/HEAD\s' | sort |
        fzf-down --ansi --multi --tac --preview-window right:70% \
                 --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1)' |
        sed 's/^..//' | cut -d' ' -f1 |
        sed 's#^remotes/##'
}

_gt() {
    is_in_git_repo || return
    git tag --sort -version:refname |
        fzf-down --multi --preview-window right:70% \
                 --preview 'git show --color=always {}'
}

_gh() {
    is_in_git_repo || return
    git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
        fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
                 --header 'Press CTRL-S to toggle sort' \
                 --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always' |
        grep -o "[a-f0-9]\{7,\}"
}

_gr() {
    is_in_git_repo || return
    git remote -v | awk '{print $1 "\t" $2}' | uniq |
        fzf-down --tac \
                 --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1}' |
        cut -d$'\t' -f1
}

_gs() {
    is_in_git_repo || return
    git stash list | fzf-down --reverse -d: --preview 'git show --color=always {1}' |
        cut -d: -f1
}

join-lines() {
    local item
    while read item; do
        echo -n "${(q)item} "
    done
}

bind-git-helper() {
    local c
    for c in $@; do
        eval "fzf-g$c-widget() { local result=\$(_g$c | join-lines); zle reset-prompt; LBUFFER+=\$result }"
        eval "zle -N fzf-g$c-widget"
        eval "bindkey '^g^$c' fzf-g$c-widget"
    done
}
bind-git-helper f b t r h s
unset -f bind-git-helper

# OS bundles
if [[ $OSTYPE == darwin* ]]; then
    zinit snippet PZTM::osx
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

#
# Aliases
#

# General
alias zshconf="$EDITOR $HOME/.zshrc; $EDITOR $HOME/.zshrc.local"
alias h='history'
alias c='clear'

# ls
alias ls='ls --color=auto --group-directories-first'

# Git
alias gtr='git tag -d $(git tag) && git fetch --tags' # Refresh local tags from remote

# Emacs
alias me="emacs -Q -l $EMACSD/init-mini.el" # mini emacs
alias mte="emacs -Q -nw -l $EMACSD/init-mini.el" # mini terminal emacs
alias e="$EDITOR -n"
alias ec="$EDITOR -n -c"
alias ef="$EDITOR -c"
alias te="$EDITOR -nw"
alias rte="$EDITOR -e '(let ((last-nonmenu-event nil) (kill-emacs-query-functions nil)) (save-buffers-kill-emacs t))' && te"

# Upgrade
alias upgrade_repo='git pull --rebase --stat origin master'
alias upgrade_dotfiles='cd $DOTFILES && upgrade_repo; cd - >/dev/null'
alias upgrade_emacs='emacs -Q --batch -L "$EMACSD/lisp/" -l "init-funcs.el" -l "init-package.el" --eval "(update-config-and-packages t t)"'
alias upgrade_omt='cd $HOME/.tmux && upgrade_repo; cd - >/dev/null'
alias upgrade_zinit='zinit self-update && zinit update'
alias upgrade_env='upgrade_dotfiles; sh $DOTFILES/install.sh'

(( $+commands[cargo] )) && alias upgrade_cargo='cargo install-update -a' # cargo install cargo-update
(( $+commands[gem] )) && alias upgrade_gem='gem update && gem cleanup'
(( $+commands[go] )) && alias upgrade_go='GO111MODULE=on && $DOTFILES/install_go.sh'
(( $+commands[npm] )) && alias upgrade_npm='for package in $(npm -g outdated --parseable --depth=0 | cut -d: -f2); do npm -g install "$package"; done'
(( $+commands[pip] )) && alias upgrade_pip="pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U"
(( $+commands[pip3] )) && alias upgrade_pip3="pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip3 install -U"
(( $+commands[brew] )) && alias upgrade_brew='brew update'; alias upgrade_brew_cask='$DOTFILES/install_brew_cask.sh'

# Proxy
PROXY=http://127.0.0.1:7890         # ss:1088, vr:8001
PROXY2=http://127.0.0.1:8123
SOCK_PROXY=socks5://127.0.0.1:7890  # ss:1086, vr:1081
NO_PROXY=10.*.*.*,192.168.*.*,*.local,localhost,127.0.0.1
alias set_polipo_proxy='ps -ef | grep polipo | grep -v grep; [ $? -ne 0 ] && polipo socksParentProxy=192.168.31.1:1082 &'
alias showproxy='echo "proxy=$http_proxy"'
alias setproxy='export http_proxy=$PROXY; export https_proxy=$PROXY; export no_proxy=$NO_PROXY; showproxy'
alias setproxy2='set_polipo_proxy; export http_proxy=$PROXY2; export https_proxy=$PROXY2; export no_proxy=$NO_PROXY; showproxy'
alias unsetproxy='export http_proxy=; export https_proxy=; export all_proxy=; export no_proxy=; showproxy'
alias unsetproxy2=unsetproxy
alias kill_polipo_proxy='killall polipo'
alias toggleproxy='if [ -n "$http_proxy" ]; then unsetproxy; else setproxy; fi'
alias toggleproxy2='if [ -n "$http_proxy" ]; then unsetproxy2; else setproxy2; fi'
alias set_sock_proxy='export http_proxy=$SOCK_PROXY; export https_proxy=$SOCK_PROXY; all_proxy=$SOCK_PROXY; export no_proxy=$NO_PROXY; showproxy'
alias unset_sock_proxy=unsetproxy
alias toggle_sock_proxy='if [ -n "$http_proxy" ]; then unset_sock_proxy; else set_sock_proxy; fi'

# Local customizations, e.g. theme, plugins, aliases, etc.
[ -f $HOME/.zshrc.local ] && source $HOME/.zshrc.local
