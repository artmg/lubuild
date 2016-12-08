#!/bin/bash

# options used
# $LUBUILD_HARDWARE_TYPE_EXTERNAL_SCREEN
# $LUBUILD_HARDWARE_TYPE_LAPTOP 


### Screen locking issues in 14.04 & 14.10
# do we want to force screensaver to lock, or let user config manually?
#
if \
 [[ "${DESKTOP_SESSION} $(lsb_release -sr)" == "Lubuntu 14.04" ]] \
 || [[ "${DESKTOP_SESSION} $(lsb_release -sr)" == "Lubuntu 14.10" ]] \
; then
  echo === change C-A-L lock shortcut to use light locker
  cp ~/.config/openbox/lubuntu-rc.xml{,.`date +%y%m%d.%H%M%S`}
  sed -i 's/lxsession-default lock/light-locker-command -l/' \
   ~/.config/openbox/lubuntu-rc.xml
fi

# consider changing (unconditionally) shortcut from key="C-A-l" to key="W-l"
# or at least adding in a copy (like W-p below) to use both shortcuts



### Set laptop mode ###
if [[ $LUBUILD_HARDWARE_TYPE_LAPTOP -eq TRUE ]] ; then ( 
  if \
    [[ "${DESKTOP_SESSION} $(lsb_release -sr)" == "Lubuntu 14.04" ]] \
    ; then
    # credit > http://askubuntu.com/a/361286
    cp ~/.config/lxsession/Lubuntu/desktop.conf{,.`date +%y%m%d.%H%M%S`}
    echo modify the following setting in the named section ; \
    echo [State] ; \
    echo laptop_mode=yes ; \
    sudo leafpad ~/.config/lxsession/Lubuntu/desktop.conf 
  fi
) ; fi



######### toggle external screen display using SUPER-P ###########################
#
# Lubuntu's (LXDE's) LXRandR gui allows you to set a specific configuration,
# but not toggle / cycle between alternative modes you choose to predefine
#
# Use ARandR scripts instead... 
# help - http://christian.amsuess.com/tools/arandr/
# proc - http://askubuntu.com/questions/162028/how-to-use-shortcuts-to-switch-between-displays-in-lxde

if [[ $LUBUILD_HARDWARE_TYPE_LAPTOP -eq TRUE ] && [ $LUBUILD_HARDWARE_TYPE_EXTERNAL_SCREEN -eq TRUE ]] ; then ( 
# This installs the GUI and the notify-send util the script uses for notification bubbles / toasts
sudo apt-get install -y arandr libnotify-bin

# This sets up the script to cycle modes
mkdir -p ~/.screenlayout
cd ~/.screenlayout
wget https://github.com/bmnz/arandr-cycle/raw/master/arandr-cycle.sh ./.arandr-cycle.sh
mv arandr-cycle.sh .arandr-cycle.sh
chmod +x .arandr-cycle.sh

# This sets up the Function key as Win-P 
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
   -t text -n text -v "~/.screenlayout/.arandr-cycle.sh" \
> ~/.config/openbox/lubuntu-rc.xml

openbox --reconfigure

# Now use the GUI to save one file for each of your preferred modes
arandr

) ; fi

# NB: If mouse pointer does not appear when you switch external monitor on then try the following:
# EITHER re-awaken X by switching consoles - CTRL-ALT-F1 then CTRL-ALT-F7 - credit https://bbs.archlinux.org/viewtopic.php?pid=648767#p648767
# OR suspend and resume


# for alternative scripts that can cycle between 3 or more modes, 
# see... (in ascending order of complexity)
# http://crunchbang.org/forums/viewtopic.php?id=10182
# http://unix.stackexchange.com/a/168141
# https://gist.github.com/davidfraser/4131369
# https://awesome.naquadah.org/wiki/Using_Multiple_Screens

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


### The rest of this used to be in user-fixes.bash


#### Sound controls
# some Laptops not adjusting volume with Fn VolUp and Fn VolDn keys
# credit - http://ubuntuforums.org/archive/index.php/t-1977849.html
# credit - https://bugs.launchpad.net/ubuntu/+source/lxpanel/+bug/1262572

MODEL_NO=`sudo dmidecode -s system-product-name`
AFFECTED_MODELS='|AO722|Latitude E7240|sample other|'

if [[ $AFFECTED_MODELS == *\|$MODEL_NO\|* ]] ; then
  sudo cp $HOME/.config/openbox/lubuntu-rc.xml{,.`date +%y%m%d.%H%M%S`}  # backup original config
  # find the text   XF86AudioRaiseVolume
  # after each of the three  commands   amixer -q   insert the following text before   sset
  #   -D pulse 
  sed -i -e 's|amixer -q sset|amixer -q -D pulse sset|' \
  $HOME/.config/openbox/lubuntu-rc.xml ;

  openbox --reconfigure
 
fi

##### Power cord beep
# Acer One has a loudly annoying beep when inserting or removing the power cord.
# credit - http://housegeekatheart.blogspot.co.uk/2011/10/disable-ac-adaptor-beep-in-portables-in.html
# Windows-side fix: [http://www.jdhodges.com/blog/disable-beep-on-acer-ao722-netbook-solved-two-ways/]

MODEL_NO=`sudo dmidecode -s system-product-name`
AFFECTED_MODELS='|AO722|'

if [[ $AFFECTED_MODELS == *\|$MODEL_NO\|* ]] ; then
  # check which card is the non HD audio card with 
  cat /proc/asound/cards 
  # set the card's Beep setting to almost silent
  amixer -c 1 sset Beep 1
fi




# now fixed and backported 
## "lxsession-default tasks" (CTRL-ALT-DEL) kills xorg / logs user out
#  sed -i -e 's|lxsession-default tasks|lxtask|' \
#  $HOME/.config/openbox/lubuntu-rc.xml ;
#  openbox --reconfigure
## http://ubuntuforums.org/showthread.php?t=2218356
## http://askubuntu.com/questions/499036/
## https://bugs.launchpad.net/ubuntu/+source/lxsession/+bug/1316832


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

