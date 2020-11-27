
See also:
* [https://github.com/artmg/lubuild/blob/master/help/manipulate/films-and-songs.md]
	* how to find out details (metadata and contents) of media files


## file types ##

### common types

```
# display the type of known files, based on their signature
file <path/filename.ext>
```

### common file signatures

Use a hex editor to read the header bytes at the beginning of a file and check against:

* [http://www.garykessler.net/library/file_sigs.html]
* 


### type identifier software

read the header bytes at the beginning of a file 
and detect / identify common signatures 
to understand what filetype it is 
and which programmes may be used to open / view / extract data 

* Detect It Easy (DIE) - QT app with extensible signatures (programmable in java)
    * Download from [http://ntinfo.biz/index.php/detect-it-easy]
    * Unpack
    * `sh lin64/die`


## Data Carving

Recovering data from unused clusters of a disk - like Undelete but better! These data recovery tools don't need file tables 
nor even partition tables – they just look at the raw data on the disk, recognising what look like files and guessing the type 
using the file signatures mentioned above.

See sections below or other carving utils include MagicRescue, Hachoir

* [http://www.forensicswiki.org/wiki/Tools%3aData_Recovery#Carving]
* [https://help.ubuntu.com/community/DataRecovery]


### scalpel and foremost

Scalpel and Foremost insist on using a disk image file
This is best practice anyhow, to avoid damaging the original

Foremost was the original, but scalpel was forked from it
and has had more recent development

```
# source - https://github.com/sleuthkit/scalpel
sudo apt-get install scalpel
# uncomment the files you want

sudo nano /etc/scalpel/scalpel.conf

scalpel -o NewDirForFilesFound <.img or /dev>
```

### PhotoRec and TestDisk 

PhotoRec runs in terminal and if you supply no parameters 
it is driven by interactive menus.

You may use it on directly mounted media, as well as image files

```
sudo apt-get install testdisk
sudo photorec /dev/sdYX

# help - http://www.cgsecurity.org/wiki/PhotoRec
# also - http://www.cgsecurity.org/wiki/Image_Creation
```

## raw partition and loop files ##

```
# trying to mount an image file as a loop...

losetup /dev/loop9 myfile.IMG
sudo mount /dev/loop9 /mnt/img

# NTFS signature is missing.
# Failed to mount '/dev/loop2': Invalid argument
# The device '/dev/loop2' doesn't seem to have a valid NTFS.

# try to look at the image details, see if there is a partition table
fdisk -l myfile.IMG

# if so, to use it for mount offsets see
# http://askubuntu.com/questions/69363/mount-single-partition-from-image-of-entire-disk-device
# or use   kpartx   to do this for you

# Can we recognise the type
blkid
blkid -p /dev/loop9
file -s /dev/loop9

# check if it might be encrypted
cryptsetup luksUUID /dev/loop9

# inspect the data contents 
head -c 256 < /dev/loop2 | hd

# consider a forensic data carving tool

# see also [https://major.io/2010/12/14/mounting-a-raw-partition-file-made-with-dd-or-dd_rescue-in-linux/]


```

## Recovering from damaged media

### Magnetic

There is an older ddrescue package with Garloff's dd_rescue command from 2010, but we'll use ddrescue from GNU. 

sudo apt install gddrescue

lsblk -o name,label,size,fstype,model

ddrescue goes through Copying, Trimming, Scraping and Retrying. You can modify this basic behaviour with options or just leave it to what the authors considered an optimal approach to recovery. Perhaps the first time you might get as much data as you can before risking the disk mechanism, then you might try again more intensively to get every bit of data you possibly can.

ddrescue /dev/sdX saveto.img [mapfile]

Instead of an image, you can write to another disk device, but you might need the -f --force option.
If you use a mapfile to allow you multiple attempts, 
you can inspect it with `ddrescuelog`

For the manual see 
https://www.gnu.org/software/ddrescue/manual/ddrescue_manual.html

### Optical

DVDisaster is in the Ubuntu repos
and can read as much of CDs and DVDs as possible despite physical damage
[http://dvdisaster.net/en/index.html]


## IN - Using LiveUSB for Data Recovery

_from old Set Up Ubuntu_

Data recovery tools (in universe repository):
* testdisk
* foremost
* scalpel

source [http://www.howtogeek.com/howto/15761/recover-data-like-a-forensics-expert-using-an-ubuntu-live-cd/]

