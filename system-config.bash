#!/bin/bash

# options used
# $LUBUILD_HARDWARE_TYPE_EXTERNAL_SCREEN
# $LUBUILD_HARDWARE_TYPE_LAPTOP 
# $LUBUILD_HARDWARE_TYPE_LIVEUSB
# $LUBUILD_HARDWARE_TYPE_DVD


#################################
### HP Linux Imaging & Printing project (HPLIP) - HP printer & scanner drivers

# now distributed via repos
sudo apt-get install -y hplip hplip-gui

# *** VERSION FIXES ***
# credit https://help.ubuntu.com/community/HpAllInOne#error:_hp-setup_requires_GUI_support
if [[ "${DESKTOP_SESSION} $(lsb_release -sr)" == "Lubuntu 14.04" ]] then 
   sudo apt-get install -y python-qt4 ; 
fi
if [[ "${DESKTOP_SESSION} $(lsb_release -sr)" == "Lubuntu 15.04" ]] then 
   sudo apt-get install -y python3-pyqt4 ; 
fi
if [[ "${DESKTOP_SESSION} $(lsb_release -sr)" == "ubuntustudio 16.10" ]] then 
   sudo apt-get install -y python3-pyqt5 ; 
fi

sudo hp-setup
# help - https://help.ubuntu.com/community/HpAllInOne


## alternative for manual install (or latest version)
# xdg-open http://hplipopensource.com/hplip-web/install/install/index.html 
## launch the downloaded installer by entering the following, then TAB to autocomplete, then ENTER
# bash `xdg-user-dir DOWNLOAD`/hplip*.run


# First time around you can check compatibility at 
# xdg-open http://hplipopensource.com/hplip-web/install_wizard/index.html

# should also include XSANE scanner


### webcam

if [[ LUBUILD_HARDWARE_TYPE_LAPTOP -eq TRUE ]] ; then ( 
	# support for most webcams
	sudo apt-get install guvcview
) fi


### Allow to play DVDs

if [[ LUBUILD_HARDWARE_TYPE_DVD -eq TRUE ]] ; then ( 
	# NB: both these commands are attended installs, needing some user interaction
	# credit https://help.ubuntu.com/stable/ubuntu-help/video-dvd-restricted.html
	sudo apt-get install -y libdvdnav4 libdvdread4 gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly libdvd-pkg
	sudo dpkg-reconfigure libdvd-pkg
	# optional player app as alternative to MPlayer
	# sudo apt-get install -y vlc
) ; fi






######### Defaults for Users ###########
# (consider splitting off to seaparate script) #
# some default contents of home folder come from /etc/skel
# many ubuntu settings are in other places...
# e.g. The lxpanel default config file that needs to be edited for all new users is located at:
# /usr/share/lxpanel/profile/Lubuntu/panels/panel
# also check
#  /etc/xdg/lxsession/Lubuntu/desktop.conf 
# credit http://ubuntuforums.org/archive/index.php/t-2210805.html
# /usr/share/lubuntu/openbox/


######### register app(s) to use when dvd inserted ###########################
# STILL NEEDS DEVELOPING AND TESTING
sudo cp /usr/share/applications/defaults.list{,.`date +%y%m%d.%H%M%S`}
# in file  /usr/share/applications/defaults.list
# x-content/video-dvd=org.gnome.Totem.desktop
# x-content/video-vcd=org.gnome.Totem.desktop
# x-content/video-svcd=org.gnome.Totem.desktop
# need replacing with =gnome-mplayer.desktop

# sudo tee -a /etc/xdg/lubuntu/applications/defaults.list cat <<EOF!
# x-content/video-dvd=gnome-mplayer.desktop
# x-content/video-vcd=gnome-mplayer.desktop
# x-content/video-svcd=gnome-mplayer.desktop
# EOF!


######### toggle external screen display using SUPER-P ###########################
#
# this is now in user-config but could it be sys wide?
#
# ~/bin/toggle_external_monitor.sh
# ~/.config/openbox/lubuntu-rc.xml


# NB: If mouse pointer does not appear when you switch external monitor on then try the following:
# EITHER re-awaken X by switching consoles - CTRL-ALT-F1 then CTRL-ALT-F7 - credit https://bbs.archlinux.org/viewtopic.php?pid=648767#p648767
# OR suspend and resume
##############################################




##############################################
###### Localisation ##########################
##############################################

LUBUILD_LOCALE_LAYOUT=gb
LUBUILD_LOCALE_LANGUAGE=en_GB

# set keyboard map
setxkbmap -layout $LUBUILD_LOCALE_LAYOUT
# set default keyboard map in sessions 
echo '@setxkbmap -layout $LUBUILD_LOCALE_LAYOUT' | sudo tee -a /etc/xdg/lxsession/Lubuntu/autostart
# credit > http://askubuntu.com/questions/102344/switching-keyboard-layouts-in-lubuntu-11-10

# Add the rest of the language support
sudo apt-get -y install `check-language-support -l $LUBUILD_LOCALE_LANGUAGE`
# credit http://askubuntu.com/a/476719

# ensure that OpenOffice recognises the language thesaurus inside mythes-en-us
cd /usr/share/mythes/
sudo ln -s th_en_US_v2.idx th_$LUBUILD_LOCALE_LANGUAGE_v2.idx
sudo ln -s th_en_US_v2.dat th_$LUBUILD_LOCALE_LANGUAGE_v2.dat
# credit http://askubuntu.com/questions/42850/


#
### CDROM RO issue on Live USB ###
#
if [[ LUBUILD_HARDWARE_TYPE_LIVEUSB -eq TRUE ]] ; then ( 
sudo mount -o remount,rw,UID=`id -u` /cdrom
) ; fi
# credit > http://askubuntu.com/a/54622
# credit > http://unix.stackexchange.com/questions/47433/mount-usb-drive-fat32-so-all-users-can-write-to-it#comment66000_47433

# fix (requires manual changes)
# http://www.pendrivelinux.com/sharing-files-between-ubuntu-flash-drive-and-windows/
# workaround  
# http://askubuntu.com/a/57911

# if it's been used in windows, but not safely removed...
# help > http://ubuntuforums.org/showthread.php?p=7525441 


### suppress Boot messages

# For informative thread on hiding the text messages which appear during boot...
# [https://lists.ubuntu.com/archives/lubuntu-users/2014-December/008989.html]
# See esp the end solution and the archwiki link
