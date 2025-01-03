
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


## Windows 11 quick local setup

This follows the Windows 'out of (the) box experience' to provide the quickest, simplest way to get a working Windows 11 system from the OEM vendor-preinstalled recovery partition. Note that this process reverts to a local administrator account, avoiding using a Microsoft Account with real user credentials, until the build is complete enough to offer to the user. 

* Accept Region
* Accept Input Method
* Shift F10 for command prompt
* enter the command  `oobe\bypassnro`  to finish setup with no network
	* otherwise Connect Wireless
	* then when prompted for Microsoft Account...
	* see below
* wait for updates
* wait for restart

* Accept license agreement
* Set hostname
	* record in Private Config Note
* wait for restart

* if prompted for Microsoft Account...
	* disconnect network
		* e.g. use Flight Mode function key
	* press back button
	* Enter local user name & security details
		* record in Private Config Note
* No Location
* No Find
* Required only
* No inking
* No diagnostic
* No Ad ID

* Vendor registration
	* by-pass as needed
	* (e.g. HP Register and Protect...)
		* Leave empty and next
		* Leave unticked and next

* Wait for completion
* turn Flight Mode back on
* Settings / WIndows Updates / Download Now
* Restart as required 
* Keep an eye on Update download status
* until updates all complete

In the mean time you can check the System Configuration, Windows Editions and build info, Disk Layout, etc - ready to continue your preferred configuration and installation process. 

