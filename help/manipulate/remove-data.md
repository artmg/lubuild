

## erase full partition / filesystem or device

Deleting files merely makes the data hard to find and liable to be overwritten. 
If you are concerned about wiping your data to avoid casual recovery using only software tools, 
the most important task is to ensure that ALL data is physically, actually overwritten. 

See also:

* why you need to overwrite [https://github.com/artmg/lubuild/blob/master/help/diagnose/disk-recovery-and-forensics.md]
* how proper total wiping is hard on flash [https://github.com/artmg/lubuild/blob/master/help/manipulate/flash-drives-and-SSDs.md]
	* if you want to erase SSDs see the later section 


### simple overwrites with dd
```
# depending on the device and your system you may need to sudo some commands
# all the commands below need sdXY changing to your real device
# ENSURE you are really overwritting data you no longer want - wrong choices will cause you pain

# select the device from which you want to totally wipe the filesystem  (but leave dev node intact)
MY_DRIVE=/dev/sdXY
# Make totally SURE this is the right device FIRST
mount -l | grep $MY_DRIVE
df | grep $MY_DRIVE

# speedy overwrite with zeros
dd if=/dev/zero of=$MY_DRIVE bs=256K status=progress

# you can check which blocksize gives the quickest throughput
# https://github.com/tdg5/blog/blob/master/_includes/scripts/dd_obs_test.sh


#### random overwrites
# if you plan to use encryption, then it is recommended you fill the space with random data first 
# to reduce the ability for others to understand anything about the size of contents of the encrypted area 

# this traditional method is rather SLOW to overwrite, using quality psuedo-random data stream
dd if=/dev/urandom of=$MY_DRIVE bs=1M status=progress

# This is probably THE quickest way to write a simple pseudo-random stream
# by using openssl to encrypt the zeros 
openssl enc -aes-256-ctr -salt -pbkdf2 -pass pass:"$(dd if=/dev/urandom bs=128 count=1 </dev/null | base64)" </dev/zero | sudo dd of=$MY_DRIVE bs=1M status=progress

# previously used
# head -c 32 /dev/urandom | openssl enc -rc4 -nosalt -in /dev/zero -pass stdin | sudo dd of=$MY_DRIVE bs=1M status=progress
# credit - http://askubuntu.com/a/359547

# use built-in cryptsetup to access the kernel dm-crypt encryption for quick psuedo-random
sudo cryptsetup open --type plain /dev/sdXY container --key-file /dev/random
sudo dd if=/dev/zero of=/dev/mapper/container status=progress
sudo cryptsetup close container 
# credit - https://wiki.archlinux.org/index.php/Dm-crypt/Drive_preparation#dm-crypt_wipe_on_an_empty_disk_or_partition
# if you want a second pass, close then re-open so the random key file changes what will be written
# If you must PAUSE, CTRL-C out and note `n` the number of blocks written, then when you restart specify  seek=n 

# earlier versions of dd did not support status=progress, you had to use another window to...
# watch -n30 'sudo pkill -usr1 dd'
```
### multiple overwrite

The following utilities perform multiple 'pass' wipes, repeatedly overwriting the same areas. 
They are based on theories from Guttmann in the late 1990s that erased data could be recovered 
using magnetic microscope technology. Later [experimnents by Wright in 2008](https://digital-forensics.sans.org/blog/2009/01/15/overwriting-hard-drive-data/) debunked such theories. It has been suggested that the density of magnetic datum points on modern media make such forensic recovery less feasible.

If you are unsure which case to beleive, you might consider either of the following contrasting viewpoints:
* does it cost me much extra time to multi-pass wipe my disk
* what is the chance that someone will want to spend time examining my old disk with expensive equipment

If you want some more of other people's opinions then try [http://security.stackexchange.com/questions/10464]

Remember, as mentioned above, overwriting multiple times will not help if it misses an area containing data. 
Some modern storage technologies like to manage things themselves and make it hard to access all writable areas. 
Perhaps this is why people and organisations who want to take NO risk will physically shred or destroy old devices?

```
#### shred

# * part of GNU Coreutils
# * installed by default under Lubuntu
# * help - [https://www.gnu.org/software/coreutils/manual/html_node/shred-invocation.html]
# these examples leave the default 3 pass overwrite, fine unless you're hyper-paranoid

##### basic example
shred -vu MyFiles*

##### current folder tree
# make sure you CD into the folder first
find . -type f -print0 | xargs -0 shred -fuzv
# credit http://askubuntu.com/a/146003
# however this does not "shred" the folder names in the same way

##### full drive
# select the device from which you want to totally wipe the filesystem  (but leave dev node intact)
MY_DRIVE=/dev/sdX
# Make totally SURE this is the right device FIRST
mount -l | grep $MY_DRIVE
df | grep $MY_DRIVE
# say goodbye to all contents
shred -v $MY_DRIVE

# claims to work as is for floppy drive 

#### wipe

# * in ubuntu repos
# * help - http://manpages.ubuntu.com/manpages/hardy/man1/wipe.1.html

# wipe man pages recommends telling the util how much to overwrite as floppies don't always correctly report their dimensions
wipe -l 1440k /dev/sdX
# wipe can follow symlinks (if you have a psuedo-device like /dev/floppy) with option  -D


#### secure-delete

sudo apt-get install secure-delete
srm -rfll folderPathToRemove
# credit http://askubuntu.com/a/122562
# single pass only

```

## Solid State (flash) drives

According to [NIST guidelines](http://dx.doi.org/10.6028/NIST.SP.800-88r1) the ATA Secure Erase command is an effective sanitisation technique to 'Clear' data (protection against simple non-invasive data recovery techniques).

IMPORTANT NOTES:

* it is suitable for both HDD and SSD drives
* this procedure is ONLY for ATA attached drives
* do NOT use it on drives you attach via USB or SCSI
	* only certain USB to SATA/PATA bridges can pass through these commands
		* e.g. https://hardwarerecs.stackexchange.com/a/7003
	* and if something goes wrong you risk bricking the drive

If you are not 100% sure your connection supports ATA Secure Erase then simply plug the drive into an old computer's ATA/SATA.

The steps are:

* check you disk supports secure erase and is not frozen
* set a security password
* do the erase
* check it completed
* disable security to remove the password 

See instructions at:

* https://ata.wiki.kernel.org/index.php/ATA_Secure_Erase or
* https://grok.lsu.edu/Article.aspx?articleid=16716

