cd ~

apt-get update && apt-get install -y git neovim tmux wget fzf cmake

wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
tar zxf nvim-linux64.tar.gz
rm nvim-linux64.tar.gz

rm -rf dotfiles
git clone http://github.com/devenv/dotfiles.git
rm -rf .git .bashrc_remote .tmux.conf_remote .profile_remote
mv -f dotfiles/.git ./
git fetch --all
git reset origin/master --hard

cp -f .bashrc_remote .bashrc
cp -f .tmux.conf_remote .tmux.conf
cp -f .profile_remote .profile

pip install debugpy python-lsp-server

