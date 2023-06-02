export LANG="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export C_INCLUDE_PATH=/opt/homebrew/Cellar/librdkafka/2.1.1/include
export LIBRARY_PATH=/opt/homebrew/Cellar/librdkafka/2.1.1/lib

export EDITOR=nvim
export VISUAL=$EDITOR
export GIT_EDITOR=$EDITOR
export LESS='-imJMWR'
export PAGER="less"
export MANPAGER=$PAGER
export BROWSER='firefox'
export COLORTERM=truecolor

export AWS_REGION=us-east-1
export LC_ALL=en_US.UTF-8

export FZF_TMUX_HEIGHT=20
export FZF_DEFAULT_OPTS="-m --bind ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all"

export PATH=$HOME/.pyenv/shims/:/opt/homebrew/bin:$HOME/bin:$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH

export MYPYPATH=$HOME/nilus/
export MYPY_CACHE_DIR=$HOME/.mypy_cache

export GOPATH=$HOME/.go
export DOCKER_DEFAULT_PLATFORM=linux/arm64

alias gut='git'
alias got='git'
alias l='lsd -alh'
alias ll='lsd -alh'
alias vi='nvim'
alias vim='nvim'
alias rm='grm'

test -e "${HOME}/.secrets" && source "${HOME}/.secrets"
