sudo apt-get install -y git vim htop tmux

git clone http://github.com/devenv/dotfiles.git
mv dotfiles/.git ./
git fetch --all
git reset origin/master --hard
cp .bashrc_remote .bashrc
cp .tmux.conf_remote .tmux.conf
cp .profile_remote .profile

vim +PlugInstall +qall
