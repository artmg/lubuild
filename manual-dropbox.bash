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
   (cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -)
 ;;
 i?86)
   (cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86" | tar xzf -)
 ;;
esac


# and first time around you will need to configure it with your account
# If you choose "Advanced" setup you can choose where to store your files locally


# create the Start Menu shortcut
cat > ~/.local/share/applications/dropbox.desktop<<EOF
[Desktop Entry]
Name=Dropbox
Comment=Share your files between computers
Exec=$HOME/.dropbox-dist/dropboxd
Icon=$HOME/.dropbox-dist/images/emblems/emblem-dropbox-syncing.icon
Categories=Network
Type=Application
Terminal=false
StartupNotify=true
EOF

## if you need to refresh the Start Menu  
# lxpanelctl restart


# this will launch the daemon
~/.dropbox-dist/dropboxd

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

