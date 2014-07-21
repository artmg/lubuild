#!/bin/bash

# request sudo password before getting stuck in...
sudo echo


####################################
### *** PREPARE REPOSITORIES *** ###
####################################

# backup software sources
sudo cp /etc/apt/sources.list{,.`date +%y%m%d`}
# Add partner
sudo add-apt-repository -y "deb http://archive.canonical.com/ $(lsb_release -sc) partner"
# help > https://help.ubuntu.com/community/Repositories/CommandLine

# Prepare for repository installs
sudo apt-get update



###################################
### *** REMOVE BUNDLED APPS *** ###
###################################

### Clean up OS install

sudo apt-get remove -y unity-lens-shopping  # prevent purchasable items appearing in software list
# credit > http://www.omgubuntu.co.uk/2012/10/10-things-to-do-after-installing-ubuntu-12-10

# avoid this 'dependendency only' package being removed when a dependee is removed
if [[ $DESKTOP_SESSION == Lubuntu ]] ; then
 sudo apt-mark manual lubuntu-desktop ;
fi
# credit - https://help.ubuntu.com/community/Lubuntu/Documentation/RemoveLubuntuDesktop

sudo apt-get remove -y abiword		# remove abiword to avoid doc corruption issues
# sudo apt-get remove -y abiword abiword-common
## or will this do it all?
# sudo apt-get autoremove



######################################
### *** *** *** BASICS *** *** *** ###
######################################

# including some proprietary (non-libre) packages
# pre-answer the accept EULA to avoid the install waiting
sudo debconf-set-selections <<EOF
msttcorefonts msttcorefonts/defoma note
ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula boolean true
ttf-mscorefonts-installer msttcorefonts/present-mscorefonts-eula note
EOF
# credit - https://code.google.com/p/installit/source/browse/install.ubuntu-restricted-extras.sh
# NOTES: to check the input to set selections use --checkonly
# to see what is set install debconf-get-selections using sudo apt-get install debconf-utils
# previously....
# sudo sh -c "echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections"
## credit > http://askubuntu.com/questions/16225/how-can-i-accept-microsoft-eula-agreement-for-ttf-mscorefonts-installer
sudo apt-get install `echo ${DESKTOP_SESSION,}`-restricted-extras -y
# help > https://help.ubuntu.com/community/RestrictedFormats


####################################
### *** *** APPLICATIONS *** *** ###
####################################

# Supersedes list in HTML doc section - Applications - General Apps

#! / bin / bash
cat > ./package_list <<EOF

######## ALL MACHINES ############

### General Utilities ###
geany      # syntax highlighting editor - # alternatives: gedit (ubuntu default), sublime text??,  xemacs21 (no app menu shortcut), vim (_really_?), gVim?
baobab     # graphical disk usage analyser
flashplugin-installer	 # Adobe Flash plugin for browsers - alternatives are swfdec-gnome or gnash
cups-pdf	 	# PDF printer
xmlstarlet # used by LUbuild for changing XML config files

####### MultiMedia ##########
gstreamer		 ### NO LONGER FOUND! ### # none-open formats incl DVDs - also needs post install code below # might be part of other media player like totem
pulseaudio	 # should be in by default
pavucontrol	# pulse volume control
# AUDIO usually works fine out of the box unless you want to use Bluetooth Audio Sink

# vlc vlc-plugin-esd mozilla-plugin-vlc

### Alternative music players ###

# on lubuntu default player is Audacious
# Audacious works but not great interface for finding tracks in big library
#
# consider alternative like:
#
# VLC might be getting into album art browsing
# vlc browser-plugin-vlc  # vlc-plugin-pulse to use pulse instead of ALSA is now automatically included; browser ?? not sure why! ;  
## libavcodec-extra # streaming codecs only if required;
#
# Clementine has strong fan base and rich features
#
# LXMusic might be too simple as well
# Banshee does it out of the box
# Musique is lightweight and QT-based
# did YaRock continue developing?
# Rhythmbox is commonly used
## Cover Art is still a Third party plug in:
### sudo add-apt-repository ppa:fossfreedom/rhythmbox-plugins
### sudo apt-get update && sudo apt-get install rhythmbox-plugin-coverart-browser
## can preset library using gsettings set org/gnome/rhythmbox/rhythmdb locations or similar
## https://help.ubuntu.com/community/Rhythmbox#Multiple_Library_Directories


