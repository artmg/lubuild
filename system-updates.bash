#!/bin/bash

### UPDATES ################

# if you want to reduce the priority for these running in the background
# set nice value for current process's PID
renice -n 20 $$

# Prepare for repository installs
sudo apt-get update

# update existing applications with no user interaction...
sudo apt-get upgrade -y

## Problems with MergeList?? - purge that cache...
# sudo rm -r /var/lib/apt/lists/*
# sudo apt-get clean && sudo apt-get update


### OPTIONAL UPDATES only if you want ...

# load any kernel updates
sudo apt-get dist-upgrade -y

### remove unwanted
# after all applications are installed and/or upgraded, clean up using...
sudo apt-get autoremove -y


# change grub timeout 
sudo sed --in-place 's/GRUB_TIMEOUT=10/GRUB_TIMEOUT=2/' /etc/default/grub
# credit - http://karelzimmer.nl/data/linux/pdf/install-Lubuntu-14.04-desktop-algemeen.sh.pdf
# ensure that grub is properly updated
sudo update-grub


# Enable automatic updates except on LiveUSBs, where they should stay on demand...
if [[ $LUBUILD_HARDWARE_TYPE_LIVEUSB -neq TRUE ]] ; then (
sudo apt-get install unattended-upgrades
# credit > http://mcarpenter.org/blog/2012/08/12/ubuntu-automatic-package-updates
sudo sh -c "echo unattended-upgrades unattended-upgrades/enable_auto_updates boolean true | debconf-set-selections"
# for solution using a deb set default config file see https://github.com/netsocDIT/serversetup/blob/master/unattended-upgrades.sh
sudo dpkg-reconfigure -plow unattended-upgrades
# help > https://help.ubuntu.com/community/AutomaticSecurityUpdates
)

# reboot to use any new kernel version installed
sudo reboot

