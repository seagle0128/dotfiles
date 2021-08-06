# ZSH envioronment

export LANG="en_US.UTF-8"
export TERM=xterm-256color
export DEFAULT_USER=$USER
export EDITOR='emacsclient -a ""'
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/sbin:$PATH

# zinit
export PATH=$HOME/.zinit/polaris/bin:$PATH

# Cask
export PATH=$HOME/.cask/bin:$PATH

# Golang
export GO111MODULE=auto
export GOPROXY=https://goproxy.cn # https://athens.azurefd.net
export GOPATH=$HOME/go
export PATH=${GOPATH//://bin:}/bin:$PATH

# Rust
export PATH=$HOME/.cargo/bin:$PATH
