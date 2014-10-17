#!/bin/bash

# ====Sound controls====
# Acer One not adjusting volume with Fn VolUp and Fn VolDn keys
# credit - http://ubuntuforums.org/archive/index.php/t-1977849.html

MODEL_NO=`sudo dmidecode -s system-product-name`
AFFECTED_MODELS='|AO722|sample other|'

if [[ $AFFECTED_MODELS == *\|$MODEL_NO\|* ]] ; then
  sudo cp $HOME/.config/openbox/lubuntu-rc.xml{,.`date +%y%m%d.%H%M%S`}  # backup original config
  # find the text   XF86AudioRaiseVolume
  # after each of the three  commands   amixer -q   insert the following text before   sset
  #   -D pulse 
  sed -i -e 's|amixer -q sset|amixer -q -D pulse sset|' \
  $HOME/.config/openbox/lubuntu-rc.xml ;

  openbox --reconfigure
 
fi

# no longer needed per user as it's fixed system-wide
## credit - https://bugs.launchpad.net/ubuntu/+source/pcmanfm/+bug/975152/comments/17
## still an issue in Lubuntu 14.10 (Beta 2)
#if \
#  [[ "${DESKTOP_SESSION} $(lsb_release -sr)" == "Lubuntu 14.04" ]] \
#  || [[ "${DESKTOP_SESSION} $(lsb_release -sr)" == "Lubuntu 14.10" ]] \
#  ; then
#  echo === open bash scripts in Terminal from File Manager - Lub 14.04 ;
### This would fail anyhow, as config file not created until you go into GUI preferences
#  sudo cp $HOME/.config/lxpanel/Lubuntu/config{,.`date +%y%m%d.%H%M%S`}
#  sed -i -e 's|lxsession-default terminal|x-terminal-emulator|' \
#  $HOME/.config/lxpanel/Lubuntu/config ;
#fi
