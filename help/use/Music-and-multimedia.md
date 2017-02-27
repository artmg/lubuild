
This page is all about **Using** Music and Other Multimedia files (such as Video) 
including some bash commands for generating playlists

NB: this file also includes details of Android Applications used for:
* rendering media including audio
* remote control for media server software


See also:

* [https://github.com/artmg/lubuild/blob/master/help/manipulate/music-and-instruments.md]
    * For creating music or playing instruments see 
* [https://github.com/artmg/lubuild/blob/master/help/manipulate/films-and-songs.md]
    * for ripping CDs DVDs Blu Rays etc
    * manipulating files for the best size and markup
        * including metadata tagging to make collections convenient
    * other kinds of AV file conversion
    * maintaining a catalogue of media owned (even when not ripped)
* [https://github.com/artmg/lubuild/blob/master/help/manipulate/photos.md]
	* image recognition (OCR, QR codes etc)
* For details of some ways to make Music and Multimedia available around your house:
    * [Volumio and MPD](https://github.com/artmg/MuGammaPi/wiki/Volumio-and-MPD)
        * Dedicated headless music player distro based on MPD
        * Also work multi-room using snapcast to send and sync audio
        * see intro below
    * [Media Centre](https://github.com/artmg/MuGammaPi/wiki/Media-Center)
        * Full media centre solutions for Pi, rather than simple audio
    * [Audio-Hub](https://github.com/artmg/MuGammaPi/wiki/Audio-Hub)
        * Other generic solutions for playing music 
	* DNLA / UPnp Media Server
		* [https://github.com/artmg/lubuild/blob/master/help/configure/Networked-Services.md]



## basic media library players 

Requirements:
* build index of local (-ly attached) media files 
** including cover art
* allow browsing by artist / album etc
** also search
* 

### Alternative music players

For current installs see [https://github.com/artmg/lubuild/blob/master/app-installs.bash] 

* on lubuntu default player is Audacious
    * Audacious works but not great interface for finding tracks in big library
    * Not much use for editing playlists (see below) 
    * What will be default app with Lubuntu on LxQt?
* VLC might be getting into album art browsing
    * vlc browser-plugin-vlc vlc-plugin-fluidsynth
    * vlc-plugin-pulse to use pulse instead of ALSA is now automatically included; browser ?? not sure why! ;  
    * vlc-plugin-fluidsynth: if you need to play MIDI files, includes the large but high quality soundfont fluid-soundfont-gm 
    * libavcodec-extra # streaming codecs only if required;
    * Popular choice on Windows and Android platforms too 
        * (where it is used to play WMAs if unspported by Stock player)
* QT-based
    * Clementine has strong fan base and rich features
        * no native WMA support - needs packages depending on gstreamer version it uses
            * Clementine v1.2 needed gstreamer0.10-ffmpeg e.g. from ppa:mc3man/gstffmpeg-keep
            * v1.3 gstreamer1.0-libav
    * Musique is lightweight and QT-based
    * sayonara-player
    * did YaRock continue developing?
    * qmmp? - http://qmmp.ylsoftware.com/
    * SMPlayer - generic player including video formats
* LXMusic might be too simple as well
* Banshee does it out of the box
* Rhythmbox is commonly used
    * Cover Art is still a Third party plug in:
        * sudo add-apt-repository ppa:fossfreedom/rhythmbox-plugins
        * sudo apt-get update && sudo apt-get install rhythmbox-plugin-coverart-browser
    * can preset library using gsettings set org/gnome/rhythmbox/rhythmdb locations or similar
    * https://help.ubuntu.com/community/Rhythmbox#Multiple_Library_Directories

## playlist creation

### bash scripts to create M3U playlist files

```
#### Absolute list of specific subfolder
# the $PWD gives find an absolute starting point, so this is how it returns the names
find $PWD/MyMusicFolder -type f \( -iname \*.mp3 -o -iname \*.wma  -o -iname \*.ogg \) | sort >>"MyFolderPlayList.m3u";

#### One relative list per subfolder 
# create one M3U file for each subfolder of current, 
# with sorted entries, using relative paths from current folder
for D in *; do
    if [ -d "${D}" ]; then
        echo \#EXTM3U >"${D}.m3u";
        find "${D}" -type f \( -iname \*.mp3 -o -iname \*.wma  -o -iname \*.ogg \) | sort >>"${D}.m3u";
    fi
done

#### single relative list with subfolders in reverse order
PLAYLIST_PATHFILE="/home/user/Playlists/Series In Reverse"
# we need to use arrays to properly handle the spaces in filenames
# Note: The wildcard must be OUTSIDE the quotes to get expanded to matches
PATH_RELATIVE_MATCH=("./genre\ folder"/Series*1)

echo \#EXTM3U >"$PLAYLIST_PATHFILE.m3u";
# in case filenames contain spaces we pipe to while instead of for x in backticks do
# as this uses zero termination we need to sort -z as well as -r for reverse
# to handle the spaces in the match string we pass as the array elements
find "${PATH_RELATIVE_MATCH[@]}" -type d -print0 | sort -rz | while read -d $'\0' -r folder ; do
	echo "$folder"
	find "$folder" -type f \( -iname \*.mp3 -o -iname \*.wma  -o -iname \*.ogg \) | sort >>"$PLAYLIST_PATHFILE.m3u";
done


#### old notes
# various at...
# http://linuxreviews.org/quicktips/playlists/index.html.en
find . -name ‘*.mp3′ -execdir bash -c ‘file=”{}”; printf “%s\n” “${file##*/}” >> “${PWD##*/}.m3u”‘ \;
# http://jgiffard.wordpress.com/2013/06/04/create-m3u-playlists-from-the-command-line-on-mac-os-x/
find . -name "*.wma" -printf "%f\n" -or -name "*.mp3" -printf "%f\n"
```

### Playlist editing

If you bulk create playlists using scripts or commands like above, 
you may decide you wish to refine these playlists, 
perhaps filtering out songs you don't appreciate as much

* Requirements - a music player that:
    * easily accepts playlists
    * changes easily saved whilst playing
    * not too fussy about relative or absolute paths
 
Solutions:
    
* Clementine
    * Effective solution
    * M3U playlists output are reasonably robust
    * Player interface makes it relatively easy to manipulate as you listen
* Audacious
    * NOT suitable
    * output to M3U was substandard - Space -> %20 and no #EXTINF directives



## uPNP / DLNA

Note: this is about uPNP AV solutions, like DLNA, rather than UPnP Internet Gateway Device (IGD) port management.

For a general introduction to Hifi UPnP / DNLA Network Audio see [http://www.computeraudiophile.com/content/524-complete-guide-hifi-upnp-dlna-network-audio/]. 

For simpler audio-only solutions see MPD below.


### uPNP discovery 

Avahi discovery (_link to Support Network_) supports mDNS (tcp/udp 5353) and DNS-SD (like apple bonjour) but not SSDP. 
Simple Service Discovery Protocol (tcp/udp1900) is how DNLA (over uPNP) advertises Service Types and Names using 
NOTIFY HHTP to multicast groups.

Discovery is one function of Media Controllers (see below)
but also:
    * (rather old) [uPNP-Inspector](http://coherence.beebits.net/wiki/UPnP-Inspector)

### uPNP clients

* Media Controllers / "Control Point"
    * upplay
        * qt-based
        * in jfdockes PPA [http://lesbonscomptes.com/upplay/downloads.html]
        * maintainer active but would prefer not to be
    * madrigal
        * qt5 OpenHome control point for linux, mac, windows
        * new-ish project
        * author previously developed cantata MPD client
        * [https://github.com/CDrummond/madrigal]
        * no PPA yet
    * gupnp-tools in ubuntu repos
        * control point gupnp-av-cp 
        * cli discovery - gssdp-discover

    * Android Apps (especially open source) 
        * Kazoo (+ predecessor Kinsky) [https://oss.linn.co.uk/trac/wiki/Kinsky] = FOSS multi-platform by high end h/w vendor
        * ControlDLNA = works but not smooth, slightly buggy and original branch now abandoned
        * YAACC – Yet Another Android Client Controller [http://www.yaacc.de/] = 'A flexible UPnP media device controller'
        * SlickDLNA [https://github.com/KernelCrap/android-dlna/] = abandoned?
        * [https://sourceforge.net/projects/droiddlnaplayer/] = 3 years old


* Media Renderers (players)
    * local
        * VLC
        * Kodi
        * Gnome Totem player (needs grilo plugin)
        * compere - may be old
    * remote (i.e. may be connected to over network for rendering)
        * Kodi
            * see UPnP / DLNA Services in [https://github.com/artmg/MuGammaPi/wiki/Media-Center]
        * gmediarenderer (gmrender-resurrect on Pi)
        * ???
        * NB: one Windows 10 there is no longer any built-in DLNA Renderer, and even WMP now comes without
        * bubbleupnpserver?
    * Android Apps
        * FireAir Receiver (e.g. on [Justop Droibox](Android Justop Droibox Media Center box XBMC.md) )
        * NB: for Miracast Receivers (HMDI over WifiDirect) see [Android Apps.md] or [Lub App TV streaming.md]

* Media Servers - some DNLA compliant uPNP server software:
    * ReadyMedia (was miniDLNA) 
    		- used by Volumio - see [Pi Volumio.md]
    		- see also [https://github.com/artmg/lubuild/blob/master/help/configure/Networked-Services.md]
    * [MediaTomb](https://help.ubuntu.com/community/MediaTomb)
    * [Ps3MediaServer](https://help.ubuntu.com/community/Ps3MediaServer)
    * upmpdcli provides a UPnP interface to DNLA control points, but it is actually a client for an underlying MPD service




* Further reading
    * [http://lesbonscomptes.com/pages/homenet-audio.html]
    * [http://elinux.org/DLNA_Open_Source_Projects]
    * [http://elinux.org/UPnP]
    * [https://en.wikipedia.org/wiki/List_of_UPnP_AV_media_servers_and_clients]



## MPC Clients (MPD)

Music Player Daemon (MPD) is a Linux service allowing remote control of rendering music. It is a simpler model than UPnP, but it does have the advantage that the playlist is held by the rendering server, instead being sent track by track by the remote control point client. This makes it more of a room-based solution, rather than 'follow-me' controller-based listening.

For more on MPD, see [https://github.com/artmg/MuGammaPi/wiki/Volumio-and-MPD]

Music Player Clients (MPC), often referred to as MPD clients, include:
* Linux
    * Cantata
        * QT-based and feature rich
        * still some active development
        * Qt version 2.x now upstream in debian repos
    * Quimup
    * QMpdClient
    * 
* Android
    * MPDroid
        * slightly quirky setup for connecting to the server, but a good reliable contender for controlling music
        * does not have a simple way to switch between multiple MPD servers
    * Sound @ Home ?
    * RuneAudio ?
    * MPD Remote ?
    * see also [http://www.androidmeta.com/keyword/volumio]

**upmpdcli** is a special case, as it is client for MPD that exposes itself as a UPnP interface to DNLA control points

For an exhaustive (though rather old) list of MPC clients see [http://mpd.wikia.com/wiki/Clients]


## remote control ###

### candidates ####


Android Apps:
* KODI server
	* Kore (official KODI remote)
		* configure Kodi - http://forum.kodi.tv/showthread.php?tid=221700
	* Yatse
		* can purchase extra features
	* "XBMC Remote" fr.beungoud.xbmcremote
	* See also - http://kodi.wiki/view/Smartphone/tablet_remotes
* SSHD +
	* Home Remote Control 
		* Uses sshd for mouse / keyboard / file access / stats
		* http://linuxlove.eu/remotely-control-ubuntu-pc-android-device/
		* http://tuxdiary.com/2014/12/17/home-remote-control/
		* REVIEW: decent set of features, works as it should!
	* JuiceSSH
		* simple SSH client
	* Connectbot
		*  simple alternative
* LIRC (for old style remotes)
	* what does BeeBox remote use?
	* https://marklodato.github.io/2013/10/24/how-to-use-lirc.html
* Dedicated Server App
	* Blink
		* Touchpad over Bluetooth (dedicated server app)
	* DroidMote
		* Mouse / Kbd / gamepad over wifi (decicated)
	* Remote Mouse
	* AIOR (All in One Remote)
		* over Wifi/BT to Dedicated Svr App
		* predefined settings for popular multimedia apps
	* Unified Remote (URC ?) by Unified Intents
		* commercial with free version
		* free remotes include VLC, Media, Keyboard, Spotify - NOT KODI / XBMC !
	* old list - www.openremote.org - sshmote - gmote?
* Appliance servers
    * Marantz / Denon AV components
        * MyAV
            * reasonable set of features
            * trialware - check others before buying Pro
* Windows Media Player
    * MyRemote ?
    * MultiRemote ?

Feed back into:

* [MuGammaPi/Media Centre]


### Not applicable ####

* EventGhost
	* Windows only


## DJ Mixing 

Lubuntu Candidates:

* ** Mixxx **
* IDJC (pro-oriented)
* ultramixer (freemium?)
* GDAM
* Ardour 
* Jokosher

- Virtual DJ (works under Wine)

? LMMS
? DJPlay
? OpenDJmix
? BPMDJ 
? xwax

See also http://www.linux-sound.org/ddj.html

Android Candidates:
- Virtual DJ Home Edition (Freemium) - also Windows Touch
- CrossDJ (Freemium)

For hardware search "Behringer BCD3000"


