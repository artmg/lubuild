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