Once updates are complete you may consider uninstalling OEM provided 'bloatware', but be cautious not to remove useful features or render your system inoperable. See [Manage Applications](#Manage%20Applications) section below.


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

Update 2021: it seems as though more recent versions of Windows 10 can find printer devices via mDNS. However, if the client and printer are in different subnets, you may need an mDNS Repeater like Avahi helping between the networks.

## Manage Applications

### Remove Unwanted Apps & Features

You can do this via Apps and Features, but it can be quicker in an Adminsitrators Powershell

Note that this list is based on Windows 10 20H2

```
# Get-AppxPackage | select name | sort name
Get-AppxPackage -AllUsers | Select Name, PackageFullName

function FullyRemove-AppxPackage {
    param (
        $AppxPackageName
    )
    Get-AppxPackage -Name $AppxPackageName | Remove-AppxPackage 
    Get-AppxPackage -AllUsers -Name $AppxPackageName | Remove-AppxPackage -AllUsers
}

FullyRemove-AppxPackage -AppxPackageName Microsoft.GetStarted
FullyRemove-AppxPackage -AppxPackageName Microsoft.MicrosoftOfficeHub
FullyRemove-AppxPackage -AppxPackageName Microsoft.Office.OneNote
FullyRemove-AppxPackage -AppxPackageName Microsoft.Microsoft3DViewer
FullyRemove-AppxPackage -AppxPackageName Microsoft.MixedReality*
FullyRemove-AppxPackage -AppxPackageName Microsoft.WindowsFeedbackHub
FullyRemove-AppxPackage -AppxPackageName Microsoft.WindowsMaps
FullyRemove-AppxPackage -AppxPackageName Microsoft.SkypeApp # use full version if you want it
FullyRemove-AppxPackage -AppxPackageName Microsoft.Xbox*
FullyRemove-AppxPackage -AppxPackageName Microsoft.Zune*
FullyRemove-AppxPackage -AppxPackageName Microsoft.BingNews
FullyRemove-AppxPackage -AppxPackageName Microsoft.BingWeather

# Optional items
# if you have no Windows devices or MS accounts
FullyRemove-AppxPackage -AppxPackageName Microsoft.YourPhone
FullyRemove-AppxPackage -AppxPackageName Microsoft.People
FullyRemove-AppxPackage -AppxPackageName Microsoft.OneDriveSync
# Apps needing a SIM & Mobile radio
FullyRemove-AppxPackage -AppxPackageName Microsoft.OneConnect

# simple games
FullyRemove-AppxPackage -AppxPackageName 'Microsoft.MicrosoftSolitaireCollection'
FullyRemove-AppxPackage -AppxPackageName *.SimpleSolitaire
FullyRemove-AppxPackage -AppxPackageName Microsoft.MinecraftEducationEdition
FullyRemove-AppxPackage -AppxPackageName king.com*

# if you add a proper recorder
FullyRemove-AppxPackage -AppxPackageName Microsoft.WindowsSoundRecorder

# more trialware
FullyRemove-AppxPackage -AppxPackageName *.McAfeeSecurity
FullyRemove-AppxPackage -AppxPackageName DropboxInc.DropboxOEM

# if you don’t use these services:
FullyRemove-AppxPackage -AppxPackageName *.AmazonAlexa
FullyRemove-AppxPackage -AppxPackageName Disney.*
FullyRemove-AppxPackage -AppxPackageName *.McAfeeSecurity
FullyRemove-AppxPackage -AppxPackageName DropboxInc.Dropbox
FullyRemove-AppxPackage -AppxPackageName SpotifyAB.SpotifyMusic

# example vendor bundleware
FullyRemove-AppxPackage -AppxPackageName *.myHP
FullyRemove-AppxPackage -AppxPackageName *.HPSupportAssistant

# other bundled apps
FullyRemove-AppxPackage -AppxPackageName *EclipseManager*
FullyRemove-AppxPackage -AppxPackageName *Duolingo*


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

### Terminal
You may consider a themed developers’ terminal prompt, similar to OhMyZsh, but want to sail close to the Microsoft direction for better supportability and futureproofing. Fortunately the Windows Terminal, built into Windows 11 (and in the [app store](https://apps.microsoft.com/store/detail/windows-terminal/9N0DX20HK701) and `choco install microsoft-windows-terminal` for Windows 10) strategically integrates PowerShell, supports ssh natively, and has the winget package manager. 

```powershell
# allow scripts
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned  -Scope CurrentUser
# install Oh My Posh
winget install JanDeDobbeleer.OhMyPosh -s winget
# restart terminal to get effects
exit
```

* For configuring your Terminal profile see https://docs.microsoft.com/en-us/windows/terminal/tips-and-tricks 
* If you [install Terminal into Windows 10](https://apps.microsoft.com/store/detail/windows-terminal/9N0DX20HK701) you might also want to [add the shortcuts into WinX Quick Links menu](https://www.neowin.net/guides/guide-add-terminal-to-windows-10-quick-links-winx-right-click-on-start-menu/) 

#### Useful shortcuts

* Ctrl+Shift+P - command palette
* Ctrl+R or Ctrl+S - command history reverse and normal search
   - start typing a match (any position in command)
   - repeat the search key (e.g. Ctrl+R) to search next or previous match
        - note: this comes from the PSReadLine module and shows bck-i-search

#### In-terminal editor
It can be useful to have an editor directly in the terminal, rather than ‘shell out’ to a GUI editor, so to satisfy both camps you can install both geeky vim and friendly nano.

```powershell
choco install -y vim nano
```

#### Previous alternatives

* Cmder - coder's shell with tab completion and git integration
	* may need extra .REG for Explorer integration
* 


### Prevent sleep

If you use a Professional Edition of Windows, you can use Presentation Mode to prevent sleep/monitor darkness whilst using the machine passively (e.g. watching something or video conference).

* New Desktop Shortcut
* `C:\Windows\System32\PresentationSettings.exe /start`
* Pin to taskbar
* Click to test icon in system tray
* Unlock systray and Always show

If you are on Home Edition this will not work, so you can use one of the following utilities

```
choco install -y caffeine
# OR
choco install -y dontsleep.install
```

### Print to PDF

In earlier version of Windows you needed expensive Adobe Acrobat to install a 'print to PDF' printer driver. Freeware like CutePDF or PDFCreator, but as proprietary binaries with no obvious income there is an increasing risk that these contain bundled adware or worse kinds of malware. Choco installs sometimes counter these issues, but third party software is not necessary with more recent versions of Windows.

Windows 10 _should_ include the `Microsoft Print to PDF` feature, their own bundled PDF printer driver. If you cannot see Print to PDF in your list of printers then it might be:

* removed as a printer, or 
* turned off as a feature

The Microsoft articles below explain the steps to reinstate the feature / driver. For newer versions (e.g. Windows 10 build 20H2? or later) the `dism` technique works better. For older versions (e.g. Windows 10 build 1903? or earlier), the `dism` technique doesn't work so you'll have to try the manual setup.

* [Use DISM command to reinstate MS PDF printer](https://answers.microsoft.com/en-us/windows/forum/all/how-to-add-or-reinstall-the-microsoft-pdf-printer/a473357b-8a8f-44fe-ba3a-9680b6bdfa79)
* [Manually re-add MS PDF printer](https://answers.microsoft.com/en-us/windows/forum/all/how-to-add-or-reinstall-the-microsoft-pdf-printer/70377c34-e50a-42be-b9f3-92345d6e25df)

If you are still having issues then [this forum Question](https://answers.microsoft.com/en-us/windows/forum/all/cant-reinstall-the-driver-for-microsoft-print-to/9433dd1f-6ed7-498d-878e-ab654a62d702) has Answers suggesting links to alternative solution steps and alternative commands and method to properly clear out old drivers before re-instating a fresh.


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

### Disk usage analyser

* Venerable **WinDirStat** is still a great FOSS option on Windows
* but you might be using GrandPerspective on macOS and [baobab](lubuild/help/diagnose/disks#What's using my space?) on linux
* [SquirrelDisk](https://github.com/adileo/squirreldisk)is a cross-platform React/Rust FOSS project, 
	* and since Dec 2024 it is availabe via ` choco install squrreldisk `

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

Windows 10, together with the hidden OEM recovery partition, make it easy to refresh your PC as if you'd just unpacked it for the first time.

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

### USB Recovery Drive

If you decide you wish to remove the recovery partition, to make more space, 
search in the Start Menu for Recovery and select '**Create a recovery drive**'. 
This will transfer the contents of the hidden recovery drive to a bootable usb 
medium and allow you to do a repair as above, regardless of the state of the boot partitions on the disk. 

http://windows.microsoft.com/en-US/windows-8/create-usb-recovery-drive

### Full reinstall

If you go to the Windows 11 download page you have the Media Creation Tool 
that will download the correct ISO image and write it to a drive and 
make it bootable. Using this you could delete the existing partition(s) and start with a totally fresh image. 

#### Activation with digital license

Providing your OEM has included a digital license onto its motherboard (stored permanently into the system BIOS during the manufacturing process), and you have not swapped that motherboard out, then Windows 11 will use that key to (re-)activate Windows 11 on that specific system. This replaces the activation code on the sticker from the underside of the PC, and most major vendors follow this approach.

This activation requires an internet connection (to check for blacklisted license keys). If you install without an internet connection you will have a 'Deferred activation' which is 'Not Activated', but fully functional. If you have an internet connection but there is an issue with the digital license your PC will be 'Not activated' and message on desktop and personalization features are blocked.


## Device Encryption

Full disk encryption will secure your 'data at rest' - in other words, if your device falls into the wrong hands, people cannot access your stored data by loading it onto a different system. 
Under Windows Home editions you may use the simple, straightforward 'Device Encryption' to encrypt your storage volume, as opposed to the more complex Bitlocker system available on Professional editions. 

Under Settings / Privacy and Security / Device Encryption you will find whether your device supports Windows Device Encryption (WDE). For instance, your computer must have a Trusted Platform Module (TPM). Even though Bitlocker is not available on Home edition WDE is not bad. The issue comes if you use a local account. 

When you install Windows Home on hardware that supports WDE, it will turn on Device Encryption and encrypt the disk ready using a Clear Key, which is left on the disk as Full Volume Encryption Metadata. This would let you recover the data if a password was lost/forgotten, but it is clearly not secure from attack!

When you log on with a Microsoft account, it replaces that Clear Key with a Volume Master Key (VMK) sealed onto the computer’s TPM. In the process it also generates a Recovery Key, which it escrows to your Microsoft account, allowing you to get the data back if the password is forgotten/lost.

Even if you have the right hardware on your computer, you can only safely encrypt your data on Home edition using Windows Device Encryption when you log on with a Microsoft Account. If you want an alternative, you may use Veracrypt to turn on Full Disk Encryption (FDE) before committing sensitive data to the disk.

### Check if Device Encryption is available

* Provided you have TPMv2 enabled and UEFI, 
	* Settings / Update & Security / Device Encryption
* If you don't see this option
	* Start / Win Admin Tools / System Information / right-click run as Admin
	* System Summary / Device Encryption Support
	* There _might_ be ways to deal with errors
		* by turning on or off certain bios settings
		* try Googling the error
			* with your fingers crossed and plenty of patience

### Veracrypt System Encryption

If you choose to use Veracrypt to encrypt your system partition, you might consider turning off Windows FDE in settings (even if it is not fully encrypted for the reasons above).

* `choco install -y veracrypt`
* not sure if restart is required now
* launch the Veracrypt app
* System / Encrypt System Partition
* Type: Normal
* Area: Windows System Partition
* Number of OS: (choose as appropriate, e.g. Single Boot)
* Encryption options: 
	* if you don't understand these, default is fine
	* if you change these, it may take a couple of seconds longer to boot
	* however it will make it MUCH harder for other people to brute-force crack your encryption
	* Of course a longer password really helps this too!
* Use mouse for random data
* Disable Windows Fast Startup
* save the recovery data to a removable drive medium
	* the Rescue Data only takes a handful of MB
* choose Wipe Mode
* reboot for a PreTest
* finally Encrypt

Fast Startup is related to 'Hybrid boot and shutdown', which essentially means shutdown is not fully shutdown, but a disguised hibernate. 
The unencrypted volume might still be mounted when you restart, 
unacceptably exposing your private data. 
The bits that 'slow it down' are features that you _actually_ want!

#### Veracrypt Bootloader

On older BIOS systems, Veracrypt would install it's own bootloader over the 
default system bootloader. With modern UEFI systems, Veracrypt only needs to add it's bootloader into the EFI list and ask if that can be default. This leaves the original Windows OS bootloder intact, even if second in line for now. 


#### Windows updates puts Veracrypt into Recovery

If you have used Veracrypt System Encryption to encrypt your full Windows System Partition, you might encounter issues 
following a Windows Update. 
Instead of asking for the encryption password at Power On, a blue Recovery warning appears.

    Recovery
    Your PC/Device needs to be repaired.
    A required device isn’t connected or can’t be accessed 0xc000000f

This appears to happen because Windows Update moves up the Windows Boot option to the top of the Boot Order list, and moves down the Veracrypt boot partition (which may appear to have a blank description). 

* Esc to go into UEFI Firmware settings
* UEFI asks for Enter Current Password
    - this is the Windows User Password used to unlock the desktop screen
    - it is NOT the Veracrypt System Encryption password
* Use arrows to move across to the Boot page
* Use arrows to move down to blank line
    - this is the Veracrypt boot partition that prompts for the Power On password
* Use F6 multiple times to move that line up to the top
	* NB: your UEFI 'bios' may use different function keys
* F10 to Save and Exit
* Enter to say Yes to save

The Veracrypt developer [has produced](https://sourceforge.net/p/veracrypt/discussion/general/thread/d68f12c213/) a utility called [VcFixBoot]() which you can [download](https://github.com/veracrypt/VcFixBoot/tags) (previously [here](https://sourceforge.net/projects/veracrypt/files/Contributions/)). Although early source versions had no documentation, [the developer stated](https://sourceforge.net/p/veracrypt/discussion/general/thread/d68f12c213/)

    The tool VcFixBoot can be
    run after booting Windows manually through Rescue Disk or BIOS VeraCrypt
    entry. It will fix the EFI partition content so that Windows will boot
    normally without needing the Rescue Disk or changing the BIOS boot order.

NB: there was [one report](https://libredd.it/r/VeraCrypt/comments/m8b4hc/) that turning off FastBoot might also work around this issue, but we did not want to try that. 


### Reinstall Windows on encrypted system disk

If you have Veracrypt System Partition encrypted, and you want to reinstall Windows:
* I want to overwrite the system files with new copies to fix issues, but leave my data intact
	* theoretically you should be able to do this leaving the encryption on
* I want to wipe my disk and reinstall my system with a fresh copy of Windows, ready to pass onto someone else, but without putting my data at risk
	* if I need to remove System Partition encryption, how do I protect my data from inspection?
		* if I rmdir folders and choose A (All), System Partition encryption does not interpret the filesystem but simply encrypts and decrypts the lot. This means that data could theoretically be recovered post-deletion if it has not yet been overwritten.
	* You could simply reinstall Windows using a bootable ISO (e.g. via the Media Creation Tool) and remove the old System Partition to restart from scratch.
		* you may also remove the old recovery partition, 
			* most of the time anything non-MS that it contains is only bloatware
			* unless you have some very esoteric OEM hardware that requires special drivers and software
		* then during Windows 11 install it will create a new one for you

Refer to the installation flows at the top of this article for other help.


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

### USB ports and devices

If you want to find out information about your USB ports on the PC, or devices connected via them, the Device Manager (devmgmt.msc) does not make it easy to view this. 

Microsoft offer an [open source](https://github.com/Microsoft/Windows-driver-samples/tree/main/usb/usbview) sample tool called [USBView](https://docs.microsoft.com/en-us/windows-hardware/drivers/debugger/usbview#where-to-get-usbview) in their Windows Debugging Tools component, included in the Windows SDK or Driver WDK. Although these are both pretty meaty downloads, the link above explains how to install just the Debugging Tools (less than a gig) and then run the utility.

There is a mature standalone thrid party utility [USBTreeView](https://www.uwe-sieber.de/usbtreeview_e.html) that has been derived from this. Although it has many more features that have been developed over the years it is still much quicker and easier to download. However, being closed source, it is up to you whether or not to trust the author.

Here are a couple of PoSh commands that can help

```powershell
# simple list
Get-PnpDevice -PresentOnly | Where-Object { $_.InstanceId -match '^USB' }

# full detail
Get-PnpDevice -PresentOnly | Where-Object { $_.InstanceId -match '^USB' } | Format-List

# credit https://www.shellhacks.com/windows-lsusb-equivalent-powershell/

```

## Subsystem for Linux

WSL is the Windows Subsystem for Linux, 
where you can choose a Linux flavour to install 
from the Windows App Store to run via this subsystem. 
With the `wsl` executable you can either 
open a linux terminal or directly run a linux shell command. 
You might find this a useful alternative to 
either dual booting or installing a whole virtual machine. 

### Enable the WSL

#### Windows 11

If you want to set up the Virtual Machine Platform and WSLcomponents and download Ubuntu to run full Linux commands and stacks, simply

```powershell
wsl --install
```
You will most likely need a reboot to use this VM, but to configure it see https://docs.microsoft.com/en-us/windows/wsl/setup/environment 


#### Windows 10

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



