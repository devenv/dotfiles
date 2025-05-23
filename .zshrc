ZSH_AUTOSUGGEST_USE_ASYNC=true
source $HOME/.profile

DISABLE_AUTO_UPDATE=true
export ZSH="$HOME/.oh-my-zsh"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#585b70"

plugins=(fzf kubectl nilus)

source $ZSH/oh-my-zsh.sh
# setopt inc_append_history

eval "$(oh-my-posh init zsh -c ~/.config/fish/catppuccin.omp.json)"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
test -e "${HOME}/.config/zsh-autosuggestions.zsh" && source "${HOME}/.config/zsh-autosuggestions.zsh"
test -e "${HOME}/.config/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" && source "${HOME}/.config/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

fd() {
  preview="git diff $@ --color=always -- {-1}"
  git diff $@ --name-only | fzf -m --ansi --preview $preview
}
vfd() {
  vim $(fd $@)
}
export LIBRARY_PATH=/opt/homebrew/lib
export C_INCLUDE_PATH=/opt/homebrew/include
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/homebrew/opt/mpdecimal/lib
