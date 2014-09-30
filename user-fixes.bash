#!/bin/bash

# ====Sound controls====
# Acer One not adjusting volume with Fn VolUp and Fn VolDn keys
# credit - http://ubuntuforums.org/archive/index.php/t-1977849.html

MODEL_NO=`sudo dmidecode -s system-product-name`
echo $MODEL_NO
if \
    [[ "${MODEL_NO}" == "AO722" ]] \
    || [[ "${MODEL_NO}" == "sample other" ]] \
; then
  # find the text   XF86AudioRaiseVolume
  # after each of the three  commands   amixer -q   insert the following text before   sset
  #   -D pulse 
  sed -i -e 's|amixer -q sset|amixer -q -D pulse sset|' \
  $HOME/.config/openbox/lubuntu-rc.xml ;

  openbox --reconfigure
 
fi


