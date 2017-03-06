## OS Version

``` 
# What version is my system
uname
lsb_release -a
# short version is...
# lsb_release -sr

# on a LiveUSB you can check without booting 
# by opening the file README.diskdefines in the media's root 

# kernel version
cat /proc/version
```

## OS Architecture

``` 
# Detect Processor Arch
uname -m
# i686 = 32-bit
# x86_64 = 64-bit
```

## Shell

``` 
# which shell and version?
which $0 && $0 --version
# http://wiki.ubuntu-it.org/Programmazione/LinguaggioBash
```

## Boot-Repair

```
# if you are having trouble with booting, 
# or wish to return from using GRUB boot loader 
#	and reinstall Windows Master Boot Record (MBR) with NTBootloader, 
# If you can only boot to Windows locally, use a LiveUSB for this
# help - [https://help.ubuntu.com/community/Boot-Repair]

sudo add-apt-repository ppa:yannubuntu/boot-repair && sudo apt-get update
sudo apt-get install -y boot-repair && (sudo boot-repair &)

# make a note of any URL you are given to Pastebin or similar log caching site

# if you are still having problems with a dual-boot install 
# see also the section **Dual Boot / bcdedit** in 
# [https://github.com/artmg/lubuild/blob/master/help/configure/Windows.md] 
```

## Hostname 

```
# to check the hostname (works on remotely attached drives)
cat /etc/hostname
# to change the hostname see http://askubuntu.com/a/16443
```

## Installation date 

```
# ouptut first 3 words of install log (i.e. date install started)
sudo cat /var/log/installer/syslog | head -1 | cut -f 1-3 -d " "
```

## Resource utilisation

```
# CLI...
top
# htop as alternative, showing process hierarchy - needs installing
# consider respected CLI 'glances' tool - http://askubuntu.com/a/293447

# GUI (or via System Tools menu)
lxtask
# or in Ubuntu...
gnome-system-monitor

# some performance tweaks, including swapiness
cat /proc/sys/vm/swappiness
# see more at - https://sites.google.com/site/easylinuxtipsproject/speed
```

* For issues checking Disk Utilisation, see Hardware Troubleshooting [https://github.com/artmg/lubuild/wiki/Troubleshooting#Hardware] 


## Diagnostic Log Files

```
# Check the log
dmesg | tail

# logs are in
#  /var/log/

# if you want to force rotation then check there is a .conf file in
#  /etc/logrotate.d/
# and run (e.g.)
logrotate -df /etc/logrotate.d/rsyslog
# to see what would happen then
sudo logrotate -f /etc/logrotate.d/rsyslog
# to force rotation
```

## Performance and Tuning 
Some of these are old links...
```
# Check the top CPU consuming processes:
top

# Check if anything is swapping heavily
sudo apt-get install sysstat
iostat -k 5

# 10 ways to make Linux boot faster (July 24th, 2008 - Jack Wallen)
# http://blogs.techrepublic.com.com/10things/?p=387

# Make Linux faster, lighter and more powerful -
# http://www.techradar.com/news/computing/pc/make-linux-faster-lighter-and-more-powerful-641317?artc_pg=1
```

## Updates 

Sometimes bringing software (both OS and apps) to the latest versions can resolve issues
```
# simple update, no risk of breaking packages or dependencies
sudo dpkg --configure -a      # complete any previously-interrupted installs
sudo apt-get update           # reread all repo contents
sudo apt-get upgrade -y       # update all packages

# potential to remove dependencies, but _MOST_ things _unlikely_ to break (!)
sudo apt-get dist-upgrade -y  # updates including kernels
sudo apt-get autoremove -y    # remove obsolete packages and kernels

# any third party drivers may need manual updating
```

If you want to understand the difference between ''upgrade'' and ''dist-upgrade'' 
please read http://askubuntu.com/questions/194651/ or to contrast with
''do-release-ugrade'' behaviour see http://ubuntuforums.org/showthread.php?t=2113373

To troubleshoot issues with apt-get see Applications / Package Manager section below

### Latest mainline kernel

Some driver issues recommend installing the latest mainline ('''non-daily''') kernel as the issue may already have been fixed upstream (help - https://wiki.ubuntu.com/Kernel/MainlineBuilds ). Be aware that these are unsupported, and for diagnostics. You can however install these kernels side-by-side and only use them for specific tests.
* Browse to http://kernel.ubuntu.com/~kernel-ppa/mainline/?C=N;O=D
* open the latest folder
* download 3 .deb files (generic unless you use low latency):
** headers for your arch
** headers for "all"
** image for your arch
* install the .debs
 sudo dpkg -i *.deb
* reboot into new upstream kernel from grub

### Kernel versions 

```
# check exact kernel version signature in use
cat /proc/version_signature
# credit http://ubuntuforums.org/showthread.php?t=1872537

# check versions installed
dpkg-query -W -f '${db:Status-Abbrev}\t${Package}\t${Version}\n' linux-image-* | grep -E '^ii'
# credit https://help.ubuntu.com/community/Lubuntu/Documentation/RemoveOldKernels

# latest linux kernel
x-www-browser https://www.kernel.org/
# find specific kernel versions
x-www-browser http://kernel.ubuntu.com/~kernel-ppa/mainline/
```
what is not currently clear is where to find which is the latest kernel release for a specific ubuntu version!

### Choose preferred kernel 

The GRUB bootloader will normally default to the latest installed kernel, but you may want to choose a different one. For instance, if you have installed the latest mainline kernel, you may wish to revert to the supported kernel version.

```
# change kernel version...

##### momentarily: 
# choose from grub menu at cold boot
# if you do not normally see the Grub Menu at boot, 
# hold the SHIFT key to force it to appear and wait

##### temporarily: 
# change default option, based on 0 as first option
# e.g.  GRUB_DEFAULT="1>2"
# will choose the second option, and the third option from the submenu (quotes required for submenus)
# credit - https://help.ubuntu.com/community/Grub2/Submenus
sudo leafpad /etc/default/grub
sudo update-grub   
# help - https://help.ubuntu.com/community/Grub2/Setup#Configuring_GRUB_2

##### permanently:
# check https://help.ubuntu.com/community/Lubuntu/Documentation/RemoveOldKernels
dpkg-query -W -f '${db:Status-Abbrev}\t${Package}\t${Version}\n' linux-image-* | grep -E '^ii'
# choose which to remove
sudo apt-get autoremove -y linux-image-W.X.Y-Z-generic
```

## Shutdown / reboot 
```
# Reboot neatly
sudo reboot

# neatly shutdown now
sudo shutdown now -P

# Immediately pull the plug
sudo halt
```

## Startup Apps 

```
# To control what runs at startup, install &amp; use
sysv-rc-conf
```

