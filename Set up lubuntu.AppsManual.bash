#!/bin/bash

#######################
### *** ***  Live  USB  *** *** ###
#######################

# set GB keyboard map
setxkbmap -layout gb
# set GB as default keyboard map in sessions 
echo '@setxkbmap -layout gb' | sudo tee -a /etc/xdg/lxsession/Lubuntu/autostart
# credit > http://askubuntu.com/questions/102344/switching-keyboard-layouts-in-lubuntu-11-10

### CDROM RO issue ################
# credit > http://askubuntu.com/a/54622
# credit > http://unix.stackexchange.com/questions/47433/mount-usb-drive-fat32-so-all-users-can-write-to-it#comment66000_47433
sudo mount -o remount,rw,UID=`id -u` /cdrom

# fix (requires manual changes)
# http://www.pendrivelinux.com/sharing-files-between-ubuntu-flash-drive-and-windows/
# workaround  
# http://askubuntu.com/a/57911

# if it's been used in windows, but not safely removed...
# help > http://ubuntuforums.org/showthread.php?p=7525441 

### LOCATION specific #######################################

# move to root of Wallet drive
cd /media/lubuntu/W_SD_8BU/

# open setup help
xdg-open Wallet/Service/Procedures/Setup/Public/Set\ up\ Ubuntu.html 

### BOOKMARKS #######################
cp ~/.gtk-bookmarks{,.`date +%y%m%d`}
# Add local music folder to bookmarks
echo file:///media/lubuntu/Default/Documents%20and%20Settings/UserName/Local%20Settings/Personal/Music Music.COPY | tee -a ~/.gtk-bookmarks




################################
### *** Pre App Install  *** ###
################################

### REPOSITORIES

# backup software sources
sudo cp /etc/apt/sources.list{,.`date +%y%m%d`}
# Add partner
sudo add-apt-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner"
# help > https://help.ubuntu.com/community/Repositories/CommandLine

# Prepare for repository installs
sudo apt-get update

### UPDATES ################

# update existing applications with no user interaction...
sudo apt-get upgrade -y


### OPTIONAL UPDATES only if you want ...

# load any kernel updates
sudo apt-get dist-upgrade -y

# ensure that grub is properly updated in case of issues
# and if you want to change timeout then first edit /etc/default/grub
sudo update-grub

# if you want to enable automatic updates...
sudo apt-get install unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades
# help > https://help.ubuntu.com/community/AutomaticSecurityUpdates

#########################
# after all applications are installed and/or upgraded, consider clean up using...
# sudo apt-get autoremove -y
# reboot to use any new kernel version installed
sudo reboot




####################################
### *** *** APPLICATIONS *** *** ###
####################################

### Clean up OS install

sudo apt-get remove -y unity-lens-shopping  # prevent purchasable items appearing in software list
# credit > http://www.omgubuntu.co.uk/2012/10/10-things-to-do-after-installing-ubuntu-12-10

sudo apt-get remove -y abiword		# remove abiword to avoid doc corruption issues
# sudo apt-get remove -y abiword abiword-common
## or will this do it all?
# sudo apt-get autoremove

### BASICS
# including some proprietary (non-libre) packages
# pre-answer the accept EULA to avoid the install waiting
sudo sh -c "echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections"
# credit > http://askubuntu.com/questions/16225/how-can-i-accept-microsoft-eula-agreement-for-ttf-mscorefonts-installer
sudo apt-get install `echo ${DESKTOP_SESSION,}`-restricted-extras -y
# help > https://help.ubuntu.com/community/RestrictedFormats


# Supersedes list in HTML doc section - Applications - General Apps

#! / bin / bash
cat > ./package_list <<EOF

######## ALL MACHINES ############

# MultiMedia
gstreamer		
# none-open formats incl DVDs - also needs post install code below
# might be part of other media player like totem
pulseaudio	
# should be in by default
pavucontrol	
# pulse volume control
# AUDIO usually works fine out of the box unless you want to use Bluetooth Audio Sink

flashplugin-installer	
# Adobe Flash plugin for browsers - alternatives are swfdec-gnome or gnash
cups-pdf		
# PDF printer


######## LAPTOPS ############
guvcview		
# support for most webcams


########### KIDS #############
# for more ideas see...
# https://wiki.ubuntu.com/Edubuntu/AppGuide

# infants
childsplay gcompris tuxpaint kwordquiz ri-li

# practice
tuxtype ktouch tuxmath gbrainy kig kalgebra

# programming
basic256 laby kturtle

