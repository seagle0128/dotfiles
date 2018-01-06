# Zsh configuration

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Get OS name
sysOS=`uname -s`

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Source customization
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(emacs git history-substring-search golang
         colored-man-pages d extract
         sudo themes z zsh_reload)

if [[ $sysOS == "Darwin" ]]; then
    plugins+=(osx)
fi

if hash tmux 2>/dev/null; then
    plugins+=(tmux)
fi

# Custom plugins
plugins+=(alias-tips
          zsh-256color
          zsh-autosuggestions
          zsh-syntax-highlighting
          zsh-completions)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
alias zshconf='$EDITOR ~/.zshrc'
alias ohmyzsh='$EDITOR ~/.oh-my-zsh'
alias h='history'
alias c='clear'
alias rt='trash'                # npm install --global trash-cli

# emacs
alias rmtags='rm -f GTAGS; rm -f GRTAGS; rm -f GPATH; rm -f TAGS'
alias rmelc='rm -f ~/.emacs.d/lisp/*.elc'
alias restart_emacs='emacsclient -e "(let ((last-nonmenu-event nil) (kill-emacs-query-functions nil)) (save-buffers-kill-emacs t))" && te'

# upgrade
alias upgrade_dotfiles='cd ~/.dotfiles && git pull --rebase --stat origin master && cd - >/dev/null && src'
alias upgrade_emacs='cd ~/.emacs.d && git pull --rebase --stat origin master && cd - >/dev/null'
alias upgrade_oh_my_tmux='cd ~/.tmux && git pull --rebase --stat origin master && cd - >/dev/null'
alias upgrade_env='upgrade_dotfiles && sh ~/.dotfiles/install.sh'
alias upgrade_go='sh ~/.dotfiles/install_go.sh'

# apt
alias apu='sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get autoremove -y && sudo apt-get autoclean -y'

# brew
alias bu='brew update && brew upgrade && brew cleanup'
alias bcu='brew cu --all --yes --no-brew-update --cleanup'

# proxy
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

# functions
function goclean() {
    go clean -i -n $1
    go clean -i $1
    rm -rf $GOPATH/src/$1
    if [ -d $GOPATH/pkg/${sysOS:l}_amd64/$1 ]; then
        rm -rf $GOPATH/pkg/${sysOS:l}_amd64/$1;
    fi
}

function goclean_test() {
    go clean -i -n $1
    tree -L 1 $GOPATH/src/$1
    tree -L 1 $GOPATH/pkg/${sysOS:l}_amd64/$1
}
