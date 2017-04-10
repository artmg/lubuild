This article focusses on special features associated with Tablet computers 
and similar devices, such as hybrid or convertible form factors. 

If you want to put Ubuntu Mobile onto a tablet see the section towards the end.


## Auto-rotate

Recent Ubuntu versions, including 16.04 and onwards, reportedly have 
auto-rotate working out of the box. 

A sensor called an Accelerometer detects the screen orientation, 
and a service monitoring this sensor sends a signal to the screen handler, 
to change the orientation.

### Gnome 

Ubuntu, and other desktops using Gnome, rely on `iio-sensor-proxy` [https://github.com/hadess/iio-sensor-proxy] in the universe repo. 

This proxy sends sensor info to dbus. 

How can we have dbus events autorotate xrandr?

```
# troubleshoot
# check your video driver supports rotation
xrandr
# does it list orientations: normal left inverted right
```

Other docs: 

* understand iio sensor proxy and the udev rules that allow you to control it [http://askubuntu.com/a/864783]
* is there any control via `/etc/systemd/logind.conf`?
* turn it off completely [sudo systemctl stop iio-sensor-proxy.service]


Alternative methods

* script driven: [https://linuxappfinder.com/blog/auto_screen_rotation_in_ubuntu]
* more scripts: [https://wiki.archlinux.org/index.php/Tablet_PC#Automatic_rotation]






## Touch Screen

seems to work out of the box


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