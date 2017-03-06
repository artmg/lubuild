
# VirtualBox

## Windows Guest

For step-by-step instructions to create a Windows Virtual Machine on your PC under Ubuntu using virtualbox see [https://itsfoss.com/install-windows-10-virtualbox-linux/] 

NB: you can just install **virtualbox** with no version specifier


## Ubuntu Guest Additions

If you are using an Ubuntu VM on a Windows PC, 
you'll need these for proper sizing of the screen between the host and the guest

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

