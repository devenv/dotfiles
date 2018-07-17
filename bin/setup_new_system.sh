#!/bin/bash

cd

sudo chsh devenv -s /usr/bin/fish

sudo gpasswd --add devenv docker
sudo gpasswd --add devenv vboxusers
sudo gpasswd --add devenv video
sudo gpasswd --add devenv bumblebee

sudo systemctl enable bumblebeed
sudo systemctl start bumblebeed
sudo systemctl enable ntpd
sudo systemctl start ntpd

sudo cp ~/bin/etc/70-synaptics.conf /etc/X11/xorg.conf.d/
sudo cp ~/bin/etc/inotify.conf /etc/sysctl.d/
sudo cp ~/bin/etc/i8k.conf /etc/modprobe.d/
sudo cp ~/bin/etc/i8kmon.conf /etc/
sudo cp ~/bin/etc/cpupower /etc/default/
sudo cp ~/bin/etc/logind.conf /etc/systemd/

sudo cp /etc/anarchy-release /etc/arch-release -f

sudo pacman -S --needed --noconfirm base-devel
sudo pacman -S --noconfirm bumblebee nvidia lib32-virtualgl lib32-nvidia-utils base-devel acpi acpi audacity autoconf automake aws-cli compton cups dconf-editor dia docker docker-compose easystroke evince feh filelight firefox fish gcc gcolor2 gdb htop jq libtool meld mutt neomutt net-tools parcellite pavucontrol pv python2-pip qiv rofi ruby scrot sxiv sysstat sysstat thunar tmux tmux unrar vlc xautolock xautomation xbindkeys xcape xclip xclip zathura zenity zip python python-pip transset-df wireshark-qt xsel pkgfile pass rsync openvpn gtk-theme-switch2 zathura-pdf-poppler dunst qalculate-gtk pulseaudio-equalizer ctags cscope wine playonlinux dex tcpdump gthumb sox cronie dbus-python qt5 grc primus openssh npm ack mercurial luajit physfs flashplugin openvpn dos2unix cmake strace dnsutils neomutt iftop vagrant rtorrent tcl tk perl-xml-libxslt cpupower ntp apm dmenu neovim

sudo pip2 install gcalcli
sudo pip3 install pyinotify i3-py i3ipc tldextract

sudo npm install -g gcal

function aur_install () {
  cd
  git clone https://aur.archlinux.org/$1.git
  cd $1
  git pull
  makepkg -si --noconfirm
}

aur_install kbdd-git
aur_install i3lock-cac03-git
aur_install pavolume-git
aur_install i8kutils
aur_install xv
aur_install q
aur_install urlview
aur_install enpass-bin
aur_install mkpasswd
aur_install dropbox
aur_install slack-desktop
aur_install messengerfordesktop-bin
aur_install veusz.git
aur_install autokey-py3
aur_install teamviewer
aur_install dwarffortress-lnp-git

#echo "/etc/default/grub:\
#GRUB_CMDLINE_LINUX_DEFAULT='acpi_osi=! acpi_osi="Windows 2009" quiet splash vga=792'
#GRUB_TERMINAL_INPUT=text
#GRUB_GFXMODE=1024x768x32

#grub-mkconfig -o /boot/grub/grub.cfg"

cd
wget https://downloads.jungledisk.com/jungledisk/junglediskworkgroup64-3222.tar.gz
tar zxf ~/junglediskworkgroup64-3222.tar.gz
rm junglediskworkgroup64-3222.tar.gz
sudo rsync -avP jungledisk-workgroup-3.22.2-linux-x86_64/usr/* /usr/
rm jungledisk-workgroup-3.22.2-linux-x86_64 -rf

cd
git clone https://aur.archlinux.org/git-secrets
cd git-secrets
make install
git secrets --register-aws --global
git secrets --install ~/.git-templates/git-secrets
git config --global init.templateDir ~/.git-templates/git-secrets

sudo cp ~/.git /root -r
sudo sh -c "cd /root && git reset HEAD --hard"
