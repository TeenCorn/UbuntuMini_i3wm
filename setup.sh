#!/bin/bash

## INSTALL SCRIPT FOR UBUNTU MINIMAL

## Downloads the all of the programs I use
basic_programs ()
{
	cd ~/
	sudo apt update -qq
	sudo apt install -yy -q xorg vim rofi feh compton pulseaudio pavucontrol firefox scrot ranger thunar ubuntu-restricted-extras git software-properties-common w3m build-essential cmake automake checkinstall lxappearance gtk-chtheme qt4-qtconfig network-manager redshift alarm-clock-applet mpd mpc ncmpcpp zip gdebi htop fonts-takao xbacklight notify-osd xdotool wmctrl wine imagemagick zsh language-pack-gnome-zh-hant language-pack-gnome-zh-hans language-pack-gnome-ja fcitx

	#Installing the latest mpv
	sudo add-apt-repository ppa:mc3man/mpv-tests -y
	sudo apt update -yy
	sudo apt install mpv -yy
}

## Prompts the user if they would like to delete flash, mainly due to security concerns, after downloading all the basic programs.
## I have not learned how to install ubuntu-restricted-extras without flash yet so that will be done later on.
flash_delete ()
{
	clear
	echo "Would you like to delete flash? y/n"
	read input

	if [ "$input" = "y" ]
	then
		sudo apt purge --auto-remove flashplugin-installer -yy
	fi
	
	sudo apt -yy install gstreamer1.0-plugins-{base,good,bad,ugly} gstreamer1.0-libav ## Getting a youtube videos to work without flash

}

## Downloads the lastest stable version of i3wm for Ubuntu. Don't like the one in the regular repo since it can't use json. Bumblebee-status and Polybar
## use json so that is the reason for it.
i3_install ()
{
	clear
	## This chuck gets the lastest stable version of i3wm on ubuntu.
	sudo /usr/lib/apt/apt-helper download-file http://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2017.01.02_all.deb keyring.deb SHA256:4c3c6685b1181d83efe3a479c5ae38a2a44e23add55e16a328b8c8560bf05e5f
	sudo apt install ./keyring.deb
	sudo su -c "echo 'deb http://debian.sur5r.net/i3/ $(grep '^DISTRIB_CODENAME=' /etc/lsb-release | cut -f2 -d=) universe' >> /etc/apt/sources.list.d/sur5r-i3.list"
	sudo apt update -qq
	sudo apt install -yy i3

	#Install i3-gaps && it's dependencies
	sudo apt install libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf libxcb-xrm-dev -yy

	sudo add-apt-repository ppa:aguignard/ppa -y
	sudo apt update -y
	sudo apt-get install libxcb-xrm-dev -yy

	sudo apt upgrade -yy

	cd
	git clone https://www.github.com/Airblader/i3 i3-gaps
	cd i3-gaps

	autoreconf --force --install
	rm -rf build/
	mkdir -p build && cd build/

	../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
	make
	sudo make install
}

## I don't need all the python packages here. Haven't figured out which ones I don't need.
python_stuff ()
{
	sudo apt -yy install python3.5 python3-lxml python-tox python3-pyqt5 python3-pyqt5.qtwebkit python3-pyqt5.qtquick python3-sip python3-jinja2 python3-pygments python3-yaml python3-pip python-dev python3-dev	## Installing python
	pip3 install mps-youtube youtube_dl

}

## Downloads all my fonts and my plugin manager for vim
git_stuff ()
{
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim	## Vim plugins
	
}

## Downloads my terminal emulator termite
term ()
{
	cd ~/
	##Termite Install
	wget https://raw.githubusercontent.com/Corwind/termite-install/master/termite-install.sh
	chmod +x termite-install.sh
	./termite-install.sh
	rm termite-install.sh
}

## Downloads all dependencies for polybar and builds it from github.
polybar_install ()
{
	cd ~/
	sudo apt install cmake cmake-data libcairo2-dev libxcb1-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-image0-dev libxcb-randr0-dev libxcb-util0-dev libxcb-xkb-dev pkg-config python-xcbgen xcb-proto libxcb-xrm-dev i3-wm libasound2-dev libmpdclient-dev libiw-dev libcurl4-openssl-dev -yy
	
	git clone --branch 3.0.5 --recursive https://github.com/jaagr/polybar
	mkdir polybar/build
	cd polybar/build
	cmake ..
	sudo make install
}

## Downloads all my configurations for my setup
confs ()
{
	##Getting configs
	cd ~/
	git clone https://github.com/TeenCorn/UbuntuMini_i3wm.git
	cd UbuntuMini_i3wm/
	mkdir ~/.config
	mkdir ~/.config/i3
	cp -R .config/i3 ~/.config/
	cp -R .config/.mpd/ ~/.config/
	cp -R .config/.ncmpcpp/ ~/.config/
	cp -R .config/polybar/ ~/.config/
	cp -R .config/termite ~/.config/
	cp -R .config/ranger ~/.config/
	cp -R .config/.vimrc ~/
	cp -R .fonts/ ~/
	cp -R .zsh/ ~/
	cp .zshrc ~/
	cp .zprofile ~/
	cp .profile ~/
	wget https://raw.githubusercontent.com/TeenCorn/UbuntuMini_i3wm/master/wall.jpg
	mv wall.jpg ~/.config/
	cd .. && rm -rf UbuntuMini_i3wm/

	vim +PluginInstall +qall
}

winePro ()
{
	#Downloads Foxit reader
	mkdir -p ~/Downloads/wine
	cd ~/Downloads/wine
	wget --header='Host: dl-web.dropbox.com' --header='User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:56.0) Gecko/20100101 Firefox/56.0' --header='Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' --header='Accept-Language: en-US,en;q=0.5' --header='Referer: https://www.dropbox.com/' --header='Cookie: locale=en; t=rzYgk-qUudU1uE6Uv4oKy0io; _ga=GA1.2.350055373.1510123821; blid=AABhIx8kX-zQii2Sibyf1tJ48mfpcfzULgmzJDpjo0tsug; bjar=W3sidWlkIjogNzE1MDAxMjg3LCAic2Vzc19pZCI6IDkyNzY3MTUzMjgyNjQ5Mjg5NjMzOTE1OTQ5NTUyNTMxMTM2NzQ3LCAiZXhwaXJlcyI6IDE1MTA0MzU1NzksICJ0ZWFtX2lkIjogIiIsICJyb2xlIjogInBlcnNvbmFsIn1d; last_active_role=personal' --header='Connection: keep-alive' --header='Upgrade-Insecure-Requests: 1' 'https://dl-web.dropbox.com/get/i3wm_Stuff/FoxitReader90_enu_Setup_Clean.exe?_download_id=7106491938436524493329434914874724554205174303734012627366031487841&_notify_domain=www.dropbox.com&_subject_uid=715001287&dl=1&w=AAA0sdGSkWo8HddZRCfJucZsyvaA7zTeoEGu2_NTQ-Bmrw' -O 'FoxitReader90_enu_Setup_Clean.exe' -c
}

basic_programs
flash_delete
i3_install
python_stuff
git_stuff
term
polybar_install
confs
wine
cd ~/ && rm setup.sh
chsh -s $(which zsh)

clear
echo "Want to reboot? y/n: "
read option
if [[ $option == "y" ]]
then
	sudo reboot
fi
