bind \e\[1\;5C forward-word
bind \e\[1\;5D backward-word
#bind \cleft backward-word
#bind \cright forward-word
set -g fish_prompt_pwd_dir_length 1
set -g theme_project_dir_length 1
set -U fish_key_bindings fish_default_key_bindings
set -g theme_powerline_fonts no
set -g theme_nerd_fonts yes
set -g theme_avoid_ambiguous_glyphs yes

set -g theme_display_cmd_duration yes
set -g theme_title_display_process yes

set -g theme_display_vi yes
set -g theme_display_vagrant no
set -g theme_display_docker_machine no
set -g theme_display_k8s_context no
set -g theme_display_hg no
set -g theme_display_virtualenv no
set -g theme_display_nix no
set -g theme_display_ruby no
set -g theme_display_node no
set -g theme_display_user ssh
set -g theme_display_hostname ssh
set -g theme_display_date no
fish_vi_key_bindings

#source ~/.credentials
source ~/.profile

#fish_vi_key_bindings

set -e fish_greeting
set -U grc_plugin_execs cat cvs df diff dig gcc g++ ls ifconfig make mount mtr netstat ping ps tail traceroute wdiff mvn

function fish_greeting
  date
end

set  -U grc_plugin --color


test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

set -g theme_date_format "+%H:%M"
set -g theme_show_exit_status yes
#set -g theme_display_git_master_branch yes
#set -g theme_display_git_ahead_verbose yes
#set -g theme_display_git_dirty_verbose yes
#set -g theme_display_git_stashed_verbose yes
set -g theme_display_cmd_duration yes
set -g theme_display_jobs_verbose yes
set -g theme_color_scheme terminal2

function bind_bang
    switch (commandline -t)[-1]
        case "!"
            commandline -t $history[1]; commandline -f repaint
        case "*"
            commandline -i !
    end
end

function bind_dollar
    switch (commandline -t)[-1]
        case "!"
            commandline -t ""
            commandline -f history-token-search-backward
        case "*"
            commandline -i '$'
    end
end

function fish_user_key_bindings
    bind ! bind_bang
    bind '$' bind_dollar
end
