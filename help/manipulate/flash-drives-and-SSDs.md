
## Flash drives

Flash memory storage devices, such as SD cards, USB pen drives and SSD
drives, sometimes referred to as NAND memory, has very different
characterstics from spinning magnetic hard disk drives (HDD). The
devices have built-in controllers to make them 'more efficient and
durable' but these sometimes increase the complications for using them
effectively for specific purposes.

If you want to get a low-level picture of this see
[https://lwn.net/Articles/428584/]


### Using flash as additional storage

Check the the partitions are aligned - see above - SD card alignment


### Issues arising later with flash drives

Remember that most flash drives not sold as SSDs are simply low cost
consumables, and you might consider pragmatism when troubleshooting
older drives. Are you better off spending a little money on a new drive
rather than loads of time fixing an older one?

[http://superuser.com/questions/376274/check-the-physical-health-of-a-usb-stick-in-linux]

#### Drives that appear Read Only

If a flash drive appears Read Only, it might be a sign that it is 
reaching the end of its usable life. However there are some steps 
to take first, to see if proper functionality can be restored:

[https://askubuntu.com/a/859284]


### Optimising OS installed on flash

How to set up your linux OS to work best when running from flash media,
as opposed to HDD.

CHECK: <https://wiki.archlinux.org/index.php/Solid_State_Drives>
<https://wiki.debian.org/SSDOptimization>
<https://sites.google.com/site/easylinuxtipsproject/ssd>
<http://askubuntu.com/questions/352131/put-swap-on-ssd-or-hdd>

For some specific ideas on optimisation see
<http://linuxonflash.blogspot.co.uk/2014/10/optimizing-system-performance-of-flash.html>

Avoid excessive writes by:

* choosing a journaling FS like EXT4
* turning off access time stamps 
    * **noatime** option in fstab (or relatime if noatime causes app issues)
* reduce swapiness?
    * echo -e "vm.swappiness=1" | sudo tee -a /etc/sysctl.conf

You could avoid Swap altogether, but this might make the device laggy.
Alternatively you could consider *swapspace*, a dynamic swap space
manager.

Are these good or bad advice?

-   Should tmp go onto a separate volume with tmpfs? Would it really
    wear better?
-   Should hibernate be avoided, as regularly writing multiple GBs of
    data might shorten a flash drive's life?
-   Should TRIM be allowed (using the **discard** option in fstab?)

#### Trimming

Ubuntu 14.04+ will automatically tell SSDs to trim the data no longer
used on a weekly cron job. See articles below if you consider this needs
doing more frequently.

#### Overprovision

Here we assume the SSD vendor has already overprovisioned by say, 7%.
There should, therefore, be no value to leaving part of the disk
unpartitioned. However it may be wise to avoid filling the disk (or any
partitions?) beyond, say, 80%

#### Firmware

We also assume your SSD was supplied by an OEM and therefore the BIOS
and SSD firmware is already configured optimally

Further info - see...
<https://sites.google.com/site/easylinuxtipsproject/ssd>
<http://www.leaseweblabs.com/2013/07/5-crucial-optimizations-for-ssd-usage-in-ubuntu-linux/>



## Flash and Filesystems ##

### background

There was a time when techies would caution about special settings such as those below, to prevent NAND Flash Devices such as pen drives and SD cards from wearing out too soon. 
Now these devices are so common-place that most modern linux distros are typically set up with the necessary options built in. 

The default filesystem for many distros is (still) Ext4 and this does provide a sensible balance, in most cases, between 
performance, resilience, compatibility and ease of use. However there are some circumstances when you might want to look further.  

Performance of cheap flash drives, speed and longevity, could be improved by a file system that takes their characteristics into account. In embedded systems (including devices like Raspberry Pi) the chances of suddenly loosing power increases the risk of filesystem corruption if it was writing at the time. 

### Alternatives

**btrfs** is sometime heralded as more modern and flash friendly. 
over the years it has become a little more mature 
and performance is comparable. 
If you want to see an extreme configuration, 
how about an SD card with two mirrored BTRFS partitions 
https://unix.stackexchange.com/a/186954

**f2fs** is designed as flash-friendly (as its name states) 
and performance is comparable with ext4. 
There were issues with stability in early days, but these seem to be resolved.

Note that linux developed a Memory Technology Device (MTD) subsystem, that improves reliability of flash storage devices. Filesystems such as **JFFS2** (or even UBIFS) use MTD to improve the way that raw flash devices are used. However, SD cards and pendrives have their own build in Flash Translation Layer (FTL) to present them to the system as a good old fashioned 'block device', so these MTD filesystems offer **no** benefit for these. 

### Embedded-style systems

There are other ways you can lay out disks to vastly improve reliability. For instance, some OS configurations for embedded use-cases, where very little changes boot after boot, use a ram disk for their core storage. That way writing is mainly done in memory so the flash storage device is mainy read only. That avoids issues with wear levelling and reliability. ALternatively, battery backup (UPS-style) can prevent sudden power loss, removing the cause of some corruption).

Some alternative distros like Slackware and its derivatives, Slax and PuppyLinux, are reputed to be more flash friendly. This is because the OS is stored in layers that are read into memory, and run from RAM disk. Then, on shutdown, only the changes are written into a new layer file.


### other ssd enhancements ###

what is NOOP scheduling and why use it over CFQ (completely fair queuing)?

for swap and app enhancements see also
http://apcmag.com/how-to-maximise-ssd-performance-with-linux.htm/

### hybrid optimisation and encryption ###

If we are using a combination of Flash/SSD and HDD to install, 
we should separate linux root folders so that 
most READ data comes from flash and 
most WRITE data goes to a magnetic drive.

Bear in mind however that write data is also read, 
and if SSD wear-leveling compensates, 
you might want to keep only the bulkiest data on HDD 
if the rest fits onto SSD. 

See also the [Debian article on HDD/SSD partitioning schemes](https://wiki.debian.org/Multi%20HDD/SSD%20Partition%20Scheme)

* Flash
    * / boot
    * /
* Magnetic
    * /home ?
    * /tmp 
    * swap (file)
    * /var

Installation Techniques:

* use [bind mount for multiple points in one volume](http://unix.stackexchange.com/a/47224)
    * but beware the impact on **find** and **locate** utils [http://unix.stackexchange.com/a/247024]
* move (e.g.) **var** onto other drive see http://unix.stackexchange.com/q/131311/
* 

According to [Archwiki's LVM_on_LUKS](https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#LVM_on_LUKS) you cannot spread a single Encrypted Volume over multiple physical devices. However the [section on LUKS on LVM](https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#LUKS_on_LVM) says that you can spread them with this technique. The trick then to limit the number of passwords entered is:

* use a keyfile for the volume(s) containing persistent data (like /home)
* use a random key for the transient folders (like /tmp and /swap)

Bear in mind, the risks of creating a complex stack of mappers (Physical Disks - Physical Partitions - LVM PV - LVM LV - LUKS):

* more complex to set up and diagnose
* potential inefficiency, more places to loose performance
* more places for a **physical error** (on ANY ONE of the underlying volumes) to render data inaccessible (ALL data if using LVM on LUKS)
    * you MUST have a means to secure a backup of any valuable data elsewhere


#### mount options ####

[https://wiki.debian.org/SSDOptimization#Mounting_SSD_filesystems]

* With LVM on LUKS the **discard** mount option should go in /etc/crypttab
    * On more recent OS versions you may find it already there by default, and [the cron job for trim may already be set up by default](http://askubuntu.com/a/19480)
* 

#### encrypt tmp 

_Can we have a single (auto) encrypted volume which holds tmp and cache so they dynamically share as much of the space as they each need?_ This could also hold a swap file (rather than swap partition) so all the transitory data can go in one single pot! Note that, although tmp and swap can happily use a key from dev random, the cache want to persist so such a single volume would need a stable encryption password. 

```
# credit - http://askubuntu.com/a/146641
# /etc/crypttab
crypttmp /dev/mapper/hdd-part-tmp /dev/urandom precheck=/bin/true,tmp,size=256,hash=sha256,cipher=aes-cbc-essiv:sha256

# /etc/fstab
/dev/mapper/crypttmp /tmp ext4 defaults 0 2
```

#### encrypt swap

merge with [https://github.com/artmg/lubuild/wiki/Encryption#encrypted_swap]

```
# see if it's encrypted
sudo blkid | grep swap
# if /dev/sdaX then not

# see if it's being used
cat /proc/swaps
cat /proc/meminfo | grep Swap

# OPTIONALLY wipe by filling with zeroes
dd if=/dev/zero of=/dev/sdXn
# wiping also destroys the UUID, leaving only PARTUUID (might work in crypttab ? )
# so generate a new one...
mkswap /dev/sdXn

# ### this is for swap PARTITION ###

# /etc/crypttab  ### NB UUID must be without quotes
swap    UUID=xxxxxOR_/dev/sdX1   /dev/urandom    swap

# /etc/fstab
/dev/mapper/swap     none     swap     defaults     0     0
# or sw instead of defaults ??

# credit http://www.microhowto.info/howto/create_an_encrypted_swap_area.html
# mount the line from crypttab
sudo cryptdisks_start swap

# credit http://www.tecmint.com/disk-encryption-in-linux/
sudo swapon /dev/mapper/swap

# reboot then verify the status of the swap space:
sudo cryptsetup status swap

```
# NB: if you want to specify multiple swap partitions, you can state 
# volume type as sw,pri=10 on first then =20 on second


#### application specifics ####

##### Browser cache #####

Google's Chrome browser especially, but also Firefox, write a lot of small cache files on most page loads. This can cripple performance on flash drives, as well as causing wear. If your home drive is on flash storage, use browser executable options to place the cache in a different location which is on HDD magnetic media, which is more 'write-friendly' especially for small files. E.g. 

* Google Chrome
 /usr/bin/google-chrome-stable %U --disk-cache-dir=/my/temp/cache/GCpath/
* Firefox
    * about:config / NEW / String
    * browser.cache.disk.parent_directory
    * paste in /my/temp/cache/FFpath/

[credit](http://www.sevenforums.com/tutorials/312031-ram-disk-install-browser-cache-file-storage.html)


## partitioning ##

### flash factory partitioning ###

since having erased the factory partition on a 32GB SanDisk Cruzer Fit v1.27
I no longer know how much free space HAD been left on the factory partitioning

Some vendor articles suggest using the "HP USB Disk Storage Format Tool" 
HPUSBFW.exe but this will NOT create a parition, only format one that is there
The other suggestion was using Windows Disk Management but this did NOT leave 
a free unallocated space at the front of the new paritioning arrangement
(start was 63, perhaps for partition table)

The article http://forum.xda-developers.com/showthread.php?t=2117275 
suggests a 1MB gap and # sectors MOD 256 = 0. 
This is to keep them to whole blocks where 
"the largest known block size is 128 KiB (128 * 1024 bytes). 
256 sectors = 128 KiB. Even if block size is 64 / 32 / 16 / 8 or 4 KiB 
128 KiB is certainly a multiple of the smaller block sizes."

However SanDisk forum article http://forums.sandisk.com/t5/M/6/m-p/301049#M2727
shows a 64GB device with 16MB free space at start

See original partition for Cruzer Fit 8GB according to 
[http://www.flashdrivespeed.com/flash-drive/sandisk-cruzer-fit-8gb-usb-flash-drive-review-and-speed-test/]



### force partitioning to sector 63 ###

"Most modern disk drives need a partition to be aligned on sector 2048 
to avoid writes overlapping two sectors. 
On modern distros like Ubuntu the fdisk utility is patched to default 
to 2048 sectors. But [what if] you need to use sector 63?"

[http://confluence.wartungsfenster.de/display/Adminspace/fdisk+Force+sector+63+boundary]

