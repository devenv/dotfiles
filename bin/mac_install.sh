#!/bin/sh

# before starting - install the keys from the secret repo

xcode-select --install

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install rsync git
git clone https://github.com/devenv/dotfiles.git
rsync -avP dotfiles/ ~/
mkdir ~/.ssh
chmod 600 ~/.ssh
cd ~/.ssh
git clone https://github.com/devenv/ssh-keys.git .

eval "$(/opt/homebrew/bin/brew shellenv)"

brew install --force autoconf automake awscli bat cataclysm catimg clojure cmake cscope espanso extract_url fish fpp fzf gcc git graphviz gsed highlight htop imagemagick ispell iterm2 jq lua luajit lynx ncurses neovim nethack node nvm openjdk openssl@1.1 python@3.9 pyenv pyvim qcachegrind ranger readline remind ruby rust skhd sqlite telnet tmux tree-sitter universal-ctags urlview vim w3m wget yabai zsh discord dwarf-fortress-lmp mysqlworkbench ngrok notion rar spotify steam git-delta dog tldr duf delta

brew tap homebrew/cask-fonts
brew install --cask font-iosevka
brew install --cask font-hack-nerd-font

brew install koekeishiya/formulae/skhd
brew services start skhd

brew install koekeishiya/formulae/yabai
brew services start yabai

brew install --cask alt-tab

defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 10
defaults write .GlobalPreferences com.apple.mouse.scaling -1
defaults write .GlobalPreferences com.apple.scrollwheel.scaling -1

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/tpm

curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
fisher install jethrokuan/fzf

omf install
pip3 install neovim

sudo gem install coderay

