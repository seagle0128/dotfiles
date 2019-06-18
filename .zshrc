# Zsh configuration

ANTIGEN=$HOME/.antigen
DOTFILES=$HOME/.dotfiles

# Configure Antigen
declare -a ANTIGEN_CHECK_FILES
ANTIGEN_CHECK_FILES=($HOME/.zshrc $HOME/.zshrc.local)

# Load Antigen
if [[ $OSTYPE == darwin* ]]; then
    source /usr/local/share/antigen/antigen.zsh
else
    if command -v apt-get >/dev/null 2>&1; then
        source /usr/share/zsh-antigen/antigen.zsh
    elif command -v yaourt >/dev/null 2>&1; then
        source /usr/share/zsh/share/antigen.zsh
    else
        source $ANTIGEN/antigen.zsh
    fi
fi

# Load the oh-my-zsh's library
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh)
antigen bundle common-aliases
antigen bundle git
antigen bundle gitfast
antigen bundle colored-man-pages
antigen bundle extract
antigen bundle sudo
antigen bundle z

# Misc bundles.
command -v python >/dev/null 2>&1 && antigen bundle djui/alias-tips
if command -v fdfind >/dev/null 2>&1; then
    alias fd='fdfind';
fi

# OS bundles
if [[ $OSTYPE == darwin* ]]; then
    antigen bundle osx
    if command -v brew >/dev/null 2>&1; then
        export HOMEBREW_INSTALL_CLEANUP=1
        alias bu='brew update && brew upgrade'
        alias bcu='brew cu --all --yes --cleanup'
        alias bua='bu && bcu'
    fi
elif [[ $OSTYPE == linux* ]]; then
    if command -v apt-get >/dev/null 2>&1; then
        antigen bundle ubuntu
        alias agua='aguu -y && agar -y && aga -y'
        alias kclean+='sudo aptitude remove -P "?and(~i~nlinux-(ima|hea),\
                            ?not(?or(~n`uname -r | cut -d'\''-'\'' -f-2`,\
                            ~nlinux-generic,\
                            ~n(linux-(virtual|headers-virtual|headers-generic|image-virtual|image-generic|image-`dpkg --print-architecture`)))))"'
    elif command -v pacman >/dev/null 2>&1; then
        antigen bundle archlinux
    fi
fi

# Load FZF
if command -v fzf >/dev/null 2>&1; then
    if [[ $OSTYPE == cygwin* ]]; then
        [ -f /etc/profile.d/fzf.zsh ] && source /etc/profile.d/fzf.zsh;
    else
        antigen bundle fzf
        antigen bundle andrewferrier/fzf-z
    fi

    if command -v fd > /dev/null 2>&1; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    elif command -v rg >/dev/null 2>&1; then
        export FZF_DEFAULT_COMMAND='rg --hidden --files'
    elif command -v ag >/dev/null 2>&1; then
        export FZF_DEFAULT_COMMAND='ag -U --hidden -g ""'
    fi
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
    export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
    export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
fi

# antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zdharma/fast-syntax-highlighting
# antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle hlissner/zsh-autopair

# Load the theme.
antigen theme ys            # ys, dst, steeef, wedisagree, robbyrussell

# Local customizations, e.g. theme, plugins, aliases, etc.
[ -f $HOME/.zshrc.local ] && source $HOME/.zshrc.local

# Tell Antigen that you're done
antigen apply

# Completion enhancements
source $DOTFILES/completion.zsh

#
# Aliases
#
unalias fd

# General
alias zshconf="$EDITOR $HOME/.zshrc; $EDITOR $HOME/.zshrc.local"
alias h='history'
alias c='clear'
alias rt='trash'                # `brew install trash` or `npm install --global trash-cli`

alias gtr='git tag -d $(git tag) && git fetch --tags' # Refresh local tags from remote

if [[ $OSTYPE == darwin* ]]; then
    command -v gls >/dev/null 2>&1 && alias ls='gls --color=tty --group-directories-first'
else
    alias ls='ls --color=tty --group-directories-first'
fi

# Emacs
# alias emacs='emacsclient -a ""'
alias emacs-mini='emacs -Q --load ~/.emacs.d/init-mini.el'
alias e='emacsclient -n'
alias ec='emacsclient -c'
alias ef='emacsclient -n -c'
alias te='emacsclient -nw'
alias rmelc='rm -f $HOME/.emacs.d/lisp/*.elc'
alias rmtags='rm -f GTAGS; rm -f GRTAGS; rm -f GPATH; rm -f TAGS'
alias restart_emacs='emacsclient -e "(let ((last-nonmenu-event nil) (kill-emacs-query-functions nil)) (save-buffers-kill-emacs t))" && te'

# Upgrade
alias upgrade_repo='git pull --rebase --stat origin master'
alias upgrade_dotfiles='cd $DOTFILES && upgrade_repo; cd - >/dev/null'
alias upgrade_emacs='cd $HOME/.emacs.d && upgrade_repo; cd - >/dev/null'
alias upgrade_oh_my_tmux='cd $HOME/.tmux && upgrade_repo; cd - >/dev/null'
alias upgrade_env='upgrade_dotfiles && sh $DOTFILES/install.sh'
alias upgrade_pip="pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U"

if [[ $OSTYPE == darwin* ]]; then
    command -v brew >/dev/null 2>&1 && alias upgrade_antigen='brew update antigen'
    alias upgrade_brew_cask='$DOTFILES/install_brew_cask.sh'
elif [[ $OSTYPE == linux* ]]; then
    # (( $+commands[apt-get] )) && apug -y antigen
    alias upgrade_antigen='sudo curl -o /usr/share/zsh-antigen/antigen.zsh -sL git.io/antigen'
else
    alias upgrade_antigen='curl -fsSL git.io/antigen > $ANTIGEN/antigen.zsh.tmp && mv $ANTIGEN/antigen.zsh.tmp $ANTIGEN/antigen.zsh'
fi