# geo-astro
celestia stellarium kstars marble kgeography

#play

aisleriot airstrike glchess glines gnect gnibbles gnobots2 gnome-sudoku
gnomine gnotravex gtali iagno gnotski fraqtive khangman solfege

# the following do not seem to be included with 12.04
# gnome-mahjongg

# the following do not seem to be included with 11.04
# klotski
# lightsoff
# quadrapassel
# swell-foop

################# EITHER #################

libreoffice		
# office - prefer to replace abiword - should we remove gnumeric too?

# notes
vym

# Skype - no longer in repos - see below
# Dropbox - manual, see below

# advanced
gimp
inkscape
dia-gnome
scribus

# music
# on lubuntu default player is Audacious
# consider alternative like LXMusic or RhyhtmBox

############## TECH STUFF ################

meld					
# file and folder diffs...
#  alternatives: xxdiff - also kdiff3 (floss) + diffMerge (free) are Win/Nux

geany					
# syntax highlighting editor
# alternatives: gedit (ubuntu default), sublime text??,  xemacs21 (no app menu shortcut), vim (_really_?), gVim?

epiphany-browser	
# alternative lightweight browser
transmission			
# torrent client

gftp					
# file transfer client

pandoc				
# convert documents between markup formats 
# sample command 
# pandoc -f markdown -t html -o output.htm input.txt

calibre					
# convert docs to AZW kindle format for USB download

python					
# code execution

# decompression
# for ubuntu, p7zip for 7z format (fits into fileroller)
# or for xubuntu, xarchiver (includes p7zip)

### Other Candidates
# jockey-gtk
# hardware drivers 

### Busines Apps
# gnucash

### Utilities
# vlc vlc-plugin-esd mozilla-plugin-vlc
# txt2tags


# WSYIWYG html editor - kompozer no longer in repos
# see > https://help.ubuntu.com/community/InstallKompozer 
# alternatives: http://www.bluegriffon.org/ although not in repos
# What about Amaya?
# Is BlueFish visual? Aptana is more web dev

EOF

# while read -r line; do [[ $line = \#* ]] && continue; sudo apt-get install -y $line; done < package_list
# while read -r line; do [[ $line = \#* ]] && continue; echo -e "$line"; done < package_list
# credit > http://mywiki.wooledge.org/BashFAQ/001

# not sure why this one fails

# cat package_list | xargs -r -d # sudo apt-get install 


################################
### *** Post App Install *** ###
################################


### Allow 
# play dvds
sudo /usr/share/doc/libdvdread4/install-css.sh 



#####################################
### Apps requiring manual install ###
#####################################


#################################
### KOMPOZER

# WSYIWYG html editor - kompozer no longer in repos
xdg-open https://help.ubuntu.com/community/InstallKompozer 
# alternatives: http://www.bluegriffon.org/ although not in repos
# What about Amaya?
# Is BlueFish visual? Aptana is more web dev

#################################
### DROPBOX

# install from repository
sudo apt-get install nautilus-dropbox -y
dropbox start -i

