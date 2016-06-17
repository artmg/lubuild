
## adb on linux ##


### install packages ###

# now in official repos
```
sudo apt-get install -y android-tools-adb android-tools-fastboot
```

### prepare your PC for device connection ###
```
# EITHER get a [whole generic list of rules](http://bernaerts.dyndns.org/linux/74-ubuntu/328-ubuntu-trusty-android-adb-fastboot-qtadb)
# or obtain your specific Vendor and Product codes from ID [credit](http://askubuntu.com/a/213907)
lsusb 

DEVICE_VENDOR_ID=04e8
DEVICE_PRODUCT_ID=6860

echo SUBSYSTEM==\"usb\", ATTR{idVendor}==\"$DEVICE_VENDOR_ID\", ATTR{idProduct}==\"$DEVICE_PRODUCT_ID\", MODE=\"0600\", GROUP=\"plugdev\" | sudo tee -a /etc/udev/rules.d/51-android.rules
# sudo chmod a+r /etc/udev/rules.d/51-android.rules

# reload udev for new rules
sudo udevadm control --reload   # was sudo /etc/init.d/udev restart

# test if this is ALWAYS required...
# also add Vendor ID [credit](http://askubuntu.com/a/341696)
mkdir -p ~/.android/
echo 0x$DEVICE_VENDOR_ID | tee -a ~/.android/adb_usb.ini
adb kill-server
adb start-server

# other guidance - http://forum.xda-developers.com/showthread.php?p=11823740#post11823740
```


### test and connect ###
```
# ensure your device has Developer Mode - USB Debugging enabled 
# Tap About - Build Number several times repeatedly until Developer Mode appears

adb devices

adb shell

# inspect device properties

cat /system/build.prop | grep "ro.product.model"
cat /proc/version


### how to read app data ###

# credit http://denniskubes.com/2012/09/25/read-android-data-folder-without-rooting/
# use adb then run-as, e.g.
run-as com.your.package ls -l /data/data/com.your.package
```

### explore and save current flash images ###

_needs root!_

```
# help on basics - http://www.addictivetips.com/mobile/android-partitions-explained-boot-system-recovery-data-cache-misc/
# from the adb shell 

# check volumes
df

# find mounts
mount

# find special devices
ls -al /dev/block/platform/msm_sdcc.1/by-name

# check partition details - http://www.all-things-android.com/content/review-android-partition-layout
blkid 

# save them and drag themn back [credit](http://androidcreations.weebly.com/how-to-get-android-mounts-and-partition-images.html)
cd /sdcard
mkdir -p ADB_Images
cd ADB_Images

dd if=/dev/block/mmcblk0pXX of=XXXXXXX.img
# OR
dd if=/dev/block/platform/msm_sdcc.1/by-name/XXXXXXXX of=XXXXXXX.img


# NOT From ADB shell, but from another terminal...

adb pull /sdcard/ADB_Images/ ~/Desktop/ADB_Images/

# NB: Odin images are compressed to tar - adb flash images are simply .img files



#### Samsung example ####
# efs includes IMEI
# Recovery Mode Firmware (alternate Boot)
# apnhlos = Baseband (modem) firmware
dd if=/dev/block/platform/msm_sdcc.1/by-name/efs      of=efs.img
dd if=/dev/block/platform/msm_sdcc.1/by-name/mdm      of=mdm.img
dd if=/dev/block/platform/msm_sdcc.1/by-name/modemst1 of=modemst1.img
dd if=/dev/block/platform/msm_sdcc.1/by-name/modemst2 of=modemst2.img
dd if=/dev/block/platform/msm_sdcc.1/by-name/recovery of=recovery.img
dd if=/dev/block/platform/msm_sdcc.1/by-name/apnhlos  of=apnhlos.img
dd if=/dev/block/platform/msm_sdcc.1/by-name/system   of=system.img

# taking these just for good measure - not sure they would be needed
dd if=/dev/block/platform/msm_sdcc.1/by-name/boot     of=boot.img
dd if=/dev/block/platform/msm_sdcc.1/by-name/param    of=param.img

# more help ? http://forum.xda-developers.com/showpost.php?p=33358998&postcount=3
```

