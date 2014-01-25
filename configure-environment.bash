#!/bin/bash

# LUBUILD_HARDWARE_TYPE_WIFI=TRUE
# export LUBUILD_HARDWARE_TYPE_WIFI

#
### Wifi issues after waking from hibernate or suspend ###
#
## credit - http://askubuntu.com/questions/365112/lubuntu-13-10-laptop-loses-wireless-after-sleep
## sudo not required :)
# nmcli nm sleep false
#
if [[ $LUBUILD_HARDWARE_TYPE_WIFI -eq TRUE ]] ; then ( 
sudo tee /usr/share/applications/wake-up-wifi.desktop cat <<EOF!
[Desktop Entry]
Type=Application
Name=Wake up Wifi
Exec=nmcli nm sleep false
Terminal=false
Categories=System;
Icon=nm-signal-50
EOF!

) ; fi
## alternative
## https://bugs.launchpad.net/ubuntu/+source/systemd-shim/+bug/1184262
#sudo restart network-manager
## or   sudo killall NetworkManager
## and this article may have a bugfix to help
###############################################


#######################
### *** ***  Live  USB  *** *** ###
#######################

# set GB keyboard map
setxkbmap -layout gb
# set GB as default keyboard map in sessions 
echo '@setxkbmap -layout gb' | sudo tee -a /etc/xdg/lxsession/Lubuntu/autostart
# credit > http://askubuntu.com/questions/102344/switching-keyboard-layouts-in-lubuntu-11-10

### CDROM RO issue ################
# credit > http://askubuntu.com/a/54622
# credit > http://unix.stackexchange.com/questions/47433/mount-usb-drive-fat32-so-all-users-can-write-to-it#comment66000_47433
sudo mount -o remount,rw,UID=`id -u` /cdrom

# fix (requires manual changes)
# http://www.pendrivelinux.com/sharing-files-between-ubuntu-flash-drive-and-windows/
# workaround  
# http://askubuntu.com/a/57911

# if it's been used in windows, but not safely removed...
# help > http://ubuntuforums.org/showthread.php?p=7525441 

### LOCATION specific #######################################

# move to root of Wallet drive
cd /media/lubuntu/W_SD_8BU/

# open setup help
xdg-open Wallet/Service/Procedures/Setup/Public/Set\ up\ Ubuntu.html 

### BOOKMARKS #######################
cp ~/.gtk-bookmarks{,.`date +%y%m%d`}
# Add local music folder to bookmarks
echo file:///media/lubuntu/Default/Documents%20and%20Settings/UserName/Local%20Settings/Personal/Music Music.COPY | tee -a ~/.gtk-bookmarks


