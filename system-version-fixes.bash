#!/bin/bash

MODEL_NO=`sudo dmidecode -s system-product-name`
RELEASE=`lsb_release -sr`

# credit - https://bugs.launchpad.net/ubuntu/+source/pcmanfm/+bug/975152/comments/17
# still an issue in Lubuntu 14.10 (Beta 2)
if \
    [[ "${DESKTOP_SESSION} $(lsb_release -sr)" == "Lubuntu 14.04" ]] \
    || [[ "${DESKTOP_SESSION} $(lsb_release -sr)" == "Lubuntu 14.10" ]] \
    ; then 
  echo === open bash scripts in Terminal from File Manager - Lub 14.04 ; 
  sudo cp /etc/xdg/lubuntu/libfm/libfm.conf{,.`date +%y%m%d.%H%M%S`}
  sudo sed -i -e 's|lxsession-default-terminal %s|x-terminal-emulator -e %s|' \
   /etc/xdg/lubuntu/libfm/libfm.conf ; 
  sudo cp /usr/share/lxpanel/profile/Lubuntu/config{,.`date +%y%m%d.%H%M%S`}
  sudo sed -i -e 's|lxsession-default terminal|x-terminal-emulator|' \
   /usr/share/lxpanel/profile/Lubuntu/config ; 
fi


# power tray applet not appearing
# https://bugs.launchpad.net/ubuntu/+source/xfce4-power-manager/+bug/1446247

if [[ "${DESKTOP_SESSION} $RELEASE" == "Lubuntu 15.04" ]] ; then 
  sudo apt-get install xfce4-power-manager-plugins ; 
fi

# see also http://askubuntu.com/questions/624797/problem-with-battery-indicator-in-lubuntu-15-04
# right-click in tray - Panel Settings / Applets / Add / Battery Monitor


# Suspend on timeout fails with "Power Manager: GDBus.Error:org.freedesktop.DBus.Error.NoReply: Method call timed out."
# http://askubuntu.com/a/817106
# https://bugs.launchpad.net/ubuntu/+source/systemd/+bug/1605189
if [[ "${DESKTOP_SESSION} $(lsb_release -sr)" == "Lubuntu 16.10" ]] ; then 
  sudo tee /etc/polkit-1/localauthority/50-local.d/com.0.allow-suspend-on-timeout.pkla <<EOF!
[Allow suspend on timeout]
Identity=unix-user:*
Action=org.freedesktop.login1.suspend;org.freedesktop.login1.suspend-multiple-sessions
ResultInactive=yes
EOF!
fi
# http://askubuntu.com/a/700713
# could have used xmlstarlet on actions/org.freedesktop.login1.policy but adding localauthority is more atomic way to intervene
# for more on polkit and overides see [https://github.com/artmg/lubuild/blob/master/help/configure/Desktop.md]



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
if [[ $LUBUILD_HARDWARE_TYPE_LAPTOP -eq TRUE ] && [ "${DESKTOP_SESSION}" == "Lubuntu" ] && [ (( $(echo "$(lsb_release -sr) <= 16.04"  | bc -l) )) ]] ; then 
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




# Notifications not clear
# https://bugs.launchpad.net/ubuntu/+source/lubuntu-artwork/+bug/1362555

if [[ "${DESKTOP_SESSION} $(lsb_release -sr)" == "Lubuntu 15.04" ]] ; then 
  sudo rm /usr/share/themes/Lubuntu-default/gtk-2.0/images/panel-bg.png ; 
fi

# to test ...
# sudo apt-get install -y libnotify-bin
# notify-send -u normal "Hello" "Testing"
# help - https://wiki.archlinux.org/index.php/Desktop_notifications



### exFAT support for 64GB SD cards
if [[ "$(lsb_release -sr)" == "15.04" ]] ; then 
  sudo apt-get install exfat-fuse exfat-utils ;
fi



# BCM 4313 wireless adapter (PnP ID [14e4:4727]) 
# is supported best by Broadcom "wl" driver
# see also [https://github.com/artmg/lubuild/blob/master/help/diagnose/hardware.md#wifi-driver-issues]
AFFECTED_MODELS='|AO722|'
if \
    [[ $AFFECTED_MODELS == *\|$MODEL_NO\|* ]] \
    ; then 
	sudo apt-get install -y bcmwl-kernel-source
; fi



### This logic to only do this for HP Mini on 14.04 is not yet working, 
# probably due to the space on the end of the model no

#AFFECTED_MODELS='|HP Mini 110-3100 |sample other|'
#AFFECTED_RELEASES='|14.04|'
#
#if \
#    [[ $AFFECTED_MODELS == *\|$MODEL_NO\|* ]] \
#    && [[ $AFFECTED_RELEASES == *\|$RELEASE\|* ]] \
#    ; then 

sudo mkdir -p /etc/X11/xorg.conf.d
#sudo touch /etc/X11/xorg.conf.d/20-screen.conf
#sudo cat <<-EOF! >> /etc/X11/xorg.conf.d/20-screen.conf
sudo tee /etc/X11/xorg.conf.d/20-screen.conf <<EOF!
Section "Device"
  Identifier "card0"
  Driver "intel"
  Option "Backlight" "intel_backlight"
  BusID "PCI:0:2:0"
EndSection
EOF!
# credit - https://bugs.launchpad.net/ubuntu/+source/xserver-xorg-video-intel/+bug/1273234

#; fi
