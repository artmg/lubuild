Partitions
----------

### Rename USB
```
# Rename USB drive or flash / SD card to change label:
# help > [https://help.ubuntu.com/community/RenameUSBDrive](https://help.ubuntu.com/community/RenameUSBDrive)
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

### do it with parted

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


### choose Boot Parititon

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


<<<<<<< Updated upstream
## Diagnostics and Troubleshooting
=======
see also GitHub/Lubuild.wiki/Troubleshooting.mediawiki

see also GitHub/Lubuild.wiki/Troubleshooting.mediawiki

see **boot-repair** for great and powerful GUI
>>>>>>> Stashed changes

If you are having trouble with an installed system, 
see **boot-repair** for a powerful GUI designed to get it working again

The rest of this section introduces useful commands for understanding 
disks and other storage devices.

### GUI

The '''gnome-disks''' utility is a handy GUI for most diagnostics


### Discover the attached devices
```
# see which partitions are currently in use and check how full
df
# if you prefer 'human readable' gigs and megs 
df -H

# view details of disk partitioning
sudo fdisk -l

# show all devices whether or not mounted
lsblk

# by disk (partition) Label, show mounted devices
ls -l /dev/disk/by-label/
# and all devices
lsblk -o name,mountpoint,label,size
```

### Simple checks
```
# provided the filesystem is UNMOUNTED, check it
sudo umount /dev/sdbX
sudo fsck -t ext4 /dev/sdbX 

# sudo badblocks /dev/sdbX
```
If you need to do full check on a filesystem that is in use, 
reboot to a Live USB so they are not mounted.

For help on disk and partition diagnostics see 
http://www.howtogeek.com/howto/37659/the-beginners-guide-to-linux-disk-utilities/

### In from lubuild/wiki/Troubleshooting/

#### Capcity - disk full?

```
# check available space on mounted disks
df -H

# check the first level folders
du --max-depth=1
# sort it
du --max-depth=1 -a | sort -nr | head

### GUI to identify space hogs (esp in home folders) ###
baobab &
```

#### Specifics to clean up 

```
### Clean up root ###

## local package cache ##
# display cache size
du -sh /var/cache/apt/archives
# credit - http://www.howtogeek.com/howto/28502/
# purge
sudo apt-get clean


