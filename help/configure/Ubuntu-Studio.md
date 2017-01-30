

This article is about installing the Ubuntu Studio distribution 
and preparing for use, especially setting up the multimedia components. 

See also:
* [https://github.com/artmg/lubuild/blob/master/help/manipulate/music-and-instruments.md]
    * for details on the applications software bundled with the distro
* [https://github.com/artmg/lubuild/blob/master/help/understand/about-Sound-software-in-Ubuntu.mediawiki]
    * how the audio subsystem fits together
* [https://github.com/artmg/lubuild/blob/master/help/configure/write-Distro-to-flash.md]
    * prepare your install media
* 



## background ##

This setup starts with a clean standard, full Ubuntu Studio 16.10 installation. 
It assumes you did not choose to install the proprietary extras, 
or did not have connectivity at the time. 


## Keyboard shortcuts

Ubuntu Studio uses XFCE desktop by default (rather than Ubuntu=Unity or Lubuntu=LXDE)

Lubuild instructions not needed:
* Super-P for screen switch
    * already set up by default in XFCE
* CTRL-ALT-T for Terminal
    * XFCE shortcut appears set up for xfce4-terminal, but it does not work!
* 
* 
```
# manually add shortcuts
xfce4-keyboard-settings

# list current shortcuts
xfconf-query -c xfce4-keyboard-shortcuts -l

# neater list
xfconf-query -c xfce4-keyboard-shortcuts -l -v | cut -d'/' -f4 | awk '{printf "%30s", $2; print "\t" $1}' | sort | uniq

# set CTRL-ALT-T for Terminal
xfconf-query -c xfce4-keyboard-shortcuts -p "/xfwm4/custom/<Control><Alt>T" -n -t string -s "xfce4-terminal"
# https://alexander-rudde.com/2014/02/lets-add-some-keyboard-shortcuts-to-xfce4/

# alternative syntax
xfconf-query --channel xfce4-keyboard-shortcuts --property "/commands/custom/<Super>q" --create --type string --set "exo-open --launch TerminalEmulator"
# credit http://askubuntu.com/a/375743

# possible file locations for these settings
# ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml
# /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml
```




## system

```
### Graphic options at startup
# test if this machine uses graphic drivers requiring ...

# add option   nomodeset 
sudo gedit /etc/default/grub

sudo update-grub
```

check which VBE modes can be used with GRUB_GFXMODE to rotate Monitor 1 Left in grub

How can I rotate monitor in greeter (desktop login) ?


## Apps ##

```
#### prepare for unattended install
# credit https://github.com/artmg/lubuild/blob/master/app-installs.bash
sudo debconf-set-selections <<EOF
msttcorefonts msttcorefonts/defoma note
ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula boolean true
ttf-mscorefonts-installer msttcorefonts/present-mscorefonts-eula note
EOF

#### installs
sudo apt-get install -y ubuntu-restricted-extras   # apparently is slightly more up to date than xub..
sudo apt-get install -y gstreamer0.10    # media codecs for listening to or watching mpeg / dvd etc
sudo apt-get install -y cups-pdf
sudo apt-get install -y cifs-utils       # is this needed? libnss-mdns is already in there
sudo apt-get install -y tuxtype ktouch   # touch typing practice apps
sudo apt-get install -y python3-pyqt4 python3-pyqt5    # hplip (incl xsane) is installed but need QT4/5 to fix GUI
sudo apt-get install -y unrar            # add rar capability to gnome archive manager


# alternatives
# sudo apt-get install -y vlc
# not used for now...
# rosegarden - alternative to LMMS
# lilypond - alternative to musescore 

#### setup

# Allow play from DVD
sudo /usr/share/doc/libdvdread4/install-css.sh 

sudo hp-setup


```


### Per User ###

```
# install dropbox
https://github.com/artmg/lubuild/blob/master/user-apps.bash

# When you add user accounts, ensure you add them to the **audio** group
sudo usermod -a -G audio,video,plugdev,netdev,fuse,lpadmin,scanner  login_id_of_user

```

### Real Time Support

```
sudo mv /etc/security/limits.d/audio.conf(.disabled,)
# help - https://help.ubuntu.com/community/UbuntuStudioPreparation
```

