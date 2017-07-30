
There are issues with the Kubuntu spin of the `Ubiquity` 
graphical installer interface for Ubuntu, and spins derived from it 
like Lubuntu Next. This is about the error 

* more tech detail on install 
	* [https://bugs.launchpad.net/ubuntu/+source/ubiquity/+bug/1670336]
* has kubuntu been plagued by this for years?
	* [https://bugs.launchpad.net/ubuntu/+source/ubiquity/+bug/1510731]
* lots and lots of history
	* [https://bugs.launchpad.net/ubuntu/+source/ubiquity/+bug/1066480]
* the bug I opened a bug to link to an ISO tracker report for artful alpha 1 Lubuntu Next
	* [https://bugs.launchpad.net/ubuntu/+source/ubiquity/+bug/1705845]

Some people suggest usung Ubuntu Server ISO to complete setup 
then install the desktop metapackage (lxqt, tho they say kubuntu)

However, if you want to test the contents of a specific ISO image 
you might prefer to simply work around the encyption issue in the installer:

* Do the encyption manually before (and after) ubiquity install
	* simplest [https://askubuntu.com/a/623842]
		* but misses the chroot initramfs (only mentioned in comments)
	* simple version for Mac dualboot [https://blog.jayway.com/2015/11/22/ubuntu-full-disk-encrypted-macosx/]
	* next best [https://askubuntu.com/a/293029]
	* more technical [https://nwrickert2.wordpress.com/2016/04/25/installing-kubuntu-16-04-in-an-existing-encrypted-lvm/]


```
PARTITION_TO_ENCRYPT=/dev/sdXN
```
[https://github.com/artmg/lubuild/blob/master/help/configure/Disks-and-layout.md#overwrite-entire-partition-before-encyption]
