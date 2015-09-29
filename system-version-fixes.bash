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


# Notifications not clear
# https://bugs.launchpad.net/ubuntu/+source/lubuntu-artwork/+bug/1362555

if [[ "${DESKTOP_SESSION} $(lsb_release -sr)" == "Lubuntu 15.04" ]] ; then 
  sudo rm /usr/share/themes/Lubuntu-default/gtk-2.0/images/panel-bg.png ; 
fi

# to test ...
# sudo apt-get install -y libnotify-bin
# notify-send -u normal "Hello" "Testing"
# help - https://wiki.archlinux.org/index.php/Desktop_notifications



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
