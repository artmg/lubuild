
This article is all about manipulating films and songs to be held as data files.
It covers ripping, conversion, metatagging and similar topics.

see also:

*  [https://github.com/artmg/lubuild/blob/master/help/use/Music-and-multimedia.md]
    * playing multimedia files including discs CDs DVDs Blu Rays etc
    * creating playlists
    * uPNP discovery and clients
    * other AV remote control software 
* [https://github.com/artmg/lubuild/blob/master/help/manipulate/music-and-instruments.md]
    * For creating music or playing instruments 
* [https://github.com/artmg/lubuild/blob/master/help/manipulate/photos.md]
    * for working with your own captured images


## IN



## CD ripping 

Options
* Asunder is simple, does MP3s and is in repos - gets some +1s
    * uses CDparanoia under covers (like apparently a lot of rippers) 
    * does not search or save cover art images
    * GTK-based
* Sound Juicer is Ubuntu default but has had issues in past
* abcde CLI that gets lots of +1s
* RubyRipper well +1ed but not in repos


### asunder

NB: Asunder does not search or save cover art images

```
sudo apt-get install -y asunder

# Now installs into options when inserting CD  via MimeType=x-content/audio-cdda
# sudo leafpad /usr/share/applications/asunder.desktop

# If you want to be able to output to MP3 as well as OGG
sudo apt-get install -y lame
# does this include the dependency libmp3lame0 ?

# changes to config stored in ~/.config/asunder
# this example is for very small file sizes (at the cost of quality)
```

* Destination Folder: choose Media.IN/Music.IN/RIP.IN
* Create Playlist: No
* Eject when finished: Yes
* Album Directory (folder name): %A/%L
* Music Filenames: %N %T
* OGG Quality: 1 (or 6 for Oversize)


## DVD ripping 
```
# MakeMKV wraps to single file (nicely for XBMC) but no compression
## see MKV Extractor Qt as GUI
# Handbrake supports MKV too but excellent balance of quality and compression in h264
# these also work with Blu Ray
# AcidRip and dvd::rip are in multiverse 
# help - https://help.ubuntu.com/community/RestrictedFormats/RippingDVDs
sudo apt-get install dvdrip
```


## Music file conversion

### Re-encoding into smaller files

Objective:
* re-encode music files (yeah, I know lossy to lossy is sub-optimal)
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


### cutting an audio track

if you want to extract a short clip of audio from a track, 
for instance to create a ringtone or alert, 
you can use the exact same syntax of ffmpeg as for Video Cutting, 
below, because it does NOT re-encode.

```
ffmpeg -ss <duration> -i input_file.mp3 -t <duration> -codec copy output_file.mp3
# where <duration> is hh:mm:ss (e.g. 01:10:30)
# of the start and length of the segment you want to extract
```


## AV File Conversion

Move the relevant detail from [### Music file conversion]

This is about the decoding and re-encoding utilities themselves, 
more than the front-ends that make them easy to use

* Demux / mux - handle the container format 
* Decode / encode - handle the compression and storage of each image

GStreamer is the back-end that handles interaction between many codecs and the application software
Some older app versions relied on the Gstreamer legacy libraries (e.g. gstreamer0.10-xxxx) 
but fortunately most have moved onto mainstream versions now 



### ffmpeg vs Libav/avconv

At their basis these are 'religious differences' 

* Libav forked from ffmepg in 2011, and was widely used at the time by OSes whose maintainers followed the fork
* a cursory glance at the situation in 2016 suggests that ffmepg is more actively contributed to
* or is it that ffmpeg gets more commits but libav do more testing?
* ffmeg _might_ be in popular use again
* NB: Libav project does NOT equal the libavcodec package - don't get confused (check for l vs L)

? if you have one or the other, how do you tell _which_ package your ffmpeg command utility comes from


#### ffmeg

sudo apt-get install ffmpeg

Examples:
* Video Cutter - extract timed sequence from VOB files
    * VOB is Video Object container format for DVD
    * it contains MPEG program stream video, audio & subtitles (limited variety of compression standards)
    * to demux the video and audio stream, 
    * and Cut them from the start to end frame/time, 
        * -ss <duration> -i input -t <duration>
    * but not to re-encode
        * ffmpeg stream copy mode '-c(odec) copy' omits decoding and encoding
 ffmpeg -ss 00:04:30 -i VTS_01_1.VOB -t 00:07:00 -codec copy My_Movie_Cut.MPG


* (command documentation)[https://www.ffmpeg.org/ffmpeg.html]
* (some useful samples)[http://www.labnol.org/internet/useful-ffmpeg-commands/28490/]
* (load more useful samples)[https://wiki.archlinux.org/index.php/FFmpeg]

### others

* mencoder - nicely matched to mplayer 

* xvidenc ?
* h264enc ?

* what's below the covers of Handbrake and MakeMKV?

## Films

### Blu Rays and DVDs

For some reason the whole subject of Blu Rays and Linux seems overly complex. 
You can get an intro at [http://www.libregeek.org/2014/01/05/a-guide-to-playing-blu-rays-on-ubuntu-linux/]
but once you realise that's the simplified version of the story you might still be worried!

#### start with MakeMKV 

I found a PPA method of installing MakeMKV, but it's not widely mentioned so I'm not sure how trustworthy it is - http://askubuntu.com/a/579156

* Use one of the following **Script installers**
    * **https://github.com/pellcorp/ubuntu/blob/master/bin/update-mkv.sh**
    * http://www.makemkv.com/forum2/viewtopic.php?f=3&t=9451
    * **http://www.makemkv.com/forum2/viewtopic.php?f=3&t=9820**
    * http://www.makemkv.com/forum2/viewtopic.php?f=3&t=5266
* Reboot
* Test it using first command below
```
# help - http://www.makemkv.com/developers/usage.txt
# list all available drives
makemkvcon -r --cache=1 info disc:9999

# alternative way to find device code and see disc title
blkid


# example device path
makemkvcon info dev:/dev/sr0

# back up the disc with decryption to specified folder/path
makemkvcon backup --decrypt --cache=16 --noscan -r --progress=-same disc:0 folder/path/DiscTitleName

##### Streaming your discs #####
# help - http://www.makemkv.com/developers/usage.txt
makemkvcon stream --upnp=1 --cache=128 --bindport=51000 file:/home/family/Videos/backup/CATCHING_FIRE/

# options NMT (using Syabas myiBox protocol extensions) and UPnP (fewer video formats supported in NMT UPnP client)
# see also - http://www.makemkv.com/forum2/viewtopic.php?f=1&t=703

###### view the streams ######

HOST=localhost
# view first title
x-www-browser http://$HOST:51000/stream/title0.ts
# examine all titles and available formats
x-www-browser http://$HOST:51000/


```

see also **uPNP discovery and clients** - _where?_


#### MakeMKV for direct playback

see:

* Kodi overview of bluray playback - http://forum.kodi.tv/showthread.php?tid=217592
* Play discs directly into Kodi - http://www.makemkv.com/forum2/viewtopic.php?f=6&t=8661
* Play discs directly into VLC - http://www.makemkv.com/forum2/viewtopic.php?f=3&t=7009
* play into Kodi with plugin - http://forum.kodi.tv/showthread.php?tid=67420&page=33
* using the libmmbd to play into Kodi on Windows - http://forum.kodi.tv/showthread.php?tid=189402
* 


#### MakeMKV and Handbrake

* Linux make MakeMKV from source - http://www.makemkv.com/forum2/viewtopic.php?f=3&t=224
* list of steps for both - http://www.libregeek.org/2013/06/16/30-days-of-linux-day-6-blu-ray-ripping-time-with-makemkv-and-handbrake-2/


* some alternative software - https://www.reddit.com/r/htpc/comments/2zhntu/alternatives_to_makemkv/


## Music Metadata tagging

see also:
* [MultiOS Data Music Metadata.md] for metadata editors
    * and _old_ notes on Windows apps for compressing oversized music files

### Meta data organisers 

The most popular... do not support WMA!

* kid3-qt - simple and relatively light
* easytag - good range of features, in repos
* puddletag - see below

Other candidates:
* mp3tag on Windows! ... under Wine?
* Picard for MusicBrainz (does MWA?) metadata http://musicbrainz.org/doc/MusicBrainz_Picard/
* TagScanner under Wine (can put cover art into folder not files)
* kid3 (WMA support?) under wine or using KDE4
* entagged (java but supports WMA)
* coquillo - QT-based
    * not sure if there is a debian / ubuntu repo
* Amarok, although more a player and format convertor, has been reported to update WMA tags successfully
* 

#### Exiftool

Although not a specific candidate for the functionality mentioned here, 
**exiftool** is a great CLI utility for basic file metadata manipulation

see:
* [https://github.com/artmg/lubuild/blob/master/help/manipulate/PDF files.md]
    * to view a single file's metadata properties
* [https://github.com/artmg/lubuild/blob/master/help/manipulate/photos.md]
    * to bulk rename files based on meta properties (e.g. date photo or video was taken)
* 


#### kid3-qt 

* use QT version in Lubuntu to avoid KDE dependencies
* Also has CLI: http://kid3.sourceforge.net/kid3_en.html
* uses TagLib for WMA support

```
sudo apt-get install kid3-qt
```


#### Picard 

```
# credit https://musicbrainz.org/doc/Picard_Linux_Install
# available in repos

sudo apt-get install picard

# help http://picard.musicbrainz.org/docs/basics/
```


#### puddletag 

QT-based

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


