#!/usr/bin/sh

ssh -tt $1 "git clone http://github.com/devenv/dotfiles.git; mv dotfiles/.git ./; git fetch --all; git reset origin/master --hard; cp .bashrc_remote .bashrc; cp .tmux.conf_remote .tmux.conf"
