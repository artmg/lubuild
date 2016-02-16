
see also:

* uPNP discovery and clients
    * _where?_

## IN



### CD ripping 

Options
* Asunder is simple, does MP3s and is in repos - gets some +1s (like apparently a lot of rippers) uses CDparanoia under covers  
* Sound Juicer is Ubuntu default but has had issues in past
* abcde CLI that gets lots of +1s
* RubyRipper well +1ed but not in repos

#### asunder

```
sudo apt-get install -y asunder

# Now installs into options when inserting CD  via MimeType=x-content/audio-cdda
# sudo leafpad /usr/share/applications/asunder.desktop

# Not sure about getting LAME working for MP3 output so use ogg

# changes to config stored in ~/.config/asunder
# this example is for very small file sizes (at the cost of quality)
```

* Destination Folder: choose Media.IN/Music.IN/RIP.IN
* Create Playlist: No
* Eject when finished: Yes
* Album Directory (folder name): %A/%L
* Music Filenames: %N %T
* OGG Quality: 1 (or 6 for Oversize)


### DVD ripping 
```
# MakeMKV wraps to single file (nicely for XBMC) but no compression
## see MKV Extractor Qt as GUI
# Handbrake supports MKV too but excellent balance of quality and compression in h264
# these also work with Blu Ray
# AcidRip and dvd::rip are in multiverse 
# help - https://help.ubuntu.com/community/RestrictedFormats/RippingDVDs
sudo apt-get install dvdrip
```

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


