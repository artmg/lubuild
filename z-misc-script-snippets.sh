#!/bin/bash

cat "$0"
echo
echo FYI: these are shell script samples (snippets), not meant to be run!
echo
read -p "Press [Enter] key to end"
exit 1

# see also:
# * https://github.com/artmg/lubuild/blob/master/help/manipulate/files-and-folders.sh
# * https://github.com/artmg/lubuild/blob/master/help/use/Music-and-multimedia.md
#    * for and find to output to playlists
#


### OS and Version ###

# use ubuntu version as variable
#
VERSION=`lsb_release -sd | cut -c 8-`
echo Configuring for Ubuntu ${VERSION}…

#
source /etc/lsb-release
echo $DISTRIB_RELEASE

### Apps ####

#
if dpkg -s "$PACKAGE_NAME" 2>/dev/null 1>/dev/null; then
 echo "Package $PACKAGE_NAME is installed."
else
 echo "Package $PACKAGE_NAME isn't installed."
fi

# list all current installations into a file
sudo dpkg --get-selections | grep '[[:space:]]install$' | \awk '{print $1}' &gt; package_list
# then use the list to install (missing) packages on another machine
cat package_list | xargs sudo apt-get install
#



### desktop files as example for Variable Arrays

#!/bin/bash
WEBSITE=("torios.org" "duckduckgo.com")
NAME=(ToriOS duckduckgo)
ICON=(www-browser firefox)
for ((i=0;i<2;++i));do
echo -e "[Desktop Entry]
Encoding=UTF-8
Exec=firefox ${WEBSITE[i]}
Icon=${ICON[i]}
Terminal=false
Type=Application
Categories=Network;
Name=${NAME[i]}" >> ~/Desktop/${NAME[i]}.desktop
chmod a+rx ~/Desktop/${NAME[i]}.desktop

# credit - https://lists.ubuntu.com/archives/lubuntu-users/2014-September/008496.html


## Fonts

# install fonts
# cp *.ttf ~/.fonts/fontname
# sudo cp /usr/share/fonts/fontname
# or copy by hand  -  alt-f2   gksu pcmanfm /usr/share/fonts/

# refresh font cache to use new fonts immediately
sudo fc-cache -f -v
# credit http://askubuntu.com/a/3706


## ls examples

# Cut part of name and sort
ls | cut -d'.' -f3- | sort -r
# Sort on date with gaps
find . -iname "*FileNamePateern*" -maxdepth 1 -printf '%TY-%Tm-%Td\t%f\n' | sort -r | awk -v i=1 'NR>1 && $i!=p { print "" }{ p=$i } 1'

## sed examples

# wrap with quotes part of a CSV in case it contains commas
sed -i -E 's/^(.{11})(.{66})(.*)/\1\"\2\"\3/' filename
# this quote delimts the entire portion from column positions 12 to 77
# wraping with quotes was simpler than substituting ONLY within that range of column positions!

