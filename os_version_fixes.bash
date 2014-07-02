#!/bin/bash

# credit - https://bugs.launchpad.net/ubuntu/+source/pcmanfm/+bug/975152/comments/17
if [[ "${DESKTOP_SESSION} $(lsb_release -sr)" == "Lubuntu 14.04" ]] ; then 
  echo ### open bash scripts in Terminal from File Manager - Lub 14.04 ; 
  sudo sed -i -e 's|lxsession-default-terminal %s|x-terminal-emulator -e %s|' \
   /etc/xdg/lubuntu/libfm/libfm.conf ; 
  sudo sed -i -e 's|lxsession-default terminal|x-terminal-emulator|' \
   /usr/share/lxpanel/profile/Lubuntu/config ; 
fi
