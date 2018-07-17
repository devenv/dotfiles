#!/usr/bin/sh
rm ~/Pictures/Screenshots/201*
DATE=`date '+%Y-%m-%d_%H:%M:%S'`
echo $DATE
scrot -s $DATE.png -e 'mv $f /home/devenv/Pictures/Screenshots/'
#$HOME/bin/effects/disperse -s 5 -d 2 -c 10 /home/devenv/Pictures/Screenshots/$DATE.png /home/devenv/Pictures/Screenshots/$DATE_dispersed.png
xclip -selection clipboard -t image/png -i "/home/devenv/Pictures/Screenshots/$DATE.png"
