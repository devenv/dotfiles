export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
export PYTHONPATH=$HOME/.pyenv/versions/3.10.5/lib/python3.10/site-packages/

plugins=(fzf kubectl last-working-dir nilus zsh-autosuggestions zsh-history-substring-search)

source $HOME/.profile

eval "$(oh-my-posh init zsh -c ~/.config/fish/catppuccin.omp.json)"

# alt-↑
bindkey '^[^[OA' insert-last-word '^[^[[A' insert-last-word
# alt-↓
bindkey '^[^[OB' insert-next-word '^[^[[B' insert-next-word

# ↑
bindkey "${terminfo[kcuu1]}" history-substring-search-up
# ↓
bindkey "${terminfo[kcud1]}" history-substring-search-down

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