# Manual install
# help > https://www.dropbox.com/install?os=lnx
case $(uname -m) in
 x86_64)
   (cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -)
 ;;
 i?86)
   (cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86" | tar xzf -)
 ;;
esac

# this will launch the daemon
~/.dropbox-dist/dropboxd


# and first time around you will need to configure it with your account
# If you choose "Advanced" setup you can choose where to store your files locally


# create the Start Menu shortcut
cat > ~/.local/share/applications/dropbox.desktop<<EOF
[Desktop Entry]
Name=Dropbox
Comment=Cloud file sync 
Exec=$HOME/.dropbox-dist/dropboxd
Categories=Network
Type=Application
Terminal=false
StartupNotify=true
EOF
# then refresh the Start Menu  
lxpanelctl restart

## alternative or supplementary lines
# Version=1.0
# X-GNOME-FullName=Dropbox file sync daemon
# Comment=Share you files between computers
# Icon=~/.dropbox-dist/images/emblems/emblem-dropbox-syncing.icon
# StartupNotify=false


# help > http://www.dropboxwiki.com/Using_Dropbox_CLI
mkdir -p ~/bin
wget -O ~/bin/dropbox.py "http://www.dropbox.com/download?dl=packages/dropbox.py"
chmod +x ~/bin/dropbox.py
# ~/bin/dropbox.py help

## third part hack script to move dropbox folder programmatically...
# https://whatbox.ca/wiki/Dropbox


##################################
### SKYPE

case $(uname -m) in
 x86_64)
 (cd ~ && wget http://www.skype.com/go/getskype-linux-beta-ubuntu-64)
 ;;
 i?86)
 (cd ~ && wget http://www.skype.com/go/getskype-linux-beta-ubuntu-32)
 ;;
esac
# credit > http://www.wikihow.com/Install-Skype-Using-Terminal-on-Ubuntu-11.04
sudo dpkg -i getskype-*
sudo apt-get -f install -y && sudo rm getskype-*
# credit > http://www.noobslab.com/2012/11/install-latest-skype-41-in-ubuntu.html
#
# (ensure Skype does not listen at port 80 or 443)


#################################
### GOOGLE EARTH

sudo apt-get install lsb-core
case $(uname -m) in
 x86_64)
 (cd ~ && wget http://dl.google.com/dl/earth/client/current/google-earth-stable_current_amd64.deb)
 ;;
 i?86)
 (cd ~ && wget http://dl.google.com/dl/earth/client/current/google-earth-stable_current_i386.deb)
 ;;
esac
# alternative shorter urls
# wget -c http://goo.gl/YEqTf -O google-earth-stable_i386.deb
# wget -c http://goo.gl/t6E3i -O google-earth-stable_amd64.deb
sudo dpkg -i google-earth-stable_*.deb
# ensure all dependencies are installed
sudo apt-get install -f -y
# credit > http://www.liberiangeek.net/2012/04/install-google-earth-in-ubuntu-12-04-precise-pangolin/?ModPagespeed=noscript

# if you still have issues running it, try...
# apt-get install --reinstall lsb-core
# credit > https://help.ubuntu.com/community/GoogleEarth



#################################
### CITRIX RECIEVER

# dependency for Citrix Reciever (ICA client)
# help > https://help.ubuntu.com/community/CitrixICAClientHowTo 
# WAS sudo apt-get install -y libmotif4
sudo apt-get install libmotif4:i386 nspluginwrapper lib32z1 libc6-i386
# download + install Citrix 64-bit DEB
# from http://www.citrix.com/downloads/citrix-receiver/linux.html
# SAVE the .DEB file

# See the article for the rest



#################################
### SPOTIFY

# backup software sources and add repository
sudo cp /etc/apt/sources.list{,.`date +%y%m%d`}
sudo add-apt-repository "deb http://repository.spotify.com stable non-free"

# credit > http://askubuntu.com/questions/257306/cant-install-spotify-for-ubuntu-12-10
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 94558F59
sudo apt-get update
sudo apt-get install -y spotify-client




#################################
### FREEPLANE

sudo apt-get install openjdk-6-jre -y
sudo apt-get install freeplane -y

### Manual download example with shortcut creation ...
# help > http://freeplane.sourceforge.net/wiki/index.php/Ubuntu
## wget -O - "http://sourceforge.net/projects/freeplane/files/latest/download?source=files" | 
wget -qO- -O tmp.zip "http://sourceforge.net/projects/freeplane/files/latest/download?source=files" && unzip tmp.zip && rm tmp.zip

cd freeplane*
echo "[Desktop Entry]" | sudo tee /usr/share/applications/freeplane.desktop
echo "Name=Freeplan" | sudo tee -a /usr/share/applications/freeplane.desktop
echo "Comment=Mind Mapping tool" | sudo tee -a /usr/share/applications/freeplane.desktop
echo "TryExec=$PWD/freeplane.sh" | sudo tee -a /usr/share/applications/freeplane.desktop
echo "Exec=$PWD/freeplane.sh" | sudo tee -a /usr/share/applications/freeplane.desktop
# echo "Icon=/opt/eclipse/icon.xpm" | sudo tee -a /usr/share/applications/freeplane.desktop
# echo "Categories=Development;IDE;Java;" | sudo tee -a /usr/share/applications/freeplane.desktop
echo "Terminal=false" | sudo tee -a /usr/share/applications/freeplane.desktop
echo "Type=Application" | sudo tee -a /usr/share/applications/freeplane.desktop
echo "StartupNotify=true" | sudo tee -a /usr/share/applications/freeplane.desktop
cd ..

#### EVERNOTE alternatives
## Everpad for Unity##
  # credit > http://handytutorial.com/install-evernote-in-ubuntu-12-10-12-04/
  # but this is a unity lens,  so might not be any use in Lubuntu
  # http://askubuntu.com/questions/243049/trouble-authorizing-everpad-on-lubuntu
 

# BBC iPlayer Desktop replacement...
# get_iplayer 
# http://squarepenguin.co.uk/guides/linux-quick-install-guide/

