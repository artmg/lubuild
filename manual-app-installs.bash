#!/bin/bash

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



##################################
### SKYPE

# since 13.10 skype is back in partner repos
# (it dropped out of repos for a release or so)
# along with fixes to work in Ubuntu with PulseAudio
# (like the PULSE_LATENCY_MSEC setting) 
# so these instructions are redundant for now

#case $(uname -m) in
# x86_64)
# (cd ~ && wget http://www.skype.com/go/getskype-linux-beta-ubuntu-64)
# ;;
# i?86)
# (cd ~ && wget http://www.skype.com/go/getskype-linux-beta-ubuntu-32)
# ;;
#esac
## credit > http://www.wikihow.com/Install-Skype-Using-Terminal-on-Ubuntu-11.04
#sudo dpkg -i getskype-*
#sudo apt-get -f install -y && sudo rm getskype-*
## credit > http://www.noobslab.com/2012/11/install-latest-skype-41-in-ubuntu.html
##
## (ensure Skype does not listen at port 80 or 443)


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
