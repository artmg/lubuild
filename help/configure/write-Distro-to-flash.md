
see also:
* [https://github.com/artmg/MuGammaPi/wiki/Disks#distro-images]
* 


## check ISO integrity

Copy the hyperlink to MD5SUMS 
Browsing in pcmanfm in the folder containing the ISO image, press F4 for a terminal

```
wget url_to_MD5SUMS
md5sum -c MD5SUMS
```


## Ubuntu and derivatives ##

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

# udisks2 is probably installed by default on ubuntu
sudo apt-get install -y udisks2 mtools


# write to USB
sudo -H mkusb $IMAGE_FILENAME $IMAGE_PERSISTENCE 
# and enter 100 for persistence %

# check the output for the dev name set as **vfat**
IMAGE_DEVICE=sdX9

# credit - https://help.ubuntu.com/community/RenameUSBDrive
sudo mlabel -i /dev/$IMAGE_DEVICE ::$IMAGE_LABEL

# Troubleshooting
# if you get error "not a mulliple of sectors"
# echo mtools_skip_check=1 >> ~/.mtoolsrc
# and repeat the command

# display label
sudo mlabel -i /dev/$IMAGE_DEVICE -s ::

# eject
udisksctl unmount --block-device /dev/$IMAGE_DEVICE
udisksctl power-off --block-device /dev/${IMAGE_DEVICE:0:3}
# help - https://udisks.freedesktop.org/docs/latest/udisksctl.1.html
```


## Raspberry Pi ##

### Foundation's dd write to device

[Pi Foundation's own Linux instructions](https://www.raspberrypi.org/documentation/installation/installing-images/linux.md)
may look complex but essentially boil down to a simple dd write of the entire destination filesystem. 
Note that this process will essentially overany additional partitions which may have existed on the media, 
which of course will erase any data previously stored there. 

You can use **mkusb** above for a more controlled approach, which makes it more likely you will select the right device. If you have a zipped image you could pipe it directly to the disk with `unzip -p xxx.zip xxx.img | dd bs=4M of=/dev/yyy` 


### expand the second partition

you should do this AFTER the umount above but before any device eject / power-off command

```
# credit - http://elinux.org/RPi_Resize_Flash_Partitions
# the article also explains why as well as various options for how

IMAGE_DEVICE=sdX9

# sudo parted /dev/$IMAGE_DEVICE resize 
# help

# WIP #################
# note that neither command line option (parted not fdisk delete and recreate) 
# has a simple option to automatically expand to fill all available space
# 
# for now use fdisk 
# * delete paritition (2) and create new 
# * accepting defaults will fill to end as type 83
fdisk /dev/${IMAGE_DEVICE:0:3}

udisksctl unmount --block-device /dev/${IMAGE_DEVICE:0:3}2
sudo e2fsck -f /dev/${IMAGE_DEVICE:0:3}2
sudo resize2fs /dev/${IMAGE_DEVICE:0:3}2


```

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

