# Zsh configuration

ANTIGEN=$HOME/.antigen
DOTFILES=$HOME/.dotfiles

# Load Antigen
source $ANTIGEN/antigen.zsh

# Configure Antigen
typeset -a ANTIGEN_CHECK_FILES=($HOME/.zshrc $HOME/.zshrc.local)

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

# Load the theme.
antigen theme robbyrussell

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

#
# Aliases
#

# General
alias zshconf="$EDITOR $HOME/.zshrc; $EDITOR $HOME/.zshrc.local"
alias h='history'
alias c='clear'
alias rt='trash'                # `brew install trash` or `npm install --global trash-cli`

# Emacs
alias e="$EDITOR"
alias ef="$EDITOR -c"
alias te='emacsclient -a "" -nw'
alias rmelc='rm -f $HOME/.emacs.d/lisp/*.elc'
alias rmtags='rm -f GTAGS; rm -f GRTAGS; rm -f GPATH; rm -f TAGS'
alias restart_emacs='emacsclient -e "(let ((last-nonmenu-event nil) (kill-emacs-query-functions nil)) (save-buffers-kill-emacs t))" && te'

# Upgrade
alias upgrade_repo='git pull --rebase --stat origin master >/dev/null 2>&1'
alias upgrade_dotfiles='cd $DOTFILES &&  upgrade_repo; cd - >/dev/null'
alias upgrade_emacs='cd $HOME/.emacs.d && upgrade_repo; cd - >/dev/null'
alias upgrade_oh_my_tmux='cd $HOME/.tmux && upgrade_repo; cd - >/dev/null'
alias upgrade_env='upgrade_dotfiles && sh $DOTFILES/install.sh'
alias upgrade_antigen='curl -fsSL git.io/antigen > $ANTIGEN/antigen.zsh.tmp && mv $ANTIGEN/antigen.zsh.tmp $ANTIGEN/antigen.zsh'
alias upgrade_go='sh $DOTFILES/install_go.sh'

# Apt
alias apu='sudo apt-get update; sudo apt-get upgrade -y; sudo apt-get autoremove -y; sudo apt-get autoclean -y'

# Brew
alias bu='brew update; brew upgrade; brew cleanup'
alias bcu='brew cu --all --yes --no-brew-update --cleanup'

# Proxy
PROXY=http://127.0.0.1:1087
alias showproxy='echo "http_proxy=$http_proxy"; echo "https_proxy=$https_proxy"'
alias setproxy='export http_proxy=$PROXY; export https_proxy=$PROXY; showproxy'
alias unsetproxy='export http_proxy=; export https_proxy=; showproxy'
alias toggleproxy='if [ -n "$http_proxy" ]; then unsetproxy; else setproxy; fi'
