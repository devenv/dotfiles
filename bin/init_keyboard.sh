#!/usr/bin/sh
~/bin/set_keyboard_layout
xset r rate 150 150
xmodmap -e "remove lock = Caps_Lock"
xmodmap ~/.Xmodmap
~/bin/caps_grave.sh &
kbdd &
#xinput --set-prop 'pointer:Logitech MX Master' 'libinput Accel Speed' -0.2
