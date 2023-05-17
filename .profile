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

export PATH=/opt/homebrew/bin:$HOME/bin:$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH

export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-19.jdk/Contents/Home/
export JDK_HOME=/Library/Java/JavaVirtualMachines/jdk-19.jdk/Contents/Home/

export GOPATH=$HOME/.go
export DOCKER_DEFAULT_PLATFORM=linux/arm64

alias gut='git'
alias got='git'
alias l='lsd -alh'
alias ll='lsd -alh'
alias vi='nvim'
alias vim='nvim'
alias rm='grm'
function spod; kubectl get pods --no-headers --field-selector=status.phase==Running | fzf -0 -1 (if set -q argv[1]; echo -q $argv[1]; end) | awk '{print $1}' | xargs -o -I {} kubectl exec -t -i {} -- bash; end
function kcc; kubectl config get-contexts --output name | fzf -0 -1 (if set -q argv[1]; echo -q $argv[1]; end) | awk '{print $1}' | xargs -o -I % kubectl config use-context %; end
function kcn; kubectl get namespaces --no-headers | fzf -0 -1 (if set -q argv[1]; echo -q $argv[1]; end)| awk '{print $1}' | xargs -o -I % kubectl config set-context --current --namespace %; end

source ~/.secrets
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
export PYTHONPATH=$HOME/.pyenv/versions/3.10.5/lib/python3.10/site-packages/
