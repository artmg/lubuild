See also:

* for more on OS choices (especially for Pis) see [Mugammapi Distros # Comparing distros](https://github.com/artmg/MuGammaPi/wiki/Distros#comparing-distros)
* 

Ubuntu, and its variants like Lubuntu, are derived from the Debian operating system, which is a highly mature product with many satellite development groups aiming to support a wide variety of hardware platforms. 

Perhaps you might like to try this distro directly. This gives you the flexibility to add the layers you want directly, instead of the choices being made for you by a supplier like Canonical. Of course that does mean that you need to make more choices yourself. There might have been a time when it was not as easy to get started with the installation, but the Debian project has made great strides in simplifying things for beginners. The only hard part is choosing where to start and what to add.

Here we will choose:

* **installer**: use a small USB ISO [netinst image](https://www.debian.org/CD/netinst/) 
	* just enough to get you connected and pull down what you need
* **init**: let's leave the default `systemd`
	* If you wanted to pick a different one see [here](https://wiki.debian.org/Init#Changing_the_init_system_-_at_installation_time)
* **desktop**: you could go for the vanilla but full GNU/Linux desktop or pick something lighter
	* If you're used to Lubuntu then LXQt will make you feel at home


In this example we are using an x64 architecture system, with amd64 netinst image which is around 630MB

```
wget --trust-server-names https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.7.0-amd64-netinst.iso
```

You can use [a simple dd to write the disk image](https://github.com/artmg/lubuild/blob/master/help/configure/write-Distro-to-flash.md#choice--simpler---dd) to the full disk, as it contains the partition table inside the ISO, but do remember to **` sync `** after writing

When you boot netinst, you have the choice of a full graphical window-based installer with mouse, or an ncurses keyboard-only terminal-based installer. Both look pretty similar inside, with similar choices.

## Installation Choices

Whichever installation mode you choose, graphical or text, you have the option to answer the following questions with a preseed file if you prefer, to automate the installation and to repeat it silently on many different occasions.

### Basic options

* Language (for the OS and the rest of the installation process)
* Locale (country specific settings)
* Keyboard layout
* Hostname for device on network
* root password(e.g. for sudo)
* local (non-root) username
* password for local user
* partitioning (see below for manual)
* mirror (source for installation and packages)

After those choices the bare installation progresses, setting up a very basic Debian operating system, including the basic `apt` package manager.

### Software options

Then you can choose (if you wish) one of the available Desktop 'meta-packages':

Desktops:
* GNOME
* Xfce
* KDE (Plasma)
* Cinnamon
* MATE
* LXDE
* LXQt

Any of these will also install the `Debian desktop environment`, which includes the xorg xserver and some Debian desktop theming artwork.

Other:
* Web server (`apache2`)
* SSH server (`openssh`)
* Standard system utilities (recommended - any package that has a priority “standard”)

See [installed help section D.2, “Disk Space Needed for Tasks”](https://www.debian.org/releases/bookworm/amd64/apds02.en.html "D.2. Disk Space Needed for Tasks")


## Install via ssh

To reduce the amount of time you need to be attached to the console 'head' you can [continue the install using ssh](https://www.debian.org/releases/bookworm/amd64/ch06s03.en.html#network-console). 

Boot from your `netinst` boot media (e.g. USB with the ISO written to it), and at the Debian installer menu:

- Advanced Options
- Expert Install (Graphical or text as you prefer)
- Detect and Mount Install media
- Load installer components
- check the item `network-console` then Continue
	- This will install some component from the install media
	- You will now see additional steps appear in the 'choose next step'
* Network config steps are not ONLY used for the installation process, but also retained into the finalised config 
	* _determine the value from your local instructions_
	* enter and respond to the sections...
		- Detect network hardware
		- Configure the network
		    - Hostname and Domain name
- Continue installation remotely using SSH
	- enter the password for your ssh session
	- even if it's only temporary, make it secure-ish
	- enter it twice
- Use the proposed ` ssh installer@ ` with it's ip address

Now you may continue the install (using text mode) via the ssh session, making it easier to paste in commands and configuration.

- Start Installer
- Set up users and passwords
	- Allow root: NO
	- enter the username and password
- Configure the clock
	- NTP Yes, default
- Continue with the various other options to install

NB: after the main install, make sure that you include the Software Choice: `SSH server` so that you can continue to use it remotely. You can also [use SSH certificates](https://github.com/artmg/lubuild/blob/master/help/configure/Secure-SHell-SSH.md#generate-and-install-ssh-certificate) to log onto the machine more easily in future.

## Post-installation configuration

### set user as sudoer

If you HAD allowed Root above, but then wanted to use sudo,
this is how you would change your user's config...

* this is quicker and easier to type than to paste in any blocks
* you must be root to make this change
	* **` su `**
* you will be prompted for root password
* now as root, add the user into the sudo group
	* use the specific user_name here
	* **` sudo adduser `** _user_name_  **` sudo `**
* once done, reboot for it to take effect
	* **` /sbin/reboot `**
* credit https://unix.stackexchange.com/a/773999
* after reboot, if you were remote, reconnect to ssh

