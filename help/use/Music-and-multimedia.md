
This page is all about **Using** Music and Other Multimedia files (such as Video) 
and manipulating the files for the best size and markup (tags or metadata).

See also:

* [Creating Music.md]
    * For creating music or playing instruments see 
* 
    * for ripping CDs DVDs Blu Rays etc
*  [https://github.com/artmg/lubuild/blob/master/help/manipulate/films-and-songs.md]


### Music file conversion

#### Objective 

* re-encode music files (yeh, I know lossy to lossy is sub-optimal)
* to compress (reduce file size) an allow for more music 
    * on players with limited storage media space 
    * whilst maintaining ID3 and other metadata


#### Candidates 

* Sound Converter (GNU)
    * should retain metadata
    * soundconverter should be in repos 
* soundkonverter (QT)
    * is in repos
    * currently requires too many additional libs (c 400MB)
    * try again when QT5 is mainline
* ffmpeg
    * to preserve metadate use 
        * -map_metadata 0 -id3v2_version 3 
        * credit http://stackoverflow.com/a/26109838
    * winff GUI is in repos
* Handbrake ?
* fre:ac (formally BonkEnc)

* Audacity ("chain" feature)
* gnac ?
* does qmmp batch convert ?

see also "MultiOS Data Music Metadata.txt"


#### re-encoding tests

* as per cd ripping below, currently using **asunder** to rip
    * default to OGG as not worked out LAME config yet to produce MP3s
        * need to check Windows and Android compatibility for OGG, may not be natively supported
        * defaulting to quality 1 for compact or 6 for oversize
    * uses CDParanioa for album art and track metadata

##### soundconverter

* sudo apt-get install soundconverter gstreamer0.10-plugins-ugly
* help - http://askubuntu.com/questions/468875/plugins-ugly-and-bad
* Preferences
    * Into folder Media.IN/Music.IN/_compressed
    * Create subfolders : Artist / Album
    * Delete original: do NOT check
    * Replace Messy: CHECK
    * Format: OGG
    * Quality: Very Low (64kbps)
        * Low (96kbps) resulted in 3-4MB files
* 

* later try handbrake ?

### Music Metadata tagging

see also:
* [MultiOS Data Music Metadata.md] for metadata editors
    * and _old_ notes on Windows apps for compressing oversized music files

### Meta data organisers 

The most popular... do not support WMA!

* easytag - good range of features, in repos
* puddletag - see below

Other candidates:
* mp3tag on Windows! ... under Wine?
* Picard for MusicBrainz metadata http://musicbrainz.org/doc/MusicBrainz_Picard/
* TagScanner under Wine (can put cover art into folder not files)
* kid3 (WMA support?) under wine or using KDE4
* entagged (java but supports WMA)
* coquillo - QT-based
    * not sure if there is a debian / ubuntu repo
* Amarok, although more a player and format convertor, has been reported to update WMA tags successfully
* 

NB: if you simply want a CLI tool to view a single file's metadata properties see **exiftool** in [../manipulate/PDF files.md]


#### Picard 

```
# credit https://musicbrainz.org/doc/Picard_Linux_Install
# available in repos

sudo apt-get install picard

# help http://picard.musicbrainz.org/docs/basics/
```


#### kid3-qt 

* use QT version in Lubuntu to avoid KDE dependencies
* Also has CLI: http://kid3.sourceforge.net/kid3_en.html
* uses TagLib for WMA support

```
sudo apt-get install kid3-qt
```


#### puddletag 

Feature limitations:
* Since 0.10.2 WMA support has been dropped (to avoid risk of corruption)
* 1.02 ('current' in 15.04 repos) does not show Album Art
* 1.05 source on github released May 2015

Review: www.ubuntugeek.com/linux-finally-gets-a-great-audio-tagger.html
See: https://fanart.tv/2012/06/organizing-your-xbmc-music-library/

* Edit / Preferences
    * Tag Panel / Add
        * A&lbum Artist
        * albumartist
        * 0
    * Tag Panel / Add
        * Disc &Number
        * discnumber
        * 2
* Columns
    * (add the same two as above)


### DJ Mixing 

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


### media library players 

* build index of local (-ly attached) media files 
** including cover art
* allow browsing by artist / album etc
** also search
* 

Candidates: 
* audiacious is Lubuntu default
** simple but ???
* VLC
** kids use android version on phones as it plays WMAs
* Clementine
**
* qmmp
    * QT based 
    * http://qmmp.ylsoftware.com/

#### Alternative music players

_ moved out from [https://github.com/artmg/lubuild/blob/master/app-installs.bash] _

* on lubuntu default player is Audacious
    * Audacious works but not great interface for finding tracks in big library
* VLC might be getting into album art browsing
    * vlc browser-plugin-vlc vlc-plugin-fluidsynth
    * vlc-plugin-pulse to use pulse instead of ALSA is now automatically included; browser ?? not sure why! ;  
    * vlc-plugin-fluidsynth: if you need to play MIDI files, includes the large but high quality soundfont fluid-soundfont-gm 
    * libavcodec-extra # streaming codecs only if required;
* Clementine has strong fan base and rich features
* LXMusic might be too simple as well
* Banshee does it out of the box
* Musique is lightweight and QT-based
* did YaRock continue developing?
* Rhythmbox is commonly used
    * Cover Art is still a Third party plug in:
        * sudo add-apt-repository ppa:fossfreedom/rhythmbox-plugins
        * sudo apt-get update && sudo apt-get install rhythmbox-plugin-coverart-browser
    * can preset library using gsettings set org/gnome/rhythmbox/rhythmdb locations or similar
    * https://help.ubuntu.com/community/Rhythmbox#Multiple_Library_Directories

#### playlist creation

##### manual

```
## bash script to create M3U playlist files

# create one M3U file for each subfolder of current, with sorted entries, using relative paths from current folder
for D in *; do
    if [ -d "${D}" ]; then
        echo \#EXTM3U >"${D}.m3u";
        find "${D}" -type f \( -iname \*.mp3 -o -iname \*.wma  -o -iname \*.ogg \) | sort >>"${D}.m3u";
    fi
done

### old notes

# various at...
# http://linuxreviews.org/quicktips/playlists/index.html.en

find . -name ‘*.mp3′ -execdir bash -c ‘file=”{}”; printf “%s\n” “${file##*/}” >> “${PWD##*/}.m3u”‘ \;
# http://jgiffard.wordpress.com/2013/06/04/create-m3u-playlists-from-the-command-line-on-mac-os-x/

find . -name "*.wma" -printf "%f\n" -or -name "*.mp3" -printf "%f\n"
```

### DVD ripping 

see [https://github.com/artmg/lubuild/blob/master/help/manipulate/films-and-songs.md]



### uPNP discovery and clients

Avahi discovery (_link to Support Network_) supports mDNS (tcp/udp 5353) and DNS-SD (like apple bonjour) but not SSDP. 
Simple Service Discovery Protocol (tcp/udp1900) is how DNLA (over uPNP) advertises Service Types and Names using 
NOTIFY HHTP to multicast groups.

Note: this is about uPNP AV solutions, like DLNA, rather than UPnP Internet Gateway Device (IGD) port management.

* Discovery is one function of Media Controllers
    * upplay (qt-based) - in jfdockes PPA - http://lesbonscomptes.com/upplay/downloads.html
    * gupnp-tools in ubuntu repos
        * control point gupnp-av-cp 
        * cli discovery - gssdp-discover
    * (rather old) [uPNP-Inspector](http://coherence.beebits.net/wiki/UPnP-Inspector)
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
        * minidlna
    * remote (i.e. may be connected to over network for rendering)
        * Kodi
            * see UPnP / DLNA Services in [https://github.com/artmg/MuGammaPi/wiki/Media-Center]
        * gmediarenderer (gmrender-resurrect on Pi)
        * upmpdcli (front end for MPD) or is this local only?
        * ???
        * NB: one Windows 10 there is no longer any built-in DLNA Renderer, and even WMP now comes without
        * bubbleupnpserver?
    * Android Apps
        * FireAir Receiver (e.g. on [Justop Droibox](Android Justop Droibox Media Center box XBMC.md) )
        * NB: for Miracast Receivers (HMDI over WifiDirect) see [Android Apps.md] or [Lub App TV streaming.md]

* Media Servers - some DNLA compliant uPNP server software:
    * ReadyMedia (was miniDLNA) used by Volumio - see [Pi Volumio.md]
    * [MediaTomb](https://help.ubuntu.com/community/MediaTomb)
    * [Ps3MediaServer](https://help.ubuntu.com/community/Ps3MediaServer)

* Further reading
    * [http://lesbonscomptes.com/pages/homenet-audio.html]
    * [http://elinux.org/DLNA_Open_Source_Projects]
    * [http://elinux.org/UPnP]
    * [https://en.wikipedia.org/wiki/List_of_UPnP_AV_media_servers_and_clients]



### remote control ###

#### candidates ####


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


#### Not applicable ####

* EventGhost
	* Windows only


