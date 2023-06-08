export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
export PYTHONPATH=$HOME/.pyenv/versions/3.10.5/lib/python3.10/site-packages/

export ZSH="$HOME/.oh-my-zsh"

plugins=(fzf kubectl nilus)

source $ZSH/oh-my-zsh.sh

source $HOME/.profile

eval "$(oh-my-posh init zsh -c ~/.config/fish/catppuccin.omp.json)"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
test -e "${HOME}/.config/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" && source "${HOME}/.config/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
test -e "${HOME}/.config/zsh-autosuggestions.zsh" && source "${HOME}/.config/zsh-autosuggestions.zsh"
