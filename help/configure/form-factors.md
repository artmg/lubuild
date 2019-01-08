This article focusses on special features associated with specific form factors. They include Laptops, Tablet computers, similar devices such as Hybrid or Convertibles, and may even be specific to the traditional Desktop PC. 

If you want to put Ubuntu Mobile onto a tablet see the section towards the end.


# Laptop

## Laptop Mode


* edit desktop conf - user as it's often in defaults to overide
  * (see [[Desktop and Users#wiki-Desktop_Session_settings|Session settings]])
  * where are defaults for new users?
 sudo gnome-text-editor ~/.config/lxsession/Lubuntu/desktop.conf

``` 
# [State]
# laptop_mode=yes
# credit > http://askubuntu.com/a/361286

# this should also autostart xfce4-power-manager - if not 
# power_manager/command=xfce4-power-manager
# credit > http://ubuntuforums.org/showthread.php?t=2185546&p=12837478#post12837478

# if this does not persist on reboot then in same file...
# [Session]
# disable_autostart=no
# credit - http://askubuntu.com/a/361511
```

## Laptop lid

```
 # lubuntu lid power settings workaround
 sudo editor /etc/systemd/logind.conf
 # Set "HandleLidSwitch=ignore"
 # help > https://bugs.launchpad.net/ubuntu/+source/xfce4-power-manager/+bug/1222021

 # deprecated
 # kit for power management on laptop, as alternative to little tweaks all over the place
 # sudo apt-get install laptop-mode-tools
```

### turn touchpad off when lid closes

```
# credit - http://askubuntu.com/questions/91534/disable-touchpad-while-the-lid-is-down
editor /etc/acpi/local/lid.sh.post
# with the following content:

export XAUTHORITY=`ls -1 /home/*/.Xauthority | head -n 1`
export DISPLAY=":`ls -1 /tmp/.X11-unix/ | sed -e s/^X//g | head -n 1`"

grep -q closed /proc/acpi/button/lid/*/state
xinput set-int-prop 12 "Device Enabled" 8 $?
```

#### does this go here or in utils/code snippets?

```
xinput list|grep pad|grep id=|cut -f 2|cut -f 2 -d =
# credit - http://askubuntu.com/questions/290977/grep-how-to-show-only-one-word-after-found-one
```




# Tablet

## Auto-rotate

Recent Ubuntu versions, including 16.04 and onwards, reportedly have 
auto-rotate working out of the box. 

A sensor called an Accelerometer detects the screen orientation, 
and a service monitoring this sensor sends a signal to the screen handler, 
to change the orientation.

### Gnome method

Ubuntu, and other desktops using Gnome, rely on `iio-sensor-proxy` [https://github.com/hadess/iio-sensor-proxy] in the universe repo. 

This proxy sends sensor info to dbus. 

How can we have dbus events autorotate xrandr?

Other docs: 

* understand iio sensor proxy and the udev rules that allow you to control it [http://askubuntu.com/a/864783]
* is there any control via `/etc/systemd/logind.conf`?
* turn it off completely [sudo systemctl stop iio-sensor-proxy.service]

### Add to Lubuntu

```
# credit https://unix.stackexchange.com/a/335516

# basic technique https://linuxappfinder.com/blog/auto_screen_rotation_in_ubuntu
sudo apt install iio-sensor-proxy inotify-tools

# Script location
# copied from https://github.com/artmg/lubuild/blob/master/help/configure/Desktop.md#systemwide-scripts
# see there for alternative locations
PROFILE_NAME=zz-local-scripts-path
SCRIPT_FOLDER=/opt/local/bin

sudo mkdir -p "${SCRIPT_FOLDER}"
sudo chmod 755 "${SCRIPT_FOLDER}"

if [ ! -f "/etc/profile.d/${PROFILE_NAME}.sh" ] ; then
  sudo tee "/etc/profile.d/${PROFILE_NAME}.sh" <<EOF!
if [ -d "${SCRIPT_FOLDER}" ] ; then
  if ! echo "$PATH" | /bin/grep -Eq "(^|:)${SCRIPT_FOLDER}($|:)" ; then
    PATH="${SCRIPT_FOLDER}:$PATH"
  fi
fi
EOF!
  sudo chmod +r "/etc/profile.d/${PROFILE_NAME}.sh"
fi

# Download script
SCRIPT_NAME=autorotate.sh
# updated script https://github.com/gevasiliou/PythonTests/blob/master/autorotate.sh
sudo curl -o "${SCRIPT_FOLDER}/${SCRIPT_NAME}" https://raw.githubusercontent.com/gevasiliou/PythonTests/master/autorotate.sh

# Make script Autostart for all users
chmod +x "${SCRIPT_FOLDER}/${SCRIPT_NAME}"
echo @"${SCRIPT_FOLDER}/${SCRIPT_NAME}" | sudo tee -a /etc/xdg/lxsession/Lubuntu/autostart


## NB
# due to a 'feature' with LXDE Autostart 
# https://wiki.lxde.org/en/LXSession#autostart
# if the user has their own local autostart file
# 'only the entries in the local file will be executed'
#
# If you have this issue with a given user, 
# then add the 'system' autostart to theirs
#

if [ -f $HOME/.config/lxsession/Lubuntu/autostart ] ; then
  cat /etc/xdg/lxsession/Lubuntu/autostart >> $HOME/.config/lxsession/Lubuntu/autostart
fi

```


* more scripts: [https://wiki.archlinux.org/index.php/Tablet_PC#Automatic_rotation]

#### troubleshoot

```
# check your video driver supports rotation
xrandr
# does it list orientations: normal left inverted right
```








## Touch Screen

seems to work out of the box

### Older Notes for early versions

#### generic touch screen input

* Considerations for multi-touch compatibility with ubuntu - may be superceded?
* This is not yet tied to a specific model as it has yet to be tested
* IN from [Dropbox/DROP.IN/Service.IN/Lub Hw touchscreen.txt]

If considering a specific model of laptop or external touch monitor
then check for compatibility on forums

Asus Zenbook has full multi-touch support on Ubuntu 14.04 http://ubuntuforums.org/showthread.php?t=2209387&p=12948928#post12948928

xinput_calibrator is something to do with lubuntu touch: http://ubuntuforums.org/showthread.php?t=2216019

#### desktops 

according to https://www.maketecheasier.com/best-linux-desktop-touch-enabled-monitor/

* Gnome 3.14+  (e.g. Fedora)
* Unity

Other mentions ... Plasma & Android-x86


#### add-ons

##### touchegg

Touchegg converts gestures into something that "older" desktops can understand

see: http://ubuntuforums.org/showthread.php?t=2193327&page=2
and: https://www.maketecheasier.com/best-linux-desktop-touch-enabled-monitor/


here is a "which distro" discussion that may help http://www.reddit.com/r/linux/comments/1tpnd7/best_distro_for_a_touch_screen_laptop/

someone had issues with 14.04 Lubuntu, touch worked on liveUSB but not installed! http://askubuntu.com/questions/468145/touchscreen-support-in-lxde-in-ubuntu-and-lubuntu 

This is an old page: https://wiki.ubuntu.com/Multitouch

#### apps

##### Ubuntu Touch core

The [Ubuntu Touch Core Applications](https://wiki.ubuntu.com/Touch/CoreApps)
are intended to be [usable on Unity 8+](https://wiki.ubuntu.com/Unity/Desktop/14.04/Unity8#Core_Apps)

http://askubuntu.com/questions/345226/how-do-i-view-or-install-ubuntu-touch-apps

There are [PPAs for Core Apps](https://wiki.ubuntu.com/Touch/CoreApps/PPA) 
and [3rd party "Collection"](https://wiki.ubuntu.com/Touch/Collection/PPA) 
and the more recently added [metapackage for all core apps](https://launchpad.net/~ubuntu-touch-coreapps-drivers/+archive/ubuntu/daily)
designed to stimulate interest



## On screen keyboard

Candidates:

* onboard
	- in repo
	- available from Accessability menu
	- for config files see [http://askubuntu.com/a/657065]
* Florence
	- in repos
	- see [http://xmodulo.com/onscreen-virtual-keyboard-linux.html]
* GOK (Gnome onscreen Keyboard)
	- 
* kvkbd
	- (no longer available)
* 



## Ubuntu Mobile

[https://developer.ubuntu.com/en/phone/devices/installing-ubuntu-for-devices/]

* for flashing devices previously running android
* uses phablet-tools to manipulate the USB connected tablet during install (like adb)
* 