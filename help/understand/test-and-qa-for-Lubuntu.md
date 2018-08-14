
see also:

* [https://github.com/artmg/lubuild/blob/master/help/configure/write-Distro-to-flash.md]
    * prepare your install media
* [https://github.com/artmg/lubuild/blob/master/help/diagnose/operating-system.md]
    * check your OS and update to mainline kernel if required

### Joining the community ###

https://wiki.ubuntu.com/Lubuntu/Testing

Steps to join lubuntu team generally - https://wiki.ubuntu.com/Lubuntu/GettingInvolved#Lubuntu_Official_Members
 * set up launchpad account
 * openPGP key?

* join QA team? - https://launchpad.net/~lubuntu-qa
* Add Hardware into Tracker - https://wiki.ubuntu.com/QATeam/Hardware

* After some contribs add yourself to
 - https://wiki.ubuntu.com/Lubuntu/Get%20Involved/WhoWeAre#Official_Members_of_Lubuntu

## Prepare for tests ##

### get your image and write to USB ###
```
# Install mkusb (if not already)
sudo add-apt-repository -y ppa:mkusb/ppa
sudo apt-get update
sudo apt-get install -y mkusb

sudo apt-get install zsync

# open builds page
x-www-browser http://iso.qa.ubuntu.com/qatracker/testcases
#
# or skip straight to a release
# x-www-browser http://cdimage.ubuntu.com/lubuntu/releases

# Get your folder and filename from the browser and put it here...

IMAGE_FILENAME=vivid-desktop-amd64.iso    # alpha 2
RELEASE_FOLDER=releases/vivid/alpha-2                   # alpha 2

#IMAGE_FILENAME=utopic-desktop-amd64.iso   # Daily
#RELEASE_FOLDER=daily-live/20140913        # Daily

##### Put your image folder name here #####
cd /media/Windows/Temp.Oversize/Installs

# update to the latest version ...
zsync http://cdimage.ubuntu.com/lubuntu/$RELEASE_FOLDER/$IMAGE_FILENAME.zsync
# help - https://help.ubuntu.com/community/ZsyncCdImage

# ...and write to USB
sudo -H mkusb $IMAGE_FILENAME
# help - https://help.ubuntu.com/community/mkusb


# OLD
#
#sudo usb-creator-gtk
#https://help.ubuntu.com/community/UbuntuServerFlashDriveInstaller
```


## procedures

### execute Test cases

execute test cases in ISO tacker - http://iso.qa.ubuntu.com/
e.g. http://iso.qa.ubuntu.com/qatracker/testcases/1302/info



### reporting bugs ###

report using 
 ubuntu-bug package_name

if you don't know which package

 dpkg -S `which executableName`


#### Attaching diagnostics ####

for uploading multiple files in one go is there not something like ?? 

 ubuntu-bug -c file -u 1372116

which works with MULTIPLE files ??



## about Crash Reports ##

Apport software reporting tool gathers and send diagnostics...

 # To remove old crash reports
 sudo rm /var/crash/*

This describes the auto bug reporting PRE-RELEASE
 http://askubuntu.com/questions/140379/how-can-i-track-a-bug-that-caused-a-crash-and-was-reported-via-apport-whoopsie
 
How can I ensure they contain no potentially sensitive data
- like plaintext passwords
According to this you have to "trust" that the triage process removes them
 - https://bugs.launchpad.net/ubuntu/+source/whoopsie/+bug/1255165



### issues with kernel ###

uname -r # display current kernel version

#### are you up to date? ####

sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y   # optionally update kernel and other held-back packages

#### Test using Mainline Kernel ####

see [https://github.com/artmg/lubuild/tree/master/help/diagnose/operating-system.md#latest-mainline-kernel]


### Bugs with X.org ###

https://wiki.ubuntu.com/X/Debugging
see also Triaging sub-page for suggestions on improving bug reports
http://fedoraproject.org/wiki/How_to_debug_Xorg_problems

If X freezes, you may not get a bug report, so you must connect remotely with SSH
https://wiki.ubuntu.com/X/Troubleshooting/Freeze
 
