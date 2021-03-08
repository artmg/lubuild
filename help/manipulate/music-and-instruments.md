
This is mainly concerned with creating your own music or playing instruments, 
rather than playing pre-recorded media

see also:
* [https://github.com/artmg/lubuild/blob/master/help/configure/Ubuntu-Studio.md]
    * setting up a distro that has a lot of these apps ready to use
* [https://github.com/artmg/lubuild/blob/master/help/understand/about-Sound-software-in-Ubuntu.mediawiki]
    * what audio components in the operating system help these apps
*  [https://github.com/artmg/lubuild/blob/master/help/use/Music-and-multimedia.md]
    * listening to music someone else has already created
* [https://github.com/artmg/lubuild/blob/master/help/manipulate/films-and-songs.md]
    * audio file conversion and metadata tagging 



### Midi Keyboard ###

```
# just plug it then check it shows
lsusb

# theory and some pictures explaining different set ups
# https://rafalcieslak.wordpress.com/2012/08/29/usb-midi-controllers-and-making-music-with-ubuntu/

# basics to hear a synth
# http://askubuntu.com/questions/147052/step-by-step-to-run-a-midi-keyboard-input-device-12-04

# step by step to record midi through Jack to Ardour
# http://sungwonchoe.com/how-to-configure-jack-and-ardour-in-ubuntu-linux-for-recording-midi/
```

[play live with Bristol organ](http://zenit.senecac.on.ca/wiki/index.php/Performing_Live_with_Jack,Qsynth,_and_Bristol_Organ)



## Rosegarden - getting started 

Tutorials for helping you get going with Rosegarden, 
a free, open-source Digital Audio Workstation (DAW) package

* Great for beginners: http://www.penguinproducer.com/Blog/2011/11/making-music-in-the-rosegarden/
* Working with piano notation: http://www.rosegardenmusic.com/tutorials/supplemental/piano/
* Using "Hydrogen" drum synth: http://www.rosegardenmusic.com/tutorials/supplemental/hydrogen/
* other tutorials: http://www.rosegardenmusic.com/tutorials/

more added
* incomplete manual: http://www.rosegardenmusic.com/wiki/doc:manual-en


## loops and scores 

MIDI Loops with ready made sequences to use, and full scores

* list of drum loop sites: http://www.howtoprogramdrums.com/the-best-free-midi-drum-loops-on-the-internet/
* older list some now dead: http://www.midiworld.com/sounds.htm
* full scores with some MIDI: http://www.mutopiaproject.org/browse.html
* small selection of free midis in middle of page: http://www.partnersinrhyme.com/midi/index.shtml
* mainly for sale but some may have small free MIDI selection: http://music.tutsplus.com/articles/30-sites-that-serve-up-great-loops-and-samples--audio-13963
* long list may be old: http://www.topsamplesites.com/
* another old list: http://www.loops4free.net/loops-samples-links/

NB: "Royalty Free" means you pay up front, but don't pay more to use them
this is, of course different from "Free" :)

sign up for freebies:
* modeaudio.com
* https://primeloops.com/free-samples/

Mostly proprietary but maybe some open format content
* https://www.ableton.com/en/blog/categories/downloads/

Site with free and public domain sounds...
http://soundbible.com/1264-Sunday-Church-Ambiance.html

http://bedroomproducersblog.com/tag/free-samples/

full orchestral samples to download - http://www.newgrounds.com/bbs/topic/1200140


### Creating your own scores

Software for editing and printing scores. 
Note that an alternative workflow involves editing 
using a 'piano roll' editor such as in Rosegarden. 

* museScore
	* open source cross-platform notation software
	* supports lots of file formats
* LilyPond
	* good alternative for 'music engraving'
	* use with Frescobaldi to compose from text markup
* TuxGuitar
	* notation for guitar tabs
* Rosegarden has a score editor - see above
* Improv-visor
	* for jazz musicians to prepare riffs and solos
	* includes automatic playing of backing for chords and rhythm

Software and services to interpret audio files and 
transcribe the notes 'heard' into musical notation 
(often via MIDI files). 

* PianoScribe
	* https://piano-scribe.glitch.me/
	* live working demo with open source for frontend
	* converts audio uploaded or recorded directly in the browser
	* uses a network called 'Onsets and Frames' based on Majenta and TensorFlow
	* network is trained for polyphonic piano and drum kits, as described in the paper https://arxiv.org/pdf/1710.11153.pdf
* AmazingMidi
	* abandoned freeware to produce MIDI from WAVs
* Transcribe
	* includes audio recognition
	* 30 day free trial
	* AnthemScore is the paid software that some people recommend for this
* ScoreCloud
	* service that some people said was reliable for transcribing an audio recoording automatically
	* freemium service does not allow export on free plans
* 


## improving your set up 

* add other software: http://www.rosegardenmusic.com/tutorials/qsynth-rosegarden/index.html
* hardware and soundfonts: http://www.rosegardenmusic.com/tutorials/qsynth-rosegarden/ImprovingYourSystem.html

This might be a better / easier way to install FluidSynth
* https://help.ubuntu.com/community/Midi/SoftwareSynthesisHowTo#Installing_FluidSynth

* software MIDI Sequencers
** FluidSynth
** TiMidity++
** ZynAddSubFX (may only support single voice)
** generic DSSI syth plugin interface (Disposable Soft Synth Interface)

### Notes on other software 

* Mixxx - DJ beat-matching mixer (open source)
* 

other DAW:
* Hydrogen drum machine
* LMMS (originally Linux MultiMedia Studio)
* MusE
* Qtractor


* see also extensive lists by category at http://linux-sound.org/


## File Extensions

Here are typical contents and specific editing software for file extensions you might commonly see:

* WAV - used for recordings and samples

* MID - generic MIDI files
* SMF - alternative MIDI container (Standard Midi File)

* CSD - CSound files contain both Score and Orchestra (instruments as functions) elements
* LilyPond - score format for engraving musical notation or outputing MIDI
* MusicXML - notation format

* AIFF - may contain recordings, samples and MIDI-style "Apple Loops" http://en.wikipedia.org/wiki/Audio_Interchange_File_Format#AIFF_Apple_Loops
* REX2 - compressed audio sample loops with tempo matching markers

open source DAW formats
* RGD - Rosegarden
* ARDOUR - Ardour

proprietary Digital Audio Workstation (DAW) software formats
* A?? - Albeton - various files for https://www.ableton.com/en/articles/filetypes-used-by-ableton/
* LOGIC - Apple Logic Pro (originally C-Lab)
* REASON - PropellerHeads Reason 
* FL_STUDIO - previously known as Fruity Loops
* Native Instruments - "Komplete" 

see also:
* http://www.native-instruments.com/en/products/komplete/drums/battery-4/sample-formats/

