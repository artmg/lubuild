f#!/bin/bash

# request sudo password before getting stuck in...
sudo echo


####################################
### *** PREPARE REPOSITORIES *** ###
####################################

# backup software sources
sudo cp /etc/apt/sources.list{,.`date +%y%m%d.%H%M%S`}
# Add partner
sudo add-apt-repository -y "deb http://archive.canonical.com/ $(lsb_release -sc) partner"
# help > https://help.ubuntu.com/community/Repositories/CommandLine

### PPAs ###
# NB: do NOT add comments to the end of apt-get commands, it may produce errors
# repos now deprectated or not required
# sudo add-apt-repository -y ppa:vincent-c/nevernote                # NixNote2
# sudo add-apt-repository -y ppa:freecad-maintainers/freecad-stable # FreeCAD (newer than Ubuntu version)
# sudo add-apt-repository -y ppa:basic256/basic256                  # basic256
# sudo add-apt-repository -y ppa:recoll-backports/recoll-1.15-on    # now in user-apps.bash


# if this distros does NOT have chrome sources already...
if [ ! -f /etc/apt/sources.list.d/google-chrome.list ]; then (
  # Google Key - https://www.google.com/linuxrepositories/
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
  # Chrome Repo - http://www.ubuntuupdates.org/ppa/google_chrome
  sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' ;
) ; fi

# Prepare for repository installs
sudo apt-get update



###################################
### *** REMOVE BUNDLED APPS *** ###
###################################

### Clean up OS install

# prevent purchasable items appearing in software list
sudo apt-get remove -y unity-lens-shopping  
# credit > http://www.omgubuntu.co.uk/2012/10/10-things-to-do-after-installing-ubuntu-12-10

# avoid this 'dependendency only' package being removed when a dependee is removed
if [[ $DESKTOP_SESSION == Lubuntu ]] ; then
 sudo apt-mark manual lubuntu-desktop ;
fi
# credit - https://help.ubuntu.com/community/Lubuntu/Documentation/RemoveLubuntuDesktop

# assuming the LibreOffice suite is installed, remove the lighter weight alternatives
# remove abiword to avoid doc corruption issues
sudo apt-get remove -y abiword
# sudo apt-get remove -y abiword abiword-common
## or will this do it all?
sudo apt-get remove -y gnumeric

# sudo apt-get autoremove


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

# including some proprietary (non-libre) packages

sudo apt-get install `echo ${DESKTOP_SESSION,}`-restricted-extras -y
# help > https://help.ubuntu.com/community/RestrictedFormats


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
gstreamer		 ### NO LONGER FOUND! ### # none-open formats incl DVDs - also needs post install code below # might be part of other media player like totem
# AUDIO usually works fine out of the box
pulseaudio	                 # should be in by default
pavucontrol	                 # pulse volume control
# pulseaudio-module-bluetooth # if you want to add Bluetooth Audio Sink
guvcview	# support for most webcams

######## Networking ############

libnss-mdns # name resolution
cifs-utils  # mount cifs in fuse
cups-pdf	 	# PDF printer

########### KIDS #############
# for more ideas see...  https://wiki.ubuntu.com/Edubuntu/AppGuide
childsplay gcompris tuxpaint kwordquiz ri-li # infants
tuxtype ktouch tuxmath gbrainy kig kalgebra  # practice
laby kturtle scratch                         # programming 
basic256                                     ### PPA required ### ppa:basic256/basic256 (version for correct syntax)
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

epiphany-browser	      # alternative lightweight browser
transmission			      # torrent client
gftp					          # file transfer client
skype                   # back in the repos since 13.10 - no longer need manual script

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


### Allow 
# play dvds
sudo /usr/share/doc/libdvdread4/install-css.sh 


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
