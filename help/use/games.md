
see also:

* [https://github.com/artmg/lubuild/blob/master/help/configure/VM-GPU-Passthrough.md]
    * How to play Windows-only games with your powerful graphics card
* [https://github.com/artmg/lubuild/blob/master/help/diagnose/video-display.md]
    * many gaming issues are down to the video output devices
* []



## Steam

The SteamOS is debian-based, and includes the proprietary Steam client. 
Do they publish instructions for loading the client onto other debian-based systems?

http://steamcommunity.com/groups/steamuniverse/discussions/1/648814395741989999/

Use Debian Installer method via USB 
ensure there is an alternative to "Automated Install" to avoid wasting the entire HDD

### Game controllers

Many games use the Unity3D engine, which includes Rewired to support controllers 
[http://guavaman.com/projects/rewired/docs/SupportedControllers.html] 
but if you still have issues using Game Controllers like a Wiimote or PS3 controller see 
[https://github.com/artmg/MuGammaPi/wiki/Ready-made-input-devices]


### Stream to Pi 

Although the Pi's ARM CPU with OpenGL rendering is too underpowered for
playing modern games with any more realism than Minecraft, it could be 
used to Stream games from the real PC running them

see http://www.pcgamer.com/turning-the-raspberry-pi-2-into-a-35-streaming-pc/
for how to Stream NVidia-based games onto RPi2 using the vendor's Limelight software


### Rocket

but the source code [https://github.com/steamos-community/stephensons-rocket] 
has not been updated for a while. 


## Battle.net

The main objective of this is to get Overwatch working, 
although the suggestion is that Wine may support DirectX9, 
but does not (yet) support the DirectX11 used for Overwatch. 


### Overwatch

Most suggestions claiming to get this working involve a Windows VM. 
It appears that Windows 7 would be a good enough OS for this. 
Would Windows XP or Vista work?

* Windows KVM with GPU passthrough (and much other speculation) [http://us.battle.net/forums/en/overwatch/topic/20744354240]
* Confirmation of good FPS on Windows 10 VM, with link to tips on GPU passthrough [http://us.battle.net/forums/en/overwatch/topic/20744875204]

To set up a VM to run your graphics card in Windows see 
[https://github.com/artmg/lubuild/blob/master/help/configure/VM GPU Passthrough.md]



### Wine 

In the interim, here are links to attempt to get the main Battle.Net client working. 
As well as some DirectX9 games, it seems to support OpenGL games well. 
PlayOnLinux is a front end for Wine. 

* Battlenet Desktop App FAQ [https://eu.battle.net/support/en/article/launcher-update-testing-faq]
* Some workarounds for Wine Battlenet helper [http://us.battle.net/forums/en/hearthstone/topic/20743184131] 
* PlayOnLinux code for battlenet [https://www.playonlinux.com/en/app-2599-BattleNet.html]
* PlayOnLinux battlenet tests validated for SC2 and D3 [https://voat.co/v/Linux/1170041]
* Progress of DX11 on Wine [https://www.reddit.com/r/linux_gaming/comments/4ji9up/progress_of_dx11_support_in_wine/]
* 

### CrossOver

CodeWeavers CrossOver software (commercial, proprietary windows compatibility layer built on Wine) 
As of October 2016 [https://www.codeweavers.com/products/more-information/changelog] 
it does not yet support DirectX11 - see "What Runs" link to recheck specific apps.

* about CodeWeavers involvement in DX11 development for Wine [https://bbs.archlinux.org/viewtopic.php?id=214771]



## simulators

Games based on controlling vehicles in a partially realistic way

### combined

* Rigs of Rods
    * variety of vehicles, not just airborne but road and water-based craft

### flight

* FlightGate
    * Works well in Linux & Windows with variety of graphics adapters
    * supposedly realistic, but not the simplest
* GoogleEarth
    * in-browser version for Chrome
    * much simpler
    * 
* Vega Strike
    * space-based flying game more than flying sim
    * Linux / Windows / OSX
    * trading game elements like Elite
* YSFlight
    * Windows Yes, Linux ???
    * 
* Thunder&Lightning
    * Linux/OSX/Win Fighter flight with tank strategy
    * incomplete with development hiatus between 2007 & 2015
* 



