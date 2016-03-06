

# Games

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

#### memory settings

If you tell Java how much memory you wish it to use, this may help

Set the minimum and maximum according to (???)

java -Xmx1024M -Xms512M 


Some people suggest increasing the priority of the java executable in task manager


#### java

The minecraft program code uses the java system to translate it to work properly on your specific hardware and operating system. 
By default ubuntu comes with OpenJRE (open source) however it is suggested that 
performance may increase when using Oracle's closed code Java Runtime Environment (JRE), either version 7 or 8. 

Notes:
* you may have more that one type of JRE installed at the same time (if you really want), and more than one version too

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
sudo apt-get install oracle-java8-installer
# NB this installs JRE &JDK
```

#### graphics driver

The Graphics Processing Unit (GPU) in your computer does a lot of work to render (draw) each frame you see 
as you move around the minecraft world. You should at least make sure the Graphics driver is the latest version. 
A lot of people recommend using Closed Source drivers from the GPU manufacturer (like Intel or NVidea) 
to get the best performance from the hardware they make, but there are a handful of people who suggest they 
get better results with the open source drivers (perhaps because they interact better with the open source X system 
or linux kernel that are both an important part of the software stack on your PC).

For more info and help see https://github.com/artmg/lubuild/wiki/Troubleshooting#Drivers 

For getting the very latest versions of the open source drivers see http://www.makeuseof.com/tag/top-7-ppas-repositories-add-ubuntu-based-systems/


##### mods

OptiFine Lite - http://www.minecraftforum.net/forums/mapping-and-modding/minecraft-mods/1272953-1-8-4-optifine-hd-d4-fps-boost-hd-textures-aa-af


#### other

still laggy? - for more ideas see optimise - http://www.makeuseof.com/tag/7-steps-install-optimize-minecraft-linux/

### Server ##

URL example: https://s3.amazonaws.com/Minecraft.Download/versions/1.8.7/minecraft_server.1.8.7.jar

Mojang server download page recommends the following instructions: http://minecraft.gamepedia.com/Setting_up_a_server

#### IN

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


