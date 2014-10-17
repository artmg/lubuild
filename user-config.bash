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

# NB: If mouse pointer does not appear when you switch external monitor on then try the following:
# EITHER re-awaken X by switching consoles - CTRL-ALT-F1 then CTRL-ALT-F7 - credit https://bbs.archlinux.org/viewtopic.php?pid=648767#p648767
# OR suspend and resume
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


### BOOKMARKS #######################
cp ~/.gtk-bookmarks{,.`date +%y%m%d`}
# Add local music folder to bookmarks
echo file:///media/lubuntu/Default/Documents%20and%20Settings/UserName/Local%20Settings/Personal/Music Music.COPY | tee -a ~/.gtk-bookmarks


