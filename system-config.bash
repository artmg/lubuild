#!/bin/bash

# options used
# $LUBUILD_HARDWARE_TYPE_EXTERNAL_SCREEN
# $LUBUILD_HARDWARE_TYPE_LAPTOP 


#
### Wifi issues after waking from hibernate or suspend ###
#
## credit - http://askubuntu.com/questions/365112/lubuntu-13-10-laptop-loses-wireless-after-sleep
## sudo not required :)
# nmcli nm sleep false
#
if [[ $LUBUILD_HARDWARE_TYPE_LAPTOP -eq TRUE ]] ; then ( 
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

# set GB keyboard map
setxkbmap -layout gb
# set GB as default keyboard map in sessions 
echo '@setxkbmap -layout gb' | sudo tee -a /etc/xdg/lxsession/Lubuntu/autostart
# credit > http://askubuntu.com/questions/102344/switching-keyboard-layouts-in-lubuntu-11-10

# Add the rest of the language support
sudo apt-get -y install `check-language-support -l en_GB`
# credit http://askubuntu.com/a/476719

# ensure that OpenOffice recognises the en_GB thesaurus inside mythes-en-us
cd /usr/share/mythes/
sudo ln -s th_en_US_v2.idx th_en_GB_v2.idx
sudo ln -s th_en_US_v2.dat th_en_GB_v2.dat
# credit http://askubuntu.com/questions/42850/



#######################
### *** ***  Live  USB  *** *** ###
#######################

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


