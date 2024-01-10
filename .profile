export LANG="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export TERM=xterm-color
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
export GIT_TERMINAL_PROMPT=0

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

export PATH=$HOME/.local/bin:/opt/homebrew/bin:$HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH
#export PY="$HOME/.pyenv/versions/3.10.5/lib/python3.10/site-packages"

export GOPATH=$HOME/.go

export MAKEPRG="tox"

alias gut='git'
alias got='git'
alias l='lsd -alh'
alias ll='lsd -alh'
alias vi='nvim'
alias vim='nvim'
alias rm='grm'
alias br='git checkout "$(git branch | fzf | tr -d "[:space:]")"'
alias gcp='git ci -a && git push'
alias tf='terraform'
alias kss='f() { kubectl get pods --no-headers --field-selector=status.phase==Running | { [[ -n "$1" ]] && grep "$1" || cat; } | fzf -0 -1 | awk "{print \$1}" | xpanes -c "kubectl exec -t -i {} -- env PYTHONPATH=\".\" bash" }; f'
alias ksi='f() { POD=$(kubectl get pods | fzf | awk "{print \$1}"); kubectl exec -it $POD -- /bin/bash -c "$(cat ~/bin/init_ssh_machine.sh); exec /bin/bash" }; f'


test -e "${HOME}/.secrets" && source "${HOME}/.secrets"
