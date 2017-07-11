# Get OS name
sysOS=`uname -s`

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Source customization
if [ -f ~/.zshrc.theme.local ]; then source ~/.zshrc.theme.local; fi

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
         copydir copyfile colorize colored-man-pages
         python ruby sudo themes z zsh_reload)

if [[ $sysOS == "Darwin" ]]; then
    plugins+=(osx)
fi

if hash tmux 2>/dev/null; then
    plugins+=(tmux)
fi

if hash thefuck 2>/dev/null; then
    plugins+=(thefuck)
fi

# custom plugins
plugins+=(alias-tips k zsh-autosuggestions zsh-syntax-highlighting zsh-256color)

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

# Set personal aliases, overridin those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export DEFAULT_USER=$USER

if hash rbenv 2> /dev/null; then
    export PATH=$HOME/.rbenv/shims:$PATH
fi

if [[ $sysOS == "Darwin" ]]; then
    export PATH=/usr/local/sbin:$PATH

    # Homebrew bottles
    if hash brew 2>/dev/null; then
        export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
        # export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles
    fi
fi

# Golang
if hash go 2>/dev/null; then
    GO_CACHE=$HOME/.gopath/cache # First GOPATH, 'go get' saves files here, and it's always safe to be cleaned
    GO_PKGS=$HOME/.gopath/pkgs   # For 3rd party go packages, use 'gosave' to sync all packages from cache to this folder or moved manually
    GO_PROJ=$HOME/goprojects     # Your go projects root
    export GOPATH=$GO_CACHE:$GO_PKGS:$GO_PROJ
    export PATH=$PATH:$GO_CACHE/bin:$GO_PKGS/bin:$GO_PROJ/bin
    alias gosave='rsync -aAXv ${GO_CACHE}/ ${GO_PKGS}'
    #                    |||└─ increase verbosity
    #                    ||└─ preserve extended attributes
    #                    |└─ preserve ACLs (implies --perms)
    #                    └─ archive mode; equals -rlptgoD (no -H,-A,-X)
    alias goclean='[ -d "$GO_CACHE" ] && rm -rf ${GO_CACHE}/*'
    #                                                       └─ double rm verification in zsh
fi

# aliases
alias zshconf='$EDITOR ~/.zshrc'
alias ohmyzsh='$EDITOR ~/.oh-my-zsh'
alias h='history'
alias c='clear'

alias rmtags='rm -f GTAGS; rm -f GRTAGS; rm -f GPATH; rm -f TAGS'
alias rmelc='rm -f ~/.emacs.d/lisp/*.elc'
alias restart_emacs='emacsclient -e "(let ((last-nonmenu-event nil) (kill-emacs-query-functions nil)) (save-buffers-kill-emacs t))" && te'

alias upgrade_dotfiles='cd ~/.dotfiles && git pull --rebase --stat origin master && cd - >/dev/null && src'
alias upgrade_emacs='cd ~/.emacs.d && git pull --rebase --stat origin master && cd - >/dev/null'
alias upgrade_oh_my_tmux='cd ~/.tmux && git pull --rebase --stat origin master && cd - >/dev/null'
alias upgrade_env='upgrade_dotfiles && sh ~/.dotfiles/install.sh'

# proxy
alias setproxy='export http_proxy=http://127.0.0.1:1087; export https_proxy=http://127.0.0.1:1087;'
alias unsetproxy='export http_proxy=; export https_proxy='
alias showproxy='echo "http_proxy=$http_proxy"; echo "https_proxy=$https_proxy"'
if [ -f /opt/XX-Net/start ]; then
    alias startproxy='/opt/XX-Net/start'
    alias setproxy='export http_proxy=http://127.0.0.1:8087; export https_proxy=http://127.0.0.1:8087'
fi

# bind P and N for EMACS mode
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

# Fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Source customization
if [ -f ~/.zshrc.local ]; then source ~/.zshrc.local; fi