## crash logs ##
# display cache size
du -sh /var/log
# purge
sudo rm -fR /var/log/*


## If you delete large files but they are still in use 
# in process handles the space cannot be freed
# until you flush one of these handles - 
# credit - http://unix.stackexchange.com/a/64737
lsof | grep deleted | grep MyBigFile
# pick one of the pids and check its handles
ls -l /proc/<Pid>/fd
# flush the relevant handle by sending it 'nothing' 
> /proc/<Pid>/fd/<HandleId>


## old kernels ##
# purge
sudo apt-get update         # re-read package repositories
sudo dpkg --configure -a    # complete any installations previously aborted 
sudo apt-get -f install     # sort out packages not correctly installed due to space issues 
sudo apt-get -y autoremove  # remove any items no longer required, including kernels
sudo apt-get clean          # re-purge cache for any items just downloaded


# re-check available space on mounted disks
df -H

```

#### SMART tests 

```
gnome-disks
# highlight the drive and check in the Drive Settings menu for SMART Data and Self Tests

# if this is greyed outon External USB devices, you may need a separate utility to send
# the SMART ATA commands via the USB interface
sudo apt-get install -y smartmontools

# check that SMART is available on the device 
sudo smartctl -i /dev/sdX
# you may need the -d sat option if the drive is not in the smartctl database
# for USB device compatibility see http://www.smartmontools.org/wiki/Supported_USB-Devices 

# check the health
sudo smartctl -H /dev/sdX
# if you have issues refer to http://blog.shadypixel.com/monitoring-hard-drive-health-on-linux-with-smartmontools/
```


### Media devices using MTP

13.10 includes support for MTP devices (*via GVFS?*), but by default
devices appear in PCManFM under the **mtp:** protocol, e.g.
*mtp://$$usb:001,003$$/Card*, however they also appear under a *real*
filesystem location under...

```
ls $XDG_RUNTIME_DIR/gvfs
# /run/user/<user>/gvfs
# credit - http://askubuntu.com/a/233123
#
# for a bash script to get this path deterministically, see http://askubuntu.com/a/342549 
```

NB: some proprietary MTP implementations (such as Samsung Galaxy S4) may
not allow command line access. Perhaps **go-mtpfs** might have slightly
better support?

### Speed and Capacity tests

Capacity tests may be used when you are not sure if you can still rely
on the quoted volume of a storage device (either because it is worn out
or you fear it may be counterfeit).

Before you start to perform speed tests, you should consider how you
will be using the media. Firstly will you be reading more, or writing
more? Will it be sequential (like photos or music) or random (like
general computer use)? If you will format the drive in a particular way,
you should do this before you do your tests, if you want them to be
representative.

#### built in

You can test Speed using the gnome-disk utility (Start Menu /
Preferences / Disks) to Benchmark the drive speed. Choose the partition
(where you must be prepared for data to be overwritten) and Start
Benchmark with 2 cycles of 1000 MiB with write benchmark checked.

One would expect the built-in utility to benchmark in a way which
represents typical utilisation. I'm not sure that actually IS the case.
At the time of writing the Disk utility reportedly does not take into
consideration the partition alignment considered critical to flash drive
performance.

#### dd

dd is a built-in command which very quickly gives you indicative
sequential read or write statistics, and can be used for a capacity
test.

To test capacity check the correct device path and number of MiB (not
MB) in...

`sudo dd if=/dev/zero of=/dev/sdX1/capacity.test bs=1M count=3500 oflag=direct conv=fdatasync`

If you write to FAT32 over 4GB you will need to write multiples of 4GB.
After to display the total size...

```
# Display in MiB
df -BM
# and in MB
df -BMB
```

#### under Wine

The very popular Windows util H2testw is reported to work under Wine.

Not sure if the same goes for Crystal Disk Mark, ChkFlsh or AS SSD. Atto
and IoMeter are others commonly used under Windows.

#### Bonnie++

[Bonnie++](https://en.wikipedia.org/wiki/Bonnie%2B%2B) is a tool which
you may see being recommended by many people, despite its age. For an
intro see
[1](http://www.jamescoyle.net/how-to/599-benchmark-disk-io-with-dd-and-bonnie)

#### fio

FIO seems to be the choice of many pros (and vendors). It is capable of
performing very precisely defined tests. The downside to this power and
flexibility is that I have yet to find (or work out for myself) a FIO
configuration file which will simulate typical ubuntu desktop user.
Perhaps I could convert [a sample file for simulating
servers](https://www.linux.com/learn/tutorials/442451-inspecting-disk-io-performance-with-fio/)?

* https://www.binarylane.com.au/support/solutions/articles/1000055889-how-to-benchmark-disk-i-o
* http://www.storagereview.com/fio_flexible_i_o_tester_synthetic_benchmark
* http://www.bluestop.org/fio/HOWTO.txt
* also has GUIs...
    * fio-vizualiszer (PyQt) https://communities.intel.com/community/itpeernetwork/blog/2015/03/27/how-to-benchmark-ssds-with-fio-visualizer
    * gfio (gtk)

#### IOzone

[IOzone](https://en.wikipedia.org/wiki/IOzone) is what the [Ubuntu
Kernel
team](http://illruminations.com/2014/01/17/ubuntu-file-system-benchmarking/)
use for their filesystem benchmarking. You can find examples at
[http://www.thegeekstuff.com/2011/05/iozone-examples/] and some
comparison with fio and bonnie at
[http://www.slashroot.in/linux-file-system-read-write-performance-test]

## Erasing data

see [https://github.com/artmg/lubuild/help/manipulate/remove-data.md]


Flash drives
------------

see [GitHub/Lubuild.files/help/manipulate/flash-drives-and-SSDs.md]

Layouts
-------

Here are some sample disk layouts depending on your needs

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

#### prepare

credit - <http://wiki.openelec.tv/index.php/Dual_Boot>

For flexibility these can be Logical in an Extended Partition

-   OE\_SYS (bootable) EXT4 500MB - holds KERNEL and SYSTEM
-   OE\_DATA EXT4 4GB+

Kernel and System are aparently all there is to the OpenELEC build, so
the size of data depends on your usage.

#### download OpenELEC

<http://openelec.tv/get-openelec>

circa 150MB

Open the archive and copy the files to the SYS partition

#### add to GRUB

see Dual Boot article

#### install Browser

Opera -
<http://mymediaexperience.com/how-to-install-xbmc-linux-in-15-minutes-with-openelec/>

LiveUSB
-------

### Creating a LiveUSB startup disk

If you find the (L)ubuntu built-in *Startup Disk Creator* does not
reliably create bootable live usb drives, try the alternative mkusb
script 
```
# NB: mkusb will REPARTITION your flash drive
# you may wish to note the original vendor optimised formatting layout
# (especially the start sector) before wiping it out

sudo fdisk -l

# help https://help.ubuntu.com/community/mkusb
sudo add-apt-repository -y ppa:mkusb/ppa
sudo apt-get update
sudo apt-get install mkusb

# specify an ISO file and (optionally) add persistence (casper-rw) volume using the blank space on the drive 
sudo -H mkusb path/to/imagefile.ISO p
```

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
### Live Boot Parameters

Although this list is specifically for TAILS, it does explain a wide
variety of available boot-time settings you can make on a LiveUSB

<https://craftedflash.com/info/live-distro-boot-parameters>

### Alternative to Live USB for regular use

If you always use a Live USB in the same PC, then there is no advantage.
Also, there are restictions using encrypted home with Live USB

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

### set up Swap, post install

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

### Live Persistent

=

Once CDROM is remounted as RW add to File Mgr as Places

`Browse to      Add Bookmark as `\
`/cdrom     ALLP root`\
`/cdrom/Media/In.various        ALLP.IN`

Multiboot ISOs
--------------

Here are some articles explaining how to take ISOs for multiple linux
distros, and create Grub menus to allow you to boot directly into
whichever you prefer. This assumes the ISOs are created for Live boot
and run - this technique might not support persistence of settings or
data.

-   simple - <http://www.circuidipity.com/multi-boot-usb.html>
-   generic - <http://ubuntuforums.org/showthread.php?t=2276498>
-   extensive -
    <https://wiki.archlinux.org/index.php/Multiboot_USB_drive>
-   other ISOBOOT samples -
    <https://help.ubuntu.com/community/Grub2/ISOBoot/Examples>

### Grub reference

-   archwiki Grub reference -
    <https://wiki.archlinux.org/index.php/GRUB>
-   GNU GRUB full manual - <http://www.gnu.org/software/grub/manual/>

