
_Consider moving out diagnostic and User sections_

## Display Manager (login screen)
### Auto login
```
### Lubuntu LightDM autologon 
# edit the global config file
sudo xxx-gnome-editor /etc/lightdm/lightdm.conf
# NB: there are per-user config files called .dmrc in users' home folders

# You can edit the config file directly:
#  user-session=
# to configure autologin
#   autologin-user=MyUserName
#   autologin-user-timeout=0

# old Notes on LXDM Autologon
# check that the right file is set 
update-alternatives --get-selections|grep lxdm
# then edit it, e.g.
sudo gedit /etc/xdg/lubuntu/lxdm/lxdm.conf
```
### Auto Start 
```
# XFCE & LXDE use .desktop files in
# 
ls ~/.config/autostart/
# In Xubuntu, to diagnose issues with applications added into startup apps, also check :
ls ~/Desktop/Autostart/
# /etc/X11/gdm/PostLogin/Default

# manual alternatives:
# Ubuntu: System / Preferences / Startup applications
# Xubuntu: Applications / Settings / Session and Startup / Application Autostart
```
### Switch DM
```
# which Display Manager (login screen) are you currently using?
sudo cat /etc/X11/default-display-manager
# If you want to swap to a different display manager, 
# then perhaps a safer alternative to editing that file would be to 
sudo dpkg-reconfigure yourDM
# where yourDM could be   lightdm    or     lxdm      

# list all session types (desktop environments) available 
ls /usr/share/xsessions
# CAT the specific file to see details of what starts up. 
# You can set the default session by putting the name from the .desktop file into the command:
sudo /usr/lib/lightdm/lightdm-set-defaults -s New-Session-Name

# NB if you want to use Fingerprint-GUI for the fingerprint scanner 
# lxdm does not support alternative authentication mechanisms 
# so you should install lightdm and lightdm-gtk-greeter
# credit - https://launchpad.net/~fingerprint/+archive/ubuntu/fingerprint-gui
```
## User Sessions

### Other users logged in
```
# see who else is loged in
who

# log off / logout other user session (force to them end)
sudo pkill -KILL -u username
```

## From Collector 

### Launchers
```
# alternative means to create programmatically...
# EITHER...
echo "
[Desktop Entry]
# etc ...
" > ~/.local/share/applications/myprog.desktop
#
# OR...
cat > ~/.local/share/applications/myprog.desktop<<EOF
[Desktop Entry]
# etc ...
EOF
#

#### Sample Desktop icon commands
  cat <<-EOF! > ~/.local/share/applications/Wake_up_Wifi.desktop
  [Desktop Entry]
  EOF!

  cat <<-EOF! | sudo tee /usr/share/applications/wake-up-wifi.desktop
  [Desktop Entry]
  EOF!


#### shortcut location 
;current user only
: ~/.local/share/applications/
;all users
: /usr/share/applications

mkdir ~/.local/share/applications

# if should be for all users...
cd /usr/share/applications/
sudo mv ~/.local/share/applications/myprog.desktop ./
sudo chown --reference=defaults.list myprog.desktop
# sudo chgrp --reference=defaults.list myprog.desktop

### Sessions & Users
#### Desktop Session settings

# Lubuntu session settings (valid at v13.10)
# lxsession system DEFAULTS
sudo editor /etc/xdg/lxsession/Lubuntu/desktop.conf

# if the system defaults don't modify behaviour, it might have been overriden in user settings...
# sudo editor ~/.config/lxsession/Lubuntu/desktop.conf 
# user settings gui
# lxsession-default-apps

#### Screensaver that allows Switch User
# ''search for other ScreenSaver refs in doc''
# credit > https://wiki.archlinux.org/index.php/Xscreensaver#LXDM
# credit > https://wiki.archlinux.org/index.php/LXDM#Simultaneous_Users_and_Switching_Users

echo newLoginCommand: lxdm -c USER_SWITCH | tee -a ~/.xscreensaver
cat ~/.xscreensaver

### Environment
#### Alternative Keyboards
# credit > http://noobish-nix.blogspot.co.uk/2012/06/how-to-add-and-switch-keyboard-layout.html

editor ~/.config/lxsession/Lubuntu/autostart
@lxkeymap --autostart
# http://ubuntuforums.org/showthread.php?t=2130981&p=12644858#post12644858
```


#### Accented characters

Use Hex
 e.g. CTRL-SHIFT-U e 9 ENTER as 0x00e9 is é
http://askubuntu.com/questions/32764/using-alt-keycode-for-accents

 Use ComposeKey
 SHIFT-ALTGR <release> e ' = é
 https://help.ubuntu.com/community/ComposeKey

