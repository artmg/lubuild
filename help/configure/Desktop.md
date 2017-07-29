
_Consider moving out diagnostic and User sections_

see also:

* if you are confused by some of the terminology around linux desktops
	* [https://github.com/artmg/lubuild/blob/master/help/understand/layers-on-your-desktop.md]
* this is where the desktop is initially configured
	* [https://github.com/artmg/lubuild/blob/master/user-config.bash]


## Tips

* Lubuntu
	* ALT + LeftClick hold to drag windows if you can't see buttons
* 

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

## Desktop Environment

The current default DE for Lubuntu is LXDE

The latest source for lubuntu default settings is 
[http://bazaar.launchpad.net/~lubuntu-dev/lubuntu-default-settings/trunk/files/head:/src/]

### LxQt

The next DE for Lubuntu will (eventually be) LxQt, a Qt-based spin 
of LXDE, borrowing some bits in the meantime from KDE to fill in. 

For details of the sources 
see [https://github.com/lxde/lxqt/blob/master/CONTRIBUTING.md]

Not sure where the Lubuntu Next settings source is 


### Screen locker

Lubuntu with LXDE uses light-locker as it's lock screen
Configuration is handled using startup parameters in the autostart dekstop file:

* ~/.config/autostart/*.desktop
* /etc/xdg/autostart/light-locker.desktop


## Session Manager

LXDE uses LxSession as its session manager, independent of which 
desktop manager or window manager is being used. 

* Configuration files: ~/.config/lxsession/<Profile Name>
* Default configs: /etc/xdg/lxsession/<Profile name> 

For more see [https://wiki.lxde.org/en/LXSession]


### Auto Start 

```
# Lubuntu stores it's per-user `Manual autostarted applications` 
# as line entries in
cat .config/lxsession/Lubuntu/autostart
# to add one use 
# cat >> ~/.config/lxsession/Lubuntu/autostart<<EOF
#
# to see system-wide autostart commands see
cat /etc/xdg/lxsession/Lubuntu/autostart
# and to add one use 
# cat <<EOF | sudo tee -a /etc/xdg/lxsession/Lubuntu/autostart

# XFCE & LXDE use .desktop files in
# 
ls ~/.config/autostart/
# In Xubuntu, to diagnose issues with applications added into startup apps, also check :
ls ~/Desktop/Autostart/
# /etc/X11/gdm/PostLogin/Default

# manual alternatives:
# Lubuntu: Preferences / Default applications for LXSession / Autostart
# Ubuntu: System / Preferences / Startup applications
# Xubuntu: Applications / Settings / Session and Startup / Application Autostart
```

#### Troubleshooting

If you have issues with autostart...

* check if there is a per-user file
	* in some configurations this may OVERIDE the system file, rather than add to it
+ check $HOME/.xsession-logs
	* contains details of where to find the log files
+ check out how autostart entries are executed [https://wiki.lxde.org/en/LXSession#autostart_configuration_file]
+ If the command/script is not in the PATH then qualify it
+ it is NOT a full interpreter so if you want, e.g. a delayed command use a script
	* e.g. "sleep 30 && myprog" see [https://ubuntuforums.org/showthread.php?t=2024713]
+ see also [https://ubuntuforums.org/showthread.php?t=2182986]


### Troubleshooting the Desktop

#### LXPanel menu bar 

##### Simple restart 

 lxpanelctl restart

##### kill and restart 

```
# restart lxpanel
killall lxpanel && lxpanel --profile default &
# not perfect but may get you out of a jam
```

##### reset all panel settings 

```
# Reset the user's panel to default
# credit - http://ubuntuforums.org/showthread.php?t=1490938&p=9557050#post9557050
sudo cp /usr/share/lxpanel/profile/Lubuntu/panels/panel ~/.config/lxpanel/Lubuntu/panels
sudo chown $USER:$USER  ~/.config/lxpanel/Lubuntu/panels/panel
lxpanelctl restart


# NB do not attempt to back up the old file into the same folder
# as the file with the incorrect settings will clash with the refreshed version!
```

##### help with lxpanel confiuration 

```
# view man pages locally
man lxpanel.hints
```
Or view them at http://manpages.ubuntu.com/manpages/saucy/man5/lxpanel.hints.5.html

Also see http://wiki.lxde.org/en/LXPanel 
and https://wiki.archlinux.org/index.php/LXDE
but bear in mind that the "session" config folder name is likely to be Lubuntu not LXDE


## File types, icons, shortcuts

### Mime Types

On your system, the Mime Types are defined in either:

* /etc/mime.types
* /usr/share/mime/types
* ~/.local/share/mime/types

and the applications associated are

* /usr/share/applications/defaults.list
* ~/.local/share/applications/mimeapps.list 

You can make changes to these manually, but then you will need to refresh the 
mime info cache using `sudo update-desktop-database`. Alternatively you can 
add entries directly using the command:

`xdg-mime default myapp.desktop application/myapp`

To see the mimetype for a given file use

`file --mime-type -b path/myfile`

For more details on hierarchy and implementation please see:

* [https://lkubaski.wordpress.com/2012/10/29/understanding-file-associations-in-lxde-and-pcmanfm/]
* [http://askubuntu.com/questions/16580/where-are-file-associations-stored]
* [https://specifications.freedesktop.org/shared-mime-info-spec/shared-mime-info-spec-0.18.html]

### Desktop Launchers

These are the equivalent of Windows "Shortcut" files

#### Application launchers appearing in your Start Menu

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
```

see also [https://lkubaski.wordpress.com/2012/06/29/adding-lxde-start-menu-and-desktop-shortcuts/]


#### icon files

Although you could specify an icon path in your desktop entry, 
you could choose one that comes with your distro. 
There are lots inside `/usr/share/icons` which are theme-able, 
and a few more in `/usr/share/pixmaps` too. 


#### run scripts

Inside your desktop entry, to run a script, you could either have:

```
Exec=/bin/hello.sh
Terminal=true
```

or

```
Exec=lxterminal -e "/bin/hello.sh"
Terminal=false
```

### Create New ...

To add new file templates into the menu Create New in PCManFM file manager, 
see [https://wiki.lxde.org/en/PCManFM#Create_New...]


## User Sessions

### Other users logged in

```
# see who else is loged in
who

# log off / logout other user session (force to them end)
sudo pkill -KILL -u username
```

## From Collector 


### Sessions & Users
#### Desktop Session settings

```
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

```
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

```
