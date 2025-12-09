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
export FZF_DEFAULT_OPTS=" \
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
  --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

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
export SQLALCHEMY_SILENCE_UBER_WARNING=1
export OLLAMA_HOST="http://127.0.0.1:11434"

export PATH="../venv/bin/:$HOME/.local/bin:/opt/homebrew/bin:$HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
#export PY="$HOME/.pyenv/versions/3.10.5/lib/python3.10/site-packages"

export GOPATH=$HOME/.go

export MAKEPRG="tox"

ulimit -n 4096

alias cl='claude --permission-mode bypassPermissions --model haiku'
alias cls='claude --permission-mode bypassPermissions --model sonnet'
alias clo='claude --permission-mode bypassPermissions --model opus'
alias ccl='core && cl'
alias ccom='common && cl'
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

# git shortcuts
alias gad='git add'
alias gadd='git add'
alias gbr='git br'
alias gci='git ci'
alias gco='git co'
alias gcob='git cob'
alias gcom='git com'
alias gdc='git dc'
alias gdi='git di'
alias gfa='git fa'
alias gfacob='git facob'
alias gfarbo='git farbo'
alias gmt='git mt'
alias gpr='git pr'
alias grb='git rb'
alias grba='git rba'
alias grbc='git rbc'
alias grbo='git rbo'
alias gst='git st'
alias gpush='git push'
alias gpull='git pull'
alias gfetch='git fetch'
alias gmerge='git merge'
alias gclean='git clean'
alias gclone='git clone'
alias gstash='git stash'
alias greb='git rebase'
alias gres='git reset'
alias gshow='git show'
alias glog='git log'

test -e "${HOME}/.secrets" && source "${HOME}/.secrets"