### Policy Kit

freedesktop.org Policy Kit (polkit-1)
e.g. 
* Allow all users to add wifi connections
* "Authentication is required to unlock the encrypted device"


#### Polkit rules
```
 # http://www.freedesktop.org/software/polkit/docs/latest/polkit.8.html
 # Actions are defined by applications
 # Rules are how Sys Admins control authorisation
 # also corroborated by https://wiki.archlinux.org/index.php/Polkit
 # which suggests the javascript .rules files go under
 # /usr/share/polkit-1/rules.d   for third parties and
 # /etc/polkit-1/rules.d   for local configuration

 # sample rules files...
 # https://gist.github.com/grawity/3886114
 # https://wiki.mageia.org/en/Useful_polkit_policies
 
 # to allow users to unlock encrypted devices
 # action id="org.freedesktop.udisks2.encrypted-unlock" 
 # action id="org.freedesktop.udisks2.encrypted-unlock-system"
 # or setting up loops
 # action id="org.freedesktop.udisks2.loop-setup"  
 # help > http://udisks.freedesktop.org/docs/1.97.0/udisks-polkit-actions.html

 # don't forget some of the risks of allowing regular users to mount...
 # > http://unix.stackexchange.com/questions/65039/why-does-mount-require-root-privileges
 # > http://unix.stackexchange.com/questions/32008/mount-an-loop-file-without-root-permission
 # so consider either picking certain users to extend the privilege to ...
 # or simply adding any common mounts to fstab

 # this is VERY granular control of what people can do with loops
 # http://166291.blogspot.co.uk/2013/07/mounting-luks-loopbacks-with-gvfs.html

 

====polkit actions==== 

 # many examples show modifying the actions, but could these change during updates?
 # e.g. http://ubuntuforums.org/showthread.php?t=1873477&page=2&p=11780597#post11780597
 # and https://bugs.launchpad.net/ubuntu/+source/network-manager/+bug/964705/comments/16

 # however action files do allow wildcards so you could ...
 # permit all users ...   Identity=unix-user:* 

 [All all users to modify network settings without typing password]
 Identity=unix-user:*
 Action=org.freedesktop.NetworkManager.settings.modify.system
 ResultInactive=no
 ResultActive=yes

 # help > http://www.admin-magazine.com/Articles/Assigning-Privileges-with-sudo-and-PolicyKit

 # OR EVEN...
 # permit all actions (VERY DANGEROUS!)  Action=*
 # credit - http://askubuntu.com/questions/98006/how-do-i-prevent-policykit-from-asking-for-a-password

 # nb there is an lxpolkit package but not sure this is yet mainstream

 # also ...
 man pklocalauthority 
 # describes the tree including
 # /etc/polkit-1/localauthority  sub folders such as 30-site.d and 50-local.d which are useful scopes
 # but these are all .conf files
```

## Background

The '''User Privileges''' in the ''Users & Groups'' GUI '''users-admin''' actually refer to groups of which they are made members.

To see which groups the initial install user was put into use

 sudo grep user-setup /var/log/installer/syslog
 # help and credit - http://askubuntu.com/questions/219083/

### Questions around User Privilege

* How do User Privileges in User Mgr relate to freedesktop privilege?
* How are the defaults (for new users) set?
* Why does the Adminsitrator level EXCLUDE wifi and audio??

** Or does wake-up-wifi need to be Terminal=True?

### other 131211 
System policy prevents:
* modification of network settings for all users

## Privileged Users - sudo / admin

### Recover password 

 # first boot into recovery mode, then:
 mount -rw -o remount / 
 passwd yourusername

 reboot
 # credit - http://askubuntu.com/questions/24006/how-do-i-reset-a-lost-administrative-password

### add new admin user 

 # credit - http://askubuntu.com/a/70240
 # first boot into recovery mode, then:
 mount -rw -o remount / 
 export NEW_USER=<username>
 adduser $NEW_USER --group sudo
 ## this is the equivalent of
 # useradd $NEW_USER
 # adduser $NEW_USER sudo
 passwd $NEW_USER
 reboot

#### manually create home drive 

 ## if this failed to create the home directory because the home drive was NOT mounted then
 mount -all
 export NEW_USER=<username>
 # credit - http://askubuntu.com/a/336115
 grep $NEW_USER /etc/passwd
 ls -l /home
 mkdir /home/$NEW_USER
 cp /etc/skel/* /home/$NEW_USER
 chown $NEW_USER:$NEW_USER /home/$NEW_USER
 ls -l /home
 ls -lA /home/$NEW_USER

