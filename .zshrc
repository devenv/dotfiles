source $HOME/.profile
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

DISABLE_AUTO_UPDATE=true
export ZSH="$HOME/.oh-my-zsh"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#585b70"

plugins=(fzf kubectl nilus)

source $ZSH/oh-my-zsh.sh
# setopt inc_append_history

eval "$(oh-my-posh init zsh -c ~/.config/fish/catppuccin.omp.json)"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
test -e "${HOME}/.config/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" && source "${HOME}/.config/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
test -e "${HOME}/.config/zsh-autosuggestions.zsh" && source "${HOME}/.config/zsh-autosuggestions.zsh"

fd() {
  preview="git diff $@ --color=always -- {-1}"
  git diff $@ --name-only | fzf -m --ansi --preview $preview
}
vfd() {
  vim $(fd $@)
}
