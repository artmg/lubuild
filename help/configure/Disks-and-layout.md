

This file is being prepared for separation into 
different files to cover different subjects

e.g.
* configure Disks (here)
	* install, partitioning, ???
* diagnose disks
	* Troubleshooting
	* gone out to [https://github.com/artmg/lubuild/blob/master/help/diagnose/disks.md]
* understand Layout 
	* reasoning sections separate from precise commands to manipulate
	* specific examples like OpenElec
	* will go out to [https://github.com/artmg/lubuild/blob/master/help/understand/disk-layout.md]


See also:

* [https://github.com/artmg/lubuild/blob/master/help/diagnose/disks.md]
	* diagnosis and Troubleshooting on disks
* [https://github.com/artmg/lubuild/blob/master/help/manipulate/storage-in-connected-devices.md]
    * for device storage (MTP and PTP) and mounting
* [https://github.com/artmg/lubuild/blob/master/help/configure/write-Distro-to-flash.md]
    * creating LiveUSB installation media
* [https://github.com/artmg/lubuild/blob/master/help/manipulate/flash-drives-and-SSDs.md]
    * special info about how to work with flash (non-mechanical) storage devices
* [https://github.com/artmg/lubuild/blob/master/help/manipulate/remove-data.md]
    * removing data, securely if necessary
* 

# Configure Disks

## Install

There are various options for layout explained later in this article, but here is a common scenario 
- dual boot with full disk encryption on Ubuntu partition

* Boot from Install Media
* Connect to network
	* recommended even if you do not wish to install updates or extras 
	* ubiquity can download recent fixes to installation issues
	* e.g. grub-install sometimes fails with encrypted root unless network available

```
# turn off extra ('unsafe') swap to avoid errors during install
cat /proc/swaps
sudo swapoff -a
cat /proc/swaps

# launch installer
ubiquity
```

* Basics
   * choose language
	* I don't want to connect to internet
	* do not install third-party software

* Disk config 
	* Something else
	* select the root of the drive for boot loader
	* select small volume ax ext4 /boot
	* larger volume as Physical Volume for Encryption and enter pass phrase twice
	* Afterwards you will find a crypt mapper device at the top of the list
	* set this as the root
	* (if you get swap issues you may need to select other swap partitions and change to not used)

* Install Now
	* accept warnings about no swap and partitions to format


## Partitions

### Rename 

```
#!/bin/bash
# Rename partition to change label and automount path
# help > [https://help.ubuntu.com/community/RenameUSBDrive](https://help.ubuntu.com/community/RenameUSBDrive)

# enter your password for su
sudo echo

# install tools for FAT and for exFAT
sudo apt-get install -y udisks mtools exfat_utils

# identify your media's device name
lsblk

# check for the dev name
echo -n "Enter device node (e.g. sdc1 ) : "
read MEDIA_DEVICE

#### relabel partition

# enter your password for su
sudo echo

# enter the label you want for this device
echo -n "Enter new label for Media : " && read MEDIA_LABEL


#### Troubleshooting FAT relabeling
## if below you get error "not a multiple of sectors"
# echo mtools_skip_check=1 >> ~/.mtoolsrc

# determine filesystem type then set display label accordingly
case $(lsblk -o FSTYPE -n /dev/$MEDIA_DEVICE) in
    vfat)
        sudo mlabel -i /dev/$MEDIA_DEVICE ::$MEDIA_LABEL
        sudo mlabel -i /dev/$MEDIA_DEVICE -s ::     ;;
    exfat)
        sudo exfatlabel /dev/$MEDIA_DEVICE $MEDIA_LABEL
        sudo exfatlabel /dev/$MEDIA_DEVICE          ;;
    ntfs)
        echo NOT AVAILABLE      ;;
    ext*)
		sudo apt-get install -y e2fsprogs
        sudo e2label /dev/$MEDIA_DEVICE $MEDIA_LABEL
        sudo e2label /dev/$MEDIA_DEVICE
esac


#### List out the parition table
fdisk -l /dev/${MEDIA_DEVICE:0:3}

## mount
udisksctl mount -b /dev/$MEDIA_DEVICE
## this alternative mount goes to /media NOT /media/$user
# udisks --mount /dev/$MEDIA_DEVICE

## eject
#udisks --unmount /dev/$MEDIA_DEVICE && udisks --detach /dev/${MEDIA_DEVICE:0:3}
```


### Align partitions

Gnome disk utility does not currently create partitions that are
automatically aligned. This causes performance issues, even on Flash/SSD
media.
```
# credit - http://www.thomas-krenn.com/en/wiki/Partition_Alignment

# ensure you're using at least v2.17.1
fdisk -v

# fdisk commands to use ...
# p - print
# n - new
# p - print
# w - write and exit

# use sectors as units and don't use DOS compatibility mode
fdisk -c -u /dev/sdX

# ensure your partitions are all aligned
fdisk -l -u /dev/sdX

```


### SD card alignment

When new SD cards come from the factory, they often have 4MB space at
the front, to ensure they are properly aligned, and use Partition ID
"0Ch" for maximum compatibility.

```
# commands to follow....
# fdisk -c -u /dev/sdX

# n - new
# start from 8192

# t - change type
# c ( = 0Ch )

# w - write

# then format
# mkfs.fat /dev/sdX1 -n LABEL
```

#### do it with parted

as an alternative 
```
# help - fdisk and parted apparently DO align properly - http://superuser.com/a/700554 
# help - params for parted http://unix.stackexchange.com/a/49274
# sample parted commands
# first set your device and check it
MYDEVICE=/dev/sdX
sudo parted -s $MYDEVICE print

# to keep your data safe, make SURE it's the RIGHT device BEFORE you continue!!

sudo parted -a optimal $MYDEVICE unit s mkpart primary fat32 8192 100%  # create
sudo parted -s $MYDEVICE print                                          # show
sudo parted $MYDEVICE align-check optimal 1                             # check

# NB if you get issues like "is being used. Are you sure you want to continue?"
# which prevent the command from working, with -s (script mode) then see the 
# workaround in https://bugs.launchpad.net/ubuntu/+source/parted/+bug/1270203

# finally you can format the partition
sudo mkfs.fat -n U50 ${MYDEVICE}1

```

### resize partition and move data

This is easiest using the Graphical Interface (GUI) utility GParted. 
It guides you through the whole procedure and is easy to use. 
```
sudo apt-get install gparted
```

### choose Boot Partition

use fdisk to make a partition bootable

e.g.

```
sudo fdisk /dev/sdb
# p - print table
# a1 - make partition 1 active
# p - reprint table
# w - write and exit

# if that doesn't work use syslinux to install bootloader

sudo apt-get install syslinux mtools

syslinux -s /dev/sdc

### make a partition Bootable

# use fdisk to make a partition bootable, e.g.

sudo fdisk /dev/sdb
# p - print table
# a1 - make partition 1 active
# p - reprint table
# w - write and exit
```

if that doesn't work use syslinux to install bootloader


### Backing up MBR and EISA install partition

best done BEFORE installing ubuntu (to preserve initial MBR)

```
#===History===
# booted into ubuntu
# ran Disk Utility to identify details of /dev/sda1
# (e.g. partition type 0x27, capacity 9.7gb 9,664,671,744b)
# or just use ...
sudo cfdisk -Pt /dev/sda
# other commands to investigate disk setup...
# show all partitions
sudo fdisk -l
# show mounted devices
df -Th
#
# copy contents of PQSERVICE partition to C:\Backup\PQSERVICE...

##### create folder to store files
BackupFolder=/media/Acer/Backup/PQSERVICE
mkdir $BackupFolder
cd $BackupFolder
# credit &gt; https://help.ubuntu.com/community/WindowsDualBoot#Master%20Boot%20Record%20backup%20and%20re-replacement
# Backup the MBR code only
sudo dd if=/dev/sda of=./mbr.bin bs=446 count=1
# Backup the MBR including primary partition table: 
sudo dd if=/dev/sda of=./mbr.bin.plusPrimaryPartitionTable bs=512 count=1
# to Restore the MBR 
# e.g. sudo dd if=/media/sda/mbr.bin of=/dev/sda bs=446 count=1

#### Whole Partition copy

# credit &gt; http://www.backuphowto.info/linux-backup-hard-disk-clone-dd
# Back up the hidden partition
sudo dd if=/dev/sda1 of=./PQSERVICE.partition
# view progress using...
# sudo pkill -SIGUSR1 ^dd$
# alternatives
# help (error handling) &gt; http://www.inference.phy.cam.ac.uk/saw27/notes/backup-hard-disk-partitions.html
# idea &gt; consider setting blocksize to match (hard disk or partition) blocksize
# idea &gt; partimage ?
# idea &gt; ntfsclone http://www.linux-ntfs.org/doku.php?id=ntfsclone
# sample (command included in ubuntu 10.4)
sudo ntfsclone -s -o ./PQSERVICE.ntfsclone /dev/sda1
===Content files copy===
# (not yet complete)
sudo dd if=/dev/sda1 of=./PQSERVICE.bootsect.bin bs=512 count=1
```

## Automount

### IN - validate how current / useful 

==== Xbuntu/Myth Check the NTFS driver is installed ====

```
apt-cache search ntfs-3g
```

==== Identify disks ====
```
sudo fdisk -l<br />(or)<br />ls -l /dev/disk/by-uuid/
sudo editor /etc/fstab
# Ubuntu:
sudo gedit /etc/fstab
# Xbuntu/Myth:
sudo mousepad /etc/fstab
```

##### Add mount lines 

```
/dev/sda2 /media/Windows ntfs-3g rw,auto,user,fmask=0111,dmask=0000 0 0
/dev/sda3 /media/shared vfat rw,auto,user,fmask=0111,dmask=0000 0 0
# or using UUIDs:

# /dev/sda2
UUID=7C84665A846616C4 /media/Windows ntfs-3g rw,auto,user,fmask=0111,dmask=0000 0 0
# /dev/sda3
UUID=3C72F85E72F81E78 /media/shared vfat rw,auto,user,fmask=0111,dmask=0000 0 0
```
''Sample of original fstab contents:''

```
# /dev/sda2
UUID=7C84665A846616C4 /media/sda2 ntfs defaults,umask=007,gid=46 0 0
# /dev/sda3
UUID=91A1-25A1 /media/open vfat defaults,utf8,umask=007,gid=46 0 1
sudo mkdir /media/Windows
sudo mkdir /media/shared
sudo mount -a
credit &gt; https://help.ubuntu.com/community/AutomaticallyMountPartitions
```

## Swap

### set up Swap, post install

NB: This will leave the swap **unencrypted** - see below to encrypt your swap

*Check the code in case of format errors!*
```
# help - https://help.ubuntu.com/community/SwapFaq
# check what swap is set up
cat /proc/swaps

# get the UUID of the device
sudo blkid

sudo editor /etc/fstab

# add in the UUID without quotes and make something like
# UUID=0b3fb4b3-f645-468e-a7d5-c39a19edc07c none swap sw 0 0 

# enable the swap now if you want...
sudo swapon -a

# check it's there
cat /proc/swaps

sudo leafpad /etc/default/grub

# Look for the line GRUB_CMDLINE_LINUX="" 
# and make sure it looks like this (using your UUID of course) 
# GRUB_CMDLINE_LINUX="resume=UUID=41e86209-3802-424b-9a9d-d7683142dab7" 
# and save the file

sudo update-grub

sudo leafpad /etc/initramfs-tools/conf.d/resume
# and make sure its contents are 
# resume=UUID=41e86209-3802-424b-9a9d-d7683142dab7 (with your UUID of course in place of mine). Save the file!

sudo update-initramfs -u
```
Reboot!

### Encrypted Swap


```
LUBUILD_SWAP_DEVICE=/dev/sdXN
sudo echo

# package required for ecryptfs-setup-swap script used below
sudo apt-get install ecryptfs-utils

# credit [https://blog.sleeplessbeastie.eu/2012/05/23/ubuntu-how-to-encrypt-swap-partition/]
sudo mkswap $LUBUILD_SWAP_DEVICE
# e.g. Setting up swapspace version 1, size = 4 GiB (4293218304 bytes)
# e.g. no label, UUID=7881e5fd-a2d2-4ffc-ac14-7df643a370aa

sudo swapon $LUBUILD_SWAP_DEVICE
# check swap is now on
cat /proc/swaps 
# should show /dev/sdXN
sudo blkid | grep swap

sudo ecryptfs-setup-swap
# if this fails with 
# swapon: cannot open /dev/mapper/cryptswap1: No such file or directory
# then run the following 
## do we also need... ?
## sudo swapoff $LUBUILD_SWAP_DEVICE
# sudo cryptdisks_start cryptswap1
# or simply reboot

# should show /dev/mapper/cryptswap1
sudo blkid | grep swap

```

There were some issues with 14.04 Trusty, but they could be worked around by using /dev references rather than UUIDs (see [here](https://ubuntuforums.org/showthread.php?t=2224129) and [here](http://askubuntu.com/a/463688))


#### IN from wiki

For simple step-by-step instructions on what to change during your
Ubuntu install see "full encryption using LVM" in Encryption page
<https://github.com/artmg/lubuild/wiki/Encryption#Full_Disk_Encryption_with_LVM>


##### Hibernate issues with encrypted swap 

It is worth mentioning that encrypted swap prevents hibernate (a.k.a. suspend to disk), as a key would be required to decrypt swap after resume. 
Although https://help.ubuntu.com/community/EncryptedHome#Caveats states that versions 9.10 onwards will encrypt swap if the home is encrypted, it is worth checking using the command in the previous section. 
If you really want to encrypt swap and hibernate the see the workaround https://help.ubuntu.com/community/EnableHibernateWithEncryptedSwap

https://help.ubuntu.com/community/EnableHibernateWithEncryptedSwap


##### Other Notes on encrypted swap 

```
# encrypt swap and don't give the message saying hibernate will fail to resume
sudo ecryptfs-setup-swap -f
```

add this to [https://github.com/artmg/lubuild/wiki/Encryption#encrypted_swap]
mention in [https://github.com/artmg/lubuild/wiki/Disks-and-layout#Alternative_to_Live_USB_for_regular_use]

14.04 had issues
 - [https://bugs.launchpad.net/ubuntu/+source/ecryptfs-utils/+bug/1310058]
 - [http://ubuntuforums.org/showthread.php?t=2224129]

```
# 14.10 too!
SWAPDEV=/dev/sdb2
sudo umount $SWAPDEV

sudo mkswap $SWAPDEV
# Use the UUID from the previous output...
SWAPUUID=
# OR get it from old swap and re-use
# sudo mkswap --label Ubuntu\ Swap --uuid $SWAPUUID $SWAPDEV

echo "RESUME=UUID=$SWAPUUID" | sudo tee /etc/initramfs-tools/conf.d/resume
#echo "cryptswap1 $SWAPUUID /dev/urandom swap,cipher=aes-cbc-essiv:sha256" | sudo tee /etc/crypttab
#echo "cryptswap1 $SWAPUUID /dev/urandom noauto,offset=6,swap,cipher=aes-cbc-essiv:sha256" | sudo tee /etc/crypttab
#echo "cryptswap1 $SWAPDEV /dev/urandom swap,cipher=aes-cbc-essiv:sha256" | sudo tee /etc/crypttab
echo "cryptswap1 $SWAPDEV /dev/urandom noauto,offset=6,swap,cipher=aes-cbc-essiv:sha256" | sudo tee /etc/crypttab
sudo update-initramfs -u




# create upstart script
sudo tee /etc/init/cryptswap1.conf <<EOF!
start on started mountall
script
 /sbin/cryptdisks_start cryptswap1
 /sbin/swapon /dev/mapper/cryptswap1
end script
EOF!

# then Modify /etc/fstab changing the line:
#    /dev/mapper/cryptswap1 none swap sw 0 0
# to
#    /dev/mapper/cryptswap1 none swap noauto,sw 0 0

# now reboot and check with...
free --human
swapon --summary
```
interesting article with lots of detail - http://thesimplecomputer.info/encrypt-your-linux-home-folder-2-ways-and-10-steps
for useful links see also - https://wiki.archlinux.org/index.php/System_Encryption_with_LUKS



### IN 

The following sections need to be rationalised and reformatted

#### Grub 

##### reference

-   archwiki Grub reference -
    <https://wiki.archlinux.org/index.php/GRUB>
-   GNU GRUB full manual - <http://www.gnu.org/software/grub/manual/>


##### Advanced Grub2 

###### Install if required 

```
# Check which version(s) of grub is installed, looking for lines beginning 'ii' in the list...
dpkg --list 'grub*'

# Check which version is active using:
grub-install -v

# If required, upgrade to the new version using:
sudo apt-get install grub-pc
# Then TAB to choose OK, choose Yes, accept overwriting

###### Configure 

# credit &gt; [http://www.linuxquestions.org/blog/drask-180603/2009/12/5/howmany-for-grub-2-2466/ http://www.linuxquestions.org/blog/drask-180603/2009/12/5/howmany-for-grub-2-2466/]
sudo cp /usr/sbin/grub-mkconfig /usr/sbin/grub-mkconfig_backup
sudo cp /etc/grub.d/10_linux /etc/grub.d/10_linux_backup
sudo chmod a-x /etc/grub.d/10_linux_backup
sudo cp /etc/grub.d/30_os-prober /etc/grub.d/30_os-prober_backup
sudo chmod a-x /etc/grub.d/30_os-prober_backup
sudo gedit /usr/sbin/grub-mkconfig

# after export GRUB_DEFAULT \
# GRUB_HOWMANY_LINUX \

sudo gedit /etc/grub.d/10_linux

# replace code with what's in '''10_linux''' in Service Procs folder (wallet or online in FM)

# (was [http://www.linuxquestions.org/blog/drask-180603/2009/12/5/howmany-for-grub-2-2466/ www.linuxquestions.org/blog/drask-180603/2009/12/5/howmany-for-grub-2-2466/]

# but then had to make sure you change the HOWMANYs to GRUB_HOWMANY_LINUX)
sudo gedit /etc/default/grub

# GRUB_HOWMANY_LINUX=1
sudo os-prober

# to check for exact wording
sudo gedit /etc/grub.d/30_os-prober

# after

echo &quot;Found ${LONGNAME} on ${DEVICE}&quot; &gt;&amp;2

# found_other_os=1

# insert the code:

if [ &quot;${LONGNAME}&quot; = &quot;Windows NT/2000/XP (loader)&quot; ]; then
LONGNAME=&quot;Windows XP&quot;
fi

# then run

sudo update-grub
```

##### Remove grub bootloader 

To remove grub boot loader and reinstall Windows Master Boot Record (MBR) with 
NTBootloader, install **boot-repair** tool - see 
[https://github.com/artmg/lubuild/blob/master/help/diagnose/operating-system.md]


#### Appendix E - Advanced disk configuration =

##### Boot configuration ==

''WARNING: Do not upgrade or modify grub in dual boot configurations when Windows is HIBERNATED!''

NB: Left Ubuntu as default – some machines should make Windows default (see ''Set Up PC.htm'')

<pre>If performance on device has ever been in question: </pre>
<ul>
<li><pre>default Grub to Ubuntu</pre></li></ul>



##### Restore Acer MBR for windows restore partition ===

```
# REPLACE X in sdX with the letter for the disk you need
# Check the current partition table
sudo cfdisk -Pt /dev/sdX
# Backup the MBR including primary partition table: 
sudo dd if=/dev/sdX of=./mbr.bin.plusPrimaryPartitionTable bs=512 count=1
# find the file RTMBR.bin from the PQSERVICE hidden partition /acer/tools folder
cd /media/art/PQSERVICE/acer/tools
# Restore the MBR *including* primary partition table: 
sudo dd if=RTMBR.bin of=/dev/sdX bs=512 count=1
# to Restore JUST the MBR 
# sudo dd of=RTMBR.bin if=/dev/sdX bs=446 count=1
```

##### NTFS Permissions 

```
#==mount options==
# help &gt; http://www.tuxera.com/community/ntfs-3g-manual/
ntfs-3g
users = any user can mount, different user can dismount
uid=1000
gid=100
# less permissive dmask=027,fmask=137
# more permissive dmask=000,fmask=111
# totally permissive umask=000
utf8
user mapping with windows &gt; http://www.tuxera.com/community/ntfs-3g-manual/#7
```

# Understand Layout



## Layouts  #############################################

Here are some sample disk layouts depending on your needs

### IN

### Formatting for large hard drives ==

Previously chose NTFS format for large partitions for compatibility 
with Windows devices. Unfortunately filesystem repair tools under Linux 
are not as "NTFS friendly". As most home devices are NOT Windows-based 
the new proposed large FS is EXT4. Windows drivers for ext4 include 
Ext2Fsd, and the device can have an initial liveCD partition to boot 
into linux and copy data to other locally attached (e.g. NTFS) drives 
for access by Windows. 

Issues:
WDTV supports only FAT32/NTFS - http://wdc.custhelp.com/app/answers/detail/a_id/2726
Android (which didn't support NTFS) does not have across the board support for extX
Permissions could be an issue unless umasks are sep up or root is used 


10GB boot partition = FAT32 ??

Although this is WAY bigger than needed for a live install, 
it does allow space for retrofitting the drive to also boot on UEFI PCs
https://help.ubuntu.com/community/Installation/UEFI-and-BIOS

Being FAT32 it is limited to 4GB persistence file, but could consider 
changing to ext4 if supported or making a separate casper-rw partition 
http://askubuntu.com/questions/138356/

Use Startup Disk Creator to load live image and make this bootable 
 
 
<The Rest>GB Data partition = EXT4



### full encryption using LVM

Objectives:

-   Full desktop install including apps
-   ALL data and config protected by strong encryption
-   Permanent install (not LiveUSB) to permit use of encryption

The solution uses a small unencrypted /boot partition, and a larger
"LVM" partition which is encrypted using LUKS and contains the root,
home and swap, all of which are protected with a single boot-time
password

We're choosing to use a Boot partitions to enable Encryption via LVM,
but it will also be required on GPT disks and under UEFI.

Some sizing recommendations for Boot partitions (the unencrypted bit)
state that 200 or 300MB is sufficient, and this is certainly enough for
a kernel or two plus other boot files. However, if you upgrade your
system as per best practice, but do not always remember to
**autoremove** superseded kernel versions, then creating a boot
partition just big enough may lead to errors during updates. If you can
easily afford it, then **allowing a 1GB partition for /boot** will save
you from later pain. See also
<https://help.ubuntu.com/community/DiskSpace>

Some layouts use separate home partitions to preserve data between
rebuilds(\*), however the usable data volume of your drive will be
created as encrypted, so you have to move your data in manually post
build therefore a single root parition filling the encrypted volume
makes most sense

(\*) anyhow, experience of maintaining home folders between two distinct
distro versions shows that version differences in hidden config files
makes it impractical to truly share a single home folder between them.

For simple step-by-step instructions on what to change during your
Ubuntu install see "full encryption using LVM" in Encryption page
<https://github.com/artmg/lubuild/wiki/Encryption#Full_Disk_Encryption_with_LVM>

### ALUT

Objectives:

-   Full App suite install
-   Permanent install (not LiveUSB) to permit use of encrypted home
-   Allow multi-OS media transfers

Using **32GB flash drive**

-   8GB Ext4 / root for os & app installs
-   2GB swap and hibernate
-   6GB Ext4 /home
-   16GB FAT for media transfer

NB: there is an additional pretty large SWAP on host PC home drive which
may be better for hibernate, however may not be available if running on
other PCs

Install with generic build user, add real users with encrypted homes
later


### OpenELEC multiboot

If you want a really fast-loading media player which has a browser
available, then you could have OpenELEC as an additional GRUB option on
your multi-boot menu

For other installation and configuration procedures, 
see [https://github.com/artmg/MuGammaPi/wiki/Media-Centre]

NB: Some sections have been added IN below from Media-Centre 
so might need rationalising / de-duping


#### prepare

credit - <http://wiki.openelec.tv/index.php/Dual_Boot>

For flexibility these can be Logical in an Extended Partition

-   OE\_SYS (bootable) EXT4 500MB - holds KERNEL and SYSTEM
-   OE\_DATA EXT4 4GB+

Kernel and System are aparently all there is to the OpenELEC build, so
the size of data depends on your usage.

#### Partitions ###

Here is information about install OpenELEC 
as Triple Boot on top of Windows and Ubuntu. 

* OE_BOOT
    * required
    * bootable
    * recommended 1GB
    * contents: KERNEL and SYSTEM files from distro image
* OE_DATA
    * required (for persisting data - will it work 'live' without??)
    * state data like thumbnails and meta-databases
    * **also stores config??**
    * using 6GB in this example

credit - [http://wiki.openelec.tv/index.php/Dual_Boot]


#### Partitioning issues ####

* No free (unpartitioned) space on HDD.
* can shrink Windows Partition to make space
* This will put OpenELEC between Windows & Ubuntu
* Need to expand the Extended Partition to make space for two new logical partitions at the start of the Extended
* Must leave current partitions AS THEY ARE at the end of the repartitioning, so that data is left intact (non-destructively)
* deleting partitions in FDISK and recreating them did NOT put the partitions back in the same places
* had to use **gparted** to resize the Extended Partition forward to insert the two extra partitions required
    * found gparted on Lubuntu "Live USB Installer"
* 



### Reducing the number of Primary Partitions

Some manufacturers (such as HP) may use up all 4 available Primary Partitions in their factory-shipped configuration. This means that when you try to create a new partition (Primary OR Logical) you get an error saying &quot;it is not possible to create more than 4 Primary Partitions&quot;.

This workaround is based on the comprehensive article [http://h30434.www3.hp.com/t5/Other-Notebook-PC-Questions/How-to-repartition-HDD-of-HP-notebook-with-pre-installed/td-p/742019 How to repartition HDD of HP notebook with pre-installed Windows 7] by MVP Daniel Potyrala, which explains the various options with pros and cons and recommends the option to remove the System Partition (sda1). By making the OS partition (sda2) bootable directly, Windows works, the Recovery (sda3) partition is still intact for a full restore, and the HP_tools (sda4) partition is still available. The System Partition contains boot files and the WinRE (Windows Recovery Environment) whichallows you to do Startup Repair, System Restore, Complete PC Restore and Windows Memory Diagnostic Tool . However, the same tasks are performed much better by the tools contained in these other partitions, and you can access the different partitions just by marking them as active using a parition table tool (like GPartEd).

Note we do NOT create a Windows 7 System Repair disc as no optical drive is available. You CAN however back up the System Parition. Use GPartEd to ensure that the System partiton IS /dev/sda1 first...

```
# Back up HP SYSTEM partition prior to removal
# ===create folder to store files===
SystemBackup=/media/mysdcard/Media.IN/HP_SYSTEM
mkdir $SystemBackup
cd $SystemBackup
# Backup the MBR code only
sudo dd if=/dev/sda of=./mbr.bin bs=446 count=1
# Backup the MBR including primary partition table: 
sudo dd if=/dev/sda of=./mbr.bin.plusPrimaryPartitionTable bs=512 count=1
# to Restore the MBR 
# e.g. sudo dd if=/media/sda/mbr.bin of=/dev/sda bs=446 count=1
===Whole Partition copy===
# credit &gt; http://www.backuphowto.info/linux-backup-hard-disk-clone-dd
# Back up the System partition
sudo dd if=/dev/sda1 of=./HP.SYSTEM.partition
```

Before proceeding you should prepare your Windows by shrinking the main OS partition to make space for the Ubuntu partitions, as you will need to install Ubuntu to give a bootloader in place of the old HP System parition.

Once you have done this you can use GPartEd to delete the System Partition. Create the new Ubuntu partitons in the space freed up by shrinking the OS partition (as the System partition was too small to use for this) Finally proceed with the Ubuntu installation



## LiveUSB

see also:
* [https://github.com/artmg/lubuild/blob/master/help/configure/write-Distro-to-flash.md]
    * For creating a LiveUSB install or trial flash-drive 
    * Adding a Persistence volume
    * troubleshooting

### Alternative to Live USB for regular use

If you always use a Live USB in the same PC, then there is no advantage.
Also, there are restrictions using encrypted home with Live USB. 
Instead you could Install to the flash drive, as if it were an SSD. 

In this case we have an 8GB USB and a PC with 8GB RAM.

The only use for Swap here would be hibernate - consider setting later
using parition on HDD

-   Launch Install from other USB as Live
-   Plug in USB during install
-   Choose entire volume as root and reformat
-   accept "no swap?" dialog and choose to Continue
-   Enter computer name e.g. ALUH (Art Lubuntu Usb HP)
-   Encrypt my home folder - failed with error ???? - unselected

Later, to enable hiberate, we need a swap = GB RAM, preferably encrypted

`# help - `[`https://help.ubuntu.com/community/SwapFaq`](https://help.ubuntu.com/community/SwapFaq)

see [Configure Disks#Swap] currently in this doc




