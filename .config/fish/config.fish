bind \e\[1\;5C forward-word
bind \e\[1\;5D backward-word

source ~/.profile
oh-my-posh init fish --config ~/.config/fish/catppuccin.omp.json | source

set -U fish_key_bindings fish_default_key_bindings

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

