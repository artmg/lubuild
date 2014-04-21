#!/bin/bash

#####################################
### DROPBOX                       ### 
#####################################

# DROPBOX daemon manual install
# NB: it appears this must be INSTALLED in user folder for EACH USER
# and then individually run for each user too

# help > download URLs from https://www.dropbox.com/install?os=lnx
case $(uname -m) in
 x86_64)
   (mkdir ~/bin ; cd ~/bin && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -)
 ;;
 i?86)
   (mkdir ~/bin ; cd ~/bin && wget -O - "https://www.dropbox.com/download?plat=lnx.x86" | tar xzf -)
 ;;
esac


# and first time around you will need to configure it with your account
# If you choose "Advanced" setup you can choose where to store your files locally


# create the Start Menu shortcut / launcher
mkdir -p ~/.local/share/applications
cat > ~/.local/share/applications/dropbox.desktop<<EOF!
[Desktop Entry]
Name=Dropbox
Comment=Share your files between computers
Exec=$HOME/bin/.dropbox-dist/dropboxd
Icon=$HOME/bin/.dropbox-dist/images/emblems/emblem-dropbox-syncing.icon
Categories=Network
Type=Application
Terminal=false
StartupNotify=true
X-GNOME-Autostart-enabled=true
EOF!

## to auto start on login in Ubuntu ...
# mkdir -p ~/.config/autostart/
# cp ~/.local/share/applications/dropbox.desktop ~/.config/autostart/
## credit - http://askubuntu.com/a/48327

## if you need to refresh the Start Menu  
# lxpanelctl restart


# this will launch the daemon
~/bin/.dropbox-dist/dropboxd

## alternative or supplementary lines
# Version=1.0
# X-GNOME-FullName=Dropbox file sync daemon
# StartupNotify=false

# *** still need to configure browser
# https://wiki.archlinux.org/index.php/dropbox#Context_menu_entries_in_file_manager_do_not_work
# see also http://askubuntu.com/questions/247003/is-there-a-way-to-stop-dropbox-from-opening-firefox-as-its-default-when-viewing

# Configuring DAEMON to AUTORUN at startup
# v1 (simple & clear): http://nixgeek.com/headless-dropbox.html
# v2 (with credit): http://www.andrewault.net/2010/06/08/install-dropbox-on-ubuntu-server/
# v3 (any user mod): http://ubuntuserverguide.com/2012/06/how-to-install-and-configure-dropbox-on-ubuntu-server-12-04.html#comment-663384785

## for command line ways to configure folders (root location and folders to include/exclude)...
# https://whatbox.ca/wiki/Dropbox


## help > http://www.dropboxwiki.com/Using_Dropbox_CLI
#mkdir -p ~/bin
#wget -O ~/bin/dropbox.py "http://www.dropbox.com/download?dl=packages/dropbox.py"
#chmod +x ~/bin/dropbox.py
## ~/bin/dropbox.py help

# in case of issues with Ubuntu not showing panel icon see
# workaround > http://itsfoss.com/solve-dropbox-icon-ubuntu-1310/

## alternative (still requires manual config) install from repository
#sudo apt-get install nautilus-dropbox -y
#dropbox start -i



#####################################
### Google Drive client           ### 
#####################################

# could move install to system-wide and just have user setup here

## Options ##
#
# Grive - free, in repo, seems popular but some issues mentioned
# InSync - $15pa, well liked
# SyncDrive - free, more thumbs down than up!
#
# Grive in repos is CLI only
# use Grive-Tools to wrap with GUI & panel icon
#
# credit - http://www.thefanclub.co.za/how-to/ubuntu-google-drive-client-grive-and-grive-tools
#
sudo add-apt-repository ppa:thefanclub/grive-tools
sudo apt-get update
sudo apt-get install grive-tools
#
# Begin setup
#
gksudo /bin/bash /opt/thefanclub/grive-tools/grive-setup
#
# or use icon in Accessories
#
# In the Google Drive indicator Preference prefer light icon theme for LXDE
#



#####################################
###   W I N E                     ### 
#####################################

# main install now in app-installs.bash - https://github.com/artmg/lubuild/blob/master/app-installs.bash
# sudo apt-get install wine


### to get the VERY latest version ###
#
# credit > http://www.winehq.org/download/ubuntu
# sudo add-apt-repository ppa:ubuntu-wine/ppa
# sudo apt-get update
# sudo apt-get install wine1.5

# might want to consider adding exec option to fstab/disks


#### ====Wine compatibility====

 # on 64 bit systems, you may get 32 bit issues with wine 
 # to make sure wine is registered as 32 bit
 # credit > http://askubuntu.com/questions/74690/how-to-install-32-bit-wine-on-64-bit-ubuntu

export WINEARCH=win32
export WINEPREFIX=~/.wine32
winecfg

# add any drives ...
# credit - ftp://ftp.winehq.org/pub/wine/docs/en/wineusr-guide.html#AEN737

ln -s /media/Windows $WINEPREFIX/dosdevices/w:


# single line to initialise the config,or to validate such a config, or to configure it manually...
# WINEARCH=win32 WINEPREFIX=~/.wine32 winecfg

## or run apps directly ...
# wine /media/Windows/PortableApps/.... 
## first time you run this it will create the wine "prefix" configuration
## so will be a little slower


#### ====Wine Shortcuts====

#* Create new shortcut
#* browse to file in Windows partition
#* prepend "wine "
#* Note that ~ does not work in shortcuts so if you need an alternative prefix (e.g. 32-bit) then prepend
# env WINEPREFIX=/home/username/.wine32 wine "
#* don't choose an icon


# sample Start Menu shortcut / launcher
mkdir -p ~/.local/share/applications
cat > ~/.local/share/applications/wine-keepass.desktop<<EOF!
[Desktop Entry]
Name=Wine KeePass
Comment=KeePass with wine 32
Exec=env WINEPREFIX=$HOME/.wine32 wine $HOME/.wine32/dosdevices/w:/PortableApps/KeePassPortable/KeePassPortable.exe
Icon=password
Categories=Wine
Type=Application
EOF!

