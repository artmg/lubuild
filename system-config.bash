#!/bin/bash

# options used
# $LUBUILD_HARDWARE_TYPE_EXTERNAL_SCREEN
# $LUBUILD_HARDWARE_TYPE_LAPTOP 
# $LUBUILD_HARDWARE_TYPE_LIVEUSB


#
### Wifi issues after waking from hibernate or suspend ###
#
## credit - http://askubuntu.com/questions/365112/lubuntu-13-10-laptop-loses-wireless-after-sleep
## sudo not required :)
# nmcli nm sleep false
#
# before nmcli version 0.9.10 this was
#
# nmcli nm sleep false
#
# since nmcli version 0.9.10 this should now be
# nmcli networking on   # or simply    nmcli n on 
#
# and check with 
# nmcli general   # or simply    nmcli g
#
## if nmcli n on does not bring it out of sleep (check with nmcli -f state g)
## there appears to be no way with nmcli to turn STATE asleep into anything else
## so just restart the service
# sudo service network-manager restart
if [[ $LUBUILD_HARDWARE_TYPE_LAPTOP -eq TRUE ]] ; then ( 
sudo tee /usr/share/applications/wake-up-wifi.desktop cat <<EOF!
[Desktop Entry]
Type=Application
Name=Wake up Wifi
Exec=nmcli networking on
Terminal=false
Categories=System;
Icon=nm-signal-50
EOF!
) ; fi
###############################################


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
