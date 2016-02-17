
## file types ##

### type identifier software

read the header bytes at the beginning of a file 
and detect / identify common signatures 
to understand what filetype it is 
and which programmes may be used to open / view / extract data 

* Detect It Easy (DIE) - QT app with extensible signatures (programmable in java)


## Data Carving ##

Recovering data from unused clusters of a disk - like Undelete but better!

See sections below or other carving utils include MagicRescue, Hachoir

* [http://www.forensicswiki.org/wiki/Tools%3aData_Recovery#Carving]
* [https://help.ubuntu.com/community/DataRecovery]


### scalpel and foremost ##

Scalpel and Foremost insist on using a disk image file
This is best practice anyhow, to avoid damaging the original

Foremost was the original, but scalpel was forked from it
and has had more recent development

```
# source - https://github.com/sleuthkit/scalpel
sudo apt-get install scalpel
# uncomment the files you want
sudo nano /etc/scalpel/scalpel.conf
```

### PhotoRec and TestDisk ###

PhotoRec runs in terminal and if you supply no parameters 
it is driven by interactive menus.

You may use it on directly mounted media, as well as image files

```
sudo apt-get install testdisk
sudo photorec

# help - http://www.cgsecurity.org/wiki/PhotoRec
# also - http://www.cgsecurity.org/wiki/Image_Creation
```

## loop files ##

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
```

