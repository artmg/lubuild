
## references

* For other recipes, please see also:
    * sharing printers - [https://github.com/artmg/MuGammaPi/wiki/Print-server]
    * sharing optical drives - WIP see below
* please see also [https://github.com/artmg/lubuild/blob/master/help/configure/Networked-Services.md]
    * For samba clients
    * For other Networked Services


## Introduction

Samba is an SMB server. It runs a daemon listening at port 445 that uses Server Message Blocks to share files and printers across a network. It has also been known as CIFS, the Common Internet File System. Because it is the default way for Windows to share files, it is commonly used as a cross-platform solution from Linux servers (rather than just using the NFS Network File System that only Unix understands). See more info at [https://en.wikipedia.org/wiki/Server_Message_Block]

This Samba config file also turns on WINS, the Windows Internet Naming Service, so that computer names are broadcast and can be used instead of IP addresses

(_copied from [https://github.com/artmg/MuGammaPi/wiki/Shared-files]_)

### how to configure

* install
* create master conf
* testparm to copy to main conf

### advertising shares with Avahi

for basics on avahi please see ...



### SAMBA ### 
```
sudo apt-get install -y samba

# back up original
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.original
# save as master
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.master
# edit master file
sudo gnome-text-editor /etc/samba/smb.conf.master


### Sample shares ####
# unauthenticated access to a share
cat <<EOF | sudo tee /etc/samba/smb.conf.master 
EOF

# help - https://www.samba.org/samba/docs/man/manpages/smb.conf.5.html

# test the master file and create real conf file
testparm -s /etc/samba/smb.conf.master && testparm -s /etc/samba/smb.conf.master | sudo tee /etc/samba/smb.conf
# credit - http://ubuntuforums.org/showthread.php?t=1462926
# NB only valid option lines that differ from the default will appear in the testparm output

### Restart services with new config ###
sudo /etc/init.d/samba restart
## OR alternatively
# sudo smbd reload
# sudo service smbd restart
```


## Optical Drives

These are more complex because the drive will normally automount the media 
ONLY once a disc is inserted.

NB: the two alternative attempts so far (root or regular user context) 
below are still Work In Progess :( 

```
### User mount
# the samba guest will NOT be able to browse a device at /dev/xxx
# it must be mounted into a file area that is accessible
# this can be done at startup

# NB Audio CDs CANNOT be mounted - see https://linuxconfig.org/how-to-mount-cdrom-in-linux

# check BluRay player device
blkid
# check 'regular' username
cat /etc/passwd|grep 100

DRIVE_DEVICE=/dev/sr0

DRIVE_USERNAME=username
DRIVE_UID=1001
DRIVE_PATH=/media/$DRIVE_USERNAME/DRIVE_DEVICE

SERVER_DESCR=Server with optical drive shared out

DRIVE_USERNAME=root
DRIVE_UID=1000
DRIVE_PATH=/Optical_Drive

sudo mkdir $DRIVE_PATH
sudo chown $DRIVE_USERNAME $DRIVE_PATH
sudo chgrp $DRIVE_USERNAME $DRIVE_PATH

echo $DRIVE_DEVICE  $DRIVE_PATH  auto defaults,noauto,ro,user   0  0 \
 | sudo tee -a /etc/fstab
#echo $DRIVE_DEVICE  $DRIVE_PATH  auto ro,uid=$DRIVE_UID,gid=$DRIVE_UID \
# | sudo tee -a /etc/fstab

sudo mount -a

#### eject
# NB if you want to eject the media from software you will need to 
sudo eject $DRIVE_DEVICE
# as the first step of ejecting is to umount the device which requires sudo
# add the eject -v option to see the steps

# NB: if you eject using the hardware button the software will automatically umount the device
# therefore we should check the behaviour of the share when substituting one disc for another!

# be aware that smb.conf has the options preexec and postexec which may assist with on the fly mount and umount
# https://www.samba.org/samba/docs/man/manpages/smb.conf.5.html#idp61441536



### Samba config
# credit [Lubuild/Networked Services.mediawiki] 

# create the base samba config
cat <<EOF | sudo tee /etc/samba/smb.conf.master 
[global]
   wins support = yes
   server string = $SERVER_DESCR
   #log level = 0
   #syslog = 0

   security = share
   guest account = $DRIVE_USERNAME
   map to guest = Bad User

   ###map untrusted to domain = yes
   #load printers = no
   #domain master = no
   #local master = no
   #preferred master = no

[Optical_Drive]
   path = $DRIVE_PATH
   comment = Read Only access to the DVD / Blue Ray drive over the network
   guest ok = yes
   read only = yes
#   root preexec = /bin/mount $DRIVE_DEVICE  $DRIVE_PATH
   preexec = /bin/mount $DRIVE_PATH
   postexec = /bin/umount $DRIVE_PATH

EOF
# help on guest and bad user - http://ubuntuforums.org/showthread.php?t=1962617&p=12291761#post12291761

# tweak samba config manually
sudo vi /etc/samba/smb.conf.master

# test the master file, create real conf file and restart
testparm -s /etc/samba/smb.conf.master && testparm -s /etc/samba/smb.conf.master | sudo tee /etc/samba/smb.conf && sudo /etc/init.d/samba restart
# NB only valid option lines that differ from the default will appear in the testparm output

# help - https://www.samba.org/samba/docs/man/manpages/smb.conf.5.html

# TO FIND - diagnostic instructions, how to use and interpret samba logs

## access samba from command line
# mount.smbfs (smbmount) is deprecated - use cifs option instead
sudo mkdir /media/$USER/disc
sudo mount -t cifs //$SERVER_HOSTNAME/Optical_Drive /media/$USER/disc
sudo umount /media/$USER/disc



### Root mount
# mounting in the user context did not seem to work so lets do it all as root

# check BluRay player device
blkid
# check 'regular' username
cat /etc/passwd|grep 100

DRIVE_DEVICE=/dev/sr0
DRIVE_USERNAME=username
DRIVE_UID=1001

sudo mkdir /media/$DRIVE_USERNAME/DRIVE_DEVICE
sudo chown $DRIVE_USERNAME /media/$DRIVE_USERNAME/DRIVE_DEVICE
sudo chgrp $DRIVE_USERNAME /media/$DRIVE_USERNAME/DRIVE_DEVICE

echo $DRIVE_DEVICE  /media/$DRIVE_USERNAME/DRIVE_DEVICE auto ro,uid=$DRIVE_UID,gid=$DRIVE_UID \
 | sudo tee -a /etc/fstab

sudo mount -a

#### eject
# NB if you want to eject the media from software you will need to 
sudo eject $DRIVE_DEVICE
# as the first step of ejecting is to umount the device which requires sudo
# add the eject -v option to see the steps

# NB: if you eject using the hardware button the software will automatically umount the device
# therefore we should check the behaviour of the share when substituting one disc for another!

# be aware that smb.conf has the options preexec and postexec which may assist with on the fly mount and umount
# https://www.samba.org/samba/docs/man/manpages/smb.conf.5.html#idp61441536



### Samba config
# credit [Lubuild/Networked Services.mediawiki] 

# create the base samba config
cat <<EOF | sudo tee /etc/samba/smb.conf.master 
[global]
   wins support = yes
   server string = $SERVER_DESCR
   #log level = 0
   #syslog = 0

   security = share
   guest account = $DRIVE_USERNAME
   map to guest = Bad User

   ###map untrusted to domain = yes
   #load printers = no
   #domain master = no
   #local master = no
   #preferred master = no

[DRIVE_DEVICE]
   path = /media/$DRIVE_USERNAME/DRIVE_DEVICE
   comment = Read Only access to the DVD / Blue Ray drive over the network
   guest ok = yes
   read only = yes
#   root preexec = /bin/mount /cdrom
#   postexec = /bin/umount /cdrom

EOF
# help on guest and bad user - http://ubuntuforums.org/showthread.php?t=1962617&p=12291761#post12291761

# tweak samba config manually
sudo vi /etc/samba/smb.conf.master

# test the master file, create real conf file and restart
testparm -s /etc/samba/smb.conf.master && testparm -s /etc/samba/smb.conf.master | sudo tee /etc/samba/smb.conf && sudo /etc/init.d/samba restart
# NB only valid option lines that differ from the default will appear in the testparm output

# help - https://www.samba.org/samba/docs/man/manpages/smb.conf.5.html

# TO FIND - diagnostic instructions, how to use and interpret samba logs

## access samba from command line
# mount.smbfs (smbmount) is deprecated - use cifs option instead
sudo mkdir /media/$USER/disc
sudo mount -t cifs //$SERVER_HOSTNAME/DRIVE_DEVICE /media/$USER/disc
sudo umount /media/$USER/disc
```

