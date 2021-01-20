# Zsh configuration

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
zinit snippet OMZL::key-bindings.zsh

zinit wait lucid for \
      OMZL::correction.zsh \
      OMZL::directories.zsh \
      OMZL::history.zsh \
      OMZL::theme-and-appearance.zsh \
      OMZP::colored-man-pages \
      OMZP::common-aliases \
      OMZP::cp \
      OMZP::extract \
      OMZP::fancy-ctrl-z \
      OMZP::git \
      OMZP::sudo

zinit light-mode for \
      zsh-users/zsh-autosuggestions

zinit wait lucid light-mode for \
      zsh-users/zsh-history-substring-search \
      hlissner/zsh-autopair \
      agkozak/zsh-z

# Completion enhancements
zinit ice wait lucid atload"zicompinit; zicdreplay" blockf
zinit light zsh-users/zsh-completions

zinit ice wait lucid atinit"zicompinit; zicdreplay"
zinit light zdharma/fast-syntax-highlighting

zinit ice wait lucid from'gh-r' as'program'
zinit light sei40kr/fast-alias-tips-bin
zinit ice wait lucid depth"1"
zinit light sei40kr/zsh-fast-alias-tips

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
      atload"alias ls='exa --group-directories-first'; alias la='ls -laFh'" sbin"exa* -> exa" ogham/exa \
      cp"completions.zsh -> $ZINIT[COMPLETIONS_DIR]/_exa" https://github.com/ogham/exa/blob/master/completions/completions.zsh\
      cp"**/bat.1 -> $ZPFX/share/man/man1" mv"**/autocomplete/bat.zsh -> $ZINIT[COMPLETIONS_DIR]/_bat" sbin"**/bat" @sharkdp/bat \
      cp"**/fd.1 -> $ZPFX/share/man/man1" mv"**/autocomplete/_fd ->$ZINIT[COMPLETIONS_DIR]" sbin"**/fd"  @sharkdp/fd \
      cp"**/doc/rg.1 -> $ZPFX/share/man/man1" mv"**/complete/_rg -> $ZINIT[COMPLETIONS_DIR]" sbin"**/rg" BurntSushi/ripgrep

# FZF
zinit ice id-as"fzf-bin" as"program" wait lucid from"gh-r" sbin"fzf"
zinit light junegunn/fzf

zinit ice wait lucid depth"1" as"null" sbin"bin/fzf-tmux" \
      cp"man/man.1/fzf* -> $ZPFX/share/man/man1" atpull'%atclone' \
      src'shell/key-bindings.zsh'
zinit light junegunn/fzf

zinit ice wait lucid atload"zicompinit; zicdreplay" blockf
zinit light Aloxaf/fzf-tab

zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ":completion:*:git-checkout:*" sort false
zstyle ':fzf-tab:complete:(cd|ls|exa|bat|cat|emacs|nano|vi|vim):*' fzf-preview 'exa -1 --color=always $realpath'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
       '[[ $group == "[process ID]" ]] &&
        if [[ $OSTYPE == darwin* ]]; then
           ps -p $word -o comm="" -w -w
        elif [[ $OSTYPE == linux* ]]; then
           ps --pid=$word -o cmd --no-headers -w -w
        fi'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags '--preview-window=down:3:wrap'

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

alias gtr='git tag -d $(git tag) && git fetch --tags' # Refresh local tags from remote

(( $+commands[bat] )) && alias cat='bat -p --wrap character'
(( $+commands[htop] )) && alias top='htop'

if [[ $OSTYPE == darwin* ]]; then
    (( $+commands[gls] )) && alias ls='gls --color=tty --group-directories-first'
else
    ((! $+commands[exa] )) && alias ls='ls --color=tty --group-directories-first'
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
alias upgrade_env='upgrade_dotfiles; sh $DOTFILES/install.sh; zinit update'

alias upgrade_cargo='cargo install-update -a' # cargo install cargo-update
alias upgrade_gem='gem update && gem cleanup'
alias upgrade_go='GO111MODULE=on && $DOTFILES/install_go.sh'
alias upgrade_npm='for package in $(npm -g outdated --parseable --depth=0 | cut -d: -f2); do npm -g install "$package"; done'
alias upgrade_pip="pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U"
alias upgrade_pip3="pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip3 install -U"
[[ $OSTYPE == darwin* ]] && alias upgrade_brew='/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'; alias upgrade_brew_cask='$DOTFILES/install_brew_cask.sh'
alias upgrade_zinit='sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"'
