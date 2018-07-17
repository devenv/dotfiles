#!/usr/bin/sh

rsync -avP --delete ~/.git /run/media/devenv/BD0A-8A72/home/
rsync -avP --delete ~/dy --exclude=target /run/media/devenv/BD0A-8A72/home/
rsync -avP --delete ~/Documents /run/media/devenv/BD0A-8A72/home/
