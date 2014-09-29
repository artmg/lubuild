#!/bin/bash

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
