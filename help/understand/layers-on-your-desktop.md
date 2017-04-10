
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


## X Server

* x11drv
* alternatives like Wayland?


Display Manager
 starts the X servers, user sessions and greeter (login screen)
LightDM is default in and Lubuntu & Ubuntu
see https://wiki.ubuntu.com/LightDM

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