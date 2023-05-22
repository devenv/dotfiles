export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
export PYTHONPATH=$HOME/.pyenv/versions/3.10.5/lib/python3.10/site-packages/

plugins=(fzf kubectl last-working-dir nilus zsh-autosuggestions zsh-history-substring-search)

export ZSH="$HOME/.oh-my-zsh"

fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
source $ZSH/oh-my-zsh.sh
source $HOME/.profile

eval "$(oh-my-posh init zsh -c ~/.config/fish/catppuccin.omp.json)"

source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh

# alt-↑
bindkey '^[^[OA' insert-last-word '^[^[[A' insert-last-word
# alt-↓
bindkey '^[^[OB' insert-next-word '^[^[[B' insert-next-word

# ↑
bindkey "${terminfo[kcuu1]}" history-substring-search-up
# ↓
bindkey "${terminfo[kcud1]}" history-substring-search-down
