bind \e\[1\;5C forward-word
bind \e\[1\;5D backward-word
bind \cleft backward-word
bind \cright forward-word
set -U fish_key_bindings fish_default_key_bindings

source ~/.credentials
source ~/.profile

#fish_vi_key_bindings

set -e fish_greeting
set -U grc_plugin_execs cat cvs df diff dig gcc g++ ls ifconfig make mount mtr netstat ping ps tail traceroute wdiff mvn

function fish_greeting
  date
end

set  -U grc_plugin --color

