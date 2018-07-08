# Zsh configuration

ANTIGEN=$HOME/.antigen
DOTFILES=$HOME/.dotfiles

# Configure Antigen
declare -a ANTIGEN_CHECK_FILES
ANTIGEN_CHECK_FILES=($HOME/.zshrc $HOME/.zshrc.local)

# Load Antigen
source $ANTIGEN/antigen.zsh

# Load the oh-my-zsh's library
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh)
antigen bundle git
antigen bundle colored-man-pages
antigen bundle extract
antigen bundle sudo
antigen bundle z
[[ $OSTYPE == darwin* ]] && antigen bundle osx

# Misc bundles.
antigen bundle djui/alias-tips
[[ $OSTYPE != cygwin* ]] && antigen bundle andrewferrier/fzf-z

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

# Load FZF
if [[ $OSTYPE == cygwin* ]]; then
    [ -f /etc/profile.d/fzf.zsh ] && source /etc/profile.d/fzf.zsh;
else
    [ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh;
fi
if hash rg >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='rg --hidden --files'
elif hash ag >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='ag -U --hidden -g ""'
fi
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

#
# Aliases
#

# General
alias zshconf="$EDITOR $HOME/.zshrc; $EDITOR $HOME/.zshrc.local"
alias h='history'
alias c='clear'
alias rt='trash'                # `brew install trash` or `npm install --global trash-cli`

if [[ $OSTYPE == darwin* ]]; then
    hash gls >/dev/null 2>&1 && alias ls='gls --color=tty --group-directories-first'
else
    alias ls='ls --color=tty --group-directories-first'
fi

# Emacs
alias e="$EDITOR"
alias ef="$EDITOR -c"
alias te='emacsclient -a "" -nw'
alias rmelc='rm -f $HOME/.emacs.d/lisp/*.elc'
alias rmtags='rm -f GTAGS; rm -f GRTAGS; rm -f GPATH; rm -f TAGS'
alias restart_emacs='emacsclient -e "(let ((last-nonmenu-event nil) (kill-emacs-query-functions nil)) (save-buffers-kill-emacs t))" && te'

# Upgrade
alias upgrade_repo='git pull --rebase --stat origin master'
alias upgrade_dotfiles='cd $DOTFILES && upgrade_repo; cd - >/dev/null'
alias upgrade_emacs='cd $HOME/.emacs.d && upgrade_repo; cd - >/dev/null'
alias upgrade_oh_my_tmux='cd $HOME/.tmux && upgrade_repo; cd - >/dev/null'
alias upgrade_env='upgrade_dotfiles && $DOTFILES/install.sh'
alias upgrade_antigen='curl -fsSL git.io/antigen > $ANTIGEN/antigen.zsh.tmp && mv $ANTIGEN/antigen.zsh.tmp $ANTIGEN/antigen.zsh'
alias upgrade_go='$DOTFILES/install_go.sh'
[[ $OSTYPE == darwin* ]] && alias upgrade_brew_cask='$DOTFILES/install_brew_cask.sh'

# Apt
if [[ $OSTYPE == linux* ]] && which apt-get >/dev/null 2>&1; then
    alias apu='sudo apt-get update; sudo apt-get upgrade -y; sudo apt-get autoremove -y; sudo apt-get autoclean -y'
fi

# Brew
if [[ $OSTYPE == darwin* ]]; then
    alias bu='brew update; brew upgrade; brew cleanup'
    alias bcu='brew cu --all --yes --no-brew-update --cleanup'
fi

# Proxy
HTTP_PROXY=http://127.0.0.1:1087
PROXY=socks5://127.0.0.1:1086
NO_PROXY=10.*.*.*,192.168.*.*,*.local,localhost,127.0.0.1
alias showproxy='echo "proxy=$http_proxy"'
alias setproxy='export http_proxy=$PROXY; export https_proxy=$PROXY; export no_proxy=$NO_PROXY; showproxy'
alias unsetproxy='export http_proxy=; export https_proxy=; export no_proxy=; showproxy'
alias toggleproxy='if [ -n "$http_proxy" ]; then unsetproxy; else setproxy; fi'
alias set_http_proxy='export http_proxy=$HTTP_PROXY; export https_proxy=$HTTP_PROXY; export no_proxy=$NO_PROXY; showproxy'
alias unset_http_proxy=unsetproxy
alias toggle_http_proxy='if [ -n "$http_proxy" ]; then unset_http_proxy; else set_http_proxy; fi'
