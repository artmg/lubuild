
# Understand Layout



## Layouts  #############################################

Here are some sample disk layouts depending on your needs

### Sizing Notes

Recommend minimum 16GB device - skip the rest of the section if you're ok with that

Reasoning:

* System and apps
	* base install with standard apps is c 6GB
	* fresh LxQt 17.10 with typical app installs c 7GB
* home
	* not only data and config but browser cache and search indexes
* allow 1GB for boot
    * recommendations say 200-300 MB
    * this is fine until you start applying updates (especially automatically)
    * you get the following error from Software Updater: 
        * "Not enough free disk space"
    * Workaround: sudo apt-get autoremove 
    * better solution is to leave enough room on boot partition
        * allow space for at least two or three extra kernel versions 
* allow a swap on HDD
    * equal to the total amount of RAM installed
    * leaves enough space to hibernate (suspend to disk)
    * also handy when booting from flash


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



