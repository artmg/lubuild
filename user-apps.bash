#!/bin/bash

#####################################
### LibreOffice                   ### 
#####################################

# disable Java integration to speed up the start up of the program. 

# MANUALLY: Tools > Options > LibreOffice > Advanced > Use a Java runtime environment
###########

# list of features that will no longer work: 
# http://ask.libreoffice.org/en/question/696/what-features-absolutely-require-java/



#####################################
### DROPBOX                       ### 
#####################################

# DROPBOX daemon manual install
# NB: it appears this must be INSTALLED in user folder for EACH USER
# and then individually run for each user too

LUBUILD_BIN_FOLDER=.bin
export LUBUILD_BIN_FOLDER

LUBUILD_DROPBOX_AUTOSTART=TRUE
export LUBUILD_DROPBOX_AUTOSTART

# help > download URLs from https://www.dropbox.com/install?os=lnx
case $(uname -m) in
 x86_64)
   (mkdir ~/$LUBUILD_BIN_FOLDER ; cd ~/$LUBUILD_BIN_FOLDER && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -)
 ;;
 i?86)
   (mkdir ~/$LUBUILD_BIN_FOLDER ; cd ~/$LUBUILD_BIN_FOLDER && wget -O - "https://www.dropbox.com/download?plat=lnx.x86" | tar xzf -)
 ;;
esac

# create the Start Menu shortcut / launcher
mkdir -p ~/.local/share/applications
cat > ~/.local/share/applications/dropbox.desktop<<EOF!
[Desktop Entry]
Name=Dropbox
Comment=Share your files between computers
Exec=$HOME/$LUBUILD_BIN_FOLDER/.dropbox-dist/dropboxd
#Icon should be $HOME/$LUBUILD_BIN_FOLDER/.dropbox-dist/dropbox-lnx.x86_64-x.yy.z/images/emblems/emblem-dropbox-syncing.png
Icon=$HOME/$LUBUILD_BIN_FOLDER/.dropbox-dist/images/emblems/emblem-dropbox-syncing.icon
Categories=Network
Type=Application
Terminal=false
StartupNotify=true
X-GNOME-Autostart-enabled=true
EOF!

# Add to Autostart 
if [[ $LUBUILD_DROPBOX_AUTOSTART -eq TRUE ]] ; then ( 
  mkdir -p ~/.config/autostart/
  cp ~/.local/share/applications/dropbox.desktop ~/.config/autostart/
) ; fi
## paths validated for BOTH Unity & LXDE at 14.04

## if you need to refresh the Start Menu  
# lxpanelctl restart


# and first time around you will need to configure it with your account
# If you choose "Advanced" setup you can choose where to store your files locally

# this will launch the daemon
~/$LUBUILD_BIN_FOLDER/.dropbox-dist/dropboxd &

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


## in case of issues with Ubuntu not showing panel icon try
# sudo apt-get install libappindicator1
## credit - http://askubuntu.com/a/359224
## or see - http://itsfoss.com/solve-dropbox-icon-ubuntu-1310/


### Official Dropbox CLI
## help - http://www.dropboxwiki.com/tips-and-tricks/using-the-official-dropbox-command-line-interface-cli
## installing - http://www.dropboxwiki.com/tips-and-tricks/install-dropbox-in-an-entirely-text-based-linux-environment
## old help - http://www.dropboxwiki.com/Using_Dropbox_CLI
## also - http://zeblog.co/?p=682
#mkdir -p ~/bin
#wget -O ~/bin/dropbox.py "http://www.dropbox.com/download?dl=packages/dropbox.py"
#chmod +x ~/bin/dropbox.py
## ~/bin/dropbox.py help


## alternative (still requires manual config) install from repository
#sudo apt-get install nautilus-dropbox -y
#dropbox start -i



########################################
## Linux Client for Google Drive sync ##
########################################

### About the Drive API ###
# The current version is Drive API v2
# migration from older versions: https://developers.google.com/drive/web/migration
# Documents List API deprecated 20th April 2015: https://developers.google.com/google-apps/documents-list/

### Alternative Linux Clients ###
# lnsync is paid version only
# Grive Tools suspended - https://www.thefanclub.co.za/how-to/ubuntu-google-drive-client-grive-and-grive-tools
# - old links to deprecated Grive Indicator - https://github.com/Sadi58/grive-indicator
# - also happy to do without those extra 165MB of libs it needed!
# ocamlfuse is transient (mount lost when connection lost) like web version - https://github.com/astrada/google-drive-ocamlfuse

