

This article is focussed mainly on the procedures for actually 
configuring the disks and partitions you have decided upon. 
It includes swap partitions with encryption and resume. 

To find out more about why you might choose a particular layout see 
[https://github.com/artmg/lubuild/blob/master/help/understand/disk-layout.md] 
and for diagnosis and Troubleshooting on disks see 
[https://github.com/artmg/lubuild/blob/master/help/diagnose/disks.md]

See also:

* options and constraints for laying out partitions on your disks
	* [https://github.com/artmg/lubuild/blob/master/help/understand/disk-layout.md]
* diagnosis and Troubleshooting on disks
	* [https://github.com/artmg/lubuild/blob/master/help/diagnose/disks.md]
* encrypting data (other than install partitions and swap, covered in here)
	* [https://github.com/artmg/lubuild/blob/master/help/use/encryption.md]
* dealing with windows volumes, and shrinking them for dual boot
	* [https://github.com/artmg/lubuild/blob/master/help/configure/Windows.md]
* for device storage (MTP and PTP) and mounting
	* [https://github.com/artmg/lubuild/blob/master/help/manipulate/storage-in-connected-devices.md]
* creating LiveUSB installation media
	* [https://github.com/artmg/lubuild/blob/master/help/configure/write-Distro-to-flash.md]
* special info about how to work with flash (non-mechanical) storage devices
	* [https://github.com/artmg/lubuild/blob/master/help/manipulate/flash-drives-and-SSDs.md]
* removing data, securely if necessary
	* [https://github.com/artmg/lubuild/blob/master/help/manipulate/remove-data.md]
* to workaround issues installing QT and KDE into encrypted partitions 
	* [https://github.com/artmg/lubuild/blob/master/help/configure/LxQt-Kubuntu-Ubiqity-manual-encryption-bug.md]


# Configure Disks

## Install

There are various options for layout explained later in this article, but here is a common scenario 
- dual boot with full disk encryption on Ubuntu partition

* Boot from Install Media
* Connect to network
	* recommended even if you do not wish to install updates or extras 
	* ubiquity can download recent fixes to installation issues
	* e.g. grub-install sometimes fails with encrypted root unless network available

* Qt Ubiquity issues (Lubuntu Next, LxQt, Kubuntu) with encryption
	* to avoid them check out...
	 	* [https://github.com/artmg/lubuild/blob/master/help/configure/LxQt-Kubuntu-Ubiqity-manual-encryption-bug.md]

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

### Partitioning Recommendations

* use fdisk interactively
    * recent versions handle geometry well
    * you are generally offered logically recommended boundaries
    * you can use +XXG to create partitions in nice round GiB sizes
* if you want to carve your disk up, do it now
    * makes it simpler when you run the install
* Create the partitions in order (e.g. within an Extended partition)
    * it helps fdisk make sensible suggestions for you
* write and exit at the end
    * `sudo partprobe` if you want to re-read the table to check

```
### WARNING ###

# please remember that if you choose 
# the WRONG disk or partition IDs for /dev/sdXY 
# then you WILL LOOSE YOUR DATA ! ! ! 
# 
# please check VERY carefully before executing the commands

### set up your new partitioning
sudo fdisk -c -u /dev/sdX

### check what was written
sudo partprobe
fdisk -c -l /dev/sdX

### format and label any boot or root partitions
sudo mkfs.ext4 /dev/sdXY
sudo e2label /dev/sdXY xNN_XXXX

### random wipe any magnetic partitions that will be used for encryption

# credit - https://wiki.archlinux.org/index.php/Dm-crypt/Drive_preparation#dm-crypt_wipe_on_an_empty_disk_or_partition
sudo cryptsetup open --type plain /dev/sdXY container --key-file /dev/random
dd if=/dev/zero of=/dev/mapper/container --status=progress
# no longer need this in another window to to check the dd progress
# watch -n30 'sudo pkill -usr1 dd'
sudo cryptsetup close container 

```

### Rename 

Note: this automation in this section 
is similar to that used in the pages below, 
so perhaps they could be merged/unified at some point?

* [Buildroot](https://github.com/artmg/MuGammaPi/wiki/buildroot)
* [ArchLinuxArm install](https://github.com/artmg/MuGammaPi/wiki/arch-linux-install)
* [Raspbian basics](https://github.com/artmg/MuGammaPi/wiki/Raspbian-basics)
* [write Distro to flash](https://github.com/artmg/lubuild/blob/master/help/configure/write-Distro-to-flash.md) 


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

# ISSUE - sometimes the lsblk returns blank (e.g. after mkfs.ext4)
 
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

Note that you cannot move a mounted partition, such as the root 
you are currently booted from. Consider booting using a Live USB. 


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

### Overwrite entire partition before encyption

Best practice 

There are suggestions for preparing file loop volumes in 
[https://github.com/artmg/lubuild/blob/master/help/use/encryption.md#create-new-loop-volumes-files] 
but here is a simpler method for crypto-overwriting an entire partition: 

```
PARTITION_TO_ENCRYPT=/dev/sdXN
# use openssl to encrypt the zeros (much QUICKER simple pseudo-RANDOM - better than patterns)
head -c 32 /dev/urandom | openssl enc -rc4 -nosalt -in /dev/zero -pass stdin | dd bs=1M status=progress of=$PARTITION_TO_ENCRYPT
# credit - http://askubuntu.com/a/359547

## simpler version if you don't need to view progress
#sudo openssl enc -aes-256-ctr -pass pass:"$(dd if=/dev/urandom bs=128 count=1 2>/dev/null | base64)" -nosalt < /dev/zero > $PARTITION_TO_ENCRYPT
## credit [http://thesimplecomputer.info/full-disk-encryption-with-ubuntu]
```

For more alternatives on how to wipe whole partitions as preparation for encryption 
see [https://github.com/artmg/lubuild/blob/master/help/manipulate/remove-data.md]


## Automount

### IN - validate how current / useful 

#### Xbuntu/Myth Check the NTFS driver is installed

```
apt-cache search ntfs-3g
```

#### Identify disks

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

For help with automatically mounting encrypted partitions 
using a securely stored key file to unlock them 
see http://thesimplecomputer.info/full-disk-encryption-with-ubuntu



## Swap

### set up Swap, post install

NB: This will leave the swap **unencrypted** - see below to encrypt your swap

Improvements:

* Check the code in case of format errors!
* use some of the automation in 
	* [https://github.com/artmg/lubuild/blob/master/help/configure/LxQt-Kubuntu-Ubiqity-manual-encryption-bug.md]

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
# check current swap
cat /proc/swaps

# check your disk partitions
lsblk

# Prepare variables
LUBUILD_SWAP_DEVICE=/dev/sdXN
```

* Best practice recommends overwriting  magnetic media with random patterns

```
PARTITION_TO_ENCRYPT=$LUBUILD_SWAP_DEVICE
```

* [https://github.com/artmg/lubuild/blob/master/help/configure/Disks-and-layout.md#overwrite-entire-partition-before-encyption]


```
# authenticate for sudo
sudo echo

# package required for ecryptfs-setup-swap script used below
sudo apt-get install -y ecryptfs-utils

# credit [https://blog.sleeplessbeastie.eu/2012/05/23/ubuntu-how-to-encrypt-swap-partition/]
sudo mkswap $LUBUILD_SWAP_DEVICE
# This will output the main UUID of the swap partition

sudo swapon $LUBUILD_SWAP_DEVICE
# check swap is now on
cat /proc/swaps 
# should show /dev/sdXN
sudo blkid | grep swap

sudo ecryptfs-setup-swap --force

# if this fails with 
# swapon: cannot open /dev/mapper/cryptswap1: No such file or directory
# then run the following 
sudo cryptdisks_start cryptswap1
sudo swapon /dev/mapper/cryptswap1
# or simply reboot

# finally check 
cat /proc/swaps
# should show /dev/mapper/cryptswap1
sudo blkid | grep swap
# check config files tally with cryptswapx entry, e.g. 
# /dev/mapper/cryptswap1 none swap sw 0 0
# cryptswap1 UUID=ac17...9b75 /dev/urandom swap,offset=1024,cipher=aes-xts-plain64
cat /etc/fstab |grep swap
cat /etc/crypttab |grep swap

```

There were some issues with 14.04 Trusty, but they could be worked around 
by using /dev references rather than UUIDs 
(see [here](https://ubuntuforums.org/showthread.php?t=2224129) and [here](http://askubuntu.com/a/463688))


#### Hibernate with Encrypted swap

When you hibernate your RAM is saved to disk in the swap area. 
If you have openned an encrypted volume with a LUKS key, 
that would be stored in plaintext inside your RAM, making it easy 
to decrypt your main volumne. This is why you need to encrypt your swap 
before considering hibernating, if you have an encrypted volume. 

The trick with hibernate is actually the RESUME. If the swap is 
encryped you need a key to decrypt it upon resume, to get your RAM contents 
back out of the swap. 

```
# Prepare variables
LUBUILD_SWAP_DEVICE=/dev/sdXN
```

This method asks you for the passphrase that will be used to encrypt 
the swap. 

```
PARTITION_MAPPER=cryptswap1
CRYPT_OPTIONS="--cipher aes-xts-plain64 --verify-passphrase --key-size 256"

# Turn off swap.
sudo swapoff -a

# Undo the existing mapping.
sudo cryptsetup luksClose /dev/mapper/$PARTITION_MAPPER

# remember YES must be uppercase, then enter passphrase twice
sudo cryptsetup $CRYPT_OPTIONS luksFormat $LUBUILD_SWAP_DEVICE

# and passphrase a third time
sudo cryptsetup luksOpen $LUBUILD_SWAP_DEVICE  $PARTITION_MAPPER

#Set up the partition as swap.
sudo mkswap /dev/mapper/$PARTITION_MAPPER
# Turn on the swap
sudo swapon --all
# Check that it is working.
swapon --summary

sudo cp /etc/crypttab{,.`date +%y%m%d.%H%M%S`}
sudo sed -i 's|cryptswap1|#cryptswap1|' /etc/crypttab
sudo tee -a /etc/crypttab <<EOF!
$PARTITION_MAPPER   $LUBUILD_SWAP_DEVICE   none   luks
EOF!
cat /etc/crypttab

sudo tee -a /etc/initramfs-tools/conf.d/resume <<EOF!
RESUME=/dev/mapper/$PARTITION_MAPPER
EOF!
cat /etc/initramfs-tools/conf.d/resume

## IS THIS STILL TRUE ??? - IMPORTANT: Whenever new kernels are installed, this step must be repeated

sudo update-initramfs -u -k all

```

* will this also put RESUME into grub??




If you have an encrypted swap and want to enable hibernate
* flexible method with any paritioning
	[https://help.ubuntu.com/community/EnableHibernateWithEncryptedSwap]
* method with single encrypted LVM including swap partition inside
	[http://thesimplecomputer.info/full-disk-encryption-with-ubuntu]

Other links copied from top:

* [general partitioning procs](https://github.com/artmg/lubuild/blob/master/help/configure/Disks-and-layout.md)
* [Lubuild Encryption Wiki article](https://github.com/artmg/lubuild/wiki/Encryption.mediawiki)
	- should move into lubuild files somewhere, e.g. Disks & Layout
* [Partitioning, Encryption and SSD advice](DROP.IN/Service.IN/Lub Disk Partitions & Tests.md)
    * most stuff moved out of here now


##### Hibernate issues with encrypted swap 

It is worth mentioning that encrypted swap prevents hibernate (a.k.a. suspend to disk), 
as a key would be required to decrypt swap after resume. 
Although https://help.ubuntu.com/community/EncryptedHome#Caveats 
states that versions 9.10 onwards will encrypt swap if the home is encrypted, 
it is worth checking using the command in the previous section. 
If you really want to encrypt swap and hibernate the see the workaround 
https://help.ubuntu.com/community/EnableHibernateWithEncryptedSwap

###### Resume with encrypted swap


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


Resume with encrypted swap - 
/etc/initramfs-tools/conf.d/resume
RESUME=/dev/mapper/MyEncrSwap
update-initramfs


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



## IN 

The following sections need to be rationalised and reformatted

NB: for shrinking windows volumes 
see [https://github.com/artmg/lubuild/blob/master/help/configure/Windows.md#shrink-windows-volume]

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

NB: Left Ubuntu as default ??? some machines should make Windows default (see ''Set Up PC.htm'')

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


