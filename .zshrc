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
      zdharma-continuum/zinit-annex-bin-gem-node \
      zdharma-continuum/zinit-annex-patch-dl

### End of Zinit's installer chunk

# Oh My Zsh
zinit for \
      OMZL::correction.zsh \
      OMZL::directories.zsh \
      OMZL::history.zsh \
      OMZL::key-bindings.zsh \
      OMZL::theme-and-appearance.zsh \
      OMZP::common-aliases

zinit wait lucid for \
      OMZP::colored-man-pages \
      OMZP::cp \
      OMZP::extract \
      OMZP::fancy-ctrl-z \
      OMZP::git \
      OMZP::sudo

# Completion enhancements
zinit wait lucid depth"1" for \
      atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
      zdharma-continuum/fast-syntax-highlighting \
      blockf \
      zsh-users/zsh-completions \
      atload"!_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions

zinit wait lucid light-mode depth"1" for \
      djui/alias-tips \
      zsh-users/zsh-history-substring-search \
      hlissner/zsh-autopair

#
# Utilities
#

# Z
if (( $+commands[zoxide] )); then
    export _ZO_FZF_OPTS="--scheme=path --tiebreak=end,chunk,index \
           --bind=ctrl-z:ignore,btab:up,tab:down --cycle --keep-right \
           --border=sharp --height=45% --info=inline --layout=reverse \
           --tabstop=1 --exit-0 --select-1 \
           --preview '(eza --tree --level 3 --color=always \
           --group-directories-first {2} || tree -NC {2}) 2>/dev/null'"
    unalias zi
    eval "$(zoxide init zsh)"
else
    zinit ice wait lucid depth"1"
    zinit light agkozak/zsh-z
fi

# Git extras
zinit ice wait lucid depth"1" as"program" pick"$ZPFX/bin/git-*" \
      src"etc/git-extras-completion.zsh" make"PREFIX=$ZPFX" \
      if'(( $+commands[make] ))'
zinit light tj/git-extras

# Prettify ls
if (( $+commands[gls] )); then
    alias ls='gls --color=tty --group-directories-first'
else
    alias ls='ls --color=tty --group-directories-first'
fi

# Homebrew completion
if (( $+commands[brew] )); then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    autoload -Uz compinit
    compinit
fi

# FZF: fuzzy finder
if (( $+commands[brew] )); then
    FZF="$(brew --prefix)/opt/fzf/shell/"
elif (( $+commands[apt-get] )); then
    FZF="/usr/share/doc/fzf/examples/"
else
    FZF="/usr/share/fzf/"
fi

if [[ -f "$FZF/completion.zsh" ]]; then
    source "$FZF/completion.zsh"
fi

if [[ -f "$FZF/key-bindings.zsh" ]]; then
    source "$FZF/key-bindings.zsh"
fi

# Git utilities powered by FZF
zinit ice wait lucid depth"1"
zinit light wfxr/forgit

# Replace zsh's default completion selection menu with fzf
zinit ice wait lucid depth"1" atload"zicompinit; zicdreplay" blockf
zinit light Aloxaf/fzf-tab

export FZF_DEFAULT_COMMAND="fd --type f --strip-cwd-prefix --hidden --follow --exclude .git || \
  rg --files --hidden --follow --glob '!.git'"
export FZF_DEFAULT_OPTS='--height 40% --tmux bottom,40% --layout reverse --border'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {} || cat {} || tree -NC {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
export FZF_CTRL_R_OPTS="--preview 'echo {} | cut -f 2 | bat --color=always --plain --language=sh'
  --preview-window down:3:wrap --bind '?:toggle-preview' --exact"
export FZF_ALT_C_OPTS="--walker-skip .git,node_modules,target
  --preview '(eza --tree --level 3 --color=always --group-directories-first {} || \
  tree -NC {} || ls --color=always --group-directories-first {}) | head -200'"

# set descriptions format to enable group support
# NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview \
       'eza -1 --color=always --group-directories-first $realpath || \
       ls -1 --color=always --group-directories-first $realpath'
# custom fzf flags
# NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
# zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
# To make fzf-tab follow FZF_DEFAULT_OPTS.
# NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
zstyle ':fzf-tab:*' use-fzf-default-opts yes
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

# Preview environment variables
zstyle ':fzf-tab:complete:(export|unset|expand):*' fzf-preview \
       'echo ${(P)word} | bat -plhelp --color=always'

# Preivew `kill` and `ps` commands
zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,comm -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
       '[[ $group == "[process ID]" ]] &&
        if [[ $OSTYPE == darwin* ]]; then
            ps -p $word -o comm="" -w -w
        elif [[ $OSTYPE == linux* ]]; then
            ps --pid=$word -o cmd --no-headers -w -w
        fi'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags '--preview-window=down:3:wrap'

# Preivew `git` commands
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
	   'git diff $word | delta'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview \
	   'git log --color=always $word'
zstyle ':fzf-tab:complete:git-help:*' fzf-preview \
	   'git help $word | bat -plman --color=always'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
	   'case "$group" in
	"commit tag") git show --color=always $word ;;
	*) git show --color=always $word | delta ;;
	esac'
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
	   'case "$group" in
	"modified file") git diff $word | delta ;;
	"recent commit object name") git show --color=always $word | delta ;;
	*) git log --color=always $word ;;
	esac'

