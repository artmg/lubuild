# Understand about Sound software in Ubuntu

Two pieces of software are frequently mentioned in relation to sound configuration on Linux, especially Ubuntu derivatives: 

* ALSA 
* PulseAudio 

It can be very useful to understand how they differ, how they _can_ compliment each other, and how applications could or should interact with one or both of them, so here’s a _really_ quick intro the architecture of sound systems on operating systems, including Ubuntu-flavoured Linux. 

## The Sound Stack

Sound is produced or recorded by pieces of hardware called sound cards. Applications want to use these to make or pick up sounds, and fortunately modern operating systems offer layers to make it easier for apps to communicate with the hardware 

* Sound card 
  - The device that converts digital audio streams into audible signals and back again. Even though it’s a physical bit of kit, it still runs software. 
* Sound driver 
  - A component of the operating system kernel that communicates directly with a variety of different sound cards from different manufacturers 
* Sound mixer 
  - a piece of software that facilitates the communication between multiple sound devices, and allows users to choose levels, settings, defaults etc, often through a nice graphical interface
* Application 
  - the software that gives the features that people actually want to use, like playing discs, recording sounds, sequencing music scores or talking to each other across continents. 

Each of these bits of software sits _on top of the lower layer_, so together these layers are referred to as a _stack_. 

## Ubuntu sound software 
So now you know about the layers in the sound stack, you will understand the differentiation, that **ALSA** is a **sound driver** and **PulseAudio** is a **sound mixer**. And now you can begin to see how they might compliment each other.

ALSA stands for **Advanced Linux Sound Architecture** and replaced _OSS_ as the default sound driver in the Linux kernel. See the [wikipedia article](http://en.wikipedia.org/wiki/Advanced_Linux_Sound_Architecture) or the [developers’ site](http://www.alsa-project.org/) if you want to read more.

PulseAudio is the sound mixer (also called a _sound server_) that ships by default in Ubuntu and many derivatives. See the [wikipedia article](http://en.wikipedia.org/wiki/PulseAudio) or the [developers’ site](http://www.freedesktop.org/wiki/Software/PulseAudio/) if you want to read more.

So PulseAudio makes it easier for users to control multiple sound devices in their computer, using ALSA to communicate with each of them. However in some cases adding this extra layer can complicate matters for developers of application software, and as versions and features are upgraded, incompatibilities can creep in.

Therefore there are some troubleshooting guides that recommend suspending or removing PulseAudio is the simplest way to make applications work, allowing them to communicate directly with the lower-lever ALSA sound driver. Although this removes some of the useful features of the PulseAudio mixer, applications are what users really want to use, and if cutting PulseAudio out of the equation is a quick way to make an application work, then this sacrifice may be worthwhile.

Alternative solutions could be installing another sound mixer, like [JACK](http://jackaudio.org/) (see also [JACK_Audio_Connection_Kit article](http://en.wikipedia.org/wiki/)), or configuring the application and/or PulseAudio to work together in harmony, or even hoping the next upgrade to the OS or the application includes sufficient bugfixes to make the issue disappear.

However some people might find the _quick fix_ of removing the sound mixer appealing. And some of the user features of sound mixers may still be available via **dmix** (an ALSA plugin), **qasmixer**, or another mixer that is highly integrated into ALSA itself.

### Links

There is an alternative summary of this in a comment in [this article](http://tuxradar.com/content/how-it-works-linux-audio-explained#comment-7448) and the article at the top goes into plenty more detail. (Credit to [Iggy64](http://ubuntuforums.org/showthread.php?t=2102513&amp;p=12444738#post12444738)).

## Troubleshooting links

* https://help.ubuntu.com/community/SoundTroubleshootingProcedure 
* https://wiki.ubuntu.com/Audio
