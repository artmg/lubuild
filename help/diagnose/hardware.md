# Troubleshooting Hardware 

[https://github.com/artmg/lubuild/blob/master/help/diagnose/hardware.md]

This article is for help with general internal hardware components, including radios, etc

See also:

* Disks
	* [https://github.com/artmg/lubuild/blob/master/help/diagnose/disks.md]
* Monitor displays and Video graphics adaptors (GPU)
	* [https://github.com/artmg/lubuild/blob/master/help/diagnose/video-display.md]
* Printers and Scanners
	* [https://github.com/artmg/lubuild/blob/master/help/use/Print-and-scan.md]
* software-level [Network troubleshooting](https://github.com/artmg/lubuild/blob/master/help/diagnose/network.md)
* operating system diagnostics
	* [https://github.com/artmg/lubuild/blob/master/help/diagnose/operating-system.md]
	* although Suspend and Hibernate issues are frequently associated with drivers and devices, they are a part of OS power management so covered in there
* 

## Basic discovery

```
# To discover the hardware in your system, and the and drivers in use...

# display computer model number
sudo dmidecode -s system-product-name

# e.g. vga video wireless network etc
HW_TYPE=vga

lspci -nnk | grep -i $HW_TYPE -A3
# credit [http://askubuntu.com/a/254877]

HW_TYPE=video
# Check which driver file is being used
modinfo -F filename `lshw -c $HW_TYPE | awk '/configuration: driver/{print $2}' | cut -d= -f2`
# credit [http://askubuntu.com/a/23240]

```

## CPU 

```
# check hardware details
cat /proc/cpuinfo
# count processor cores
grep -c processor /proc/cpuinfo
# credit &gt; http://www.cyberciti.biz/faq/ubuntu-cpu-information/
# display more detail...
sudo lshw | less
```

### Temperature

```
# install the senors
sudo apt-get install lm-sensors
# check what sensors are enabled by default
sensors
# see what other sensors your hardware makes available
sudo sensors-detect
# if you want to enable these sensors you have to say YES to update /etc/modules then restart

# for example of a monitoring and alerting system (monit) based on these
# see [http://www.htpcbeginner.com/monit-cpu-temperature-monitoring/]
```


## RAM 

```
# check hardware details
cat /proc/meminfo
# count processor cores
sudo dmidecode -t memory
# display more detail...
sudo lshw | less
```

## BIOS Version

```
# check the BIOS version
sudo dmidecode -s bios-version
# check more detail
sudo dmidecode -s bios-vendor && sudo dmidecode -s bios-version && sudo dmidecode -s bios-release-date
# even more
sudo dmidecode -t bios

# Install FirmWare Tests
sudo apt-get install fwts
# run the automated batch tests
sudo fwts
# view the logs appended to a log file "results.log"
```

### BIOS Upgrade

Quote from [[https://wiki.ubuntu.com/BIOSandUbuntu]]

A buggy BIOS can cause many different and subtle problems to Linux, ranging from reboot problems, incorrect battery power readings, suspend/resume not working correctly, and strange ACPI issues

You should also bear in mind that system or driver bug reports might get rejected if the BIOS has been superseded. For help with BIOS Upgrades see [[https://help.ubuntu.com/community/BIOSUpdate]], which includes links to using '''FreeDos over USB''' disk to run vendors' DOS-based BIOS update utility

## Radios 

see also [General Network troubleshooting](https://github.com/artmg/lubuild/blob/master/help/diagnose/network.md)

### enabled/disabled 

```
# show the current state of any hardware switch options
# to enable or disable radios (like wifi or bluetooth)
rfkill list all
```

### Wifi won't turn on

NB: this is separate from the Wifi issue upon restoring from suspend/hibernate, which is now resolved by a shortcut to '''nmcli'''

```
### Detect Wifi ###
lspci -k | grep -iA3 wireless


# Wifi appears blocked by hardware key
# - NB: this was an issue with a specific model (HP Mini 110) that was NOT using the proprietary Broadcom driver 
sudo rm /var/lib/NetworkManager/NetworkManager.state
sudo reboot
# credit - http://ubuntuforums.org/showthread.php?t=1793994
```

### Wifi driver issues

Just like with some video drivers, you may have a choice between 
community supported open source drivers, and vendors' own drivers 
that may be licensed and supported in whatever way the vendor wants. 

For example, the b43 open driver generally works suitably 
for most Broadcom Wireless Network Interface cards and chipsets, 
but if you have specific issues, you might be better 
trying the Broadcom drivers. 

```
# Issue is, e.g. 
# dmesg `Support for cores revisions 0x17 and 0x18 disabled`

# check hardware specifics and module in use
lspci -vvnn | grep -A 9 Network 

# Check support against PnP ID in
# [https://wireless.wiki.kernel.org/en/users/drivers/b43]
# or [http://linuxwireless.org/en/users/Drivers/b43/]
# see also [https://help.ubuntu.com/community/WifiDocs/Driver/bcm43xx]

# IF SUPPORTED by open driver try...
# credit [https://ubuntuforums.org/showthread.php?t=2214439&p=13037208#post13037208]
cat <<EOF! | sudo tee /etc/modprobe.d/local-b43.conf
# Activate experimental support for some hardware revisions
options b43 allhwsupport=1
EOF!
# unload / reload module to make settings come into effect
rmmod b43
modprobe b43

# IF NOT SUPPORTED try vendor driver
# credit [http://askubuntu.com/a/636113]
sudo apt-get install bcmwl-kernel-source
```

#### remove bcmwl

According to [https://askubuntu.com/a/60395] the bcmwl drivers might 
be the best for your hardware, but if they are causing issues you 
could consider replacing them with an open source driver to test.

```
sudo apt-get purge bcmwl-kernel-source

# credit [https://help.ubuntu.com/community/WifiDocs/Driver/bcm43xx#Switching_between_drivers]
# this assumes open driver already installed
sudo modprobe -r b43 bcma
sudo modprobe -r brcmsmac bcma
sudo modprobe -r wl
sudo modprobe brcmsmac

# check it loaded

lsmod | grep br

sudo reboot
```

Note that the open SoftMac driver might NOT fully support your model, see 
[https://wireless.wiki.kernel.org/en/users/drivers/brcm80211]

### Bluetooth devices 

(see also Audio section below for Audio Bluetooth issues) 

``` 
##### basic diagnostics

# check if the radios are switched off
rfkill list all

dmesg | grep -i blue

# if you are not sure what adapter you have look in devices
# be aware it might _not_ say bluetooth if, for example it is combined with a PCI wireless radio
lsusb
lspci

# display a list of bluetooth device mac addresses
hcitool dev

##### disconnection issues after suspend #####

cat /var/log/syslog|grep -i blue|tail

# may show something like...
# Bluetooth: hci0 link tx timeout
# Bluetooth: hci0 killing stalled connection 10:73:00:00:06:02

# reset the adapter
sudo hciconfig hci0 reset
# credit - https://help.ubuntu.com/community/BluetoothSetup
```
## HIDs (Human Input Devices) 

### Keyboard 

#### devices 

``` 
# simple list of input devices
xinput -list
# credit - http://superuser.com/questions/75817/two-keyboards-on-one-computer-when-i-write-with-a-i-want-a-us-keyboard-layout

# test the input (using the id)
xinput test 14
# credit - http://stackoverflow.com/a/21819422

# list intput device details
cat /proc/bus/input/devices
# check corresponding Handlers 
cat /proc/bus/input/handlers 

# other diagnostic info 
dmesg|tail
cat /var/log/Xorg.0.log|tail
lsmod
# credit - https://wiki.ubuntu.com/DebuggingKeyboardDetection#In_case_your_keyboard_doesn.27t_work_at_all
```

#### layouts 

```
# to get an on screen keyboard under Menu / Universal Access
sudo apt-get install -y onboard

# to check you current layout
cat /etc/default/keyboard

# to check what symbols are available under your layout
cd /usr/share/X11/xkb/symbols
cat <your layout code e.g. fr>
# 

# compose key
# by default it is ALT GR (right alt) then RELEASE
# to change see http://askubuntu.com/questions/73903/compose-key-in-lxde
```

