#!/bin/bash

====Sound controls====

 # Acer One not adjusting volume with Fn VolUp and Fn VolDn keys
 # credit - http://ubuntuforums.org/archive/index.php/t-1977849.html
 # 
 gnome-text-editor ~/.config/openbox/lubuntu-rc.xml
 #
 # find the text   XF86AudioRaiseVolume
 # after each of the three  commands   amixer -q   insert the following text before   sset
 #   -D pulse 
 #
 openbox --reconfigure
 