# Privew help
zstyle ':fzf-tab:complete:(\\|*/|)man:*' fzf-preview 'man $word | bat -plman --color=always'
zstyle ':fzf-tab:complete:tldr:argument-1' fzf-preview 'tldr --color always $word'

# Preview brew
zstyle ':fzf-tab:complete:brew-(install|uninstall|search|info):*-argument-rest' fzf-preview \
       'brew info $word | bat -plhelp --color=always'

# Preview systemd
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

# Commands
zstyle ':fzf-tab:complete:-command-:*' fzf-preview \
       '(out=$(tldr --color always "$word") 2>/dev/null && echo $out) ||
        (out=$(man "$word" | bat -plman --color=always) 2>/dev/null && echo $out) ||
        (out=$(which "$word") && echo $out) || echo "${(P)word}"'

# Ripgrep integration
function rgv () {
	rg --color=always --line-number --no-heading --smart-case "${*:-}" |
        fzf --ansi --height 80% --tmux 100%,80% \
            --color "hl:-1:underline,hl+:-1:underline:reverse" \
            --delimiter : \
            --preview 'bat --color=always {1} --highlight-line {2}' \
            --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
            --bind 'enter:become(emacsclient -c -nw -a "vim" +{2} {1} || vim {1} +{2})'
}

# OS bundles
if [[ $OSTYPE == darwin* ]]; then
    zinit snippet PZTM::osx
    if (( $+commands[brew] )); then
        alias bu='brew update; brew upgrade; brew cleanup'
        alias bcu='brew cu --all --yes --cleanup'
        alias bua='bu; bcu'
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
alias reload='exec zsh'
alias h='history'
alias c='clear'

# Modern Unix commands
# See https://github.com/ibraheemdev/modern-unix
if (( $+commands[eza] )); then
    alias ls='eza --color=auto --group-directories-first'
    alias lsi='ls --icons'
    alias l='ls -lhF'
    alias la='ls -lhAF'
    alias lg='ls -lhAF --git'
    alias li='ls -lhF --icons'
    alias tree='ls --tree'
fi
(( $+commands[bat] )) && alias cat='bat -p --wrap character'
(( $+commands[fd] )) && alias find=fd
if (( $+commands[btop] )); then
    alias top=btop
elif (( $+commands[btm] )); then
    alias top=btm
fi
(( $+commands[rg] )) && alias grep=rg
(( $+commands[tldr] )) && alias help=tldr
(( $+commands[delta] )) && alias diff=delta
(( $+commands[duf] )) && alias df=duf
(( $+commands[dust] )) && alias du=dust
(( $+commands[hyperfine] )) && alias benchmark=hyperfine
(( $+commands[gping] )) && alias ping=gping
(( $+commands[paru] )) && alias yay=paru

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
alias upgrade_emacs='emacs -Q --batch -L "$EMACSD/lisp/" -l "init-package.el" \
                           --eval "(progn (package-initialize) (update-config-and-packages))"'
alias upgrade_omt='cd $HOME/.tmux && upgrade_repo; cd - >/dev/null'
alias upgrade_zinit='zinit self-update && zinit update -a -p && zinit compinit'
alias upgrade_env='upgrade_dotfiles; sh $DOTFILES/install.sh'

(( $+commands[cargo] )) && alias upgrade_cargo='cargo install cargo-update; cargo install-update -a'
(( $+commands[gem] )) && alias upgrade_gem='gem update && gem cleanup'
(( $+commands[go] )) && alias upgrade_go='$DOTFILES/install_go.sh'
(( $+commands[npm] )) && alias upgrade_npm='for package in $(npm -g outdated --parseable --depth=0 | cut -d: -f2); do npm -g install "$package"; done'
(( ! $+commands[brew] )) && (( $+commands[pip] )) && alias upgrade_pip="pip list --outdated --format=json | python -c '
import json
import sys

for item in json.loads(sys.stdin.read()):
    print(\"=\".join([item[\"name\"], item[\"latest_version\"]]))
' | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip install -U"
(( ! $+commands[brew] )) && (( $+commands[pip3] )) && alias upgrade_pip3="pip3 list --outdated --format=json | python3 -c '
import json
import sys

for item in json.loads(sys.stdin.read()):
    print(\"=\".join([item[\"name\"], item[\"latest_version\"]]))
' | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U"
(( $+commands[brew] )) && alias upgrade_brew='brew bundle --global; bua'

# Proxy
PROXY=http://127.0.0.1:7897         # ss:1088, vr:8001
NO_PROXY=10.*.*.*,192.168.*.*,*.local,localhost,127.0.0.1
alias showproxy='echo "proxy=$http_proxy"'
alias setproxy='export http_proxy=$PROXY; export https_proxy=$PROXY; all_proxy=$PROXY; export no_proxy=$NO_PROXY; showproxy'
alias unsetproxy='export http_proxy=; export https_proxy=; export all_proxy=; export no_proxy=; showproxy'
alias toggleproxy='if [ -n "$http_proxy" ]; then unsetproxy; else setproxy; fi'

# Local customizations, e.g. theme, plugins, aliases, etc.
[ -f $HOME/.zshrc.local ] && source $HOME/.zshrc.local
