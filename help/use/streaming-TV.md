
== Streaming TV ==

=== Silverlight replacement ===

Pipelight instructions: http://www.inthebit.it/pipelight-come-installare-silverlight-su-ubuntu-13-10
Pipelight config for skygo: http://xpressubuntu.wordpress.com/2013/09/15/sky-tv-on-ubuntu/

- testing (on JNBBu) gives error [t:6030 / c: 4110]

Pipelight FAQ https://answers.launchpad.net/pipelight/+faqs
some history and architecture on pipelight: http://www.ubuntugeek.com/pipelight-using-silverlight-in-linux-browsers.html
(commands are superceded, but explains how pipelight came from netflix-desktop - see old instructions http://www.techrepublic.com/blog/linux-and-open-source/how-to-get-netflix-streaming-on-ubuntu-1210/ )

Apparently Mono and Gecko are NO LONGER required!

If you want to retatin existing Wine / Silverlight install with...

  sudo apt-get --no-install-recommends install pipelight

A few links to pipelight instructions: http://ubuntuforums.org/showthread.php?t=2029336&page=3
(also mentioned Amazon Instant Video)

recent mentions skygo issues from pipelight: http://ubuntuforums.org/showthread.php?t=2248794 
italians discussing skygo issues even with pipelight: http://forum.ubuntu-it.org/viewtopic.php?p=4611780
Avoid needing Silverlight (for RAI at least): https://addons.mozilla.org/it/firefox/addon/raismth/

### Sky Go ###

"Sky Go lets you stream Sky TV on your mobile, tablet, computer or games console"

http://help.sky.com/articles/sky-go-supported-devices

Apps available for: Android phones & tablets; many iOS devices; Xbox & PS3/4
Microsoft Windows Vista / 7 / 8.1 / 10 with IE9+ or Firefox (NOT Edge)
Also Mac with FireFox or Safari

Requires Microsoft Silverlight browser plugin
Google Chrome no longer supports Silverlight plugin on Mac or Windows

Sky does NOT officially support Sky Go on Linux, 
but their forum's "Spirit of the Community" article 
http://helpforum.sky.com/t5/Sky-Go/READ-THIS-FIRST/td-p/2341669
very politely says that "you can get it working" and that there are 
community members who may be able to help.

==== ?i?e?Light for Sky Go ====

See http://helpforum.sky.com/t5/Archived-Discussions/Linux/td-p/1567121

Most of it is about Pipelight, and making sure that the browser app content 
is happy that it thinks the correct version of silverlight is present

Pipelight is at...
http://fds-team.de/cms/articles/2013-08/pipelight-using-silverlight-in-linux-browsers.html

Silverlight 5 is needed so the Moonlight fork on Winepholio does this
See answers at
http://askubuntu.com/questions/623172/sky-go-keeps-asking-me-to-activate-silverlight

There are references in Kodi Forums too
http://forum.kodi.tv/showthread.php?tid=145312&page=72
http://forum.kodi.tv/showthread.php?tid=189805&page=12
http://forum.kodi.tv/showthread.php?tid=145312&pid=1812164


## Display Mirroring ##

Display Mirroring between mobiles and tablets (e.g. running Android) and TVs or other large media screens 
is most commonly done using the WiFi Direct peer-to-peer networking protocol, which is not the same 
as the normal infrastructure-client WiFi networking arrangement. The bandwidth required for sending HDMI video 
precludes the possibility of allowing simultaneous network connections to interfere. 

Although there are proprietary implementations like Google's Cast to Chromecast dongles, Samsung's AllShare, etc 
the basic feature is know generically as "Miracast". The sending App is also known as the caster, and the receiver 
sometimes known as a Miracast Sink.

For casting / sending Android client software (and maybe some sinks too) see also: [/DROP.IN/Service.IN/Android apps.md]


### Miracast Receiver software ###

Miracast typically works best with vendor-specific dongles like Microsoft's Receiver 
or with Screen cast from Google's Chrome Browser to ChromeCast hardware dongle

Note: Justop Droibox ACE (Android net-top media centre box) does have a Miracast Receiver app and advertises AirPlay services
* see [DROP.IN/Service.IN/Android Justop Droibox Media Center box XBMC.md]

On RPI: [https://www.raspberrypi.org/forums/viewtopic.php?f=36&t=153765]
or [https://www.raspberrypi.org/forums/viewtopic.php?t=60636]

On Arch: [https://www.reddit.com/r/archlinux/comments/459lcq/anyone_have_any_experience_with_miraclecast/]

#### Ubuntu

For a experimental service that is supposed to work with the dbus in ubuntu
https://github.com/albfan/systemd-ubuntu-with-dbus

https://github.com/albfan/miraclecast seems to be the main Linux Miracast Sink left, but there is no PPA

For step by step on sending Miracast FROM ubuntu, see [https://turbolab.it/htpc-807/miracast-ubuntu-guida-miraclecast-linux-515] (in italian)



