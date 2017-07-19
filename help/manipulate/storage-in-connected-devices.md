
This article covers File Storage that is contained within portable devices, 
such as Phones and Cameras, and how to access it via a USB connection between the device and the PC


See also:
* [https://github.com/artmg/lubuild/blob/master/help/configure/Disks-and-layout.md]
    * general handling of disk drives
* [https://github.com/artmg/lubuild/blob/master/help/manipulate/flash-drives-and-SSDs.md]
    * how to handle the storage media when removed from the device and inserted directly into the PC


## Background

Many portable devices have stopped using directly mounted filesystems, 
known as USB Mass Storage (UMS) connections, for reasons including:
* a direct mount means locking the filesystem, 
    * thus preventing the device from accessing it at the same time
* the underlying filesystem may have different characterstics that the host does not support
* in the case of CD Audio discs they do not actually have a filesystem at all

## Protocols

Common alternatives to direct UMS mounts are

MTP - Media Transfer Protocol (which is an extended version of...)
PTP - Picture Transfer Protocol 

for a gentle walkthrough see:
* [http://www.linux.org/threads/intro-to-mtp-ptp-and-ums.7711/]
and for more detail see: 
* [https://wiki.archlinux.org/index.php/MTP]
* [https://wiki.archlinux.org/index.php/Digital_Cameras#libgphoto2]

More esoteric solutions could involve different connectivity, 
like using the network (or wifi) instead with apps like AirDroid 
or samba or ftp servers, but for now let's stick to good old USB. 


## In use

MTP and PTP devices are mounted automatically by GVFS (Gnome Virtual File System) 
since ubuntu 13.10, and using file managers like PCManFM they appear automatically
under the **mtp:** protocol, e.g. *mtp://$$usb:001,003$$/Card* 

This is great because it works out of the box

Looking a little deeper you will find they also appear under a local filesystem location:

    /run/user/$UID/gvfs

Under the covers GVFS uses **libmtp** for MTP and **libgphoto2** for PTP


### disadvantages

Because the pseudo-filesystem mount points are created dynamically, 
this makes them harder to:
* share over the network
* access using command line tools
    * they are not really filesystems, so many commands are fooled by the psuedo part

### basic use of these auto-mounts

```
ls $XDG_RUNTIME_DIR/gvfs
# /run/user/<user>/gvfs
# credit - http://askubuntu.com/a/233123

# for a bash script to get this path deterministically, see http://askubuntu.com/a/342549 

# To see the mounts use    
sudo apt-get install **??????**
gvfs-mount --list


# mount the MTP 
gphotofs ~/some-mount-point
# credit http://unix.stackexchange.com/a/215481

```

### fully enabling commandline use of device storage

The GVFS auto-mount functionality is fine for the GUI, 
but you may come unstuck with commandline access to the paths above, 
especially using commands like rsync.

A more robust solution is a Filesystem In UserSpace (FUSE) filesystem. 

The help pages at the top of this section mention a number of candidates, 
but here I am choosing **jmtpfs** as it seems to have good support from Android 4+

```
sudo apt-get install jmtpfs
mkdir -p $HOME/mount/MTP
# mount the first available device
jmtpfs $HOME/mount/MTP

# unmount
fusermount -u $HOME/mount/MTP
```

### but MTP is slow

Many linux users have complained about the poor performance using MTP. 
Some people attribute it to the design of the MTP protocol itself, 
whereas others just say that libmtp is not the best implementation. 

In either case, on Linux you are unlikely to get any substantial 
improvement in speed unless you remove possible bottlenecks, 
usually by avoiding MTP altogether, for example:

* remove the phone
	* if the data is on an SD card, 
		- physically remove it from the phone and plug it in to the PC directly
* remove the USB cable
	* use a network (or wireless) transfer protocol like FTP, samba, etc
		* for more on networked services see 
			- [https://github.com/artmg/lubuild/blob/master/help/configure/Networked-Services.md]
* remove the MTP
	* use ADB (Android Debugging) to transfer data
		* e.g. adbfs / adbfs-rootless
		* relies on debugging being enabled
		* may have some limitations on unrooted phones
		* you may need to play with the way the phone sees the storage
		* can be command-line intensive
		* in other words it removes a lot of the advantages of MTP 
		* for more on ADB see 
			- [https://github.com/artmg/lubuild/blob/master/help/diagnose/adb-Android-Debug-Bridge.md]
* remove the Linux libmtp implementation
	* some people suggest that MTP on Windows works reasonably quickly


## Troubleshooting

### mtp index rebuild

If your device caches or indexes the files presented via MTP, 
you may resolve issues by rebuilding or flushing this

e.g.
* Settings > Applications > Media Storage > Clear Cache / Data 
    * credit - http://android.stackexchange.com/a/59687
* or alternatively:
	* Disconnect USB cable
	* Settings > Apps > Show System Apps > find External Storage and Media Storage
	* Clear data and cache on each one
	* reboot
	* give it 5 min after full boot up to rebuild media databases
	* connect to USB and select MTP
* SDrescan (not 4.4+)
    * if you get issues with folders not appearing
 

