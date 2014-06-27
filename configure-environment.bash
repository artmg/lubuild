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


### Screen locking issues in 14.04
# do we want to force screensaver to lock, or let user config manually?
#
# change C-A-L lock shortcut to use light locker
sed -i 's/lxsession-default lock/light-locker-command -l/' ~/.config/openbox/lubuntu-rc.xml



if [[ $LUBUILD_HARDWARE_TYPE_LAPTOP -eq TRUE ]] ; then ( 
###Set laptop mode
# credit > http://askubuntu.com/a/361286
echo modify the following setting in the named section ; \
echo [State] ; \
echo laptop_mode=yes ; \
sudo gnome-text-editor ~/.config/lxsession/Lubuntu/desktop.conf 
) ; fi



######### toggle external screen display using SUPER-P ###########################
#
### MANUALLY ***** check screen IDs
# 
# use gui to activate both monitors
# command to identify internal and external monitors
xrandr  -q|grep connected
# e.g.
# LVDS connected 1366x768+0+0 (normal left inverted right x axis y axis) 256mm x 144mm
# HDMI-0 connected 1920x1080+0+0 (normal left inverted right x axis y axis) 509mm x 286mm
# VGA-0 disconnected (normal left inverted right x axis y axis)

#
# ensure there are no trailing spaces after \\
#
if [[ $LUBUILD_HARDWARE_TYPE_LAPTOP -eq TRUE ] && [ $LUBUILD_HARDWARE_TYPE_EXTERNAL_SCREEN -eq TRUE ]] ; then ( 
mkdir -p ~/bin
cat <<-EOF! > ~/bin/toggle_external_monitor.sh
#!/bin/bash
# credit - http://crunchbang.org/forums/viewtopic.php?id=28846
   INTERNAL_DEVICE=LVDS \\
&& EXTERNAL_DEVICE=HDMI-0 \\
&& EXTERNAL_IN_USE="HDMI.*1920x1080+0+0" \\
&& xrandr | grep -q "\$EXTERNAL_IN_USE"  \\
&& xrandr --output \$INTERNAL_DEVICE --auto --output \$EXTERNAL_DEVICE --off \\
|| xrandr --output \$INTERNAL_DEVICE --auto --output \$EXTERNAL_DEVICE --auto
# multiway options 
# credit - http://www.thinkwiki.org/wiki/Sample_Fn-F7_script
EOF!
chmod +x ~/bin/toggle_external_monitor.sh

# insert section.....
#  <keybind key="W-p">
#    <action name="Execute">
#      <command>~/bin/toggle_external_monitor.sh</command>
#    </action>
#  </keybind>
cp ~/.config/openbox/lubuntu-rc.xml{,.`date +%y%m%d`}

cat ~/.config/openbox/lubuntu-rc.xml.`date +%y%m%d` \
| xmlstarlet ed \
 -s "/_:openbox_config/_:keyboard" \
   -t elem -n keybind  \
| xmlstarlet ed \
 -i "/_:openbox_config/_:keyboard/_:keybind[last()]" \
   -t attr -n key -v W-p \
 -s "/_:openbox_config/_:keyboard/_:keybind[last()]" \
   -t elem -n action  \
| xmlstarlet ed \
 -i "/_:openbox_config/_:keyboard/_:keybind[last()]/_:action" \
   -t attr -n name -v Execute \
 -s "/_:openbox_config/_:keyboard/_:keybind[last()]/_:action" \
   -t elem -n command  \
| xmlstarlet ed \
 -s "/_:openbox_config/_:keyboard/_:keybind[last()]/_:action/_:command" \
   -t text -n text -v "~/bin/toggle_external_monitor.sh" \
> ~/.config/openbox/lubuntu-rc.xml

openbox --reconfigure

) ; fi
##############################################



# Laptop Lid settings - ignore lid close
if [[ $LUBUILD_HARDWARE_TYPE_LAPTOP -eq TRUE ] && [ $LUBUILD_HARDWARE_TYPE_EXTERNAL_SCREEN -eq TRUE ]] ; then ( 
# credit - http://askubuntu.com/questions/407287/change-xfce4-power-manager-option-from-terminal
# credit - http://docs.xfce.org/xfce/xfce4-power-manager/preferences
# help - http://docs.xfce.org/xfce/xfconf/xfconf-query
# help - http://git.xfce.org/xfce/xfce4-power-manager/plain/src/xfpm-xfconf.c

# if you want to check current settings
# xfconf-query -c xfce4-power-manager -l -v
# or
# cat ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml 

# No action on lid close
xfconf-query -c xfce4-power-manager -n -p "/xfce4-power-manager/lid-action-on-ac" -t int -s 0
xfconf-query -c xfce4-power-manager -n -p "/xfce4-power-manager/lid-action-on-battery" -t int -s 0
) ; fi


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


