#!/bin/bash

#####################################
### Apps requiring manual install ###
#####################################

#################################
### DROPBOX

# install from repository
sudo apt-get install nautilus-dropbox -y
dropbox start -i

# Manual install
# help > download URLs from https://www.dropbox.com/install?os=lnx
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

# *** still need to configure browser
# https://wiki.archlinux.org/index.php/dropbox#Context_menu_entries_in_file_manager_do_not_work

# help > http://www.dropboxwiki.com/Using_Dropbox_CLI
mkdir -p ~/bin
wget -O ~/bin/dropbox.py "http://www.dropbox.com/download?dl=packages/dropbox.py"
chmod +x ~/bin/dropbox.py
# ~/bin/dropbox.py help

## third part hack script to move dropbox folder programmatically...
# https://whatbox.ca/wiki/Dropbox

# in case of issues with Ubuntu not showing panel icon see
# workaround > http://itsfoss.com/solve-dropbox-icon-ubuntu-1310/
