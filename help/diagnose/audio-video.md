audio-video.md
==============

This article is for help with Audio and Video input and output devices and configuration

See also

* for help with graphics cards, video display, drivers etc
	* <https://github.com/artmg/lubuild/blob/master/help/diagnose/video-display.md>
* for help with general hardware components, including radios, etc
	* <https://github.com/artmg/lubuild/blob/master/help/diagnose/hardware.md>

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


