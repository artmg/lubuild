#!/bin/bash

# request sudo password before getting stuck in...
sudo echo


####################################
### *** PREPARE REPOSITORIES *** ###
####################################

# backup software sources
sudo cp /etc/apt/sources.list{,.`date +%y%m%d.%H%M%S`}
# partner repo was axed
# sudo add-apt-repository -y "deb http://archive.ubuntu.com/ $(lsb_release -sc) partner"
## help > https://help.ubuntu.com/community/Repositories/CommandLine

### PPAs ###
# NB: do NOT add comments to the end of apt-get commands, it may produce errors
# repos now deprectated or not required
# sudo add-apt-repository -y ppa:freecad-maintainers/freecad-stable # FreeCAD (newer than Ubuntu version)
# sudo add-apt-repository -y ppa:recoll-backports/recoll-1.15-on    # now in user-apps.bash
# sudo add-apt-repository -y ppa:nixnote/nixnote2-daily             # nixnote2 use deprecated


# For each source, test the distro does NOT already have it,
# then add the key via gpg (apt-key is deprecated) and the source.
# Previously we used the folder /etc/apt/keyrings/ as recommended by 
# https://askubuntu.com/a/1437410 as local admin account manages keys. 
# Now /usr/share/keyrings/ as that's where the ubuntu sources put them
APT_KEYRING_PATH=/usr/share/keyrings
#APT_KEYRING_PATH=/etc/apt/keyrings

# - reference keyrings put via gpg into this folder
sudo mkdir -p ${APT_KEYRING_PATH}/
if [ ! -f /etc/apt/sources.list.d/google-chrome.list ]; then (
  # Google Key - https://www.google.com/linuxrepositories/
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub |
    gpg --dearmor |
    sudo tee ${APT_KEYRING_PATH}/google-chrome.gpg > /dev/null
  # Chrome Repo - http://www.ubuntuupdates.org/ppa/google_chrome
  echo "deb [signed-by=${APT_KEYRING_PATH}/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" |
    sudo tee /etc/apt/sources.list.d/google-chrome.list ;
) ; fi

if [ ! -f /etc/apt/sources.list.d/anydesk-stable.list ]; then (
  # credit http://deb.anydesk.com/howto.html
  wget -q -O - https://keys.anydesk.com/repos/DEB-GPG-KEY |
    gpg --dearmor |
    sudo tee ${APT_KEYRING_PATH}/anydesk-stable.gpg > /dev/null
  echo "deb [signed-by=${APT_KEYRING_PATH}/anydesk-stable.gpg] http://deb.anydesk.com/ all main" |
    sudo tee /etc/apt/sources.list.d/anydesk-stable.list ;
) ; fi

if [ ! -f /etc/apt/sources.list.d/megasync.list ]; then (
  # repo folders see https://mega.nz/linux/repo/ 
  # locations follow naming from debian.postinst found in .deb
  wget -q -O - https://mega.nz/linux/repo/xUbuntu_24.04/Release.key |
    gpg --dearmor |
    sudo tee ${APT_KEYRING_PATH}/meganz-archive-keyring.gpg > /dev/null
  echo "deb [signed-by=${APT_KEYRING_PATH}/meganz-archive-keyring.gpg] https://mega.nz/linux/repo/xUbuntu_24.04/ ./" |
    sudo tee /etc/apt/sources.list.d/megasync.list ;
) ; fi

if [ ! -f /etc/apt/sources.list.d/spotify.list ]; then (
  # credit https://www.spotify.com/de-en/download/linux/ 
  wget -q -O - https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg |
    gpg --dearmor |
    sudo tee /etc/apt/keyrings/spotify.gpg > /dev/null
  echo "deb [signed-by=${APT_KEYRING_PATH}/spotify.gpg] http://repository.spotify.com stable non-free" |
    sudo tee /etc/apt/sources.list.d/spotify.list ;
) ; fi

## Alternate key syntax:
# curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | 
#  sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
## which did not need the signed-by path specifying  

