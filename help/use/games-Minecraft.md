

see also:
* [https://github.com/artmg/lubuild/blob/master/help/use/games.md]
    * other games
* [https://github.com/artmg/lubuild/blob/master/help/diagnose/video-display.md]
    * many gaming issues are down to the video output devices



## Minecraft 

These instructions are mainly focussed on Ubuntu and variants. 
For Raspberry Pi see [https://github.com/artmg/MuGammaPi/wiki/Minecraft] 


### Client - download and install

Log onto your minecraft account then ... 
```
LUBUILD_MINECRAFT_BIN_FOLDER=$HOME/.minecraft
# updater seems to insist on that location
# LUBUILD_MINECRAFT_BIN_FOLDER=$HOME/bin/minecraft
LUBUILD_MINECRAFT_SHORTCUT_FOLDER=$HOME/.local/share/applications
LUBUILD_MINECRAFT_DOWNLOAD_URL=s3.amazonaws.com/Minecraft.Download/launcher/Minecraft.jar

mkdir -p $LUBUILD_MINECRAFT_BIN_FOLDER
cd $LUBUILD_MINECRAFT_BIN_FOLDER
wget -q $LUBUILD_MINECRAFT_DOWNLOAD_URL


# credit - http://www.minecraftforum.net/forums/mapping-and-modding/minecraft-tools/1261334-install-ubuntu-minecraft-installer-update-2-0
wget -q http://www.minecraft.net/favicon.png
mv favicon.png icon.png

# create the Start Menu shortcut / launcher
mkdir -p $LUBUILD_MINECRAFT_SHORTCUT_FOLDER
cat > $LUBUILD_MINECRAFT_SHORTCUT_FOLDER/Minecraft.desktop<<EOF!
[Desktop Entry]
Name=Minecraft
Comment=Build with cubes in a free-roaming game
Exec=java -jar $LUBUILD_MINECRAFT_BIN_FOLDER/minecraft.jar
Icon=$LUBUILD_MINECRAFT_BIN_FOLDER/icon.png
Categories=Game
Type=Application
Terminal=false
EOF!

# refresh menu
lxpanelctl restart

```

As an alternative, there was the `minecraft-installer-peeps` ubuntu package 
that does the download from mojang for you, on top of the OpenJDK runtime. 
Not sure if this has been maintained - see [http://www.omgubuntu.co.uk/2013/04/minecraft-installer-for-ubuntu]


### Performance ##

The graphical performance of minecraft client is measured in FPS (frames per second) 
and you can find your current setting by 

pressing F3??


#### Video Settings

You can increase your FPS by reducing the effort minecraft asks your computer to make, 
changing the Video Settings inside the game itself. 

* View Distance: Short/Tiny
* Clouds: None
* Texture Pack: low res

credit - [http://www.minecraftforum.net/forums/support/unmodified-minecraft-client/tutorials-and-faqs/1871641-minecraft-and-ubuntu-the-guide-v1-0]


#### graphics driver

The Graphics Processing Unit (GPU) in your computer does a lot of work to 
render (draw) each frame you see as you move around the minecraft world. 
You should at least make sure the Graphics driver is the latest version. 

A lot of people recommend using Closed Source drivers from the GPU manufacturer 
(like Intel or NVidea) to get the best performance from the hardware they make, 
but there are a handful of people who suggest they get better results 
with the open source drivers (perhaps because they interact better with the open source X system 
or linux kernel that are both an important part of the software stack on your PC).

For more info and help see 
* [https://github.com/artmg/lubuild/blob/master/help/diagnose/video-display.md]



#### memory settings

If you tell Java how much memory you wish it to use, this may help

Set the minimum and maximum according to (???)

java -Xmx1024M -Xms512M 


Some people suggest increasing the priority of the java executable in task manager


#### java

The minecraft program code uses the java system to translate it to work properly on your specific hardware and operating system. 
By default ubuntu comes with OpenJRE (open source) however the minecraft vendors do NOT support OpenJRE 
and recommend using Oracle's closed code Java Runtime Environment (JRE), either version 7 or 8. 

Notes:

* you may have more that one type of JRE installed at the same time (if you really want), and more than one version too
* Oracle Java 9 is only supported if change your JVM Arguments
	- if it fails with `Error: Game ended with bad state (Exit Code 1)`
	- Edit Profile / Check JVM arguments
	- remove the option clause `-XX:+CMSIncrementalMode`
	- save and re-execute game
	- credit [http://minecraft.gamepedia.com/Tutorials/Update_Java] 

```
# check the current JRE(s) installed
dpkg --get-selections | grep jre

# check the version of the default JRE
java -version
```

Oracle Java is no longer in an officially supported Ubuntu repository. If you want to install it, 
a common choice is to download it directly from Oracle. You may alternatively use the WebUpd8 PPA. 
This is a very simple technique, but the PPA does NOT contain Oracle binaries, 
it simply contains a wrapper which downloads Java from Oracle and keeps it updated. 
You can find more about Java and about the choices at https://help.ubuntu.com/community/Java

```
# http://www.webupd8.org/2012/09/install-oracle-java-8-in-ubuntu-via-ppa.html
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
### EITHER: install JRE only
sudo apt-get install oracle-java8-installer
### OR: install JDK (which includes JRE)
sudo apt-get install oracle-jdk8-installer
# For info on including browser (e.g. Firefox) plugins see http://askubuntu.com/q/48468
```

NB: If you install Oracle Java in Windows for Minecraft clients, the plugins are included. 
For help with removing the plugins (e.g. to only enable Java for local programs like Minecraft) 
see [http://www.howtogeek.com/122934] and  [http://www.ghacks.net/2010/04/25/how-to-remove-the-java-deployment-toolkit-from-firefox/]



##### mods

OptiFine Lite - http://www.minecraftforum.net/forums/mapping-and-modding/minecraft-mods/1272953-1-8-4-optifine-hd-d4-fps-boost-hd-textures-aa-af


#### other

still laggy? - for more ideas see optimise - http://www.makeuseof.com/tag/7-steps-install-optimize-minecraft-linux/

## Minecraft Server

### Download jar

Get the latest server jar file from 
[https://minecraft.net/en-us/download/server]

URL example: https://s3.amazonaws.com/Minecraft.Download/versions/1.8.7/minecraft_server.1.8.7.jar

NB: As at version 1.11.2 this starts fine with Oracle Java 9 
but connecting clients with Java 9 reports
`Unable to access address of buffer`
- fall back to Java 8 which is better supported for now


### Configure 

Mojang server download page recommends the following instructions: [http://minecraft.gamepedia.com/Setting_up_a_server]

You should consider setting the following in `server.properties`

```
# help - [http://minecraft.gamepedia.com/Server.properties]
#
### Basics
#
# what's the level (and folder) called
level-name=my-world
# how does the world name appear to players
motd=My Minecraft World
#
### Online settings
#
# full flexibility with allowing clients without rechecking each ID online when they join
online-mode=false
# Players don't kill each other (i.e. PvE players vs Environment, not Player vs Player)
pvp=false
# opt out of submitting details about the environment (e.g. OS & Java version) you run in
snooper-enabled=false
#
### Gameplay
#
# Decrease your chances of getting killed
spawn-monsters=false
# Go from Easy to Peaceful (see [http://minecraft.gamepedia.com/Difficulty])
difficulty=0
# set Creative mode (see [http://minecraft.gamepedia.com/Game_mode])
gamemode=1 
# with flight
allow-flight=true
```

### Advertise

Minecraft server advertising does not use any of the usual suspects, 
like `avahi` or `bonjour`, but broadcasts `MOTD` to port 4445... 

* Copy the python code from [http://gaming.stackexchange.com/a/238680]
* set your server(s) in the array variable
* create a .desktop file to launch it with `python`

### Troubleshoot

If you need to check which is your java executable:

```
readlink -e `which java`
```

## Resources

### Building and architecture

* UK Building Institute's "Craft Your Future" lessons
	* for Minecraft Education Edition (M:EE) 
	* [http://ciobmc.org/]
+ Greenfield
	* Minecraft's largest city
	* realistic in 1:1 scale
	* [http://www.planetminecraft.com/project/greenfield---new-life-size-city-project/]
+ 

# IN

The following sections have been extracted from old Ubuntu Setup notes and may need some tidying. 

## Minecraft server ##

### Install Oracle Java ###

As a few people have reported issues running Minecraft on OpenJDK-JRE, 
for the moment the devs are recommending using Oracle Java - 
from [http://www.oracle.com/technetwork/java/javase/downloads/index.html http://www.oracle.com/technetwork/java/javase/downloads/index.html] 
download the Java SE 6 Update 31 JRE Linux .bin file (not the .RPM.bin ! )


```
cd ~/Downloads/
wget http://download.oracle.com/otn-pub/java/jdk/6u31-b04/jre-6u31-linux-i586.bin
cd /opt
sudo mkdir java
cd java
sudo mkdir 32
sudo mv ~/Downloads/jre-6u31-linux-i586.bin /opt/java/32
sudo chmod 755 /opt/java/32/jre-6u31-linux-i586.bin
cd /opt/java/32
sudo ./jre-6u31-linux-i586.bin
sudo update-alternatives --install "/usr/bin/java" "java" "/opt/java/32/jre1.6.0_31/bin/java" 1
sudo update-alternatives --set java /opt/java/32/jre1.6.0_31/bin/java
credit - http://sites.google.com/site/easylinuxtipsproject/java
```

### Install Screen ###

If you plan to administer this via SSH then screen helps you multitask and leave processes running when SSH disconnects.

```
# install 
sudo apt-get install screen

# To run screen use
screen
# controls:
# use CTRL-A commands, e.g. using Ctrl-A ?  to see help.

```

### Create minecraft user ###

```
# Most recommendations are to use a distinct user for the server

adduser minecraft

# Now log in as that user

su -l minecraft
```

### Install Minecraft server ###

As the minecraft user put everything in home and you don't need root privileges

```
mkdir minecraft
cd minecraft
wget http://www.minecraft.net/download/minecraft_server.jar
```
### Create config files ###

Run Minecraft server for the first time 

```
java -Xmx1024M -Xms1024M -jar minecraft_server.jar nogui
```
then stop it immediately

```
/stop
```
### Configuring server and mods ###

Now edit the **server.properties** file and set _server-port_ and _motd_

```
cd /home/minecraft/minecraft
# set the level name (folder), server-port, motd, gamemode=1 (creative), etc
sudo vi server.properties
# now add names of users to avoid having to ' op <username> ' them from console 
sudo vi admin.txt
# or should that have been ops.txt ??
help > http://www.minecraftserverhosting.org/minecraft-server-files-folders/
```

#### Mods to consider: ####

* CommandBook
    * requires WorldEdit
    * many extra console cmds for ops & players (less bloat than 'Essentials')
* AdminCmd ?
* ShiftMode
    * toggle Creative or Survival from console
    * http://dev.bukkit.org/server-mods/shiftmode/
* WorldEdit
    * modify worlds 
    * [http://dev.bukkit.org/server-mods/worldedit/] 

```
mkdir craftbukkit
cd craftbukkit
# get the Craft Bukkit beta (for MC 1.2.4 compatibility)
wget http://cbukk.it/craftbukkit-beta.jar
cat > craftbukkit.sh << EOF
#!/bin/sh
BINDIR=$PWD
cd "\$BINDIR"
java -Xmx1024M -Xms1024M -jar craftbukkit-beta.jar
EOF
chmod +x craftbukkit.sh
sh craftbukkit.sh

# Then you'll need to STOP the server onces all the files are created

#you may need to get nightly build for WorldEdit
wget http://build.sk89q.com/job/WorldEdit/lastSuccessfulBuild/artifact/%2azip%2a/archive.zip
unzip -j archive.zip
rm archive.zip
mkdir plugins/WorldEdit
unzip worldedit*.zip -d plugins
wget http://build.sk89q.com/job/CommandBook/lastBuild/artifact/*zip*/archive.zip
unzip -j archive.zip
rm archive.zip
mkdir plugins/CommandBook
unzip commandbook*.zip -d plugins
```

#### Notes on client Mods ####

* TooManyItems
    * quite useful for managing inventory
* Hamachi (p2p vpn client)
    * not needed with DynDNS addressing 

### Updating minecraft ###

Start a shell session. 
NB you can see the [http://www.minecraftwiki.net/wiki/Version_history] 

```
# set v.v.v as the current version number
MCver=V.V.V
sudo /etc/init.d/minecraft stop
su -l minecraft
cd minecraft
wget -O minecraft_server.$MCver.jar http://www.minecraft.net/download/minecraft_server.jar
cp minecraft_server.$MCver.jar minecraft_server.jar
exit
sudo /etc/init.d/minecraft start
```
### Running minecraft automatically ###

Get the script from [http://www.minecraftwiki.net/wiki/Server_startup_script]

```
wget -O minecraft "http://www.minecraftwiki.net/Server_startup_script/Script?action=raw"
```
or consider https://github.com/Ahtenus/minecraft-init which includes bukkit and updates

Check the contents of the file BEFORE installing it!

```
sudo cp minecraft /etc/init.d/minecraft
sudo chmod a+x /etc/init.d/minecraft
sudo update-rc.d minecraft defaults
```
### Operator Console commands ###

/op <name>

make them admin

/gamemode <name> 1

put them into creative mode

/tp <name> <other>

teleport person to other

/toggledownfall

start or stop rain, snow etc

see others in [http://www.minecraftwiki.net/wiki/SMP_Server_commands http://www.minecraftwiki.net/wiki/SMP_Server_commands]

### Restart ###

If you installed the startup scrips, you can use the following to restart it...

```
sudo /etc/init.d/minecraft restart
```
### Saved Worlds ###

Bear in mind that singleplayer mode on Windows Vista saves it's worlds in the following location 

```
C:\Users\Username\AppData\Roaming\.minecraft\saves
```
To copy worlds...

```
cd /home/minecraft/minecraft/
sudo cp -r /mnt/win/users/username/AppData/Roaming/.minecraft/saves/worldname worldname
sudo chown -R minecraft worldname
sudo chgrp -R minecraft worldname
sudo chmod -R 664 worldname
```


