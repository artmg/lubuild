#!/bin/bash

# ====Sound controls====
# Acer One not adjusting volume with Fn VolUp and Fn VolDn keys
# credit - http://ubuntuforums.org/archive/index.php/t-1977849.html

MODEL_NO=`sudo dmidecode -s system-product-name`
AFFECTED_MODELS='|AO722|sample other|'

if [[ $AFFECTED_MODELS == *\|$MODEL_NO\|* ]] ; then
  # find the text   XF86AudioRaiseVolume
  # after each of the three  commands   amixer -q   insert the following text before   sset
  #   -D pulse 
  sed -i -e 's|amixer -q sset|amixer -q -D pulse sset|' \
  $HOME/.config/openbox/lubuntu-rc.xml ;

  openbox --reconfigure
 
fi
