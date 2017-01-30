# VirtualBox

## Guest Additions

You'll need these for proper sizing of the screen between the host and the guest

* start your VM
* install the Lubuntu OS
* reboot into newly installed Lubuntu OS
* mount the Guest Additions ISO


```
# these are the dependencies to compile the additional drivers
sudo apt-get install dkms

# now run from the ISO folder mounted 
cd ????????
sudo sh ./VBoxLinuxXxxx.run

# for the additions to work you need a reboot
sudo reboot
```

