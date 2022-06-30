
# Understand Disk Layout

Here are some sample disk layouts and notes to try and help you, depending on your needs

NB: This article is somewhat old and needs reviewing and restructuring

## Sizing Notes

### Recommendation for main system partition

#### Lubuntu Desktop

Recommend minimum 16GB device 
- for Desktop system based on Ubuntu or Lubuntu 
- skip the rest of the section if you're ok with that

Reasoning:

* System and apps
	* base install with standard apps is c 6GB
	* fresh LxQt 17.10 with typical app installs c 7GB
* home
	* not only data and config but browser cache and search indexes
* allow 1GB for boot (or up to 4GB - see below)
    * recommendations say 200-300 MB
    * this is fine until you start applying updates (especially automatically)
    * you get the following error from Software Updater: 
        * "Not enough free disk space"
    * Workaround: sudo apt-get autoremove (or dkpg -r if that fails)
    * better solution is to leave enough room on boot partition
        * allow space for at least two or three extra kernel versions 
    * In a user-maintained system that is updated regularly using the GUI, 1GB may fill after a year or so. If you have no way to instruct how to 'autoremove' old kernels, then go larger like 4GB, so it will be longer before the errors appear
* allow a swap on HDD
    * equal to the total amount of RAM installed
    * leaves enough space to hibernate (suspend to disk)
    * also handy when booting from flash

#### Ubuntu Server

The Ubuntu Server install is a common way to 
combine the extensibility of the Ubuntu ecosystem 
with a reasonably low footprint, 
where you only install what you need.

As of 18.04.3 LTS the initial install 
before updates and additional packages
takes around 4 GB. 

You _might_ be able to squeeze what you need into as little as 5 GB but that leaves very little to spare. 
How much you need depends very much on how many packages you must install, and how much data you need to hold. 

For many common scenarios **10 GB could be ample** and leave room for growth. However if you 
were running a container system like Docker requiring multiple system images, you might find you need plenty more. 

## Choice of Filesystem Type

_(need to integrate section below)_ 

NB: If instead you want to understand 
your choice of possible filesystems to 
work well with SD cards and USB drives see 
[https://github.com/artmg/lubuild/blob/master/help/manipulate/flash-drives-and-SSDs.md#flash-and-filesystems]


### Compatibility

Compatibility of Filesystems between Linux, Windows and macOS complicates matters. The only universally supported filesystem types are 
FAT (and derivatives) that are not the most efficient or resilient these days. 

For many years there was a struggle between FAT32 
being the most compatible, but limited on size, 
and exFAT allowing size but being limited cross-platform. Fortunately Apple licensed exFAT (2010-2015?) and built it in as a macos option, 
then in 2019 Microsoft release the spec allowing Linux kernel to support it natively.

For the best support on Windows AND Linux AND Mac, 
for small drives with many tiny files **FAT** uses space well, but **exFAT** is the safest choice for large volumes with large files. 

* FAT32 has a limit of max 4GB file size
* macOS has limitations with exFAT Allocation Unit Size (AUS, also know as cluster or block size)
	* You cannot specify the size when formatting
	* there are reports of drives not being recognised with custom AUS
	* Earlier macOS versions may have been limited to 128KB, but it is possible they now follow Microsoft's published defaults https://support.microsoft.com/en-gb/help/140365/
	* This makes exFAT inefficient for small volumes with many tiny files

Other Notes: 

* in legacy debian-like systems you may need to `sudo apt install exfat-fuse exfat-utils`
* exFAT might not be supported by Apple’s Time Machine software
* exFAT has features designed for Flash but works ok on magnetic media
    * although it might only has one copy of the allocation table!
* only FAT-family are cross-platform as NTFS is RO on Mac



### OLD sections on Compatibility

Filesystem type - see table in https://www.howtogeek.com/73178/
The safest three-platform choice is FAT(32)

UDF has been suggested as being supported by W, M & L (https://unix.stackexchange.com/a/59590) however it is intended for RO media like optical drives, and is not necessarily fit for general purpose RW use. 

#### macOS support

* EXT filesystems are not natively supported
* oxsfuse is a common integration layer for different filesystems
* ext4fuse is RO for Ext
* fuse-ext2 has RW options for Ext
    * had issues with SIP in macOS 10.11 but workarounds exist
    * requires MacFUSE Compatibility Layer not available via homebrew (use manual pkg)
* NTFS-3G supports RW NTFS

```
# NTFS support for macOS
brew cask install osxfuse
brew install ntfs-3g
```

The other way, the filesystem type created on macOS as 
'Mac OS Extended (Journaled)' is also known as HFS+.
It can be read on linux systems (perhaps needing a package 
such as `hfsplus` or `hfsprogs`) but 
Linux does not support writing to these disks, natively (though commercial software may be available to write). 

NB: you can completely skip the whole Compatibility issue by not plugging in a drive. If you use cloud file sync (Dropbox etc) or NAS shares (CIFS/NFS/etc) then the FS is abstracted and the problem disappears into a puff of ether.



### Size (large volumes)

You will see both the compatibility and size limitations of filesystem types at https://www.howtogeek.com/73178/

FAT32 remains the most universally supported FS, but has the increasingly noticeable limitation of 4GB maximum file size.

We chose NTFS for large sizes for a while, as Linux supports NTFS reasonably well thanks to developers (including Tuxera) maintaining open-source drivers. OK, when it comes to NTFS repair, they'll still recommend booting into Windows for a good ol' CHKDSK /F but still that worked well.

EXT4 was a good choice for a while, as we had few non-linux devices using large drives. Also Windows drivers for ext4 include Ext2Fsd, and the device can have an initial liveCD partition to boot into linux and copy data to other locally attached (e.g. NTFS) drives for access by Windows. 

However, introducing macOS has complicated things once again.

The best combination of Large File Support and cross-platform compatibility seems to come from exFAT. Yes, Linux kernel cannot include the drivers for licensing reasons until 2029, but they are easy to install...

```
sudo apt install exfat-fuse
```

As long as you stick to MBR partition tables, you'll even have game console compatibility.

```
sudo mkfs.exfat -n LABEL /dev/sdXN
```

#### Issues

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
	* [https://github.com/artmg/lubuild/blob/master/help/configure/Windows.md#shrink-windows-volume]
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

Before proceeding you should prepare your Windows 
by shrinking the main OS partition to make space for the Ubuntu partitions, 
as you will need to install Ubuntu to give a bootloader 
in place of the old HP System parition.

for help see [https://github.com/artmg/lubuild/blob/master/help/configure/Windows.md#shrink-windows-volume]
	
Once you have done this you can use GPartEd to delete the System Partition. 
Create the new Ubuntu partitons in the space freed up by shrinking the OS partition 
(as the System partition was too small to use for this). 
Finally proceed with the Ubuntu installation


## LiveUSB

see also:
* [https://github.com/artmg/lubuild/blob/master/help/configure/write-Distro-to-flash.md]()
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



