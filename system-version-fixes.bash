#!/bin/bash

MODEL_NO=`sudo dmidecode -s system-product-name`
RELEASE=`lsb_release -sr`

# credit - https://bugs.launchpad.net/ubuntu/+source/pcmanfm/+bug/975152/comments/17
# still an issue in Lubuntu 14.10 (Beta 2)
if \
    [[ "${DESKTOP_SESSION} $(lsb_release -sr)" == "Lubuntu 14.04" ]] \
    || [[ "${DESKTOP_SESSION} $(lsb_release -sr)" == "Lubuntu 14.10" ]] \
    ; then 
  echo ### open bash scripts in Terminal from File Manager - Lub 14.04 ; 
  sudo sed -i -e 's|lxsession-default-terminal %s|x-terminal-emulator -e %s|' \
   /etc/xdg/lubuntu/libfm/libfm.conf ; 
  sudo sed -i -e 's|lxsession-default terminal|x-terminal-emulator|' \
   /usr/share/lxpanel/profile/Lubuntu/config ; 
  sed -i -e 's|lxsession-default terminal|x-terminal-emulator|' \
   $HOME/.config/lxpanel/Lubuntu/config ;
fi




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
  Option "Backlight" "intel_backlight"
EndSection
EOF!
# credit - https://bugs.launchpad.net/ubuntu/+source/xserver-xorg-video-intel/+bug/1273234

#; fi