######## Networking ############

libnss-mdns # name resolution
cifs-utils  # mount cifs in fuse


######## LAPTOPS ############
guvcview		# support for most webcams
skype     # back in the repos since 13.10 - no longer need manual script


########### KIDS #############
# for more ideas see...  https://wiki.ubuntu.com/Edubuntu/AppGuide
childsplay gcompris tuxpaint kwordquiz ri-li # infants
tuxtype ktouch tuxmath gbrainy kig kalgebra  # practice
basic256 laby kturtle                        # programming
celestia stellarium kstars marble kgeography # geo-astro
aisleriot airstrike glchess glines gnect gnibbles gnobots2 gnome-sudoku  # play
gnomine gnotravex gtali iagno gnotski fraqtive khangman solfege          # play
# no longer in repos
# gnome-mahjongg klotski lightsoff quadrapassel swell-foop

hydrogen rosegarden   # Music


########### General purpose ###############

gimp inkscape dia-gnome scribus # Design
libreoffice		# office - prefer to replace abiword - should we remove gnumeric too?





############## Specialist stuff ################

thunderbird  # PIM that works well on Lubuntu AND is available on PortableApps.com, 
vym          # mind-map / notes
# gnucash     # Busines app
workrave # encourage regular breaks for posture and eyes 
meld			   # file and folder diffs...
 #  alternatives: xxdiff - also kdiff3 (floss) + diffMerge (free) are Win/Nux - http://askubuntu.com/questions/312604/how-do-i-install-xxdiff-in-13-04 
recoll       # filesystem search engine

### Internet Clients ###
epiphany-browser	 # alternative lightweight browser
transmission			   # torrent client
gftp					         # file transfer client

### conversion tools ###
pandoc	# convert documents between markup formats # sample command # pandoc -f markdown -t html -o output.htm input.txt
pdftk    # manipulate PDF files (e.g. split, combine) as alternative to installed GhostScript # see http://askubuntu.com/questions/195037/is-there-a-tool-to-split-a-book-saved-as-a-single-pdf-into-one-pdf-per-chapter/195044#195044
readpst  # convert Outlook PST mailbox file into VCards and other files containing the data from each mailbox folder # consider also pst-utils?
calibre		# convert docs to AZW kindle format for USB download
ocrfeeder # image to text - includes tesseract engine
# txt2tags
# alternative GUI for editing local Contacts?
# What about gVim with vCard syntax
# will OpenContacts work on Wine? - http://www.fonlow.com/opencontacts/Developer/BigPictures.htm

### sub-systems ###
python					# code execution
wine       # windows emulation

# see lubuild manual-apps-per-user.bash for more - https://github.com/artmg/lubuild/blob/master/manual-apps-per-user.bash


########## Other Candidates ###########

# VERY comprehensive list of alternatives...
# see - http://debianhelp.wordpress.com/2013/11/19/to-do-list-after-installing-ubuntu-13-10-aka-saucy-salamander-os-2/

# decompression
# for ubuntu, p7zip for 7z format (fits into fileroller)
# or for xubuntu, xarchiver (includes p7zip)

# jockey-gtk
# hardware drivers 

# WSYIWYG html editor - kompozer no longer in repos
# see > https://help.ubuntu.com/community/InstallKompozer 
# alternatives: http://www.bluegriffon.org/ although not in repos
# What about Amaya?
# Is BlueFish visual? Aptana is more web dev

EOF

cat package_list | while read line ; do line=${line%%\#*} ; [ "$line" ] && sudo apt-get install -y $line ; done 
#cat package_list | while read line ; do line=${line%%\#*} ; [ "$line" ] && echo $line ; done 
# credit - http://dbaspot.com/shell/406732-ignoring-comments-blank-lines-data-file.html#post1357732
#
# previously did not ignore blanks or handle inline comments....
# while read -r line; do [[ $line = \#* ]] && continue; sudo apt-get install -y $line; done < package_list
# while read -r line; do [[ $line = \#* ]] && continue; echo -e "$line"; done < package_list
# credit > http://mywiki.wooledge.org/BashFAQ/001


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
