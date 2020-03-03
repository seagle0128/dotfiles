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
antigen bundle colored-man-pages
antigen bundle common-aliases
antigen bundle cp
antigen bundle extract
antigen bundle fancy-ctrl-z
antigen bundle git
antigen bundle gitfast
antigen bundle sudo
antigen bundle z

# Misc bundles.
command -v python >/dev/null 2>&1 && antigen bundle djui/alias-tips
command -v fdfind >/dev/null 2>&1 && alias fd='fdfind'

# OS bundles
if [[ $OSTYPE == darwin* ]]; then
    antigen bundle osx
    if command -v brew >/dev/null 2>&1; then
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

# Load FD
command -v fd >/dev/null 2>&1 && antigen bundle fd

# Load FZF
if command -v fzf >/dev/null 2>&1; then
    if [[ $OSTYPE == cygwin* ]]; then
        [ -f /etc/profile.d/fzf.zsh ] && source /etc/profile.d/fzf.zsh;
    else
        antigen bundle fzf
        antigen bundle andrewferrier/fzf-z
        export FZFZ_PREVIEW_COMMAND='tree -NC -L 2 -x --noreport --dirsfirst {}'
    fi

    export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git || git ls-tree -r --name-only HEAD || rg --hidden --files || find ."
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_CTRL_T_OPTS="--preview '(bat --style=numbers --color=always {} || cat {} || tree -NC {}) 2> /dev/null | head -200'"
    export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview' --exact"
    export FZF_ALT_C_OPTS="--preview 'tree -NC {} | head -200'"
fi

antigen bundle hlissner/zsh-autopair
# antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-history-substring-search
# antigen bundle zdharma/fast-syntax-highlighting
antigen bundle zsh-users/zsh-syntax-highlighting

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

# Unalias the original fd in oh-my-zsh
alias fd >/dev/null && unalias fd

# General
alias zshconf="$EDITOR $HOME/.zshrc; $EDITOR $HOME/.zshrc.local"
alias h='history'
alias c='clear'
alias ip="curl -i http://ip.taobao.com/service/getIpInfo.php\?ip\=myip"

alias gtr='git tag -d $(git tag) && git fetch --tags' # Refresh local tags from remote

if [[ $OSTYPE == darwin* ]]; then
    command -v gls >/dev/null 2>&1 && alias ls='gls --color=tty --group-directories-first'
else
    alias ls='ls --color=tty --group-directories-first'
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
alias upgrade_env='upgrade_dotfiles; sh $DOTFILES/install.sh; upgrade_oh_my_tmux; upgrade_oh_my_zsh'

alias upgrade_cargo='cargo install-update -a' # cargo install cargo-update
alias upgrade_gem='sudo gem update && sudo gem cleanup'
alias upgrade_go='$DOTFILES/install_go.sh'
alias upgrade_npm='for package in $(npm -g outdated --parseable --depth=0 | cut -d: -f2); do npm -g install "$package"; done'
alias upgrade_pip="pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U"

if [[ $OSTYPE == darwin* ]]; then
    command -v brew >/dev/null 2>&1 && alias upgrade_antigen='brew upgrade antigen'
    alias upgrade_brew_cask='$DOTFILES/install_brew_cask.sh'
elif [[ $OSTYPE == linux* ]]; then
    # (( $+commands[apt-get] )) && apug -y antigen
    alias upgrade_antigen='sudo curl -o /usr/share/zsh-antigen/antigen.zsh -sL git.io/antigen'
else
    alias upgrade_antigen='curl -fsSL git.io/antigen > $ANTIGEN/antigen.zsh.tmp && mv $ANTIGEN/antigen.zsh.tmp $ANTIGEN/antigen.zsh'
fi