# Use snap instead
#if [ ! -f /etc/apt/sources.list.d/skype-stable.list ]; then (
#  # credit https://repo.skype.com/
#  dpkg -s apt-transport-https > /dev/null || bash -c "sudo apt-get update; sudo apt-get install apt-transport-https -y"
#  wget -q -O - https://repo.skype.com/data/SKYPE-GPG-KEY |
#    gpg --dearmor |
#    sudo tee ${APT_KEYRING_PATH}/skype-stable.gpg > /dev/null
#  echo "deb [signed-by=${APT_KEYRING_PATH}/skype-stable.gpg] [arch=amd64] https://repo.skype.com/deb stable main" |
#    sudo tee /etc/apt/sources.list.d/skype-stable.list ;
#) ; fi

# Prepare for repository installs
sudo apt-get update



###################################
### *** REMOVE BUNDLED APPS *** ###
###################################

### NO LONGER REQUIRED
# When using Minimal Install option

## prevent purchasable items appearing in software list
#sudo apt-get remove -y unity-lens-shopping  
## credit > http://www.omgubuntu.co.uk/2012/10/10-things-to-do-after-installing-ubuntu-12-10
#
## avoid this 'dependendency only' package being removed when a dependee is removed
#if [[ $DESKTOP_SESSION == Lubuntu ]] ; then
# sudo apt-mark manual lubuntu-desktop ;
#fi
## credit - https://help.ubuntu.com/community/Lubuntu/Documentation/RemoveLubuntuDesktop
#if [[ "$DESKTOP_SESSION" == "QLubuntu" ]] ; then
# sudo apt-mark manual lubuntu-qt-desktop ;
#fi
#
## assuming the LibreOffice suite is installed, remove the lighter weight alternatives
#if [[ $DESKTOP_SESSION == Lubuntu ]] ; then (
#	# remove abiword to avoid doc corruption issues
#	sudo apt-get remove -y abiword
#	# sudo apt-get remove -y abiword abiword-common
#	## or will this do it all?
#	sudo apt-get remove -y gnumeric
#) fi
## sudo apt-get autoremove


######################################
###  *** *** BASIC EXTRAS *** ***  ###
######################################

### helper app for below
sudo apt-get install -y debconf-utils

### FONTS ###

# pre-answer the accept EULA to avoid the install waiting
sudo debconf-set-selections <<EOF
msttcorefonts msttcorefonts/defoma note
ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula boolean true
ttf-mscorefonts-installer msttcorefonts/present-mscorefonts-eula note
EOF
# credit - https://raw.github.com/panticz/installit/master/install.ubuntu-restricted-extras.sh
# NOTES: to check the input to set selections use --checkonly
# to see what is set install debconf-get-selections
# if this fails see https://ubuntuforums.org/showthread.php?t=2323229&p=13483643#post13483643

# Google metric-equivalent fonts for Calibri and Cambrian
sudo apt-get install -y fonts-crosextra-carlito fonts-crosextra-caladea
# see also [https://github.com/artmg/lubuild/blob/master/help/use/Office-documents.md]


# rebuild Font Cache (just in case)
sudo fc-cache -f -v


####################################
### *** *** APPLICATIONS *** *** ###
####################################

#! / bin / bash
cat > ./package_list <<EOF

# NB: keep big apps on separate lines to avoid sudo credentials timing out

######## ALL MACHINES ############

####### MultiMedia ##########

# AUDIO usually works fine out of the box
pulseaudio	                 # should be in by default
pavucontrol	                 # pulse volume control
# pulseaudio-module-bluetooth # if you want to add Bluetooth Audio Sink

cantata						# qt-based MPD client


######## Non-libre ############
# NOT using the `echo ${DESKTOP_SESSION,}`-restricted-extras to avoid flash installer
libavcodec-extra unrar ttf-mscorefonts-installer
# help > https://help.ubuntu.com/community/RestrictedFormats


######## Networking ############

libnss-mdns                       # name resolution
cifs-utils nfs-common             # mount helpers for cifs and nfs
cups-pdf	 	                  # PDF printer

########### KIDS #############
# for more ideas see...  https://wiki.ubuntu.com/Edubuntu/AppGuide
childsplay gcompris tuxpaint kwordquiz ri-li # infants
tuxtype ktouch tuxmath gbrainy kig kalgebra  # practice
celestia stellarium kstars marble kgeography # geo-astro
aisleriot airstrike glchess glines gnect gnibbles gnobots2 gnome-sudoku  # play
gnomine gnotravex gtali iagno gnotski fraqtive khangman solfege          # play
# no longer in repos
# gnome-mahjongg klotski lightsoff quadrapassel swell-foop

