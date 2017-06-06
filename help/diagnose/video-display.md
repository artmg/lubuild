

see also:
* [https://github.com/artmg/lubuild/blob/master/help/configure/VM-GPU-Passthrough.md]
    * How to play Windows-only games with your powerful graphics card


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

# Check driver details
modinfo drivername 

```

### other diagnostics

_What do these do?_
```
sudo apt-get install mesa-utils

glxinfo 
```

## Control Monitors

### How to control HDMI screen brightness from PC

#### Hardware methods

* HDMI-CEC
* USB HID
* DDC/CI (e.g. ddccontrol package) which can work via VGA if cables and devices are compliant

#### Software methods

xrandr can control the brightness of displays. 
Apparently this is by changing the gamma, rather than actually adjusting the backlight intensity.

e.g. 
 xrandr --output HDMI1 --brightness 0.5

To assign this to OpenBox hotkeys, try the script: xrandr-adjust-brightness (up / down) - [http://crunchbang.org/forums/viewtopic.php?id=39314]

NB: if you have issues controlling integral LCD on a particular vendor's laptop, 
try the grub option acpi_backlight=vendor e.g. GRUB_CMDLINE_LINUX_DEFAULT="quiet splash acpi_backlight=vendor" - alternatively video.use_native_backlight=1





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

* Use these in descending order of preference. 
    * Stick to open source unless you have good reason - 
    * see [[https://help.ubuntu.com/community/BinaryDriverHowto]]

To update to proprietary drivers use Start / Preferences / Additional Drivers to detect and install
* either the base package 
* or the updates 


### Open Source drivers


see also:
* [http://www.makeuseof.com/tag/top-7-ppas-repositories-add-ubuntu-based-systems/]
    * PPAs for the very latest versions of the open source drivers
* https://launchpad.net/~oibaf/+archive/ubuntu/graphics-drivers



#### Intel Open Source Drivers

Intel have their own Open Source Drivers, published on https://01.org/linuxgraphics/downloads

You need to add a couple of repos, but then you just download their installer that takes
care of all the downloads and sets you up. Great! - EXCEPT they run a few months behind
the ubuntu cycle

e.g. https://01.org/linuxgraphics/downloads/intel-graphics-installer-linux-1.1.0
v1.1.0 released 15 June 2015 supports 14.04 and 14.10 - NOT 15.04!

Apparently you can use the repo to download for other derivatives manually
http://www.webupd8.org/2013/04/how-to-use-intel-linux-graphics-drivers.html
but will this work for later versions?

They do also publish a whole stack of individual drivers
e.g. 31 mar 2015 they released https://01.org/linuxgraphics/downloads/2015/2015q1-intel-graphics-stack-release
not sure which bits to take!

* XF86-Video-Intel - 2D accelerated driver for X11 
* Mesa - 3D OpenGL 
* VAAPI - Video Acceleration API for video processing
* Kernel driver and LibDRM which interfaces the other drivers




### NVidia drivers

The simplest way is by accessing the Additional Drivers GUI, but if you have issues 
you may need to drop directly to a shell or even use ssh

The repo for NVidia proprietary drivers is [https://launchpad.net/~graphics-drivers/+archive/ubuntu/ppa] which you add:

```
# check the drivers available 
sudo ubuntu-drivers devices

# Add the repo for NVidia proprietary drivers [https://launchpad.net/~graphics-drivers/+archive/ubuntu/ppa] 
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt-get update
sudo apt-get upgrade

# You could simply reboot then choose the driver from the Additional Drivers GUI 
# or install from command prompt (if you know which you want)
sudo apt-get install nvidia-370

# recheck the drivers 
sudo ubuntu-drivers devices


#### Troubleshooting

# The best recent place to find out about NVidia driver installation is: 
# help - [http://askubuntu.com/a/61433]
# as the old ubuntu comminuty pages are ancient [https://help.ubuntu.com/community/BinaryDriverHowto/Nvidia] 

# ensure your xorg conf file exists and create if not
sudo nvidia-xconfig

##### Reinstalling drivers and or XOrg

# make sure all your package depenencies are at the correct level
sudo apt-get update
sudo apt-get upgrade
# check which packages you have installed
dpkg -l | grep nvidia

# Reinstalling the driver solves several issues (replace XXX with your version number)
sudo apt-get install --reinstall nvidia-XXX

# Reinstalling Xorg also helps in other cases:
sudo apt-get remove --purge xserver-xorg
sudo apt-get install xserver-xorg
sudo dpkg-reconfigure xserver-xorg
# now reinstall drivers as above, just to make sure

##### Remove 

dpkg -l | grep nvidia
sudo apt-get purge nvidia*
# only in ?? cases?
sudo apt-get purge bumblebee primus   
sudo rm -fr /etc/modprobe.d/bumblebee.conf
#
sudo reboot


# see also the archive of proprietary NVidia linux drivers [http://www.nvidia.com/object/unix.html]

```



#### Phoronix Test Suite

```
sudo apt-get install phoronix-test-suite
#run benchmarks ...
```


### AMD Catalyst driver install 

```
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

## Advanced troubleshooting

### example circumstances

#### example 1

Xorg laggy - spikes to "over 100%" cpu
https://bugs.launchpad.net/ubuntu/+source/xorg/+bug/1372116

Improve bug report or find similar
[HD 6290] 

xserver-xorg-video-radeon 

/usr/lib/xorg/modules/drivers/radeon_drv.so
compiled for 1.15.1, module version = 7.3.0

Especially when switching windows or tabs
Issue whether or not external HDMI is attached as duplicate output

https://help.ubuntu.com/community/RadeonDriver

#### example 2

[Radeon HD 6290] xorg freezes when turning on external monitor
Steps to reproduce:
Insert HDMI cable
Start Menu / Preferences / Monitor Settings
Quick Options / Show the same screen on both laptop LCD and external monitor
X will freeze immediately, mouse is blocked, CTRL-ALT-F1 does not respond, only direct hardware function keys (like screen brightness / disable wifi) respond

### gather diags 

```
Set up SSH using 
https://github.com/artmg/lubuild/wiki/Networked-Services#SSH__remote_Secure_SHell

logged into SSH using
ssh MyUser@MyHostName.local -p PortNum

# prepare
mkdir -p ~/BugDiags
cd ~/BugDiags

sudo lshw -C video > lshw_video.txt

# credit - https://wiki.ubuntu.com/X/Troubleshooting/Freeze#Reporting_GPU_lockup_Bugs
sudo apt-get install radeontool
sudo avivotool regs all > regdump_good.txt

#### Reporting issues

# provoke the issue, then...
# credit - https://wiki.ubuntu.com/X/Troubleshooting/Freeze#Gathering_Register_Dumps
dmesg > dmesg.txt
cp /var/log/Xorg.0.log Xorg.0.log
sudo avivotool regs all > regdump_broke.txt

# credit https://help.ubuntu.com/community/ReportingBugs
# bug with no crash
apport-cli -f -p xorg --save bug.apport

# then log back into your main system and
apport-bug -c bug.apport   

# or if you cannot manage to get a crash report then
http://bugs.launchpad.net/ubuntu/+source/xorg/+filebug?no-redirect

## The following is NO USE unless a crash has occured (i.e. no good if only frozen)
# credit - https://wiki.ubuntu.com/X/Reporting#Reporting_Bugs_from_a_Different_Machine
apport-bug --save foo.apport   
 

#### Reporting to NVidia

The forum for logging issues with NVidia is [https://devtalk.nvidia.com/default/board/98/linux/]

[https://devtalk.nvidia.com/default/topic/522835/linux/if-you-have-a-problem-please-read-this-first/]
* how to gather logs locally or via SSH
* how to describe issues when logging faults

```