## Go Drive ##
#
# git-style command to pull and push content, written in Go

### Ubuntu install ###
#
# golang package in Ubuntu repos is deprecated - https://github.com/rakyll/drive/issues/8#issuecomment-61707616
# install directly from: http://golang.org/doc/install

# needs variable     LUBUILD_BIN_FOLDER
# e.g.
# LUBUILD_BIN_FOLDER=.bin
# export LUBUILD_BIN_FOLDER

# FIRST check filename at: https://golang.org/dl/
# then set this on the following line...

GOTEMPDOWNLOAD=go1.4.2.linux-amd64.tar.gz
export GOTEMPDOWNLOAD

# credit - https://www.computersnyou.com/4524/
wget -c https://storage.googleapis.com/golang/$GOTEMPDOWNLOAD
tar -xvzf $GOTEMPDOWNLOAD
sudo mv go /usr/local/
rm $GOTEMPDOWNLOAD

# credit - http://www.jeffduckett.com/blog/55096fe3c6b86364cef12da5/installing-go-1-4-2-on-ubuntu-%28trusty%29-14-04.html
# edit .profile in your home directory
sudo nano /etc/profile

# MANUALLY add the following line
export PATH=$PATH:/usr/local/go/bin

# reload profile to avoid logout
source /etc/profile

# test
go version
go env

# credit - http://www.howtogeek.com/196635/
# install prereqs
sudo apt-get install -y git mercurial

# credit - https://github.com/rakyll/drive/wiki
# prepare profile
cat << ! >> ~/.bashrc
export GOPATH=\$HOME/$LUBUILD_BIN_FOLDER/go
export PATH=\$GOPATH:\$GOPATH/bin:\$PATH
!
# reload bashrc to avoid starting new terminal
source ~/.bashrc

# install drive **from new fork**
go get github.com/odeke-em/drive/drive-gen && drive-gen
# go get github.com/rakyll/drive/cmd/drive

# test
drive help

### set up each folder
drive init ~/Google\ Drive/MyFolder/

cd ~/Google\ Drive/MyFolder/
drive pull

# For RaspberryPi issues - https://www.raspberrypi.org/forums/viewtopic.php?t=87641&p=701009

# could move install to system-wide and just have user setup here




#####################################
###   W I N E                     ### 
#####################################

## NB: original package wine has been replaced by win1.6 wine64 and others
## currently using development branch
## https://wiki.winehq.org/Ubuntu
# If your system is 64 bit, enable 32 bit architecture (if you haven't already):
sudo dpkg --add-architecture i386 
# Add the repository:
sudo add-apt-repository -y ppa:wine/wine-builds
# Update packages:
sudo apt-get update
# Then install (example for the development branch):
sudo apt-get install -y --install-recommends winehq-devel

### to get the VERY latest version ###  # credit > http://www.winehq.org/download/ubuntu
# sudo add-apt-repository ppa:ubuntu-wine/ppa && sudo apt-get update && sudo apt-get install wine1.5

# might want to consider adding exec option to fstab/disks


#### ====Wine compatibility====
# to make sure wine is registered as 32 bit, especially to avoid 32 bit issues on 64 bit systems
# credit > http://askubuntu.com/questions/74690/how-to-install-32-bit-wine-on-64-bit-ubuntu
export WINEARCH=win32
export WINEPREFIX=~/.wine32
winecfg
# single line to initialise the config,or to validate such a config, or to configure it manually...
# WINEARCH=win32 WINEPREFIX=~/.wine32 winecfg
## or run apps directly ...
# wine /media/Windows/PortableApps/.... 
## first time you run this it will create the wine "prefix" configuration - so will be a little slower

# add any drives ...  # credit - ftp://ftp.winehq.org/pub/wine/docs/en/wineusr-guide.html#AEN737
ln -s /media/Windows $WINEPREFIX/dosdevices/w:


#### ====Wine Shortcuts====
#* Create new shortcut
#* browse to file in Windows partition
#* prepend "wine "
#* Note that ~ does not work in shortcuts so if you need an alternative prefix (e.g. 32-bit) then prepend
# env WINEPREFIX=/home/username/.wine32 wine "
#* don't choose an icon



