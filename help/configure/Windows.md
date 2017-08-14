
## Intro

Even if you mainly use free operating systems, you might use Windows ...

* On dual boot if you have an OEM license and you had Windows preinstalled on your PC
* In a virtual machine if you have a retail license you purchased

This article includes some tips for the basics of administrating 
your Windows instance for such cases.

see also:

* how to decide on options for partitioning multi-boot systems
	* [https://github.com/artmg/lubuild/blob/master/help/understand/disk-layout.md] 
* specific commands for setting up your chosen layout under ubuntu 
	* [https://github.com/artmg/lubuild/blob/master/help/configure/disks.md]
* ubuntu diagnosis and troubleshooting commands 
	* [https://github.com/artmg/lubuild/blob/master/help/diagnose/disks.md]


## Windows 10 useful tips

### Power Users' menu

Use the Windows key as modifier with letter X ... **Win-X**

e.g. Elevated Command prompt...  Win-X then A

This is also available in Windows 8


### Windows 10 Prevent allow updates to download

To reduce the chance of updates 
downloading automatically and causing issues
You can change the following setting. 
Undo the change to allow updates once again:

* Settings / Network and Internet / Advanced options
* METERED CONNECTION = ON


### Create a local account

* Click Start, Settings, Family & other users, Add someone else to this PC
    * Note that you can’t “Add a family member” with a local account. Presumably that is tied in to parental controls.)
* In the box marked “How will this person sign in?” 
    * down at the bottom, click “The person I want to add doesn’t have an email address.”
* In the “Let’s create your account” dialog, at the bottom, 
    * click “Add a user without a Microsoft account.”
* enter user name, password and password hint.
    * Click Next 


## Windows Update

### Troubleshooting

Including the Windows 10 Upgrade process

* Check the file
    * %windir%\WindowsUpdate.log


#### common error codes

* http://windows.microsoft.com/en-gb/windows-10/upgrade-install-errors-windows-10


#### clear the update cache

For fuller instructions see https://support.microsoft.com/en-gb/kb/971058

#### download large updates directly

Search the Microsoft Update Catalog for the KBnumber that failed, 
download it manually and launch it (starts the WU Standalone updater)

### Fast-forward updates on new Windows 7 install

If you have old Windows 7 install media, it would take a long time to
go through all the sets of Windows Updates, and might not succeed. 
These steps will get you as far forward as you can, quickly and easily. 

* Use windows update to get to SP1, two or three reboots
* When updater gets stuck, disable updates and shutdown
* Ensure Windows Update Service (wuauserv) is Stopped / Manual
* Obtain KB3020369 & KB3125574 & KB3172605 & sdelete and place on ISO with Brasero
    * KB 3185278 is Sept 2016 Rollup - not using for now
* After installing each Stop the service again
    * credit http://www.sevenforums.com/windows-updates-activation/400285-new-install-windows-7-checking-updates-doesnt-finish-post3279171.html#post3279171
* Recheck for latest updates, install, reboot - continue until Up To Date
* Clean up restore points, update & SP caches (System / Protection & Disk cleanup)
* sdelete -z to zero unused space ready for shrinking

Now, if you are working in a Virtual Machine, you can take an image of the disk 
and shrink it to save space. This will be your baseline "OS install"


## Dual Boot

### shrink Windows volume

The best way to reconfigure NTFS partitions where Windows is installed 
is usually by using the Windows operating system itself. 
To shrink a volume use `diskmgmt.msc`.

Unfortunately Windows considers some system files to be 'unmoveable', 
and Volume Shrink will be limited by this. The trick is to disable 
those features, reboot, and shrink again, before finally reenabling them. 

To identify which file is limiting the shrink, check the Windows 
**Application** even logs for a 259 code. Once you have found the culprit, 
deal with it, then try the shrink again. You can continue this, rebooting 
occasionally, until you have the shrink size you were hoping for. 
Try using **Disk cleanup** for removing some of those temporary system files. 
Files in `System Volume Information` are often from System Recovery, 
which you can turn off in `systempropertiesprotection.exe`.

* to view the latest event preventing shrink:
	- powershell (if backqoutes surround the code, omit them)
		- `Get-WinEvent -FilterHashtable @{logname=???application???; id=259} -MaxEvents 1 | fl`
	- gui
		- `eventvwr` / Windows Logs / Application / look for event with ID 259
* to disable and renable the features
	- command line syntax 
		- [https://superuser.com/a/1175556]
	- using the GUI
		- [https://somoit.net/windows/windows-cannot-shrink-volume-unmovable-files]
* search service
	- powershell
		- `Set-Service WSearch -StartupType "Disabled"`
		- `Stop-Service WSearch`
	- GUI
		- [https://superuser.com/questions/73204/correct-way-to-disable-indexing-in-windows-7]



### Windows 10 Dual Boot

#### Access windows partition from linux

To access Windows 10 NTFS system parititon when dual booted into ubuntu

* Turn of Fast Boot 
* turn off hibernate with powercfg...
    * http://askubuntu.com/a/457401

### bcdedit

Since Windows Vista, 7 thru 10 etc, the Boot Configuration Data (BCD) store 
holds details of what system will boot and with what options. 

A common work around in Dual Boot scenarios is to re-instate the Ubuntu partition 
as the default for booting...

```
REM paste this into an Administrator CMD console window...
REM credit - http://askubuntu.com/a/655279
bcdedit /set {bootmgr} path \EFI\ubuntu\grubx64.efi

REM if you need it to work even with UEFI Secure Boot enabled then use
bcdedit /set {bootmgr} path \EFI\ubuntu\shimx64.efi
REM help - [http://askubuntu.com/a/342382]
```

+ For other useful options with Ubuntu dual-boot 
	* see [http://askubuntu.com/a/744840]
* For yet more command options 
	* see [https://technet.microsoft.com/en-us/library/cc721886.aspx]


### Windows 8 Dual Boot

* Windows - Power Options - Disable FastBoot
    * Disabling Secure Boot is not necessary, 
        * according to [http://askubuntu.com/a/666632] which says simply to ensure that UEFI shim option is chosen
        * However see hardware specific below
* linux installer 
    * Install - Something Else - write boot to sda as normal
    * Legacy CSM is "Compatibility Support Mode" which emulates the legacy BIOS boot


#### Helpful links ####

* [oldfred's UEFI Installing - Tips](http://ubuntuforums.org/showthread.php?t=2147295)
* [Alvarado's concisely comprehensive key steps for dual booting](http://askubuntu.com/a/228069)
* [Boot Info and Boot Repair tools](https://help.ubuntu.com/community/Boot-Repair)
* [ubuntu UEFI help](https://help.ubuntu.com/community/UEFI)
* 


#### Troubleshooting

##### only boots Windows

###### booted grub fine until update

If you have previously managed to get Grub working to boot into Ubuntu, 
and a subsequent Windows update removes Grub as the default UEFI boot choice, 
then rather than attempting to use Boot-Repair, 
you can simply use the Windows **bcdedit** utility...

See section above

###### "Selected boot device is disabled in BIOS"

This is another error that cropped up after using Windows for many months 
and boot-repair from a LiveUSB did not appear to sort it out, 
but bcdedit from section above did! 


###### Boot Order ######

After reboot, if it still boots into Windows go back into Live USB and 

```
sudo apt-get install efibootmgr
efibootmgr

# if Ubuntu not * active and first in order then for bootnum, e.g. 0000 ...
sudo efibootmgr -b 0000 -a
sudo efibootmgr -o 0,1,2
```

###### choose boot device from Windows ######

In Windows Recovery options (or SHIFT-restart) can choose to 
Boot from other device - "ubuntu"
however after POST, the UEFI/BIOS reports
"selected boot device is disabled in BIOS setup"

###### check EFI partition ######

 sudo mount /dev/sda2 /mnt
 ls -l /mnt/EFI/Boot
 ls -l /mnt/EFI/ubuntu


###### check if Installed in UEFI mode ######

* mount the partition you installed to
* open the **etc/fstab** file on that partition
* if there is a mount point for _/boot/efi_ then it _was_ installed in UEFI mode


###### if BIOS only 32-bit EFI #####

How to add a 32-bit EFI file if your BIOS doesn't support 64-bit UEFI
Can you just copy the one from BOOT partition of Live USB?
e.g. /mnt/boot-sav/sdb1/EFI/Boot/bootia32.efi


## issue - Windows 10 no internet

* Windows 10 Wirelesss Connection
    * Wifi connects but shows limited connectivity or no internet
    * Address is APIPA autoconfiguration 169.254. address

### check

ipconfig


### services

rem should be Running
sc query dhcp

rem if you need to diagnose further then check all services
services.msc

rem or mabe the eventlog
eventvwr


### resets


#### dhcp release and renew

ipconfig /release
ipconfig /renew
rem now check
ipconfig

#### flush dns

netsh winsock reset
ipconfig /flushdns
ipconfig /registerdns


#### flush and renew

ipconfig /flushdns
ipconfig /registerdns
ipconfig /release
ipconfig /renew
netsh winsock reset


#### ip reset v1

netsh int ip reset c:\resetlog.txt 


#### ip reset v2

rem Reset WINSOCK entries to installation defaults: 
netsh winsock reset catalog
rem Reset IPv4 TCP/IP stack to installation defaults. 
netsh int ipv4 reset reset.log
rem Reset IPv6 TCP/IP stack to installation defaults. 
netsh int ipv6 reset reset.log


#### not sure these really help

rem netsh int tcp set heuristics disabled
rem netsh int tcp set global autotuninglevel=disabled
rem netsh int tcp set global rss=enabled

#### this might be dodgy too

rem netsh interface ipv4 show inter      
rem rem note the IDX of the interface (e.g. 11 below)
rem netsh interface ipv4 set interface 11 dadtransmits=0 store=persistent 
rem rem then it says to disable DHCP client service and reboot!


### turn off APIPA

HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\<interface-name>
IPAutoconfigurationEnabled  REG_DWORD = 0

restart computer to reload tcpip settings


### turn off power management on adapter

if the error always comes up following resume (e.g. from sleep)
then consider turning off power management on the adaptor 

Network Adaptor / Properties / Configure / Power Management tab 
uncheck the Allow the computer to turn off...

### reinstall drivers

devmgmt.msc
right-click on Wifi Device / Uninstall / confirm / reboot

## IN - old issues


### Windows Boot Manager

#### Windows Failed to Start (130809)

0xc000000f - "boot selection failed because a required device is inaccessible"

* System Recovery Options - Startup Repair
* In repair option 
	* System Recovery Options - Command Line
	* Bootrec /RebuildBcd
	[http://answers.microsoft.com/en-us/windows/forum/windows_vista-hardware/windows-failed-to-start-status-0xc000000f/b15bcf91-b167-4d63-b5e3-5abe6c8be2af]

```
fixboot
fixmbr
```
* or in Ubuntu
	* try Bootinfoscript for diagnostic info
	* see boot-repair


