bind \e\[1\;5C forward-word
bind \e\[1\;5D backward-word
bind \cleft backward-word
bind \cright forward-word
set -U fish_key_bindings fish_default_key_bindings

export EDITOR=vim
export VISUAL=$EDITOR
export GIT_EDITOR=$EDITOR
export LESS='-imJMWR'
export PAGER="less $LESS"
export MANPAGER=$PAGER
export GIT_PAGER=$PAGER
export BROWSER='firefox'
export WINEDEBUG=-all
export TERM=xterm-256color
export COLORTERM=truecolor
export XCURSOR_THEME=Obsidian

source ~/.credentials
export AWS_REGION=us-east-1
export _JAVA_OPTIONS=-Djline.terminal=jline.UnsupportedTerminal

export PATH=$HOME/jdk/bin:$HOME/maven/bin:$HOME/bin:/usr/local/bin:/usr/bin:/bin:$PATH

export JAVA_HOME=$HOME/jdk
export JDK_HOME=$HOME/jdk
export M2_HOME=$HOME/maven/
export GOPATH=$HOME/.go
export ANDROID_HOME=/data/Android/Sdk/
export KDEHOME=$HOME/.kde4

alias v='vim'
alias vi='vim'
alias i='vim'
alias gut='git'
alias got='git'
alias l='ls -alh'
alias ll='ls -alh'
alias ..='cd ..'
alias rmb='rm *~ -rf; rm .*~ -rf'
#alias rmball="find -name '*~' | xargs rm -rf && find -name '*.orig' | xargs rm -rf"
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
alias fn='find -name'

set -e fish_greeting
set -U grc_plugin_execs cat cvs df diff dig gcc g++ ls ifconfig make mount mtr netstat ping ps tail traceroute wdiff mvn

function fish_greeting
  date
end

set  -U grc_plugin --color