#####################################
### RECOLL                        ### 
#####################################

# add helpers - credit - http://packages.ubuntu.com/xenial/recoll
# help - http://www.lesbonscomptes.com/recoll/features.html#doctypes
sudo apt-get update
sudo apt-get install -y antiword xsltproc catdoc unrtf libimage-exiftool-perl python-mutagen aspell

cat > $HOME/.recoll/recoll.conf <<EOF
# This is the indexing configuration for the current user
# These values override the system-wide config files in:
#   /usr/share/recoll/examples
# help - [http://www.lesbonscomptes.com/recoll/usermanual/usermanual.html#RCL.INSTALL.CONFIG.RECOLLCONF]

topdirs = ~ \


# these try to ignore the bulk of the hidden .* folder trees under home

skippedPaths = \
~/. \
~/.bin \
~/.cache \
~/.config \
~/.dropbox \
~/.local \
~/.mozilla \
~/.wine \
/*/.dropbox.cache \
/*/.dropbox-dist 

skippedPathsFnmPathname = 0

EOF

##### General knowledge on Mime Types in Recoll

# on your system, the Mime Types are defined in either:
# /etc/mime.types
# /usr/share/mime/types
# ~/.local/share/mime/types
# and the applications associated are
# /usr/share/applications/defaults.list
# ~/.local/share/applications/mimeapps.list 

# To change the recoll config (including mime types) ...
# make changes locally ~/.recoll
# make changes globally /usr/share/recoll/examples

cat > $HOME/.recoll/mimeview <<EOF
# This is the fix for the error in Lubuntu where Recoll reacts to Open Folder/Parent with
# "The viewer specified in mimeview for inode/directory" dolphin "is not found" "Do you want to start the preferences dialog"
[view]
inode/directory = pcmanfm %f
inode/directory|parentopen = pcmanfm %f
# help [http://www.lesbonscomptes.com/recoll/usermanual/RCL.INSTALL.CONFIG.html]
EOF


#### set up multiple indexes for Removeable Media ####

cd <my container root folder> ###### do this for each offline container you want to index


mkdir .recoll
cat > .recoll/recoll.conf <<EOF!
# This is the Recoll configuration file for the index for this offline container

##### how to use multiple indexes for Removeable Media #####

# help https://bitbucket.org/medoc/recoll/wiki/MultipleIndexes
# * Create separate index folder
# * Create config file
# * Build index
# * use menu Preferences / External Index to include this index when searching

# user guide Creating -  http://www.lesbonscomptes.com/recoll/usermanual/#RCL.INDEXING.CONFIG
# user guide Using - http://www.lesbonscomptes.com/recoll/usermanual/#RCL.SEARCH.GUI.MULTIDB
# sample scripts http://www.linuxplanet.com/linuxplanet/tutorials/6512/3

# Help on Config files - http://www.lesbonscomptes.com/recoll/usermanual/#RCL.INSTALL.CONFIG.RECOLLCONF.FILES
# Advanced options - http://www.lesbonscomptes.com/recoll/usermanual/#RCL.INSTALL.CONFIG.RECOLLCONF

topdirs  =  $PWD
skippedNames  =  .recoll*  .Trash*  z_History

# once the container reaches this % full, indexing will stop
maxfsoccuppc = 95 

# KB Size limit for compressed files. -1 defaults to no limit, 0 ignore compressed
compressedfilemaxkbs = -1

# MB Max text file size - as very large are usually logs, default 20MB - to disable -1 
textfilemaxmbs = 20

EOF!

##### refresh script in each root #####
cat > refresh_me.sh <<EOF!
#!/bin/bash

# set $DIR to folder containing current script
# credit - http://stackoverflow.com/a/246128
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

recollindex -c $DIR/.recoll
EOF!
chmod +x refresh_me.sh

##### Build the index now #####

recollindex -c .recoll


##### Add these as external indexes available

# although the history file in the recoll folder lists entries under allExtDbs section, 
# these are not cleartext paths so cannot be set by editing the files. 
# Use this variable instead...
export RECOLL_EXTRA_DBS=/path/to/index1/recoll/xapiandb/:/media/$USER/volume2/.recoll/xapiandb/:/media/$USER/Volume3/.recoll/xapiandb/
# NB: this will only stick for a single instance
# - how to make these permanent options of external indexes??


# # # # # # END # # # # # # 
