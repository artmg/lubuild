# Puppy Linux

## Motives

* Looking for super lightweight distro
* Decided to try a Linux distro designed to 'run from RAM'
* Porteus was a little too quirky
    * based on the 4 year outdated (though still popular!) Slackware
* decided finally to try PuppyLinux
    * see recentish walkthrough https://www.dedoimedo.com/computers/puppy-bionicpup-8.html
* start with most basic spin using whatever environment it comes with


## about PuppyLinux Distros

Regular users might not find Puppy very intuitive to set up, 
even those with some basic experience of Linux distros. 
However once installed, the interface is reasonably 
familiar looking and self-explnatory enough for a regular user 
with a little flexibility to get the hang of. 

Puppy boots from a variety of media (USB, HDD, CD, etc) 
and loads itself to be memory resident (less than half a gig). 
In Frugal mode, various Squash FileSystems are loaded 
from .sfs files and the medium may be ejected. 
Configuration changes and other core files are kept in RAM, 
and at shutdown you are offered the option to commit them. 

It is designed to be used in this 'frugal' mode, with its 
small image, that is loaded with additional overlay files. 
If is a different way of thinking about an OS, 
where you don't really 'install' it.
Any changes you make (that you want to keep) you can 
put into a 'save' overlay file that is loaded last. 
But it is much of an 'embedded' way of thinking 
rather than a traditional OS install. 

In recent years Puppy has been built from Ubuntu packages, 
using the 'Woof' toolset, and versions track Ubuntu LTS versions. 
This means it dropped 32-bit support after v8 (BionicPup). 
Generally it uses the JWM window manager and ROX desktop, 
but others are readily available. 

There are many different distro spins (Puplets) in what the loose 
development organisation refers to as 'the Puppy family'. 

* Intro https://puppylinux.com/
* Downloads http://distro.ibiblio.org/puppylinux/


## Universal Install of FossaPup using TahrPup

* Trying FossaPup64 9.5 based on ubuntu focal 20.04
* http://puppylinux.com/#download
* Installing using TahrPup which I can boot ok on my old device
    * For reasons see further below

### isohybrid

Some PuppyLinux images are isohybrid images,  
where the iso also contains 
the MBR boot sector, partition table, and filesystem. 

Therefore you do not partition the drive before copying, 
you copy the whole thing to the device root e.g. /dev/sdx with NO number. 
I'm putting these onto USB pen drives. 

simply `dd` the iso...

```
lsblk
sudo dd if=fossapup64-9.5.iso of=/dev/sdX status=progress
sync
```

or on mac

```
diskutil list
sudo dd if=Cached/Images/tahr64-6.0.5.iso of=/dev/diskN
sync
```

and here was the one for TahrPup

```
wget http://distro.ibiblio.org/puppylinux/puppy-tahr/iso/tahrpup64-6.0.5/tahr64-6.0.5.iso
sudo dd if=tahr64-6.0.5.iso of=/dev/sdb status=progress
```

### Universal Install

Start off in Tahr Pup

* use above to write Tahrpup ISO onto USB medium
* boot into Tahrpup ISO

* Download the FossaPup ISO
* Use File icon on Desktop to browse to FossaPup ISO
* Double-click to mount the ISO as a drive

* Use the Install icon on the desktop
* Choose the option "Universal Installer"
* Choose USB / Flash Drive
* Insert USB drive but do not mount it
* Chose the drive `sdX`
* Click OK on the warning about unpartitioned space
* Chose GPartEd
* Menu / Device / Create a Partition Table
* Type: msdos / Apply
* Menu / Partition / New / left as full size ext4 / Add
* Apply / Ok / Close
* Click the new partition choose Menu / Partition / Manage Flags
* Check the Boot flag and Close
* Exit GPartEd
* Chose the drive `sdX`
* Install Puppy to `sdXN` / OK
* Choose Directory
* Click the icon at the bottom of the screen to mount the tahrpup iso you booted from
* Switch /root to / and browse to folder mnt and double-click
* Double-click the sdxn folder for the ISO
* Boostrap loader missing - choose mbr.bin
* Y then enter to procede with wipe / load to ram, etc

* Double-click the +mnt+sdax+ etc folder for the ISO
* Click the puppy_fossapup .sfs file


* Use the Install icon on the desktop
* Choose the option "BootFlash USB Installer"
* Choose USB-HDD (the preferred choice)
* Insert USB drive but do not mount it
* Chose the drive `sdX`
* This told me to use the Universal Installer from the Setup menu


## Alternatives

### FossaPup did not boot directly

This is just recorded as reason why also used TahrPup

