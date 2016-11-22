

## discover monitors

```
# display devices and available modes
xrandr

# detailed info on modes
xrandr --verbose

# Extended Display Identification Data (EDID)
sudo apt-get install -y read-edid
sudo get-edid | parse-edid
```

## discover drivers and config

```
### Detect Video ###
lspci -k | grep -A3 VGA
# credit - http://ubuntuforums.org/showthread.php?t=2173550&p=12784913#post12784913

### Detailed video config ###
sudo lshw -C video

```

To update to proprietary drivers use Start / Preferences / Additional Drivers to detect and install
* either the base package 
* or the updates 

To check the details of the driver use
 modinfo drivername 

## Choosing Video Drivers

There are three types of (video) drivers you can use:

* Open Source (e.g "radeon")
 + automatically installed
 + updated via repos
 + community supported

* Third Party Supplied (e.g. "fglrx")
 + simple to install
 + updated via repos
 - only supported by Third Party hardware vendor

* Third Party Downloads (e.g. fglrx beta version)
 - manual install and update only
 + access to the latest features (and sometime bugfixes)
 - only supported by Third Party hardware vendor

Use these in descending order of preference. 
Stick to open source unless you have good reason - 
see [[https://help.ubuntu.com/community/BinaryDriverHowto]]

```
### AMD Catalyst driver install 
#
#### manual install 
# When trying to install the latest Radeon HD drivers from 
# http://support.amd.com/en-us/download/desktop?os=Linux%20x86_64
# Got an error in /usr/share/ati/fglrx-install.log
# make (bad exit status: 1)
# [Error] Kernel Module : Failed to build fglrx-14.20 with DKMS
#
# perhaps due to kernel version check that requires a specific version
# use the patch in this article
# http://bluehatrecord.wordpress.com/2014/05/10/installing-the-proprietary-amd-catalyst-14-4-fglrx-driver-on-fedora-20-with-kernel-3-14/
#
# help - https://help.ubuntu.com/community/BinaryDriverHowto/AMD

#### Help for removal
#
# If you added it the easy way through "additional drivers" it's a click to put it back.
# If you installed manually then...
# credit - http://support.amd.com/en-us/kb-articles/Pages/Catalyst-Linux-Installer-Notes.aspx#Uninstall

# after this you should check for related packages
dpkg -l | grep fglrx

# and remove them completely
sudo apt-get remove --purge fglrx fglrx-amdcccle
# credit https://help.ubuntu.com/community/BinaryDriverHowto#How_to_recover_a_non-booting_system_due_to_driver_malfunction
#
# if there were issues restoring your xorg.conf file to default:
sudo dpkg-reconfigure -phigh xserver-xorg
#
# see https://help.ubuntu.com/community/VideoDriverHowto

#### "Additional Drivers" dialog 

# to get control back via "Additional Drivers" panel again
#
# Install the fglrx repo drivers 
sudo apt-get install fglrx
# then you can uninstall after by using the dialog
# credit - http://forums.linuxmint.com/viewtopic.php?f=49&t=134112

```

