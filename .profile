export XCURSOR_THEME=Obsidian
export MPD_PORT=6601
export EDITOR=nvim
export VISUAL=$EDITOR
export GIT_EDITOR=$EDITOR
export LESS='-imJMWR'
export PAGER="less"
export MANPAGER=$PAGER
export GIT_PAGER=$PAGER
export BROWSER='firefox'
export WINEDEBUG=-all
#export TERM=xterm-256color
export COLORTERM=truecolor
export XCURSOR_THEME=Obsidian
export AWS_REGION=us-east-1
export LC_ALL=en_US.UTF-8
#export FZF_TMUX=1
export FZF_TMUX_HEIGHT=20
export FZF_DEFAULT_OPTS="-m --bind ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all"

export PYENV_ROOT="$HOME/.pyenv"
export PATH=$PYENV_ROOT/shims:$PYENV_ROOT/bin:$HOME/bin:/usr/bin:/usr/local/bin:/bin:$PATH
pyenv rehash
export LDFLAGS="-L/usr/local/opt/zlib/lib -L/usr/local/opt/bzip2/lib"
export CPPFLAGS="-I/usr/local/opt/zlib/include -I/usr/local/opt/bzip2/include"


export JAVA_HOME=$HOME/jdk
export JDK_HOME=$HOME/jdk
export M2_HOME=$HOME/maven/
export GOPATH=$HOME/.go
export ANDROID_HOME=/data/Android/Sdk/
#export _JAVA_OPTIONS=-Djline.terminal=jline.UnsupportedTerminal

alias gut='git'
alias got='git'
alias l='ls -alh'
alias ll='ls -alh'
alias ..='cd ..'
alias rmb='rm *~ -rf; rm .*~ -rf'
alias findg='find . | grep -v "\.git\|.svn\|.js.map" | grep -v -s "~" | xargs grep -n -s -i --color'
alias ducks='du -cks * | sort -rn | head -15'
alias dus='du -sh'
alias tree="tree -FC --charset=ascii"
alias psf='ps -opid,uid,cpu,time,stat,command'
alias clip='xclip -selection clipboard'
alias R='R --no-save'
alias watch='watch -n1'
alias in='task +in'
alias html='w3m -dump -T text/html -cols 200'
alias fn='find . -name'
alias vi='nvim'
alias vim='nvim'
alias sbt='env TERM=xterm-color sbt'
alias kp="ps -ef | fzf -m | awk '"'{ print $2 }'"' | xargs kill -9"
