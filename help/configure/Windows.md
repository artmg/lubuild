
## Intro

Even if you mainly use free operating systems, you might use Windows ...

* On dual boot if you have an OEM license and you had Windows preinstalled on your PC
* In a virtual machine if you have a retail license you purchased

This article includes some tips for the basics of administrating 
your Windows instance for such cases.

see also:

* getting started with a Windows Virtual Machine
	* https://github.com/artmg/lubuild/blob/master/help/configure/virtual-guest.md#windows-guest
* how to decide on options for partitioning multi-boot systems
	* [https://github.com/artmg/lubuild/blob/master/help/understand/disk-layout.md] 
* specific commands for setting up your chosen layout under ubuntu 
	* [https://github.com/artmg/lubuild/blob/master/help/configure/disks.md]
* ubuntu diagnosis and troubleshooting commands 
	* [https://github.com/artmg/lubuild/blob/master/help/diagnose/disks.md]


## Windows 10 useful tips

### Quick minimal install

* click on the mic icon to silence Cortana
* accept keyboard/locale
* Skip Wifi to allow local account
	* Or add wifi then disable it before naming first user
* Accept EULA
* Name admin account and give three question/answers
	* if it insists on an email, then disconnect network and retry
* Say NO or DECLINE or DON'T to all the pointless services
* now wait for the install to finalise
* Settings / System / About / Rename PC
	* enter the new Hostname for this PC
* Restart

* connect to wifi - ALLOW DISCOVERY 

see also 'Manage applications' below

### Power Users' menu

Right-click on Start Menu gets the power user menu up, but there is a shortcut: use the Windows key as modifier with letter X ... **Win-X**

e.g. Elevated Command prompt...  **Win-X then A**

This is also available in Windows 8

### Windows 10 Prevent allow updates to download

To reduce the chance of updates 
downloading automatically and causing issues
You can change the following setting. 
Undo the change to allow updates once again:

* Settings / Network and Internet / Advanced options
* METERED CONNECTION = ON


### Create a local account

If you don't find the options below to 'not use an email address' 
then the last gap appraoch is to disconnect from the internet, 
by removing the ethernet cable or turning off the wifi. 

* Click Start, Settings, Accounts, Family & other users, Add someone else to this PC
    * Note that you can’t “Add a family member” with a local account. Presumably that is tied in to parental controls.)
* Add someone else to this PC 
* In the box marked “How will this person sign in?” 
    * down at the bottom, click “The person I want to add doesn’t have an email address.” or "I don't have this person's sign-in information"
* In the “Let’s create your account” dialog, at the bottom, 
    * click “Add a user without a Microsoft account.”
* enter user name, password and password hint.
    * Click Next 

### UserBenchMark

If you are interested in your relative scores on performance

* https://www.userbenchmark.com/Software
* quiesce services like updates etc
	* check task manager
* Run the tests

Note that different commentators have split opinions 
on whether this closed source executable that 
doesn't show positive on most antivirus but DOES 
send data (detail undisclosed) to its developer 
is really malware or not. Consider this before using 
on secure systems, especially if you are not planning 
a final re-install before use. 


### Issue - bonjour not visible

Printers and Spotify devices broadcasting via bonjour are not picked up by Windows 10 PC

According to https://superuser.com/a/1453423 you can add the registry key/value...
`REG ADD "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" /V "EnableMulticast" /D "0" /T REG_DWORD /F` and reboot the PC. This might make it appear in Spotify, but has not yet been proven to work.

The Bonjour Service would be automatically installed if you chose to install ITunes onto the PC (but that's 300MB of software you might not otherwise need).

Bonjour browsers for Windows:
* `dns-sd` comes with IBM Network IPS
* free but closed source bonjour browsers:
	* Hobbyist https://hobbyistsoftware.com/bonjourbrowser
	* Tobias Erichsen http://www.tobias-erichsen.de/software/zeroconfservicebrowser.html
* 

Not yet resolved :(

## Manage Applications

### Remove Unwanted Apps & Features

You can do this via Apps and Features, but it can be quicker in an Adminsitrators Powershell

```
Get-AppxPackage | select name | sort name

Get-AppxPackage -Name king.com*                | Remove-AppxPackage
Get-AppxPackage -Name Microsoft.MixedReality*  | Remove-AppxPackage
Get-AppxPackage -Name Microsoft.GetStarted     | Remove-AppxPackage  # Tips
Get-AppxPackage -Name Microsoft.SkypeApp       | Remove-AppxPackage  # the 'lite' blue-on-white version
Get-AppxPackage -Name Microsoft.MicrosoftOfficeHub  | Remove-AppxPackage
Get-AppxPackage -Name Microsoft.Microsoft3DViewer  | Remove-AppxPackage
Get-AppxPackage -Name Microsoft.Office.OneNote  | Remove-AppxPackage
Get-AppxPackage -Name Microsoft.WindowsFeedbackHub  | Remove-AppxPackage
Get-AppxPackage -Name Microsoft.WindowsMaps     | Remove-AppxPackage
Get-AppxPackage -Name Microsoft.Xbox*           | Remove-AppxPackage
Get-AppxPackage -Name Microsoft.Zune*           | Remove-AppxPackage # Groove
Get-AppxPackage -Name *EclipseManager*          | Remove-AppxPackage
Get-AppxPackage -Name *Duolingo*                | Remove-AppxPackage
# Optional items
# if you have no Windows devices or MS accounts
Get-AppxPackage -Name Microsoft.YourPhone  | Remove-AppxPackage
Get-AppxPackage -Name Microsoft.People  | Remove-AppxPackage
# Apps needing a SIM & Mobile radio
Get-AppxPackage -Name Microsoft.OneConnect  | Remove-AppxPackage
# simple games
Get-AppxPackage -Name 'Microsoft.MicrosoftSolitaireCollection'  | Remove-AppxPackage
# if you add a proper recorder
Get-AppxPackage -Name Microsoft.WindowsSoundRecorder  | Remove-AppxPackage

```

```
Get-WindowsCapability -Online -Name "XPS.Viewer*" | Remove-WindowsCapability -Online
Get-WindowsCapability -Online -Name "Browser.InternetExplorer*" | Remove-WindowsCapability -Online
# credit https://jessehouwing.net/tools-for-windows-developers-2019/
```

### Install Chocolatey

* Right-click on Start for PowerShell Admin
* paste in from https://chocolatey.org
	* Get Started / Install Individual

```
choco install -y <your list of apps>
```

### Prevent sleep

If you use a Professional Edition of Windows, you can use Presentation Mode to prevent sleep/monitor darkness whilst using the machine passively (e.g. watching something or video conference).

* New Desktop Shortcut
* C:\Windows\System32\PresentationSettings.exe /start
* Pin to taskbar
* Click to test icon in system tray
* Unlock systray and Always show

If you are on Home Edition this will not work, so you can use one of the following utilities

```
choco install -y caffeine
# OR
choco install -y dontsleep.install
```

## Windows Update

### Pull Updates that aren't appearing

If you have just installed, but Settings / Updates 
is not showing stuff you know has come out, 
like major Features Updates, then you can use the 
[Update Assistant tool](https://www.microsoft.com/en-gb/software-download/windows10)

If it turns out that the update is being held back by 
a [Safeguard Hold](https://docs.microsoft.com/en-us/windows/deployment/update/safeguard-holds), then at your own risk you can push forward your device using DisableWUfBSafeguards, e.g. 

```
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate]
"DisableWUfBSafeguards"=dword:00000001
```

Note: Microsoft creates Safeguard Holds if testing
has established your hardware is at risk 
when an update is applied, so think twice before 
ploughing on ahead regardless.


### Troubleshooting

Including the Windows 10 Upgrade process

* Check the file
    * %windir%\WindowsUpdate.log


#### common error codes

* http://windows.microsoft.com/en-gb/windows-10/upgrade-install-errors-windows-10


#### clear the update cache

If updates are stuck in perpetual 'Update and Restart' 
or Checking for "Windows Update" sticks on "please wait" or if you have other reason to want to reset the 
whole Windows Update agent settings on your PC...

https://docs.microsoft.com/en-us/windows/deployment/update/windows-update-resources

_Microsoft appears to have hidden the previous "Reset Windows Update Client script" from 
https://gallery.technet.microsoft.com/scriptcenter/Reset-Windows-Update-Agent-d824badc 
where you could expand the zip and run the Batch as Admin then 
pick the options you want (e.g. 2, 3)_


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

## Manage disk space

### Universal package cache

The Universal Apps (UWP, formerly known as Metro apps or Modern Apps), so many apps loaded from the Windows 10 store, save their config and data in the folder 
%APPDATA%/Local/Packages. Some of these can become extremely bloated with cached data.

Here is a BleachBit CleanerML file for dealing with these. Use the System Info option to find your `personal_cleaner_dir` and install in there as `Streaming.Players.xml` ...


```xml
<?xml version="1.0" encoding="UTF-8"?>
<!--
    BleachBit CleanerML file
    @help: https://github.com/bleachbit/bleachbit/blob/master/doc/example_cleaner.xml
-->
<cleaner id="streaming.players" os="windows">
  <label>Streaming Player caches</label>
  <description>Cached data for music and video streaming packages</description>
  <option id="spotify.cache">
    <label>Spotify cache</label>
    <description>Spotify song cache</description>
    <!-- @credit https://community.spotify.com/t5/Desktop-Windows/cache/td-p/4722569 -->
    <action command="delete" search="walk.all" path="$LOCALAPPDATA\Packages\SpotifyAB.SpotifyMusic_zpdnekdrzrea0\LocalCache\Spotify\Data"/>
  </option>
  <option id="spotify.downloads">
    <label>Spotify downloads</label>
    <description>Remove all songs that had been downloaded for offline listening</description>
    <action command="delete" search="walk.all" path="$LOCALAPPDATA\Packages\SpotifyAB.SpotifyMusic_zpdnekdrzrea0\\LocalState\Spotify\Storage"/>
    <!-- @credit observation/guesswork -->
  </option>
  <option id="amazon.prime">
    <label>Amazon Prime downloads</label>
    <description>Remove all Prime Videos that had been downloaded</description>
    <action command="delete" search="walk.all" path="$LOCALAPPDATA\Packages\AmazonVideo.PrimeVideo_pwbj9vvecjh7j\LocalState\Downloads"/>
    <!-- @credit observation/guesswork -->
  </option>
  <option id="netflix">
    <label>Netflix downloads</label>
    <description>Remove all Netflix videos that had been downloaded</description>
    <action command="delete" search="walk.all" path="$LOCALAPPDATA\Packages\4DF9E0F8.Netflix_mcm4njqhnhss8\LocalState\offlineInfo\downloads"/>
    <!-- @credit observation/guesswork -->
  </option>
  <option id="flixster">
    <label>Flixster films</label>
    <description>Remove all locally stored Flixster content</description>
    <action command="delete" search="walk.all" path="$LOCALAPPDATA\Flixster\Storage"/>
    <!-- @credit observation/guesswork -->
  </option>
</cleaner>
```


## Reinstall

In some cases, configurations can get so snarled up that that simplest cure 
is to reinstall the whole OS, and Windows is closer to the rule than the exception. 

* First back up all data that is not cloud-based
* Then note any additional software installed
* then reinstall


### Automatic Repair Mode

Windows 10, together with the hidden OEM boot partition, make it easy to refresh your PC as if you'd just unpacked it for the first time.

* Shift Restart
* Troubleshooting
* Reset pc
* Don't keep files
* Only drive where Windows installed
* Just remove my files
* Reset

If you had installed Bitlocker encryption, 
you would then be presented with the Recovery Key ID, 
and be prompted `Reset this PC` and 
`enter the Recovery Key` that was generated 
when Bitlocker was set up.

watch also: https://www.youtube.com/watch?v=yp5bfmRwRY0&t=2s

### Device Encryption

Under Windows 10 Home you may use 'Device Encryption' (MS' free equivalent of bitlocker) to Encrypt the volume

* Provided you have TPMv2 enabled and UEFI, 
	* Settings / Update & Security / Device Encryption
* If you don't see this option
	* Start / Win Admin Tools / System Information / right-click run as Admin
	* System Summary / Device Encryption Support
	* There _might_ be ways to deal with errors
		* by turning on or off certain bios settings
		* try Googling the error
			* with your fingers crossed and plenty of patience
* Alternatively try Veracrypt
	* `choco install -y veracrypt`
	* not sure if restart required now
	* Launch Veracrypt
	* System / Encrypt System partition
	* Type: Normal
	* Area: Windows sys partition
	* OS: Single Boot
	* Encryption options: if you don't understand, then default is fine
	* you'll need a small USB drive to store the Rescue Data
* 


## Hardware misc

### Internal temperature

If you want to troubleshoot issues with cooling or the 
heat readings from CPU, GPU or other components

* choco install openhardwaremonitor
	* opensource alternative to the popular `hwinfo`
	* similar to the mac 'stats' package in brew
* 

### audio app control

If you want to diagnose which application is the 
sound source program that is currently sending audio, 
like macOS `background-music`, 
consider the advanced volume controller app EarTrumptet 
(`choco install eartrumpet`).


## Subsystem for Linux

WSL is the Windows Subsystem for Linux, 
where you can choose a Linux flavour to install 
from the Windows App Store to run via this subsystem. 
With the `wsl` executable you can either 
open a linux terminal or directly run a linux shell command. 
You might find this a useful alternative to 
either dual booting or installing a whole virtual machine. 

### Enable the WSL

* open an admin powershell
* execute:

```
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux 
```

* restart your computer
* Open the App Store
* search for `wsl`
* pick your preferred distro flavour

For help using WSL see https://adamtheautomator.com/windows-subsystem-for-linux/


## User accounts

For adding a local-only user by dropping the network, 
see [# create a local account](#create-a-local-account) section above 

### Lost Password

There are numerous ways to recover or reset lost passwords 
for local user accounts on Windows, like the administrator. 
Generally speaking it will take longer to recover a password, 
e.g. using `ophcrack` or John the Ripper,  than it will to simply 
Reset the password in the Windows SAM.  Although there are 
hacks to do this via `net user` you are likely to need to sideboot 
from a different OS.  So the simplest method is to use a live linux,  e.g. 

* Ubuntu Live USB
* PuppyLinux frugal

#### chntpw

Many distros already include the small utility `chntpw` 
but if not then you can install it with...

* `sudo apt` cli installer on ubuntu 
* `ppm` Puppy Package Manager on Puppy 

You can find dedicated distros like HirensBootCd that include this, 
but you can just as easily add it to a general purpose distro you might 
be used to using. 


```
# mount the drive and check
mkdir /mnt/Win
mount /dev/sdaX /mnt/Win
ls /mnt/Win

# Go into registry folder and back up SAM
cd /mnt/Win/Windows/System32/config/
cp SAM SAM.yymmdd.bak
chntpw -l SAM

# make your changes
chntpw -l SAM

# save and unmount
sync
mount -u /mnt/Win
```

## Blue screen errors

The Windows Blue Screen fatal errors now have a sad face 'smiley' emoticon. Sometimes referred to as Stop errors or bugchecks, they are still known as the Blue Screen of Death (BSOD) as there is no recovery, just restarting

### BSOD Diagnostics

```
Get-EventLog -LogName application -Newest 1000 -Source 'Windows Error*' | select timewritten, message | where message -match 'bluescreen' |  ft -auto -wrap
# credit https://techgenix.com/powertip-use-powershell-report-bluescreens/
```

* leave off the `-Wrap` if you want a date summary instead
	* I tried using ` | Out-String -Width 250` to just get some of the message but to no avail

### Some things to check

System File Checker looks for changes or damage to protected system files, Deployment Image Servicing and Management and a Disk Scan look for simple issues in the Windows system files and on the hard disk

```
sfc /scannow
dism /online /cleanup-image /restorehealth
chkdsk /scan
```

Some people suggest you do a memcheck too - Windows Memory Diagnostic then check eventvwr for System log and Find source `MemoryDiagnostic`

If you are still stuck see https://docs.microsoft.com/en-us/windows/client-management/troubleshoot-stop-errors


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

#### Simple dualboot with UEFI

* shutdown /s /t 0 
* Check for the BIOS key (e.g. Del/F10) and Boot Select (e.g. F12) 
* Boot into UEFI ('bios')
* (as you may need to check Safeboot is off)
* ensure you can override to choose boot USB
* boot Lubuntu (persistent or Live, but **not** to RAM)
* Launch installer
* choose to partition manually
* you should have existing FAT32 100-250MB for EFI
* mount this as /boot/efi; create 1GB ext4 /boot + <amount of RAM> swap + 15-30GB ext4 / 
	* the 1GB boot is for the kernel files and will permit full volume encryption to protect your main root folder

#### Access windows partition from linux

To access Windows 10 NTFS system partiton when dual booted into ubuntu

* Turn of Fast Boot 
* turn off hibernate with powercfg...
    * http://askubuntu.com/a/457401

##### Read-only issues

If you find that your NTFS Partition is only being mounted read-only, 
try from the command line:

```
sudo umount /media/Acer
sudo mount -a
```

If you get an error stating that it is mounted read-only beacuse 
`The NTFS partition is in an unsafe state`
this might just be because 'Fast Shutdown' is still enabled.

Log into Windows and ensure you do a clean shutdown by using the CMD

```
shutdown /s
```

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



