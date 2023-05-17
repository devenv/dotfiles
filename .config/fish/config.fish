bind \e\[1\;5C forward-word
bind \e\[1\;5D backward-word
set -U fish_key_bindings fish_default_key_bindings

source ~/.profile
for file in ~/.config/fish/functions/*.fish
  source $file
end

oh-my-posh init fish --config ~/.config/fish/catppuccin.omp.json | source

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
export PYTHONPATH=$HOME/.pyenv/versions/3.10.5/lib/python3.10/site-packages/
