if test -d /opt/homebrew
    /opt/homebrew/bin/brew shellenv | source
end

if type -q starship
    starship init fish | source
end

if type -q zoxide
    zoxide init fish | source
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Aliases
alias reload='source $HOME/.config/fish/config.fish'
alias h='history'
alias c='clear'

if type -q eza
    alias ls='eza --color=auto --group-directories-first'
    alias lsi='ls --icons'
    alias l='ls -lhF'
    alias la='ls -lhAF'
    alias lg='ls -lhAF --git'
    alias li='ls -lhF --icons'
    alias tree='ls --tree'
end

if type -q bat
    alias cat='bat -p --wrap character'
end

if type -q fd
    alias find=fd
end

if type -q top
    alias top=btop
else if type -q btm
    alias top=btm
end

if type -q rg
    alias grep=rg
end

if type -q tldr
    alias help=tldr
end

if type -q delta
    alias diff=delta
end

if type -q duf
    alias df=duf
end

if type -q dust
    alias du=dust
end

if type -q hyperfine
    alias benchmark=hyperfine
end

if type -q gping
    alias ping=gping
end

if type -q paru
    alias yay=paru
end

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

if type -q cargo
    alias upgrade_cargo='cargo install cargo-update; cargo install-update -a'
end

if type -q gem
    alias upgrade_gem='gem update && gem cleanup'
end

if type -q go
    alias upgrade_go='$DOTFILES/install_go.sh'
end

if type -q brew
    alias bu='brew update; brew upgrade; brew cleanup'
    alias bcu='brew cu --all --yes --cleanup'
    alias bua='bu; bcu'
    alias upgrade_brew='brew bundle --global; bua'

    if type -q pip3
        alias upgrade_pip3="pip3 list --outdated --format=json | python3 -c '
        import json
        import sys

        for item in json.loads(sys.stdin.read()):
        print(\"=\".join([item[\"name\"], item[\"latest_version\"]]))
        ' | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U"
    end
end
