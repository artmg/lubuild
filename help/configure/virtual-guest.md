
see also:

* using qemu to run VM guests on Linux host, and including use of graphics cards
    * 
* 

Containers, such as Docker or Kubernetes or Linux LXC, provide a way to execute different software in a compartmentalised way. However Virtual Guests offer a much cleaner division between the virtualised system inside the guest, running with its own disk and memory, and the host system it is running on. 

Virtual Guests can be started from blank operating system installation, just like a regular computer PC or server. Alternatively you can get ready-build guest images, with an OS and all the layers of software needed to run a particular application, such as LAMP or XAMPP or Wordpress. These can be trial systems, like the Windows below, or fully fledged turnkey computer appliances, like in the **Bitnami** range. Even though now owned by VWware, Bitnami appliances can run directly as virtual guests on Oracle's open-source VirtualBox.

For more specifics see [using Virtual Bitnami Guests](../use/virtual-bitnami-guests.md)

# VirtualBox

## Windows Guest

Microsoft downloads to get you going include:

* 5GB ISO installer https://www.microsoft.com/en-gb/software-download/windows10ISO
* 20GB developer VM ready to start https://developer.microsoft.com/en-us/windows/downloads/virtual-machines/

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

### With GUI (e.g. Ubuntu)

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

### Command line (e.g. Ubuntu Server)

Note that VirtualBox Clipboard may not work anyhow if your 
Ubuntu Server only uses the Wayland compositor.

```
# the device may be sr0 but cdrom should redirect there
sudo mount /dev/cdrom /mnt
cd /mnt

# check the contents
ls

# install dependencies
sudo apt install -y dkms build-essential linux-headers-generic linux-headers-$(uname -r)
sudo apt install -y module-assistant libxt6 libxmu6
# apparently no longer needed
# sudo apt install -y virtualbox-guest-dkms gcc make

# if you are reinstalling, remove old version first
# sudo sh ./VBoxLinuxAdditions.run uninstall

# get ready for kernel rebuild
sudo m-a prepare

# now install the additions
sudo sh ./VBoxLinuxAdditions.run

# check the status
sudo systemctl -all | grep box

```

Reboot once complete

If time slips, then 

```
sudo VBoxService --enable-timesync
```

## Shared Folder

If you choose Automount when you add your shared folder 
into the VirtualBox settings for your VM, 
it will automatically mount it as follows

```
MyFolder /media/sf_MyFolder vboxsf rw,nodev,relatime,iocharset=utf8,uid=0,gid=998,dmode=0770,fmode=0770,tag=VBoxAutomounter 0 0
```

```
# to access such folders from your regular user context...
sudo usermod -aG vboxsf $USER
```

That will require a restart

```
# create a Desktop icon for the shared drive like the standard home and network icons
cat > $HOME/Desktop/vm-shared.desktop <<EOF!
[Desktop Entry]
Type=Application
Exec=pcmanfm-qt /media/sf_VmShared
Icon=media-floppy
Name=VmShared
EOF!
chmod +x $HOME/Desktop/vm-shared.desktop
gio set $HOME/Desktop/vm-shared.desktop "metadata::trusted" true
```


### OLD shared folder

Previously the instructions to mount it were...

```
# acess the shared drive from the guest os 
sudo echo

# Machine Folders name from vBox Settings / Shared Folders
MACHINE_FOLDER=MyFolder


sudo usermod -aG vboxsf $USER
sudo mkdir -p /mnt/vboxshare
sudo mount -t vboxsf $MACHINE_FOLDER /mnt/vboxshare
cd /mnt/vboxshare
```


## USB Device Passthru

This should be quite straightforward, using the Devices Menu to choose the USB device you want
If you have errors, check that the VM / Settings / Ports page uses the appropriate level of
USB support (e.g. USB3)


## VirtualBox Networking

By default each VirtualBox guest VM you create is assigned 
a single Network Adapter in NAT mode. 
This is ideal is you just want a basic client machine 
that can connect to your network and the internet. 
It comes emulating an Intel PRO/1000 MT Desktop card 
which gives the highest compatibility.

### Types of Network to be Attached To

* NAT - the default, this allows you to make outbound connections
* Bridged - the simplest way to have full connectivity
	* but do you want your guests appearing on your network for everyone to see?
* Host Only - this allows the PC running virtual box to connect to the VM easily

A common scenario is to leave the default NAT on the first adapter, 
and enable Adapter 2 making it Host Only. If you didn't want to use 
Guest Additions, for instance a remote-only server, then you might put Host Only first then NAT - see below for how to get this working. 

For more information on the different Virtual Network Types
that you can attach adapters to, see 
https://www.nakivo.com/blog/virtualbox-network-setting-guide/

### Adaptor emulation

For modern linux systems, most of the Adapter Types 
should be automatically recognised by the kernel. 
You get slightly better performance for outbound connections 
using the PCnet-Fast III, or for VM to VM connections with 
the Paravirtualised virtio drivers.

### Additional adapters without guest additions

If you install the guest additions, there is a feature that 
will automatically recognise additional virtual 'hardware' 
presented to the guest, and configure the os network accordingly.

Without VirtualBox Guest Additions only the first adapter is automatically brought up
and any additional adapters show STATE DOWN

```
# show the states of all interfaces (including OS loopback)
ip link show

# list the virtual hardware devices presented to the OS
sudo lshw -class network -short
```

If you want to manually bring up the second network adapter
on Ubuntu (which uses netplan) try:

```
sudo tee /etc/netplan/90-vm-net2.yaml <<EOF!
network:
    version: 2
    ethernets:
        enp0s8:
            dhcp4: true
EOF!
sudo netplan apply
```

## Increasing disk volume

Normally VirtualBox uses disk efficiently. 
If you say 'create an 80 GB disk', and only put 15 GB data on it, 
the VDI file will not use more than 15 GB on your host, 
and with compression it will likely use less.

If you don't allocate a large-enough volume at the outset, 
you can increase the size

* VirtualBox
	* Power off the VM
	* VirtualBox / Tools / Media - Virtual Media Manager
	* look for the main vdi file and increase the size
* Ubuntu Server
	* on older versions, without LVM, you can just 
		* lsblk
		* sudo resize2fs /dev/sdnX
	* with LVM it is more complicated
		* sudo cfdisk
			* check that the new size is showing
			* see how to rescan https://packetpushers.net/ubuntu-extend-your-default-lvm-space/
			* what if it's still not showing??
		* see https://allinoneadmin.eu/2022/03/24/ubuntu-20-04-vm-increase-disk-size/ for examples of `growpart`
