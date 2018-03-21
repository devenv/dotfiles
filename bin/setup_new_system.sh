#!/bin/bash
cd
sudo pacman -S --needed --noconfirm base-devel
sudo pacman -S --noconfirm bumblebee nvidia lib32-virtualgl lib32-nvidia-utils
sudo pacman -S --noconfirm acpi acpi audacity autoconf automake aws-cli compton cups dconf-editor dia docker docker-compose easystroke evince feh filelight firefox fish gcc gcolor2 gdb gimp gvim htop jq libtool meld mutt neomutt mysql-workbench net-tools npm parcellite pavucontrol pv python-pip qiv rofi ruby scrot sxiv sysstat sysstat thunar tmux tmux unrar vlc xautolock xautomation xbindkeys xcape xclip xclip zathura zenity zip gksu google-chrome teamviewer python python2 python2-pip python-pip python2-gflags transset-df wireshark-qt xsel pkgfile mopidy mpc pass rsync openvpn gtk-theme-switch2 zathura-pdf-poppler dunst qalculate-gtk pulseaudio-equalizer ctags

sudo pip2 install gcalcli
sudo pip3 install pyinotify i3-py i3ipc tldextract

function aur_install () {
  cd
  git clone https://aur.archlinux.org/$1.git
  cd $1
  makepkg -si --noconfirm
}

aur_install grc
aur_install xv
aur_install pasystray
aur_install kbdd-git
aur_install google-musicmanager
aur_install autokey-py3
aur_install i3lock-cac03-git.git
aur_install veusz
aur_install enpass-bin
aur_install mps-youtube-git
aur_install urlview
aur_install viber
aur_install teamviewer
aur_install slack-desktop
aur_install messengerfordesktop-git

cd
wget https://downloads.jungledisk.com/jungledisk/junglediskworkgroup64-3222.tar.gz
cd /
sudo tar zxf ~/junglediskworkgroup64-3222.tar.gz
rm ~/junglediskworkgroup64-3222.tar.gz