### other backup ###
```
# credit http://android.stackexchange.com/a/28315

adb backup -f ~/Desktop/AndroidBackup.ab -noapk -system -shared -all


#### ADB-SPLIT #### 
# script for extracting individual app data dirs from ADB Backup files
# help - http://forum.xda-developers.com/showthread.php?t=2011811 

# The split script
wget http://sourceforge.net/projects/adb-split/files/adb-split.sh
# the Android Backup Extractor java object
wget http://sourceforge.net/projects/adbextractor/files/abe.jar
# STar (STandard TAR - Tape Archiver) is no longer in Ubuntu Repos
case $(uname -m) in
 x86_64)
 (wget http://sourceforge.net/projects/adbextractor/files/star-ubuntu-lucid/star_1.5final-2ubuntu2_amd64.deb)
 ;;
 i?86)
 (wget http://sourceforge.net/projects/adbextractor/files/star-ubuntu-lucid/star_1.5final-2ubuntu2_i386.deb)
 ;;
esac
sudo dpkg -i star_*.deb
sudo apt-get -f install -y && sudo rm star_*.deb

sh adb-split.sh MyBackup.ab


# see also 
# http://android.stackexchange.com/questions/96192/how-do-i-restore-my-app-k-9-mail-settings-from-an-adb-backup
#
```


### flash new images ###

```
# you probably need to have the phone rooted to allow SU to work

# adb push img to sdcard
# then dd if=/sdcard/XXX.img of=/dev/block/mmcblk0pXX
# credit http://theunlockr.com/2014/04/15/flash-custom-recovery-samsung-galaxy-s5-t-mobile/

# some recovery modes pick up files waiting for them...
# adb push flash_image /data/local/bin/flash_image
# adb push zImage /sdcard/
# adb shell
# su
# chmod 755 /data/local/bin/flash_image/data/local/bin/flash_image boot /sdcard/zImage
#sync
#exit
#exit
# adb reboot recovery
```

### Recovery mode ###

```
# To enter recovery mode

adb reboot recovery


# To abort Download or Recovery Mode

adb reboot


# to directly load recovery specifying an update package ...

adb shell
cd /sbin
recovery --update_package=/sdcard/whatever.zip

# access android app private files internal storage over adb without rooting:
# http://blog.shvetsov.com/2013/02/access-android-app-data-without-root.html
```

### rooting ###

#### Using CF-Auto-Root ####

This will
* install a customer recovery image
* install SuperSU binary and APK
* return to Stock Recovery image


##### windows #####

Get the zip from http://forum.xda-developers.com/showpost.php?p=39901436&postcount=3

follow the instructions at http://forum.xda-developers.com/showthread.php?t=2219803

Quick and Easy


##### linux #####

# THIS FAILS

```
# Open it to see the .tar.md5
tar xf CF-Au*

# credit - http://schier.co/blog/2013/11/09/how-to-root-nexus-5-in-linux.html
adb devices
# Reboot to bootloader
adb reboot bootloader
# unlock the bootloader
fastboot oem unlock
```
Device reboots into ODIN MODE and fastboot cannot talk to it!




#### simply getting root privilege ####

```
# PARANOID? - remove your SIM and SD cards if you don't trust the 
# people who made the exploit you are about to use

# NB TowelRoot since locked by Samsung Knox update!

# wget the apk from https://towelroot.com/tr.apk
 
# adb push ~/Downloads/tr.apk /data/local/tmp


# Settings - More - Security - unknown sources
# Settings - My Device - Lock Screen - None

# Settings - More - Developer Options - Enable USB debugging
# Settings - More - Developer Options - Stay awake

# (is there enable OEM unlock?) 

# either
# Settings - More - Developer Options - Verify Apps via USB - FALSE
# or tick the do it anyway box when running...

adb install ~/Downloads/tr.apk

#### old ####

# previously Tested on Mediacom 852i 
# supercedes Wallet/Service/Help/Devices/Rooting Mediacom 852i.txt


# first download SuperSU from 
# http://forum.xda-developers.com/showthread.php?t=1538053
# e.g. http://download.chainfire.eu/supersu

unzip UPDATE-SuperSU-v*.zip -d ~/SuperSU-Package

adb shell

mount | grep system

# GT-I9505 example
# /dev/block/platform/msm_sdcc.1/by-name/system /system ext4 ro,seclabel,relatime,data=ordered 0 0

mount -o remount,rw /dev/block/platform/msm_sdcc.1/by-name/system /system

# credit > http://clamel.netai.net/smartpad850i/get_root
# MediaCOm 852i example
# /dev/block/mtdblock8 /system ext3 ro,noatime,nodiratime,barrier=0,data=ordered 0 0

# mount -o remount,rw /dev/block/mtdblock8 /system

# IN *NEW* TERMINAL SHELL

adb push ~/SuperSU-Package/system/app/Superuser.apk /system/app
adb push ~/SuperSU-Package/system/xbin/su /system/bin

# IN ADB SHELL
chmod 6755 /system/bin/su
chmod 6755 /system/app/Superuser.apk

mount -o remount,ro /dev/block/mtdblock8 /system

reboot

# now unplug cable as device reboots

# on device
# go into applications Run SuperSU
# check the results with a Root Checker app from Google Play Store

```