The TahrPup version worked on target device but not Fossapup 
(fails to boot with message below). 
The C60 processor is 64-bit, and the BIOS has UEFI compatibility, 
but the image did not want to boot. 

```
Booting `find /menu.lst, /boot/grub/menu.lst, /grub/menu.lst'
GRUB4DOS 0.4.6a 2019-10-28, Mem: 638K/3557M/240M, End: 368792
[ Minimal BASH-like etc, etc ESC at any time exits. ]
grub> 
```

So, following advice in the forums, 
I used the one that works to install a later version.

#### what to try next time

according to issue response either

a) Do Universal Install then overwrite files
b) Remaster the ISO with different option

Next time try b) first - check out the issue 
[Fossapup hangs at Grub on BIOS without UEFI](https://forum.puppylinux.com/viewtopic.php?f=6&t=1180)

#### See also

See also: 

* interesting (?) background in [Puppy devs' very lengthy discussion on boot via grub or other between BIOS and UEFI](https://github.com/puppylinux-woof-CE/woof-CE/issues/1618)
* [allandiggity's suggestion of remastering ISO](https://forum.puppylinux.com/viewtopic.php?p=5957) using mkisofs and isohybrid, changing occurrences of pmedia=cd to pmedia=usbflash
* [Woof-CE's remasterpup2 script](https://github.com/puppylinux-woof-CE/woof-CE/blob/master/woof-code/rootfs-skeleton/usr/sbin/remasterpup2) is available once you have puppy running
* [PackIt](http://murga-linux.com/puppy/viewtopic.php?t=89211) is apparently a very simple way to remaster an ISO including the bootloaders for both BIOS and UEFI 

### Dualboot

Decided to try Installing Lubuntu then 
creating the frugal partition directly onto the HDD

* Disk may be wiped so
    * Write new MBR table
* Add Primary 50GiB ext4 as /
* Add 8GiB linuxswap
* Install 
* For private config see 
	* BN3c/Config misc.md#SNAQ
* restart update cycle
* create /fossapup64 folder
* copy CDROM (release ISO) contents in
* sudo nano /etc/grub.d/40_custom
    * https://forum.puppylinux.com/viewtopic.php?p=8143#p8143
* sudo nano /etc/default/grub
    * GRUB_DEFAULT=saved
    * GRUB_SAVEDEFAULT=true
    * GRUB_TIMEOUT_STYLE=menu
    * GRUB_TIMEOUT=10
* sudo update-grub
 
It had failed previously when I tried Lubuntu on an Extended Partition 
and Puppy on it's own additional ext4 partition, 
although I did manage to make it boot VIA the Puppy USB to the HDD.
Perhaps I had to address the custom grub code block to a different location?

#### Easy Windows dualboot

If you have Windows installed, the easy way to try 
Puppy Linux is with a USB drive. If you decide you like it, 
and want to use it in a more permanent way:

* Download the Puppy you want
	* according to your CPU architecture and BIOS/UEFI environment
* Turn off Hibernate in Windows
* Use 'LICK' .exe file as the installer
* https://github.com/noryb009/lick/releases/latest
	* This will turn off 'Fastboot' too
	* it will also set up a boot manager for you
		* it installs grub
		* also adds entries for Windows and your Puppy ISO
		* The ISO file can easily be a file on the regular NTFS partition
* 


### Frugal Install to media via Pi

* http://wikka.puppylinux.com/InstallationFrugal
* start with all partitioning and formatting

```
sudo apt install syslinux-efi
sudo mkdir -p /mnt/sda1/boot/syslinux/
sudo cp -af /usr/lib/syslinux/modules/efi64/{libcom32,libutil,linux,menu}.c32 /mnt/sda1/boot/syslinux/
sudo dd bs=440 conv=notrunc count=1 if=/usr/lib/syslinux/mbr/gptmbr.bin of=/dev/sdX && sync 
# sudo extlinux -i -s /mnt/sda1/boot && sync  # no 
tlinux package for raspbian

sudo mount fossapup64-9.5.iso /mnt/loop

sudo cp -rTv /mnt/loop /mnt/sda1

sudo tee /mnt/sda1/boot/syslinux/syslinux.cfg <<EOF!
PROMPT 1
TIMEOUT 5
DEFAULT puppy

LABEL puppy
MENU LABEL Puppy
KERNEL /vmlinuz
APPEND initrd=/initrd.gz pfix=fsck,copy pmedia=usbflash, elevator=noop pkeys=uk 
EOF!

sync


# pmedia=usbhd video=640x480

title Puppy Linux 525
rootnotify (hd0,0)
kernel (hd0,0)/vmlinuz pmedia=atahd psubdir=puppy525
initrd (hd0,0)/initrd.gz

#
```

