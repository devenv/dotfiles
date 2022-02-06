set -e

sudo apt-get update
sudo apt-get install -y git vim htop tmux rsync sysstat
sudo systemctl set-default multi-user.target

git clone http://github.com/devenv/dotfiles.git
mv dotfiles/.git ./
git fetch --all
git reset origin/master --hard
cp .bashrc_remote .bashrc
cp .tmux.conf_remote .tmux.conf
cp .profile_remote .profile

vim +PlugInstall +qall

sudo rm /etc/xdg/lxsession/LXDE-pi/sshpwd.sh
sudo rm /etc/profile.d/sshpwd.sh
