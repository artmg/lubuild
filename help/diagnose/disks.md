
This is diagnosis and Troubleshooting on disks

see also:

* configure Disks - install, partitioning, etc
	* [https://github.com/artmg/lubuild/blob/master/help/configure/Disks-and-layout.md]
	* [https://github.com/artmg/lubuild/blob/master/help/configure/disks.md]
* understand Layout 
	* reasoning sections separate from precise commands to manipulate
	* specific examples like OpenElec
	* will go out to [https://github.com/artmg/lubuild/blob/master/help/understand/disk-layout.md]


# Diagnose Disks

## Diagnostics and Troubleshooting


For issues low-level issues see [Hardware Troubleshooting](https://github.com/artmg/lubuild/blob/master/help/diagnose/hardware.md) 

If you are having trouble with an installed system, 
see **boot-repair** for a powerful GUI designed to get it working again

The rest of this section introduces useful commands for understanding 
disks and other storage devices.

### GUI

The '''gnome-disks''' utility is a handy GUI for most diagnostics


### Discover the attached devices

```
# see which partitions are currently in use and check how full
df
# if you prefer 'human readable' gigs and megs 
df -H

# view details of disk partitioning
sudo fdisk -l

# show all devices whether or not mounted
lsblk

# by disk (partition) Label, show mounted devices
ls -l /dev/disk/by-label/
# and all devices
lsblk -o name,mountpoint,label,size
```

### Simple checks

```
# provided the filesystem is UNMOUNTED, check it
sudo umount /dev/sdbX
sudo fsck -t ext4 /dev/sdbX 

# sudo badblocks /dev/sdbX
```
If you need to do full check on a filesystem that is in use, 
reboot to a Live USB so they are not mounted.

For help on disk and partition diagnostics see 
http://www.howtogeek.com/howto/37659/the-beginners-guide-to-linux-disk-utilities/

### ISOs

```
# If you have an ISO image and want to know if it is bootable...
# display the disk label and whether the Bootable flag is set
file MyImage.ISO
# for much more comprehensive info
isoinfo -d -i MyImage.ISO
# credit [http://askubuntu.com/a/31903]

```
### In from lubuild/wiki/Troubleshooting/

#### Capcity - disk full?

```
# check available space on mounted disks
df -H

# check the first level folders
du --max-depth=1 -ah
# sort it
du --max-depth=1 -a | sort -nr
# human readable sort
du --max-depth=1 -ah | sort -hr | head

### GUI to identify space hogs (esp in home folders) ###
baobab &
```

#### IN from wiki
##### Out to Diagnostics 

```
# Is swap encrypted?
#
sudo blkid | grep swap
#
# e.g. 
# /dev/mapper/cryptswap1: UUID="95f3d64d-6c46-411f-92f7-867e92991fd0" TYPE="swap" 
#
# if it shows standard /dev/sdxN then it's not
#
```

#### Specifics to clean up 

```
### Clean up root ###

## local package cache ##
# display cache size
du -sh /var/cache/apt/archives
# credit - http://www.howtogeek.com/howto/28502/
# purge
sudo apt-get clean


## crash logs ##
# display cache size
du -sh /var/log
# purge
sudo rm -fR /var/log/*


## If you delete large files but they are still in use 
# in process handles the space cannot be freed
# until you flush one of these handles - 
# credit - http://unix.stackexchange.com/a/64737
lsof | grep deleted | grep MyBigFile
# pick one of the pids and check its handles
ls -l /proc/<Pid>/fd
# flush the relevant handle by sending it 'nothing' 
> /proc/<Pid>/fd/<HandleId>


## old kernels ##
# purge
sudo apt-get update         # re-read package repositories
sudo dpkg --configure -a    # complete any installations previously aborted 
sudo apt-get -f install     # sort out packages not correctly installed due to space issues 
sudo apt-get -y autoremove  # remove any items no longer required, including kernels
sudo apt-get clean          # re-purge cache for any items just downloaded


# re-check available space on mounted disks
df -H

# if you still think you can reclaim more, try bleach bit system cleaner
sudo apt-get install bleachbit
# as well as locations above, it also checks locations for well-known apps (like browser caches)

```

#### SMART tests 

```
gnome-disks
# highlight the drive and check in the Drive Settings menu for SMART Data and Self Tests

# if this is greyed outon External USB devices, you may need a separate utility to send
# the SMART ATA commands via the USB interface
sudo apt-get install -y smartmontools

# check that SMART is available on the device 
sudo smartctl -i /dev/sdX
# you may need the -d sat option if the drive is not in the smartctl database
# for USB device compatibility see http://www.smartmontools.org/wiki/Supported_USB-Devices 

# check the health
sudo smartctl -H /dev/sdX
# if you have issues refer to http://blog.shadypixel.com/monitoring-hard-drive-health-on-linux-with-smartmontools/
```


### Speed and Capacity tests

Capacity tests may be used when you are not sure if you can still rely
on the quoted volume of a storage device (either because it is worn out
or you fear it may be counterfeit).

Before you start to perform speed tests, you should consider how you
will be using the media. Firstly will you be reading more, or writing
more? Will it be sequential (like photos or music) or random (like
general computer use)? If you will format the drive in a particular way,
you should do this before you do your tests, if you want them to be
representative.

#### built in

You can test Speed using the gnome-disk utility (Start Menu /
Preferences / Disks) to Benchmark the drive speed. Choose the partition
(where you must be prepared for data to be overwritten) and Start
Benchmark with 2 cycles of 1000 MiB with write benchmark checked.

One would expect the built-in utility to benchmark in a way which
represents typical utilisation. I'm not sure that actually IS the case.
At the time of writing the Disk utility reportedly does not take into
consideration the partition alignment considered critical to flash drive
performance.

#### dd

dd is a built-in command which very quickly gives you indicative
sequential read or write statistics, and can be used for a capacity
test.

To test capacity check the correct device path and number of MiB (not
MB) in...

`sudo dd if=/dev/zero of=/dev/sdX1/capacity.test bs=1M count=3500 oflag=direct conv=fdatasync`

If you write to FAT32 over 4GB you will need to write multiples of 4GB.
After to display the total size...

```
# Display in MiB
df -BM
# and in MB
df -BMB
```

#### under Wine

The very popular Windows util H2testw is reported to work under Wine.

Not sure if the same goes for Crystal Disk Mark, ChkFlsh or AS SSD. Atto
and IoMeter are others commonly used under Windows.

#### Bonnie++

[Bonnie++](https://en.wikipedia.org/wiki/Bonnie%2B%2B) is a tool which
you may see being recommended by many people, despite its age. For an
intro see
[1](http://www.jamescoyle.net/how-to/599-benchmark-disk-io-with-dd-and-bonnie)

#### fio

FIO seems to be the choice of many pros (and vendors). It is capable of
performing very precisely defined tests. The downside to this power and
flexibility is that I have yet to find (or work out for myself) a FIO
configuration file which will simulate typical ubuntu desktop user.
Perhaps I could convert [a sample file for simulating
servers](https://www.linux.com/learn/tutorials/442451-inspecting-disk-io-performance-with-fio/)?

* https://www.binarylane.com.au/support/solutions/articles/1000055889-how-to-benchmark-disk-i-o
* http://www.storagereview.com/fio_flexible_i_o_tester_synthetic_benchmark
* http://www.bluestop.org/fio/HOWTO.txt
* also has GUIs...
    * fio-vizualiszer (PyQt) https://communities.intel.com/community/itpeernetwork/blog/2015/03/27/how-to-benchmark-ssds-with-fio-visualizer
    * gfio (gtk)

#### IOzone

[IOzone](https://en.wikipedia.org/wiki/IOzone) is what the [Ubuntu
Kernel
team](http://illruminations.com/2014/01/17/ubuntu-file-system-benchmarking/)
use for their filesystem benchmarking. You can find examples at
[http://www.thegeekstuff.com/2011/05/iozone-examples/] and some
comparison with fio and bonnie at
[http://www.slashroot.in/linux-file-system-read-write-performance-test]



