# Zsh configuration

source ~/.antigen/antigen.zsh

# Configure Antigen.
typeset -a ANTIGEN_CHECK_FILES=(~/.zshrc ~/.zshrc.local)

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle colored-man-pages
antigen bundle extract
antigen bundle sudo
antigen bundle z
[[ $OSTYPE == darwin* ]] && antigen bundle osx

# Misc bundles.
antigen bundle djui/alias-tips
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zdharma/fast-syntax-highlighting
# antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-completions

# Load the theme.
antigen theme robbyrussell

# Local customizations, e.g. theme, plugins, aliases, etc.
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# Tell Antigen that you're done.
antigen apply

# Load FZF.
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh;

#
# Aliases
#

# General
alias zshconf="$EDITOR ~/.zshrc; $EDITOR ~/.zshrc.local"
alias h='history'
alias c='clear'
alias rt='trash'                # npm install --global trash-cli

# Emacs
alias e=$EDITOR
alias ef="$EDITOR -c"
alias te='emacsclient -a "" -nw'
alias rmelc='rm -f ~/.emacs.d/lisp/*.elc'
alias rmtags='rm -f GTAGS; rm -f GRTAGS; rm -f GPATH; rm -f TAGS'
alias restart_emacs='emacsclient -e "(let ((last-nonmenu-event nil) (kill-emacs-query-functions nil)) (save-buffers-kill-emacs t))" && te'

# Upgrade
alias upgrade_dotfiles='cd ~/.dotfiles && git pull --rebase --stat origin master && cd - >/dev/null'
alias upgrade_emacs='cd ~/.emacs.d && git pull --rebase --stat origin master && cd - >/dev/null'
alias upgrade_oh_my_tmux='cd ~/.tmux && git pull --rebase --stat origin master && cd - >/dev/null'
alias upgrade_env='upgrade_dotfiles && sh ~/.dotfiles/install.sh'
alias upgrade_antigen='curl -L git.io/antigen > ~/.antigen/antigen.zsh'
alias upgrade_go='sh ~/.dotfiles/install_go.sh'

# Apt
alias apu='sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get autoremove -y && sudo apt-get autoclean -y'

# Brew
alias bu='brew update && brew upgrade && brew cleanup'
alias bcu='brew cu --all --yes --no-brew-update --cleanup'

# Proxy
if [ -f /opt/XX-Net/start ]; then
    alias startproxy='/opt/XX-Net/start'
    PROXY=http://127.0.0.1:8087
else
    PROXY=http://127.0.0.1:1087
fi
alias showproxy='echo "http_proxy=$http_proxy"; echo "https_proxy=$https_proxy"'
alias setproxy='export http_proxy=$PROXY; export https_proxy=$PROXY; showproxy'
alias unsetproxy='export http_proxy=; export https_proxy=; showproxy'
alias toggleproxy='if [ -n "$http_proxy" ]; then unsetproxy; else setproxy; fi'