### Music Production ###
rosegarden   # composer, notation editor, midi sequencer
hydrogen     # drum sequencer
lilypond     # notation engraver

########### General purpose ###############

# Office
libreoffice		# office - prefer to replace abiword - should we remove gnumeric too?
mythes-en-us  # english thesaurus including GB 

# Design
gimp          # edit images
inkscape      # create vector graphics
dia-gnome     # create technical diagrams
scribus       # desktop publishing
krita         # digital painting

############## Specialist stuff ################

thunderbird  # PIM that works well on Lubuntu AND is available on PortableApps.com, 
vym          # mind-map / notes
# gnucash    # Busines app
# calibre    # convert docs to AZW kindle format for USB download () - on demand as qt5 still needs many many libs
retext       # visual editor for Markdown

### Advanced Design ###
freecad freecad-doc      # 3D parametric modeler (CAD)

### General Utilities ###
xmlstarlet  # NEEDED by Lubuild for changing XML config files
p7zip-full  # 7z handler for archive manager (fileroller) - use xarchiver for XFCE


geany       # syntax highlighting editor - # alternatives: gedit (ubuntu default), sublime text??,  xemacs21 (no app menu shortcut), vim (_really_?), gVim?
baobab      # graphical disk usage analyser
workrave    # encourage regular breaks for posture and eyes 
keepassx    # store credentials 
meld        # file and folder diffs...
# now using mkusb  (instead of)  unetbootin  # more reliable at installing bootloader than usb-creator-gtk

# Search now in user-apps.bash


######## LAPTOPS ############


### Internet Clients ###

google-chrome-stable    ### PPA required ### Google Chrome
skypeforlinux           ### PPA required ### repo.skype.com
firefox                 # for distros that don't include by default

nixnote2				### PPA required

epiphany-browser        # alternative lightweight browser
transmission            # torrent client
gftp                    # file transfer client

# deprecated
# flashplugin-installer	 # Adobe Flash plugin for browsers - alternatives are swfdec-gnome or gnash
# nixnote                  ### PPA required ### vincent-c/nevernote
#     alternatively use EverNote Windows client under WINE, and at v5 it is reasonably stable

### conversion tools ###
pandoc	      # convert documents between markup formats # sample command # pandoc -f markdown -t html -o output.htm input.txt
readpst       # convert Outlook PST mailbox file into VCards and other files containing the data from each mailbox folder # consider also pst-utils?
ocrfeeder     # image to text - includes tesseract engine
pdftk         # manipulate PDF files (e.g. split, combine)
pdfshuffler   # GUI for PDF page manipulation; 
poppler-utils # includes pdfimages to extract image files from PDFs

### sub-systems ###
python					# code execution
# wine                  # windows compatibility moved to user apps

android-tools-adb android-tools-fastboot ### Android Tools (now in main repo - was ppa:nilarimogard/webupd8)

# see lubuild manual-apps-per-user.bash for more - https://github.com/artmg/lubuild/blob/master/manual-apps-per-user.bash

# jockey-gtk
# hardware drivers 

EOF

# install the listed packages, 
# ignoring blanks and inline comments
# and tee the output to a log file
cat package_list | while read line ; do line=${line%%\#*} ; [ "$line" ] && echo && echo ======== $line ======== >> package.log && sudo apt-get install -y $line | tee -a package.log ; done 


################################
### *** Post App Install *** ###
################################



########################################
### *** *** *** DEFAULTS *** *** *** ###
########################################

# Update-Alternatives

## help - check the current defaults...
# sudo update-alternatives --get-selections

sudo update-alternatives --set x-www-browser /usr/bin/firefox

# sudo update-alternatives --set gnome-text-editor /usr/bin/geany
# geany isn't in the list in the first place so 'install' it at a high enough priority
sudo update-alternatives --install /usr/bin/gnome-text-editor gnome-text-editor /usr/bin/geany 100


###################################
### *** *** *** END *** *** *** ###
###################################
