
see also:

* for specific configuration suggestions
	* [https://github.com/artmg/lubuild/blob/master/help/configure/Desktop.md]
* this is where the desktop is initially configured during Lubuild
	* [https://github.com/artmg/lubuild/blob/master/user-config.bash]


* simple intro
[http://www.complete-concrete-concise.com/ubuntu-2/ubuntu-12-04-server/ubuntu-12-04-server-how-to-install-a-gui]
* what uses what [https://journalxtra.com/linux/desktop-recovery/the-definitive-guide-to-getting-your-linux-desktop-back/]
* see also [https://wiki.archlinux.org/index.php/desktop_environment]

## IN

### Linux GUI Architecture ###

For an introduction to the different elements of the linux GUI
(Window Mgr, Display Server, GUI etc) see

https://en.wikipedia.org/wiki/Window_manager

also check out the Category Template at the end of the article.

* Window Manager
* Display Manager
	* Greeter
* Session Manager
* Desktop Manager
* Lock screen


## X Server

* x11drv
* alternatives like Wayland?


## Display Manager

 starts the X servers, user sessions and greeter (login screen)

* LightDM
	* default in and Lubuntu & Ubuntu
	* see https://wiki.ubuntu.com/LightDM
* SDDM
	* preferred by Lxqt / Lubuntu Next


Greeter 
login screen
in Ubuntu is Unity Greater

session manager 

panel 

desktop manager 

widgets

Old set of defauls [https://wiki.ubuntu.com/UDSProceedings/N/PackageSelectionAndSystemDefaults]

### frame buffer

The Linux framebuffer (fbdev) is a graphic hardware-independent 
abstraction layer to show graphics on a computer monitor. 

The framebuffer can be used to:

* implement text Linux console that is richer than _hardware text mode_, and allows graphical elements or more flexible use of character formats
* give a hardware/driver-independent graphic output method for a display server
* allow graphical program to display without the heavy overhead of X Window

Examples of the third application include Linux programs such as MPlayer, links2, Netsurf, fbida,[2] and fim [3] and libraries such as GGI, SDL, GTK+, and Qt, which can all use the framebuffer directly. 

## Policy Kit

The freedesktop.org Policy Kit was introduced for authorising actions on the desktop to specific users or groups, although it has actually been adopted and extended to more fundamental aspects of the operating system. For instance even Raspberry Pi OS Lite [uses it](https://forum.openmediavault.org/index.php?thread/41757-polkit-s-pkexec-component-identified-as-cve-2021-4034-pwnkit/&postID=299687#post299687) to allow non-privileged users to elevate privileges to reboot. And of course it is this ability that exploits like 'pwnkit' leverage.

Now known simply as 'polkit', [the project source]() describes itself as 'a toolkit for defining and handling authorizations, used for allowing unprivileged processes to speak to privileged processes'. The polkit package (depends on the polkitd daemon and the pkexec utility as a setuid tool, but will only raise privilege if policy rules are met. 

The permlink to the most up to date manuals is https://www.freedesktop.org/software/polkit/docs/latest/ where you can also find a [polkit system architecural overview](https://www.freedesktop.org/software/polkit/docs/latest/polkit.8.html). 

e.g. 
* Allow all users to add wifi connections
* "Authentication is required to unlock the encrypted device"

* http://www.freedesktop.org/software/polkit/docs/latest/polkit.8.html
 * Actions are defined by applications
 * Rules are how Sys Admins control authorisation
 * also corroborated by https://wiki.archlinux.org/index.php/Polkit
 * which suggests the javascript .rules files go under
 * /usr/share/polkit-1/rules.d   for third parties and
 * /etc/polkit-1/rules.d   for local configuration

#### Polkit version history

In the upstream version 106, [the developer chose](`http://davidz25.blogspot.com/2012/06/authorization-rules-in-polkit.html`) to switch the local authority backend to use javascript. For [historical reasons](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=946231#10) the Debian downstream project begin manually applying virtually every change except that change, in order to keep the old **.pkla** and **.conf** files. Whereas many other distros stuck with the upstream and switched to re-defining policies in Javascript **.rules** files.

This parial forking, since around 2012, has caused a lack of correlation between upstream project version numbers where features and bugfixes have been introduced, and the Debian downstream package. For instance 0.105.20, delivered in Ubuntu 18.04 LTS, was around v115 upstream. The best way to cross-relate the versions is with [the debian package maintainer's changelog](https://salsa.debian.org/utopia-team/polkit/-/blob/master/debian/changelog)

Since 0.105.26 Debian maintainers have been stepping towards using the current upstream release, and patching in the old localauthority backend, as an alternative to the JavaScript backend. This appears to be in the form of polkitd-pkla

### Legacy PKLA backend

* [Debian PolicyKit docs](https://wiki.debian.org/PolicyKit)
	* clarifies that still uses .pkla and .conf not .rules javascript
	* recommends [pklocalauthority(8) man page](https://manpages.ubuntu.com/manpages/jammy/en/man8/pklocalauthority.8.html) for configuration help
* [Historical 105 PKLA doc](https://www.freedesktop.org/software/polkit/docs/0.105/pklocalauthority.8.html)
* Legacy system architecture from [polkit(8) man page](https://manpages.ubuntu.com/manpages/jammy/en/man8/polkit.8.html#system%20architecture)

`man pklocalauthority` describes the tree including `/etc/polkit-1/localauthority` sub folders such as 30-site.d and 50-local.d which are useful scopes but these are all .conf files


### upstream JavaScript backend 

For the syntax used elsewhere than Debian, there is a handy intro to [configuing polkit in archwiki](https://wiki.archlinux.org/title/Polkit#Configuration)


### diagnostics

```
pkaction --version
```

* pkcheck will only see in an existing process is running would be authorised
* try looking at server logs (journalctl)
* 

