
There are issues with the Kubuntu spin of the `Ubiquity` 
graphical installer interface for Ubuntu, and spins derived from it 
like Lubuntu Next. Specifically, manual partitioning encryption fails. 
This is about that error and how to work around it. 

* more tech detail on install 
	* [https://bugs.launchpad.net/ubuntu/+source/ubiquity/+bug/1670336]
* has kubuntu been plagued by this for years?
	* [https://bugs.launchpad.net/ubuntu/+source/ubiquity/+bug/1510731]
* lots and lots of history
	* [https://bugs.launchpad.net/ubuntu/+source/ubiquity/+bug/1066480]
* the bug I opened a bug to link to an ISO tracker report for artful alpha 1 Lubuntu Next
	* [https://bugs.launchpad.net/ubuntu/+source/ubiquity/+bug/1705845]

Some people suggest usung Ubuntu Server ISO to complete setup 
then install the desktop metapackage (lxqt, tho they say kubuntu)

However, if you want to test the contents of a specific ISO image 
you might prefer to simply work around the encyption issue in the installer:


## Install into Encrypted Partition outside Ubiquity

### Set up your options

```
PARTITION_TO_ENCRYPT=/dev/sda6
PARTITION_TO_BOOT=/dev/sda5
CRYPT_OPTIONS="-i 5000 -y"
```

### Prepare encrypted partition

Remember that best practice recommends you overwrite the volume with 
a random pattern 
[https://github.com/artmg/lubuild/blob/master/help/configure/Disks-and-layout.md#overwrite-entire-partition-before-encyption]


```
# set mapper name as per Ubiquity encryption standard, e.g. sda6_crypt
export PARTITION_MAPPER=${PARTITION_TO_ENCRYPT:5:8}_crypt

# remember YES must be uppercase, then enter passphrase twice
sudo cryptsetup $CRYPT_OPTIONS luksFormat $PARTITION_TO_ENCRYPT

# and passphrase a third time
sudo cryptsetup luksOpen $PARTITION_TO_ENCRYPT $PARTITION_MAPPER

# if you wamt multiple volumes inside there use pv/vg/lv create as per other articles
# otherwise create a simple filesystem in there
sudo mkfs.ext4 /dev/mapper/$PARTITION_MAPPER
```

### Installation

Launch the installer ready for 'manual' disk setup

```
# make sure the swap is turned off
sudo swapoff -a
# check there's no swap
cat /proc/swaps

# remember to choose MANUAL !!
ubiquity &

# put ROOT onto /dev/mapper/sdaX_crypt ext4
# Use As: ext4   Format: (leave unchecked)   Mount Point: /
#
# Choose your Boot partition
# Use As: ext4   Format: (leave unchecked)   Mount Point: /boot
#
# remember to select any 'swap' partition and choose 
# Change - Do Not Use so it appears as 'linux-swap' instead
#
# Install Now
# Accept that paritions will not be formatted - Continue
# Accept the changes - Continue
#
# After install you MUST choose Continue Testing
```

### Post-install

Make sure the installation is ready for opening the encrypted volume

```
# check Ubiquity mounted your encrypted root as /target
lsblk

# although it mounted your boot as /target/boot during install it may have unmounted it since
sudo mount $PARTITION_TO_BOOT /target/boot

export PARTITION_ROOT_UUID=`sudo blkid -s UUID -o value $PARTITION_TO_ENCRYPT`
export PARTITION_BOOT_UUID=`sudo blkid -s UUID -o value $PARTITION_TO_BOOT`
# credit https://stackoverflow.com/a/16277809

# credit https://blog.jayway.com/2015/11/22/ubuntu-full-disk-encrypted-macosx/
for i in /dev /dev/pts /proc /sys /run; do sudo mount -B $i /target$i; done
# for i in /dev/pts /dev /proc /sys; 

# pass in the variables
sudo -E chroot /target

# create the crypttab
echo $PARTITION_MAPPER UUID=$PARTITION_ROOT_UUID none luks > /etc/crypttab

# check the mapper and boot are correct in fstab
echo root mapper $PARTITION_MAPPER
echo boot uuid $PARTITION_BOOT_UUID
cat /etc/fstab 

# otherwise change them 
#editor /etc/fstab 
# because if the fstab mapper doesn't match crypttab...
# update-initramfs would fail to include the cryptsetup binaries and modules
# help - https://github.com/lhost/pkg-cryptsetup-debian/blob/master/debian/README.initramfs
# also - he told you so ... http://thesimplecomputer.info/full-disk-encryption-with-ubuntu

update-initramfs -u -k all -v > /tmp/initrd.log

# validated the presence of crypto items
lsinitramfs /boot/initrd* | grep crypt

# update grub just in case
update-grub
# but probably no need to    grub-install /dev/sdX

# leave the chroot
exit
# don't bother unmounting as we're about to reboot

# otherwise reverse order
#for i in /dev/pts /dev /proc /sys; do umount /mnt/system$i; done
# for DEV in proc sys dev/pts dev; do umount /mnt/newroot/$DEV; done
```

## help

### extract initramfs to view or compare files

```
cd /target/boot
for i in initrd*
do 
  echo $i
  mkdir -p /tmp/$i
  cd /tmp/$i
  # Copy the image, uncompress it
  gzip -dc /target/boot/$i | cpio --extract --make-directories --unconditional
done
cd /tmp
ls
```

## some other articles

Where possible, the code above includes credits and other urls 

* Do the encyption manually before (and after) ubiquity install
	* simplest [https://askubuntu.com/a/623842]
		* but misses the chroot initramfs (only mentioned in comments)
	* simple version for Mac dualboot [https://blog.jayway.com/2015/11/22/ubuntu-full-disk-encrypted-macosx/]
	* next best [https://askubuntu.com/a/293029]
	* more technical [https://nwrickert2.wordpress.com/2016/04/25/installing-kubuntu-16-04-in-an-existing-encrypted-lvm/]
	* alternative [https://askubuntu.com/questions/921426/update-grub-in-a-chroot-environment-with-root-on-a-luks-encrypted-volume]
	* see also 
		* https://wmbuck.net/blog/?p=537
		* https://bugs.launchpad.net/ubuntu/+source/cryptsetup/+bug/1256730
		* https://askubuntu.com/questions/803874/boot-no-luks-password-prompt


### other solutions not required

#### solutions people applied inside the chroot

##### before the update initramfs

```
## this should not be needed unless LVMs used, but I wanted to make sure it worked (grabbing at straws ;)
#apt-get update
#apt-get install lvm2

## ensure encryption modules are included
#echo "dm-crypt" >> /etc/initramfs-tools/modules

# this didn't work
#echo CRYPTSETUP=Y >> /etc/initramfs-tools/conf.d/cryptsetup
## but if you need to use hooks/cryptroot see 
# [https://bugs.launchpad.net/linuxmint/+bug/1000569]
```

##### before the update grub

```
#Edit file /etc/default/grub to enable the encrypted /boot to include:
#GRUB_ENABLE_CRYPTODISK=y
#GRUB_CMDLINE_LINUX="cryptdevice=/dev/sda5:sda5_crypt"
```

