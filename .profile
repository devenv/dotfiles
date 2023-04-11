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

export PYENV_ROOT="$HOME/.pyenv"
export PATH=$PYENV_ROOT/shims:$PYENV_ROOT/bin:$HOME/bin:$HOME/.local/bin:/Library/Java/JavaVirtualMachines/jdk-19.jdk/Contents/Home/bin/:/opt/homebrew/bin/:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH

export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-19.jdk/Contents/Home/
export JDK_HOME=/Library/Java/JavaVirtualMachines/jdk-19.jdk/Contents/Home/

export GOPATH=$HOME/.go
export DOCKER_DEFAULT_PLATFORM=linux/amd64

alias gut='git'
alias got='git'
alias l='lsd -alh'
alias ll='lsd -alh'
alias vi='nvim'
alias vim='nvim'

source ~/.secrets
