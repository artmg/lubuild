#!/bin/bash

### UPDATES ################

# Prepare for repository installs
sudo apt-get update

# update existing applications with no user interaction...
sudo apt-get upgrade -y


### OPTIONAL UPDATES only if you want ...

# load any kernel updates
sudo apt-get dist-upgrade -y

# ensure that grub is properly updated in case of issues
# and if you want to change timeout then first edit /etc/default/grub
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

