ZSH_AUTOSUGGEST_USE_ASYNC=true
source $HOME/.profile

DISABLE_AUTO_UPDATE=true
DISABLE_AUTO_TITLE=true
export ZSH="$HOME/.oh-my-zsh"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#585b70"

plugins=(fzf kubectl nilus)

source $ZSH/oh-my-zsh.sh
# setopt inc_append_history

eval "$(oh-my-posh init zsh -c ~/.config/fish/catppuccin.omp.json)"

# Disable zsh-tmux-auto-title plugin since we'll handle it ourselves
export ZSH_TMUX_AUTO_TITLE_DISABLED=1

# Add hook to update tmux window title with git branch on prompt
typeset -gA _zsh_git_cache
_zsh_git_cache[time]=0
_zsh_git_cache[pwd]=""
_zsh_git_cache[branch]=""

function _update_title_with_git() {
    [[ -z "$TMUX" ]] && return

    local current_dir=$(basename "$(pwd)")
    local title="$current_dir"
    local now=$(date +%s)
    local elapsed=$((now - ${_zsh_git_cache[time]:-0}))

    # Use cache if within 3 seconds and same directory
    if [[ $elapsed -lt 3 && "${_zsh_git_cache[pwd]}" == "$(pwd)" ]]; then
        local branch="${_zsh_git_cache[branch]}"
        if [[ -n "$branch" ]]; then
            title="$current_dir [$branch]"
        fi
    else
        # Cache miss - check if in git repo and query branch
        if git rev-parse --git-dir >/dev/null 2>&1; then
            local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
            _zsh_git_cache[time]=$now
            _zsh_git_cache[pwd]="$(pwd)"
            _zsh_git_cache[branch]="$branch"

            if [[ -n "$branch" ]]; then
                title="$current_dir [$branch]"
            fi
        else
            # Not in git repo
            _zsh_git_cache[time]=$now
            _zsh_git_cache[pwd]="$(pwd)"
            _zsh_git_cache[branch]=""
        fi
    fi

    # Use tmux command to set window name directly (uses current window)
    # Debug: echo "DEBUG: Setting title to '$title'" >&2
    tmux rename-window "$title" 2>/dev/null
}

# Add to precmd so it runs when idle
precmd_functions+=(_update_title_with_git)

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
export PATH="$HOME/bin:$PATH"
