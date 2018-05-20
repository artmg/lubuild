
see also:

* using qemu to run VM guests on Linux host, and including use of graphics cards
    * 
* 

# VirtualBox

## Windows Guest

For step-by-step instructions to create a Windows Virtual Machine on your PC under Ubuntu using virtualbox see [https://itsfoss.com/install-windows-10-virtualbox-linux/] 

NB: you can just install **virtualbox** with no version specifier


## Ubuntu Guest Additions

If you are using an Ubuntu VM on a Windows PC, 
you'll need these for proper sizing of the screen between the host and the guest

* start your VM
* install the Lubuntu OS
* restart into the newly installed Lubuntu OS
* VirtualBox Menu / Devices / Mount the Guest Additions ISO (Menu / Device menu)
* 

```
# these are the dependencies to compile the additional drivers
sudo apt-get install dkms

# now run from the ISO folder mounted 
cd ????????
sudo sh ./VBoxLinuxXxxx.run

# for the additions to work you need a reboot
sudo reboot
```

If you have issues (e.g. Clipboard) then it is possible that your Linux OS came with forked Guest Additions, which might need to be removed before the official Guest Additions will correctly install.

```
dpkg -l | grep box
sudo apt-get purge virtualbox-guest-utils
```

Then reinstall the tools as above

## Shared Folder

```
# acess the shared drive from the guest os 
sudo echo
sudo usermod -aG vboxsf $USER
sudo mkdir -p /mnt/vboxshare
# penulimate parameter is 'Machine Folders' name from vBox Settings / Shared Folders
sudo mount -t vboxsf folder_name /mnt/vboxshare
cd /mnt/vboxshare
```

```
# if you get Permission errors when you have created 
# a Shared Folder into an Ubuntu guest...
sudo usermod -aG vboxsf $USER
```

## USB Device Passthru

This should be quite straightforward, using the Devices Menu to choose the USB device you want
If you have errors, check that the VM / Settings / Ports page uses the appropriate level of
USB support (e.g. USB3)


