

## Introduction

This article is mostly about _encryption at rest_, 
in other words when data is being stored on a medium 
such as a hard disk drive or a flash drive.

For help on setting up encryption when you install into partitions, 
including encrypted swap, see 
[https://github.com/artmg/lubuild/blob/master/help/configure/Disks.md]


see also:

* discovering the contents of a disk image (loop) file
	* [loop files and forensics](https://github.com/artmg/lubuild/blob/master/help/manipulate/disk-recovery-and-forensics.md)
* general partitioning procedures including encrypted swap
	* [https://github.com/artmg/lubuild/blob/master/help/configure/Disks.md]
* how to wipe whole partitions as preparation for encryption
	* [https://github.com/artmg/lubuild/blob/master/help/manipulate/remove-data.md]
* to workaround issues installing QT and KDE into encrypted partitions 
	* [https://github.com/artmg/lubuild/blob/master/help/configure/LxQt-Kubuntu-Ubiqity-manual-encryption-bug.md]
* special considerations for data stored using solid state or NAND 'flash' technologies
	* [https://github.com/artmg/lubuild/blob/master/help/manipulate/flash-drives-and-SSDs.md]
* encryption of network traffic (e.g. using SSH) and managing encryption keys
	* [https://github.com/artmg/lubuild/wiki/Networked-Services]


## Create new loop volumes files

See also [https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_a_non-root_file_system#Loop_device]

```
VOLUME_FILE=linux.vol 
SIZE_IN_MB_BLOCKS=10
LABEL=MyDrive
# e.g. use many iterations to slow down brute force password attack
CRYPT_OPTIONS=-i 5000 -y


# cryptsetup luksFormat defaults are often close to optimum
# e.g. 1.6.0 defaults to --cipher=aes-xts-plain64 for luks
cryptsetup --help
# some people suggest increasing the key length although it slows I/O
# see the difference between aes-xts 256 and 512 bits
cryptsetup benchmark
# or number of iterations on the password which increases the time to unlock
# a more complex hash which can be iterated fewer times in the same duration

# if you do the luksFormat then luksDump you will see the resulting defaults 

# you could choose to increase
# key length                   -s 512
# iteration time in mSeconds   -i 5000
# more complex hash            -h sha256
# a different cipher           -c twofish-xts

# but remember to balance security with usability
# and consider that many diverse attack vectors exist

# see also http://code.google.com/p/cryptsetup/wiki/FrequentlyAskedQuestions
# and https://wiki.archlinux.org/index.php/Dm-crypt/Device_encryption



## OLD
LOOP=0
OPENLOOP=1

# Not sure why this changed from 1M to 5M blocks - prbly irrelevant
# SIZE_5MB=10
# SIZE_5MB_BLOCKS=2
# dd if=/dev/zero of=$VOLUME_FILE bs=5M count=$SIZE_5MB_BLOCKS


# PREP
sudo echo # collect sudo credentials before continuing

# Automatically select the next two loop numbers
LOOP=`sudo losetup -f|grep -o '.$'`
OPENLOOP=$((LOOP+1))


dd if=/dev/zero of=$VOLUME_FILE bs=1M count=$SIZE_IN_MB_BLOCKS
sudo losetup /dev/loop$LOOP $VOLUME_FILE

### Prepare space for encrypted volume ###

# Some folks suggest filling the loop device contents with zero first
# other more paranoid folks suggest random is safer, but there are disadvantages
# badblocks    = patterns, not very random;       badblocks -s -w -t random -v /dev/loopX
# /dev/urandom = more random but slower;          dd if=/dev/urandom of=/dev/loopX
# /dev/random  = really slow, waits for entropy;  dd if=/dev/random of=/dev/loopX
# help - http://gentoo-en.vfose.ru/wiki/DM-Crypt_with_LUKS#Filling_the_disk_with_random_data

# ironically one way to get psuedo random enough quickly enough is to use a cipher to encrypt zeros
# but the paranoid brigade will not want this to be based on the same passphrase

# simple dm-crypt random overwrite
# credit - https://wiki.archlinux.org/index.php/Dm-crypt/Drive_preparation
cryptsetup open --type plain /dev/loop$LOOP myMapper$LOOP --key-file /dev/random
dd if=/dev/zero of=/dev/mapper/myMapper$LOOP
cryptsetup close myMapper$LOOP

### OR ###

# luks using randomly generated keyfile, then overwriting the header
# credit - http://serverfault.com/questions/537972/
# dd if=/dev/random of=keyfile bs=512 count=1 iflag=fullblock
dd if=/dev/urandom of=keyfile bs=1k count=2
sudo cryptsetup luksFormat /dev/loop$LOOP --use-urandom --batch-mode --key-file keyfile
sudo cryptsetup luksOpen /dev/loop$LOOP myMapper$LOOP --batch-mode --key-file keyfile
# sudo cryptsetup luksDump /dev/loop$LOOP   # show the LUKS header
# sudo dmsetup ls                           # show mapper devices
# https://www.linux.com/community/blogs/133-general-linux/830662-how-to-full-encrypt-your-system-with-lvm-on-luks-from-cli
dd if=/dev/zero of=/dev/mapper/myMapper$LOOP bs=1M
# sudo kill -USR1 $(pgrep ^dd)    # from other terminal to check progress
sudo cryptsetup luksClose myMapper$LOOP --batch-mode
# this scraps the LUKS header, which is probably within the first 1MB but it does 10MB just to save thinking
dd if=/dev/urandom of=/dev/loop$LOOP bs=512 count=20480
# destroy the keyfile
dd if=/dev/urandom of=keyfile bs=1k count=2
rm -f keyfile


### Create the volume with your encryption passphrase ###

# NOT setting something that will appear in command line history! PASSWORD=BlahBlah1234 
# Could read hidden text into PASSWORD without command history being saved
# but typing it three times instead of piping echo $PASSWORD 
# is one way to validate you typed it correctly :)

sudo cryptsetup $CRYPT_OPTIONS luksFormat /dev/loop$LOOP
# Need to enter password twice

sudo cryptsetup luksDump /dev/loop$LOOP 
sudo cryptsetup luksOpen /dev/loop$LOOP myMapper$LOOP
# Need to enter password 

# not sure these tell us much of any use...
#sudo dmsetup ls
#sudo dmsetup table
#sudo dmsetup status

# use a Mapper to allow us access to format the volume
# not sure why mapper is required but that's what the old OTFE instructions suggested
sudo cryptsetup status myMapper$LOOP
sudo losetup /dev/loop$OPENLOOP /dev/mapper/myMapper$LOOP

# consider luksformat to create &gt; http://manpages.ubuntu.com/manpages/lucid/man8/luksformat.8.html
# or see cryptsetup LUKS FAQ &gt; http://code.google.com/p/cryptsetup/wiki/FrequentlyAskedQuestions

sudo mkfs -t ext4 -L $LABEL /dev/loop$OPENLOOP


# SEE notes on ACLs above


sudo losetup -d /dev/loop$OPENLOOP
sudo cryptsetup luksClose myMapper$LOOP
sudo losetup -d /dev/loop$LOOP
 
 
## is UUID from luksDump any use in helping with automount options?
## or would it be the one from mke2fs 

```

### Generate a Password

```
# use entirely built-in features...
TEMP_PWD=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;`
# credit [https://www.howtogeek.com/howto/30184/]

# or ...
# Install and use the apg app
sudo apt-get install apg
# generate pwd
apg -m 16 -s


# NB: if you want to use this as a password to create a luks volume then use
echo -n $TEMP_PWD | cryptsetup luksFormat /dev/vdxN -
# where the tailing - says to read STDIN for the password (but it includes newlines)
# so the -n avoids passing a newline as part of the password (like printf)
```

### Using a keyfile

#### Set up your variables 

```
# These two you'll need for all activities
VOLUME_FILE=linux.vol 
# ensure this is stored somewhere that is protected
KEY_FILE=/path/myvault/keyfile

# These you'll only need when creating the volume
SIZE_IN_MB_BLOCKS=10
LABEL=MyDrive
# none for now (unles we want to increase the master key size above 256B?)
CRYPT_OPTIONS=
```

#### Create the volume and keyfile

```
# ask for sudo password up front
sudo echo

# Generate the keyfile (could be 256B but here is 2KB)
dd if=/dev/urandom of=$KEY_FILE bs=1k count=2


# Prepare the volume file
# get the next free loop
LOOP=`sudo losetup -f|grep -o '.$'`
# create the file and loop it
dd if=/dev/zero of=$VOLUME_FILE bs=1M count=$SIZE_IN_MB_BLOCKS
sudo losetup /dev/loop$LOOP $VOLUME_FILE
# overwrite it with random data - use /dev/random here as we want entropy not length
sudo cryptsetup open --type plain /dev/loop$LOOP myMapper$LOOP --key-file /dev/random
dd if=/dev/zero of=/dev/mapper/myMapper$LOOP
sudo cryptsetup close myMapper$LOOP

# Now encrypt the volume using the key file
sudo cryptsetup $CRYPT_OPTIONS luksFormat /dev/loop$LOOP --batch-mode --key-file $KEY_FILE
# look at the header we created
sudo cryptsetup luksDump /dev/loop$LOOP

# open the volume
sudo cryptsetup luksOpen -d $KEY_FILE /dev/loop$LOOP myMapper$LOOP
# check the details
sudo cryptsetup status myMapper$LOOP

# now create the filesystem
sudo mkfs -t ext4 -L $LABEL /dev/mapper/myMapper$LOOP

# and close it all up
sudo cryptsetup luksClose myMapper$LOOP
sudo losetup -d /dev/loop$LOOP
```

You might want to set up permissions on the new filesystem:
e.g. 
```
sudo chgrp -R $USER:$USER /media/$USER/VolumeNAME
```

#### Scripts to Open and Close the volume

```
cat <<-EOF! > volume_open_with_key.sh
#!/bin/bash
VOLUME_FILE=$VOLUME_FILE
KEY_FILE=$KEY_FILE
LOOP=\`sudo losetup -f|grep -o '.$'\`
sudo losetup /dev/loop\$LOOP \$VOLUME_FILE
sudo cryptsetup luksOpen -d \$KEY_FILE /dev/loop\$LOOP myMapper\$LOOP
udisksctl mount -b /dev/mapper/myMapper\$LOOP
EOF!
chmod +x volume_open_with_key.sh

cat <<-EOF! > volume_close.sh
#!/bin/bash
VOLUME_FILE=$VOLUME_FILE
# find the loop where the volume is mounted, extract the first word then the last character
LOOP=\`sudo losetup -l | grep \$VOLUME_FILE | awk '{print \$1}' | grep -o '.$'\`
udisksctl unmount -b /dev/mapper/myMapper\$LOOP
sudo cryptsetup luksClose myMapper\$LOOP
sudo losetup -d /dev/loop\$LOOP
EOF!
chmod +x volume_close.sh

```


## Using Existing Volumes

VOLUME_FILE1="/mount/path/vol1"
VOLUME_FILE2="/mount/path/vol2"
BIN_FOLDER=.bin

```
DEFAULT_TERM_EMU=`readlink /etc/alternatives/x-terminal-emulator`
mkdir "~/${BIN_FOLDER}"
cat <<-EOF! > ~/$BIN_FOLDER/volumes_open.sh
#!/bin/bash
losetup /dev/loop0 "${VOLUME_FILE1}"
losetup /dev/loop1 "${VOLUME_FILE2}"
EOF!
cat <<-EOF! > "~/${BIN_FOLDER}/volumes_close.sh"
#!/bin/bash
losetup -d /dev/loop0
losetup -d /dev/loop1
EOF!
chmod +x "~/${BIN_FOLDER}/volumes_open.sh"
chmod +x "~/${BIN_FOLDER}/volumes_close.sh"
cat <<-EOF! > ~/Desktop/Volumes_Open.desktop
[Desktop Entry]
Encoding=UTF-8
Type=Application
Name=Open Volumes
Icon=gcr-key
Exec=$DEFAULT_TERM_EMU -e "${HOME}/${BIN_FOLDER}/volumes_open.sh"
Terminal=false
EOF!
cat <<-EOF! > ~/Desktop/Volumes_Close.desktop
[Desktop Entry]
Encoding=UTF-8
Type=Application
Name=Close Volumes
Icon=gcr-key
Exec=$DEFAULT_TERM_EMU -e "${HOME}/${BIN_FOLDER}/volumes_close.sh"
Terminal=false
EOF!
```

### Privilege

```
# Add users to following groups to avoid privileged authentication for:
# * fuse - "Authentication is required to unlock the encrypted device"
# * disk - sudo (execute as root on) losetup
USER_NAME=yourusername
sudo adduser $USER_NAME disk
sudo adduser $USER_NAME fuse
groups $USER_NAME
# alternatives to adding to "disk" include:
# 1 adding udev rule to allow losetup without sudo
# 2 automount via fstab - http://forum.osdev.org/viewtopic.php?f=13&t=24712
# 3 using pmount - http://pmount.alioth.debian.org/
# to understand risks, pros, cons of various approaches...
# see [https://github.com/artmg/lubuild/blob/master/help/configure/Desktop.md#policy-kit]


#### legacy polkit method

sudo tee /etc/polkit-1/localauthority/50-local.d/99-allow-loop-setup.pkla <<EOF!
# Allow all users to open and close loops (e.g. losetup) without authentication
[Set up loops]
Identity=unix-user:*
Action=org.freedesktop.udisks2.loop-setup
ResultInactive=yes
EOF!


#### New polkit method

sudo tee echo /usr/share/polkit-1/rules.d/99-allow-loop-setup.rules <<EOF!
// Allow all users to open and close loops (e.g. losetup) without authentication
polkit.addRule(function(action, subject) {
   if ((action.id == "org.freedesktop.udisks2.loop-setup")) {
      return polkit.Result.YES;
   }
});
EOF!
```

## IN from mediawiki 

### Choices

```
#===Encryption tool choices===
# Use cryptsetup because it has mainstream supported on ubuntu. 
# Cryptsetup is a frontend to the dm-crypt device mapper in the linux kernel
# and allows you to use the LUKS format. 
#
# Cryptoloop was deprecated in linux kernel 2.6.
# truecrypt.org is not preferred windows option, use FreeOFTE instead
```

### Install

```
# Installation
#
sudo apt-get install cryptsetup cryptmount
# credit &gt; http://elwoodicious.com/2007/05/24/encryption-usb-drive-ubuntu-windows-and-you/
#
# cryptmount _SHOULD_ allow volumes to be mounted without admin rights
```

### Access volume

```
sudo losetup /dev/loop0 name.vol
sudo cryptsetup luksOpen /dev/loop0 mappedLuksVol
# The extra loop below was used to perform a manual mount
# but you can just mount the volume by cliking on it in file manager
#sudo losetup /dev/loop1 /dev/mapper/mappedLuksVol
#sudo mkdir ./insideLuks
#sudo mount /dev/loop1 ./insideLuks
#unmount volume first before cleaning up with...
sudo cryptsetup luksClose mappedLuksVol
sudo losetup -d /dev/loop0
# if you want to update the timestamp you will also need to...
touch name.vol
```

#### Alternatives

```
http://www.saout.de/tikiwiki/tiki-index.php?page=luksopen
CryptoMaster (GUI - but undeveloped since 2006)
pam_mount
```

### Create volume ===

```
# credit &gt; freeOTFE docs http://www.freeotfe.org/docs/Main/Linux_examples__LUKS.htm#level_3_heading_6
PASSWORD=BlahBlah1234
VOLUME_FILE=linux.vol 
# SIZE_5MB=10
# dd if=/dev/zero of=$VOLUME_FILE bs=1M count=$SIZE_MB
SIZE_5MB_BLOCKS=2
dd if=/dev/zero of=$VOLUME_FILE bs=5M count=$SIZE_5MB_BLOCKS
# loops are used despite cryptoloop deprecation because ... &gt; http://www.freeotfe.org/docs/Main/Linux_volumes.htm#level_3_heading_5
sudo losetup /dev/loop0 $VOLUME_FILE
echo $PASSWORD | sudo cryptsetup -c aes-xts-plain -s 512 luksFormat /dev/loop0
sudo cryptsetup luksDump /dev/loop0 
echo $PASSWORD | sudo cryptsetup luksOpen /dev/loop0 myMapper
sudo dmsetup ls
sudo dmsetup table
sudo dmsetup status
sudo cryptsetup status myMapper
sudo losetup /dev/loop1 /dev/mapper/myMapper
# consider luksformat to create &gt; http://manpages.ubuntu.com/manpages/lucid/man8/luksformat.8.html
# or see cryptsetup LUKS FAQ &gt; http://code.google.com/p/cryptsetup/wiki/FrequentlyAskedQuestions
sudo mkdosfs /dev/loop1
# alternative filesystem format...
# sudo mkntfs /dev/loop1 -L labelstring -C
sudo mkdir ./test_mountpoint
sudo mount /dev/loop1 ./test_mountpoint
sudo cp 'set up Ubuntu.encr.txt' ./test_mountpoint
cp ./test_files/SHORT_TEXT.txt ./test_mountpoint
cp ./test_files/BINARY_ZEROS.dat ./test_mountpoint
cp ./test_files/BINARY_ABC_RPTD.dat ./test_mountpoint
cp ./test_files/BINARY_00_FF_RPTD.dat ./test_mountpoint
sudo umount ./test_mountpoint
sudo losetup -d /dev/loop1
sudo cryptsetup luksClose myMapper
sudo losetup -d /dev/loop0
sudo rm -rf ./test_mountpoint
```

##### IN ===

```
# cryptmount for LUKS encryption &gt; http://manpages.ubuntu.com/manpages/lucid/en/man8/cryptmount.8.html#toptoc7
# some example usage (mostly for full volume encryption) &gt; https://help.ubuntu.com/community/EncryptedFilesystemHowto3
# or https://help.ubuntu.com/community/EncryptedFilesystemHowto
# using pmount to mount and umount (but not create) volumes without privileges &gt; 
# pmount supports opening and closing of LUKS logical devices from userspace
# pmount - http://pmount.alioth.debian.org/
# alternatively use cryptmount-setup &gt; http://www.enterprisenetworkingplanet.com/netsecur/article.php/3742191/Create-Encrypted-Volumes-With-Cryptmount-and-Linux.htm
# but this creates a separate key file
# automount LUKS encrypted volumes in KDE - http://krypt.berlios.de/
```

