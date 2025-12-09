#!/bin/bash
set -e

# Modern macOS Development Environment Setup
# This script sets up a complete development environment with:
# - Version managers for multiple languages (nvm, pyenv, rustup)
# - Modern CLI tools and utilities
# - Neovim with LazyVim
# - Tmux with plugins
# - Window management (AeroSpace, Karabiner)
# - Development tools (Docker, Terraform, AWS CLI, etc.)

echo "🚀 Starting macOS development environment setup..."

# Step 1: Xcode Tools
echo "📦 Installing Xcode command line tools..."
xcode-select --install 2>/dev/null || true

# Step 2: Homebrew
echo "📦 Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || true
eval "$(/opt/homebrew/bin/brew shellenv)"

# Step 3: Essential tools
echo "📦 Installing essential tools..."
brew install rsync git curl wget

# Step 4: Dotfiles setup
echo "📂 Setting up dotfiles..."
if [ ! -d "$HOME/dotfiles" ]; then
  git clone https://github.com/devenv/dotfiles.git "$HOME/dotfiles"
fi
rsync -avP "$HOME/dotfiles/" "$HOME/" --exclude=.git

# Step 5: SSH Keys
echo "🔑 Setting up SSH keys..."
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
if [ ! -d "$HOME/.ssh/.git" ]; then
  git clone https://github.com/devenv/ssh-keys.git "$HOME/.ssh"
fi
chmod 600 "$HOME/.ssh"/*

# Step 6: Shell and environment
echo "🐚 Setting up shell environment..."
brew install zsh
chsh -s /opt/homebrew/bin/zsh

# Step 7: Language runtime managers
echo "🔧 Installing language runtime managers..."
brew install nvm pyenv rbenv rustup

# Step 8: Languages and runtimes
echo "📚 Installing language runtimes..."
brew install python@3.14 node ruby go lua luajit clojure openjdk

# Step 9: Core development tools
echo "🛠️ Installing core development tools..."
brew install neovim tmux git-delta fzf ripgrep fd bat lsd tree-sitter cmake make autoconf automake

# Step 10: CLI utilities
echo "⚙️ Installing CLI utilities..."
brew install jq yq aws-cli docker kubectl tfenv tox mypy ruff

# Step 11: Productivity tools
echo "🎯 Installing productivity tools..."
brew install tldr duf du-dust gh btop htop

# Step 12: Development dependencies
echo "📦 Installing development dependencies..."
brew install librdkafka openssl readline ncurses sqlite

# Step 13: System tools and customization
echo "⚙️ Installing system tools..."
brew install karabiner-elements aerospace

# Step 14: Terminal and UI utilities
echo "🎨 Installing UI utilities..."
brew install --cask iterm2 discord

# Step 15: Terminal fonts
echo "🔤 Installing terminal fonts..."
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font font-iosevka-nerd-font

# Step 16: oh-my-zsh
echo "📝 Setting up oh-my-zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || true
fi

# Step 17: oh-my-posh
echo "🎨 Installing oh-my-posh..."
brew install oh-my-posh

# Step 18: Zsh plugins
echo "📦 Installing zsh plugins..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$ZSH_CUSTOM/plugins"

git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" 2>/dev/null || true
git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" 2>/dev/null || true

# Step 19: Tmux plugin manager
echo "📦 Installing tmux plugin manager..."
mkdir -p "$HOME/.tmux/plugins"
git clone --depth 1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm" 2>/dev/null || true

# Step 20: Python development
echo "🐍 Setting up Python development..."
pip3 install --upgrade pip setuptools wheel
pip3 install pynvim

# Step 21: System defaults
echo "🔇 Configuring system defaults..."
# Key repeat settings
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 10
# Mouse settings
defaults write .GlobalPreferences com.apple.mouse.scaling -1
defaults write .GlobalPreferences com.apple.scrollwheel.scaling -1
# Disable system beep
defaults write com.apple.systemsound com.apple.sound.beep.volume -int 0
# Disable iTerm2 bell
defaults write com.googlecode.iterm2 VisualBell -bool false
defaults write com.googlecode.iterm2 AudibleBell -bool false

# Step 22: Neovim setup
echo "🔧 Configuring Neovim..."
mkdir -p "$HOME/.config/nvim"

# Step 23: Complete
echo ""
echo "✅ Setup complete!"
echo ""
