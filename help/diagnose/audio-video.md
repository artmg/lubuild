audio-video.md
==============

This article is for help with Audio and Video input and output devices and configuration

See also

* <https://github.com/artmg/lubuild/blob/master/help/diagnose/video-display.md>
	* for help with graphics cards, video display, drivers etc
* <https://github.com/artmg/lubuild/blob/master/help/diagnose/hardware.md>
	* for help with general hardware components, 
	* including bluetooth basics and other radio config, etc
* <https://github.com/artmg/lubuild/blob/master/help/manipulate/films-and-songs.md>
    * Use recording programs to rip content from media source devices

It might help if you read a little [background on the Linux sound software stack](https://github.com/artmg/lubuild/blob/master/help/understand/about-Sound-software-in-Ubuntu.mediawiki)

There are also detailed troubleshooting steps in the Ubuntu docs <https://help.ubuntu.com/community/SoundTroubleshootingProcedure>


# Audio

## ALSA

Alsa is the sound driver, 
but is often used with its own sound mixer:

* `alsamixer` a terminal user interface to control devices and levels
* `amixer` for scriptable command line control of the same

### Look for devices

Aside from alsamixer above you can see devices:

`cat /proc/asound/cards`

### Basic sound test

```
# play test sound
aplay /usr/share/sounds/alsa/Front\_Center.wav
# credit - <https://help.ubuntu.com/community/SoundTroubleshooting>
```

## Bluetooth Audio Sink

If you get \"Stream Setup Failed\" when connecting to Audio Sink\...

```
# assuming you already have the following installed
# pavucontrol pulseaudio blueman (desktop icon)
sudo apt-get install pulseaudio-module-bluetooth
pactl load-module module-bluetooth-discover # save yourself a restart
# credit - https://zach-adams.com/2014/07/bluetooth-audio-sink-stream-setup-failed/
# screenshots with mw600 - http://myrek.pl/?p=1283

# Older notes...

/etc/pulse/system.pa
### add at the end of the file
### Automatically redirect to newly available sinks
load-module module-switch-on-connect

# credit > http://ubuntuforums.org/showthread.php?t=2069124
/etc/bluetooth/audio.conf
AutoConnect=true
```


## PulseAudio

```
# Restart Audio
# <http://askubuntu.com/questions/230888/is-there-another-way-to-restart-ubuntu-12-04s-sound-system-if-pulseaudio-alsa-d>
# Troubleshooting help - <http://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/PerfectSetup/>

pulseaudio -k && sudo alsa force-reload

# Now you should reboot and try again
```

```
pulseaudio
# gets volume control in panel
#  and fn key vol?
# what about pavucontrol?
# help > https://help.ubuntu.com/community/Lubuntu/Setup#Sound
```


## Audio routing software

_(move OUT to music production?)_

The standard system mixers mentioned above 
are normally all you need to flow sound in and out 
of your system. However, if you are trying 
anything more complicated, such as flowing sound 
between different applications, you might 
need some audio routing software. 

JACK is cross-platform, open-source software 
that allows you to specify where sound comes out of 
one piece of software, it then goes into another. 
It works well on Linux, Windows and Mac 
and should be able to operate at low latency. 

Note that people working on sound recording 
might want to consider a low-latency kernel 
configuration, as found on Ubuntu Studio, 
so that the processor is sensitive to the needs 
of a smooth, consistent sound stream and 
prioritises processes and interupts 
to avoid human-detectable gaps in audio processing. 

Alternatives to JACK include Soundflower and Black Hole on the Mac, Synchronous Audio Router on Windows, and the freemium VB-Audio Virtual Cable for Windows and Mac. 

### Microphone pre-processing

An example of why you might need sound routing is 
if you want to pre-process your microphone input. 
If you simply record with OBS or Audacity, they 
have microphone set-up like equalisation built in, 
or available using the free [Reaper VST plugins](https://reaper.fm/reaplugs). 
If however you want to equalise for video streaming apps, then you'll need to route from your EQ to your conference client. 

`calf-plugins` in the Ubuntu repos will work with JACK 
to route your System IN through Pulse Audio JACK to 
the Calf Studio Equaliser - see this [walkthrough](https://medium.com/@kaerumy/ubuntu-linux-high-quality-sound-processing-5be177c556a0). They are `LV2` open-standard audio plugins, so can be made to work on macOS. 

EqualizerAPO is an open source Windows program, 
driven by a text config file. You might want to use a 
GUI such as Peace Equaliser or Room EQ Wizard. 
You can use the ReaPlugs Reaper VST Plugins with it ([e.g.](https://antlionaudio.com/blogs/news/removing-background-noise-with-equalizer-apo-and-reapers-reafir)). Alternatively you can install LightHost open source VST host and Virtual Audio Cables to 'wire up' the reaplugs [manually](https://antlionaudio.com/blogs/news/sound-booster-and-noise-reduction-for-pc-light-host-and-reaper). Alternative VST hosts include PedalBoard (or Cantabile Lite).

AU Lab is the Audio Unit software from Apple, 
which you can get using `brew install --cask au-lab`. 
See [this walkthrough](http://osxdaily.com/2012/05/18/equalizer-for-all-audio-mac-os-x/) of setting up an EQ routed by Soundflower. 
eqMac is an open source mac equaliser, but it 
does rely on a web interface (tho you can get that to run locally). eqMac2 is a fork with its own interface, but I'm not sure if it can do input.

### VST hosts

If you want a cross-platform, open source 
host for audio plugins, your choices include:

* Carla
	* supports lv2, vst(x), au, etc
	* available via package managers
* Element
	* supports AU, VST 2/3
* Pedalboard 2
	* currently only Windows and macOS
* 


## Other Sound issues


# Webcam


```
~/.config/guvcview/video0
# force use of PulseAudio (sound API: 0- Portaudio  1- Pulseaudio)
snd_api=1
# see also - http://www.ideasonboard.org/uvc/

# for other ideas on troubleshooting odd webcam behaviour google for
uvcvideo quirks 

# some systemwide settings can be changed using modprobe
# e.g. 
echo 'options uvcvideo quirks=2' | sudo tee -a /etc/modprobe.d/uvcvideo.conf
# credit - http://ubuntuhandboo k.org/index.php/2013/10/disable-laptop-camera-ubuntu-13-10-saucy/

# help - http://kylewilliams.co.za/2009/03/05/getting-the-lenovo-sl300-camera-to-work-on-linux/comment-page-1
# see also - http://blog.gmane.org/gmane.linux.drivers.uvc.devel

sudo apt-get remove uvcdynctrl
# stops PC becoming totally unusable when 
# /var/log/uvcdynctrl-udev.log grows to fill disk
# credit > https://bugs.launchpad.net/ubuntu/+source/libwebcam/+bug/811604
```

## Browser Media Devices

WebRTC (Real Time Communications) is a widely-used 
open-source framework for accessing media devices 
like webcams and microphones, from browsers. 
Of course, for privacy, the OS and/or browser 
should prompt you to ask whether you will allow 
any app and/or site to listen to or watch you. 

The great thing about WebRTC is that many 
modern video conference providers 
have a web-only client that allows you to join calls 
on their service without having to download 
(and maintain updates on) their clients. 

If you want to check whether WebRTC is working 
from your browser, visit

https://www.webrtc-experiment.com/DetectRTC/

for a good level of diagnositc output.
