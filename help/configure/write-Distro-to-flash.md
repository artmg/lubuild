
This is about creating LiveUSB media on a flash drive, 
to install or try out an OS. It also includes troubleshooting 
and how to add a Persistence volume

see also:

* [https://github.com/artmg/lubuild/blob/master/help/configure/Disks-and-layout.md]
    * once you've booted your distro, how do you want to configure your storage?
* [https://github.com/artmg/lubuild/blob/master/help/manipulate/flash-drives-and-SSDs.md]
    * special info about how to work with flash (non-mechanical) storage devices
* [https://github.com/artmg/MuGammaPi/wiki/Disks#distro-images]
    * 
* [https://github.com/artmg/lubuild/blob/master/help/understand/test-and-qa-for-Lubuntu.md]
    * contributing to the Lubuntu Test and QA community


## Purposes

* Operating system installation
    * extremely common use for Live Boot media
    * includes basic memory and storage testing ability
* Disk configuration and diagnostics
    * very handy if the OS on your hard disk is playing up
* Data Recovery 
    * see [https://github.com/artmg/lubuild/blob/master/help/manipulate/disk-recovery-and-forensics.md]
* 


### Multiboot ISOs

Here are some articles explaining how to take ISOs for multiple linux
distros, and create Grub menus to allow you to boot directly into
whichever you prefer. This assumes the ISOs are created for Live boot
and run - this technique might not support persistence of settings or
data.

* simple - [http://www.circuidipity.com/multi-boot-usb.html]
* generic - [http://ubuntuforums.org/showthread.php?t=2276498]
* extensive - [https://wiki.archlinux.org/index.php/Multiboot_USB_drive]
* other ISOBOOT samples - [https://help.ubuntu.com/community/Grub2/ISOBoot/Examples]

See also further down for old instructions on combined UBCD multi-boot



## check ISO integrity

Ensuring the package arrived intact is not only about maintaining security, 
it will also save you time and much frustration if you discover immediately 
whether you inadvertently lost some bits during transmission. 

Copy the hyperlink to MD5SUMS. Browsing in pcmanfm in the folder containing the ISO image, press F4 for a terminal

```
wget url_to_MD5SUMS
md5sum -c MD5SUMS
```

Alternatively if you just see the SHA-256 checksum on the download page you can manually compare it to the output from `sha256sum ~/Downloads/myimage`


## Flash two partitions

Below is a handy bit of automation 
that also sorts out the media labels and other details. 
It has been designed to work from the bash prompt 
on OSes including Ubuntu  and Raspbian.

These commands assume the typical disk layout 
for live Linux OS images 
where there is a small FAT boot partition 
followed by a larger EXT partition 
with the rest of the OS on there. 

It will write the two image partitions 
and label them for clarity. 

Note: this automation in the rest of this page 
is similar to that used in the pages below, 
so perhaps they could be merged at some point?

* [Buildroot](https://github.com/artmg/MuGammaPi/wiki/buildroot)
* [ArchLinuxArm install](https://github.com/artmg/MuGammaPi/wiki/arch-linux-install)
* [Raspbian basics](https://github.com/artmg/MuGammaPi/wiki/Raspbian-basics)
* [disks - rename](https://github.com/artmg/lubuild/blob/master/help/configure/disks.md#rename)

```
# type and tab after this to choose filename
IMAGE_FILENAME=

# enter the label you want for this device
MEDIA_LABEL=

# check the output for the dev name set as **vfat**
MEDIA_DEVICE=sdX9

# enter your password for su
sudo echo

# Prepare
SHORT_LABEL=${MEDIA_LABEL:0:8}
# detect unix release
. /etc/os-release
. /etc/*-release

# set up required tools
case "${ID}" in
  raspbian)
    FAT_LABEL_SET="sudo dosfslabel /dev/${MEDIA_DEVICE}1 ${SHORT_LABEL^^}_OS"
    FAT_LABEL_GET="sudo dosfslabel /dev/${MEDIA_DEVICE}1"
    ;;
  ubuntu)
    # udisks2 is probably installed by default
    sudo apt install -y udisks2 mtools
    # avoid the error "not a multiple of sectors"
    echo mtools_skip_check=1 > ~/.mtoolsrc
    FAT_LABEL_SET="sudo mlabel  -i /dev/${MEDIA_DEVICE}1 ::${SHORT_LABEL^^}_OS"
    FAT_LABEL_GET="sudo mlabel  -i /dev/${MEDIA_DEVICE}1 -s ::"
esac

# In case the device had volume that auto mounted on insertion...
udisksctl unmount --block-device /dev/${MEDIA_DEVICE:0:3}1
udisksctl unmount --block-device /dev/${MEDIA_DEVICE:0:3}2
sudo partprobe

# now swap the file extension as the image is unzipped directly to the device
unzip -p $IMAGE_FILENAME ${IMAGE_FILENAME//+(*\/|.*)}.img | sudo dd bs=4M status=progress of=/dev/${MEDIA_DEVICE:0:3}
# credit for substitution code https://stackoverflow.com/a/38277789
# if you have a .img.xz then use...
# xzcat $IMAGE_FILENAME ${IMAGE_FILENAME%.*}.img | sudo dd bs=4M status=progress of=/dev/${MEDIA_DEVICE:0:3}

# write everything still left in the cache 
sync
#


```

Now you wait a few minutes depending on 
the size of the image and speed of the media.

```

## don't yet have to ...
## eject
#udisksctl unmount --block-device /dev/${MEDIA_DEVICE:0:3}1
#udisksctl unmount --block-device /dev/${MEDIA_DEVICE:0:3}2
#udisksctl power-off --block-device /dev/${MEDIA_DEVICE:0:3}
## help - https://udisks.freedesktop.org/docs/latest/udisksctl.1.html
#echo please eject and re-insert media

sudo partprobe
# sudo fdisk -l /dev/${MEDIA_DEVICE}

# The partition arrangement here is for Raspbian
# see [https://github.com/artmg/MuGammaPi/wiki/Rasbian-basics]
# it appears also valid for ArchLinuxArm images

# Setting name on both partitions so Ext4 shows up on booted Pi and FAT shows up when inserted on other systems
# Rename 1 FAT and 2 Ext4 
${FAT_LABEL_SET}
sudo e2label    /dev/${MEDIA_DEVICE}2 $MEDIA_LABEL\_disk

# display labels
${FAT_LABEL_GET}
sudo e2label    /dev/${MEDIA_DEVICE}2 
# Set name / display name - does it REALLY need sudo?
```

If you are done with all your changes to the image you can 'eject' it, i.e unmount and **Power it Down**

```
# eject
udisksctl unmount --block-device /dev/${MEDIA_DEVICE:0:3}1
udisksctl unmount --block-device /dev/${MEDIA_DEVICE:0:3}2

# Shut down USB device holding newly flashed image
udisksctl power-off --block-device /dev/${MEDIA_DEVICE:0:3}
# help - https://udisks.freedesktop.org/docs/latest/udisksctl.1.html
```


### Ubuntu and derivatives

These were the older techniques used before the automation code above, and they are specific to Ubuntu.

#### Choice = Safer - mkusb

If you find the (L)ubuntu built-in *Startup Disk Creator* does not
reliably create bootable live usb drives, try the alternative **mkusb**
script, which also protects you from accidentally overwriting non-removable media. 

Browsing in pcmanfm in the folder containing the ISO image, press F4 for a terminal

```
# type and tab after this to choose filename
IMAGE_FILENAME=

# enter the label you want for this device
IMAGE_LABEL=

# leave this blank (no 'p') if you want NO persistence in the flash image
IMAGE_PERSISTENCE=p

# enter your password for su
sudo echo

# help https://help.ubuntu.com/community/mkusb
sudo add-apt-repository -y ppa:mkusb/ppa
sudo apt update
sudo apt install -y mkusb

# IF CHOICE = write to USB
sudo -H guidus $IMAGE_FILENAME $IMAGE_PERSISTENCE 
# enter persistence % (e.g. 100%)
# choose GPT or MSDOS partition table
```

See more about persistence in the later section.



#### Choice = Simpler - dd

The actual command for dd writing is very straightforward. Browsing in pcmanfm in the folder containing the ISO image, press F4 for a terminal...

```
# type and tab after this to choose filename
IMAGE_FILENAME=
# check the output for the dev name set as **vfat**
MEDIA_DEVICE=sdX9

# now swap the file extension as the image is unzipped directly to the device
unzip -p $IMAGE_FILENAME ${IMAGE_FILENAME%.*}.img | sudo dd bs=4M status=progress of=/dev/${MEDIA_DEVICE:0:3}
# if you have a .img.xz then use...
# xzcat $IMAGE_FILENAME ${IMAGE_FILENAME%.*}.img | sudo dd bs=4M status=progress of=/dev/${MEDIA_DEVICE:0:3}

```

#### Choice = GUI - gnome Disks utility

If you prefer a GUI alternative, you may find the gnome Disks utility's 
Image Restore options pratical. 

However these offer you NO features to avoid you accidentally choosing the wrong 
destination and inadvertently **wiping all your data**, so beware!

If you have a paritition image then choose the destination partition and choose 
"Restore Partition Image". If you have a Disk image then select the drive unit 
and use the top right hand menu to choose "Restore Disk Image". 

NB: This technique does NOT add any bootloader, so whether it works also 
depends on the image you choose to use, unless you have UEFI-enabled systems. 

If you get errors such as _isolinux.bin missing or corrupt_ then perhaps 
you tried to write a Disk image to a Partition?



## Troubleshooting boot issues

Here are some pointers to help you boot into the flash media you have written. 
When you start your computer you usually need to press a key to choose an alternative 
boot medium. The key depends on the BIOS but could be **DEL** or **F2** or **F12**. 

If you have a UEFI that is set to boot only EFI partitions, it might not recognise the boot medium, 
but this lack of backwards compatibility is rare. 


### ISO not hybrid

Hybrid ISOs include a Master Boot Record (MBR) to allow them to boot from USB devices 
as well as from optical drives. If you have used one of the methods above to write 
an ISO file to a drive, but it fails to boot it could be because it is NOT a hybrid ISO. 

```
# Detect if ISO is hybrid using fdisk:
fdisk -l path/to/file/filename.iso

# If you see a partition table, then the ISO is a hybrid iso. 
# If NOT then continue onto steps below to fix this 

sudo apt-get install syslinux-utils
# or just  syslinux  in Trusty and previous versions

# IMPORTANT: you must ONLY run isohybrid once on an ISO, 
# and only if you are sure it is not already hybrid

# ensure you keep the original iso file
cp -p filename.iso filename-hybrid.iso

# the actual command
isohybrid filename-hybrid.iso
# credit [https://help.ubuntu.com/community/mkusb/isohybrid]
# if you want to install to a partition, rather than a whole disk, add option -partok 
```



## Using Live Media

#### Bookmarks for media locations

This might also be useful if you have persistence (see later section)

* Once CDROM is remounted as RW add to File Mgr as Places...
 
Browse to                | Add Bookmark as 
-------------------------+-------------------
/cdrom                   | ALLP root
/cdrom/Media/In.various  | ALLP.IN



### about memtest

Note that the install media for most Ubuntu distros includes the memtest86+ memory test utility, 
however it is **not** UEFI-compatible, and will not be available when you boot dfirectly from a GPT partition. 
It will only appear when you boot from a device's BIOS-compatible partition table using legacy boot, 
and you may also need to hold SHIFT to ensure that the menu appears. 


#### startup disk creator troubleshooting

If you are having issues with usb-creator-gtk crashing, then ensure that
your FAT partition covers the whole disk (no small empty slice at the
beginning) or reboot

### only check systems on USB

```
# if you are installing to a 'portable'
# usb drive and want to ignore 'local' drives...
# <http://ubuntuforums.org/showthread.php?t=1412654&page=2>

echo "GRUB\_DISABLE\_OS\_PROBER=true" | sudo tee -a /etc/default/grub
```

#### Read Only drives

Move OUT to (or refer in from) [Disks-and-layout]

If any drive is mounted read only, including the Live USB filesystem, you can remount it as Read Write using

```
sudo mount -o remount,rw /cdrom
# credit http://askubuntu.com/questions/54613
# OR mount stick as something other than /cdrom = RO !
sudo mkdir -p /media/Wallet
sudo mount /dev/sdb1 /media/Wallet

### OLD DETAIL ON - CDROM RO issue *** CHECK FOR DUPES WITH ABOVE!!! ***
# credit &gt; http://askubuntu.com/a/54622
# credit &gt; http://unix.stackexchange.com/questions/47433/mount-usb-drive-fat32-so-all-users-can-write-to-it#comment66000_47433
sudo mount -o remount,rw,UID=`id -u` /cdrom
# fix (requires manual changes)
# http://www.pendrivelinux.com/sharing-files-between-ubuntu-flash-drive-and-windows/
# workaround 
# http://askubuntu.com/a/57911
# if it's been used in windows, but not safely removed...
# help &gt; http://ubuntuforums.org/showthread.php?p=7525441
```



### Live Boot Parameters

Although this list is specifically for TAILS, it does explain a wide
variety of available boot-time settings you can make on a LiveUSB

<https://craftedflash.com/info/live-distro-boot-parameters>




## Live Persistence


### Setting up

```
#### Partition

# Creating a Casper-RW partition may be the simplest way to provide a large amount of persistence.

# create your partition with fdisk

# then create the filesystem
sudo mkfs.ext4 -b 4096 -L casper-rw /dev/sdXn
# credit - https://help.ubuntu.com/community/LiveCD/Persistence#Creating_the_.22casper-rw.22_File_System


#### Volume (in a file)

# create the persistence file
sudo cp /media/AMG_LIVE/casper-rw/media/Wallet/#
# help creating casper-rw &gt; http://www.pendrivelinux.com/how-to-create-a-larger-casper-rw-loop-file/

```


### Using Persistence


```
#### Access Casper Volume to insert/extract files 

# to get files out of the casper volume, mount elsewhere it in 'loop' mode
sudo mount -o loop /path/to/casper-rw /mnt
# credit - http://shallowsky.com/blog/linux/install/ubuntu-persistent-live-cd.html


#### Mount casper-rw persistence file 

# If you saved any files onto your Live USB using persistence volume, 
# it is saved into the file casper-rw in the root. 
# To recover files simply mount this...

# credit - http://ubuntuforums.org/showthread.php?t=1028564
sudo mkdir /media/casper
sudo mount -o loop /media/GPARTEDLIVE/casper-rw /media/casper/
# then unmount it afterwards
sudo umount /media/casper/
sudo rmdir /media/casper/
```




## Raspberry Pi ##

### Foundation's dd write to device

[Pi Foundation's own Linux instructions](https://www.raspberrypi.org/documentation/installation/installing-images/linux.md)
may look complex but essentially boil down to a simple dd write of the entire destination filesystem. 
Note that this process will essentially overany additional partitions which may have existed on the media, 
which of course will erase any data previously stored there. 

You can use **mkusb** above for a more controlled approach, which makes it more likely you will select the right device. If you have a zipped image you could pipe it directly to the disk with `unzip -p xxx.zip xxx.img | dd bs=4M of=/dev/yyy` 


### expand the second partition

for details on expanding the default Raspbian 
second parition to fill your device, see


### Partition start improvement?

NB: The image has the starting sector of the first partition at 8192. 
If the flash media came partitioned with a start sector of 32768 
this was presumably the best alignment for the media...
How can we move the first partition to this alternate start sector? 
any ideas from [http://askubuntu.com/a/491097] 
or [https://www.linux.com/news/how-modify-raw-disk-image-your-custom-linux-distro]


### other

Raspberry Pi Foundation's instructions are based on [ELinux's own instructions](http://elinux.org/RPi_Easy_SD_Card_Setup#Flashing_the_SD_Card_using_Linux_.28including_on_a_Raspberry_Pi.21.29) 
which also add a simpler option of the ImageWriter GUI (or usb-imagewriter on deb-based distros)

According to [https://github.com/artmg/MuGammaPi/wiki/Media-Centre] 
OSMC site's "linux installer" loads specialist SD creator, 
which then asks for root before it 
creates a 255MB FAT32 partition to expand on SD 

[RetroPie's instructions](https://github.com/RetroPie/RetroPie-Setup/wiki/First-Installation#install-30-image-on-sd-card) 
suggest Win32DiskImager or Apple Pi Baker, 
but mention no Linux utility 

Nio Wiklund suggests on https://wiki.ubuntu.com/Win32DiskImager/iso2usb 
that Win32DiskImager and mkusb work in the same way

There are suggestions that  Disks->Restore Disk Image  
would work in a useful GUI kind of way, even if the term 'Restore' is not the clearest

According to http://ubuntuforums.org/showthread.php?t=1958073
mkusb can unpack .img.gz (.xz) files
at v10 it cannot yet do .zip files





## Old IN ################################################################################################


=== Other ===

Lubuntu kbd layout: http://noobish-nix.blogspot.co.uk/2012/06/how-to-add-and-switch-keyboard-layout.html?spref=tw

== Comprehensive: Universal Boot ==

The preferred method of creating a LiveUSB is currently to build a combined boot USB based upon Universal Boot CD (UBCD). This way it can incorporate all manner of handy utils, as well as your chosen Ubuntu distro.

=== Prepare ===

Format your USB drive with FAT32

=== UBCD ===

Open the UBCD ISO and copy the following folders to the root of your drive:

<pre>antivir
boot
pmagic
ubcd</pre>
<br />Create the MBR and SysLinux boot code

<pre>d:
cd \ubcd\tools\win32\ubcd2usb
syslinux -ma -d boot\syslinux d: -f
REM help - http://syslinux.zytor.com/wiki/index.php/SYSLINUX</pre>
PS: if your Windows has UAC you might need to run the command prompt as administrator

=== UBCD boot sequence ===

syslinux looks in the following locations for its configuration files

* /boot/syslinux/syslinux.cfg
* /syslinux/syslinux.cfg
* /syslinux.cfg

UBCD's implementation uses the first location and appends the following config

* /ubcd/menus/syslinux/main.cfg

and finally, at boot, if you choose the User Defined option at the end of the first section you are presented with the choices from

* /ubcd/custom/custom.cfg

=== Ubuntu ===

Open the Ubuntu Desktop ISO and extract the following folders into root

<pre>.disk
casper
dists
install
pics
pool
preseed</pre>
then copy the folder

<pre>isolinux</pre>
and rename it to

<pre>syslinux</pre>
go into this folder and rename

<pre>isolinux.cfg</pre>
to

<pre>syslinux.cfg</pre>
and

<pre>isolinux.bin</pre>
to

<pre>syslinux.bin</pre>
Finally run syslinux. 
If you use the windows version in win32, 
you must run the CMD prompt as administrator 
to write to the MBR on the drive:

<pre>syslinux -maf X:</pre>
See ealier section for what to put in the boot file '''syslinux/txt.cfg'''

credit [https://wiki.ubuntu.com/LiveUsbPendrivePersistent#Installing_Ubuntu_on_the_USB_drive]

==== ''OLD'' ====

''These instructions are from a reference below. However, since Ubuntu 10.10 these folders do not seem to be enough to boot successfully!''<br />''Looking at differences in the distros, there is now a file''

```
boot/grub/loopback.cfg</pre>
<br />''so probably need to merge the following in too (not version with brackets):''

<pre>boot</pre>
<br />''If that fails then do the lot''<br /><br />Open the file \boot\syslinux.cfg and append the following:

<pre>LABEL -
MENU LABEL Ubuntu Live
LINUX /casper/vmlinuz
 INITRD /casper/initrd.lz
 APPEND preseed/file=preseed/ubuntu.seed boot=casper root=/dev/ram rw splash --
 
LABEL -
MENU LABEL Ubuntu Persistent
 LINUX /casper/vmlinuz
 INITRD /casper/initrd.lz
 APPEND preseed/file=preseed/ubuntu.seed boot=casper persistent root=/dev/ram rw splash --</pre>
```

=== Issues ===

```
# This may give you issues with the limited size of casper-rw file available for persisting changes

#===regional settings===

# TIMEZONE ###
# credit [http://serverfault.com/questions/84521/automate-dpkg-reconfigure-tzdata]
sudo echo "Europe/London" | sudo tee /etc/timezone
sudo dpkg-reconfigure -f noninteractive tzdata

# DEPRECATED ##################################
#
# no longer using these as the boot menu can choose language & locale
#
##sudo echo LANG="en_GB.UTF-8" | sudo tee /etc/default/locale
##sudo dpkg-reconfigure -f noninteractive locales
#
##sudo update-locale LANG=en_GB.UTF-8
#
## credit [https://help.ubuntu.com/community/EnvironmentVariables]
##sudo gedit /etc/environment
#
###############################################


#===error during update===
# ' update-initramfs: 
# ' cp: cannot stat `/vmlinuz': No such file or directory
# credit [https://bugs.launchpad.net/ubuntu/+source/usb-creator/+bug/557023/comments/3]
sudo cp /cdrom/casper/vmlinuz /boot/vmlinuz-2.6.32-21-generic



==repair from live usb after windows reinstalled==

credit [https://help.ubuntu.com/community/RecoveringUbuntuAfterInstallingWindows]

Use file manager to mount and view the linux root partition

# run Terminal
mount | tail -1
# to see the drive's UUID

cd /media/ # <press tab to auto complete uuid>
cat ./boot/grub/grub.cfg
# to make sure the file exists

# reinstall GRUB to the first hard drive (or change sda)

sudo grub-install --root-directory=. /dev/sda

# you should see ...
#
# Installation finished. No error reported.
#
# If you get BIOS warnings try adding option   --recheck


===Build multi-OS boot utility live USB===

single usb drive or sd card containing:
* ubuntu
* portableapps
* wallet.copy
* media.IN
* ubcd (Ultimate Boot CD)

This latter is the base for a whole host of utils including DOS
and uses syslinux menus

Download UBCD iso and extract with 7zip
[UBCD | http://www.ultimatebootcd.com/download.html]

Use memory stick instructions from [Customizing UBCD | http://www.ultimatebootcd.com/customize.html]
to mbr &amp; syslinux the LiveUSB and copy the full Ultimate Boot CD over

Then add the ubuntu distro to usb and syslinux menu
[Ubuntu 9.10, Syslinux, UBCD 5 : 3 Step How-To Guide 
| http://www.ultimatebootcd.com/forums/viewtopic.php?f=7&t=2259]

help [syslinux | http://syslinux.zytor.com/wiki/index.php/SYSLINUX]

Alternative GUI util to combine multiple ISOs [MultiBootISOs | http://www.pendrivelinux.com/boot-multiple-iso-from-usb-multiboot-usb/]


===Trackpoint makes mouse drift===

# Possible solutions to stop trackpoint making your mouse cursor drift
#
synclient GuestMouseOff=1
#
# or edit the Xorg.cfg file
# 
# help [https://help.ubuntu.com/community/SynapticsTouchpad]
```

== Live USB - to be filed ==

```
# deprecated, there is one in ubuntu distrib
## Startup Disk Creator for making Ubuntu Live USBs
#sudo apt-get install usb-creator
#
Install using usb-creator
choose latest Desktop i386 (e.g. 10.4 LTS)
Launch and run Update Manager to get and install latest updates
#===error during update===
# ' update-initramfs: 
# ' cp: cannot stat `/vmlinuz': No such file or directory
# credit [https://bugs.launchpad.net/ubuntu/+source/usb-creator/+bug/557023/comments/3]
sudo cp /cdrom/casper/vmlinuz /boot/vmlinuz-2.6.32-21-generic
```


=== Issues ===

==== Mounting Drives ====

Issue in 12.10 mounting other USB drives

```
sudo mkdir /media/$USER
sudo chown $USER.$USER /media/$USER
# credit [http://askubuntu.com/questions/215219/cant-open-a-separate-usbdrive-when-booting-from-a-liveusb-install-12-10]
if mount still not visible in Nautilus browse directly to folder
```


