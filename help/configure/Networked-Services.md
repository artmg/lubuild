Networked Services
==================

## Autodiscovery ##

To set allow basic local autodiscovery of services on your device...

```
### NAME RESOLUTION ###
# enable mDNS '.local' name resolution (only needed on Lubuntu, is already enabled on Ubuntu)
# credit - http://superuser.com/a/725533
 
sudo apt-get install -y libnss-mdns
# this also auto-adds the mdns entries to /etc/nsswitch.conf
# later perhaps consider the full Avahi / ZeroConf stack
```

For clients you can use to discover services advertised via mDNS 
see Discovery / Services in Network Diagnostics [https://github.com/artmg/lubuild/blob/master/help/diagnose/network.md#Discovery]

## Sharing Folders ##

### Locally ###
```
# to share folders locally use bindfs to mount a location in different places
sudo apt-get install bindfs
# help > https://help.ubuntu.com/community/Bindfs-SharedDirectoryLocalUsers

# use symlinks if you want it to appear elsewhere for the other users
# .e.g. ...
ln -s -T /home/shared /home/username/Documents/Pictures
```
### Across LAN ###

#### Prepare ####
```
## FIRST Ensure underlying disks are mounted at logon
##  - via GUI using Disks program
# gnome-disks
##  - - Partition / Settings / Edit Mount Options
##  - - uncheck automount  |  choose UUID= option  |  edit mount point to use Label
##  - via CLI in /etc/fstab
# sudo editor /etc/fstab
##  - - then Create the mount point and mount it
# sudo mkdir /mnt/Label1
# sudo mount -a
```
####Choices####

; Samba
: Heavier | Windows compatible | ??Secure?? | common | simple from client
; STFP (FTP over SSH)
: 
; NFS
: lightwight | can automount in fstab or avahi (https://wiki.archlinux.org/index.php/avahi#NFS)
: see https://help.ubuntu.com/community/SettingUpNFSHowTo
; Avahi - Giver
: Push only!

#### Share with Samba ####

Below are simple instructions for setting up a basic Samba share in Lubuntu. 
For more explanation, background, and further examples of advanced use 
such as multiple shares, sharing printers and optical drives, 
or for details on accessing them with linux clients 
please see [https://github.com/artmg/lubuild/blob/master/help/configure/network-shares-with-Samba.md]

##### OUT

* dedupe between ...
 * here
 * Samba [https://github.com/artmg/lubuild/blob/master/help/configure/network-shares-with-Samba.md]
  * including WINS and Windows access
 * sharing printers - [https://github.com/artmg/MuGammaPi/wiki/Print-server]

```
##### SAMBA ### 
sudo apt-get install -y samba

# back up original
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.original
# save as master
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.master
# edit master file
sudo gnome-text-editor /etc/samba/smb.conf.master


##### Sample shares ####
# unauthenticated access to a share
cat <<EOF | sudo tee /etc/samba/smb.conf.master 
[ShareName]
path = /path/to/files
comment = my readonly guest viewable share
# at samba version 3.6.3 the following are defaults
available = yes
guest ok = yes
browsable = yes
read only = yes
# deprecated options
# writable = (opposite of read only = )
# public = (equivalent to guest ok = )
EOF

# test the master file, create real conf file and restart
testparm -s /etc/samba/smb.conf.master && testparm -s /etc/samba/smb.conf.master | sudo tee /etc/samba/smb.conf && sudo /etc/init.d/samba restart
```

#### Sharing folders between computers 

If you want to begin sharing in either direction, you should install the features you require:

```
# ACCESS REMOTE SHARES
# smbfs access remote windows CIFS shares
# winbind use WINS to resolve windows hostnames
# smbclient access remote windows CIFS shares
sudo apt-get install -y smbfs winbind smbclient
```

#### Accessing Windows shares 

##### Prepare name resolution and CIFS 

Before you access Windows machine for the first time you should

```
# set up WINS name resolution
sudo nano /etc/nsswitch.conf
# on the hosts line add wins before dns </pre>
Then to mount the share...

<pre>sudo mkdir /mnt/sharefolder
sudo mount -t cifs //servername/sharename /mnt/sharefolder -o username=xxx,password=yyy</pre>
or you may have to specify the domain too

<pre>sudo mount -t cifs //servername/sharename /mnt/sharefolder -o username=xxx,password=yyy,domain=zzzz</pre>
NB: don't forget that the C$ admin share is often locked down in modern Windows versions
```

#####  Making shares accessible to Windows ===

see Lubuild / Collector / Services / Sharing Folders
###### Sample global ====
```
[global]
# Allow use of computer names
wins support = yes
# don't insist on authenticating users
security = share</pre>
```
###### Temporary shares ====

 sudo shares-admin

#####  WebDAV ===

For ideas about using WebDAV on ubuntu, for instance to keep files syncronised with rsync, see  [http://tomalison.com/reference/2010/04/03/webdav/ http://tomalison.com/reference/2010/04/03/webdav/]

There is also the Konqueror WebDAV client for KDE 

### Sharing printers ===

If you want to share printers you will need to
```
<pre>sudo apt-get install -Y samba system-config-samba
#if you want to run it without rebooting then just
smbd start
# to validate it's running
pcmanfm smb://localhost
# (or nautilus or whatever)
system-config-printer
# go into Server / Settings and check (Show shared by others and) Publish
# right-click on the printer and ensure all three Policies are checked
sudo system-config-samba
# if you want it open 
# right-click on the print$ share and in the access tab leave it open
# if you want it locked down...
# in the server settings set the samba user passwords
# to have the drivers download automatically on Windows systems
# find the path to the drivers from the [print$] section at the end of
less /etc/samba/smb.conf
# e.g. /var/lib/samba/printers
# for XP etc go into W32X86
sudo pcmanfm /var/lib/samba/printers/W32X86
# and copy in the files as guided by hpxxxx0n.cat
# e.g. hpxxxx0n.*, i386 amd64 sobfolders, *.gpd, *.inf
# http://www.samba.org/samba/docs/man/Samba-HOWTO-Collection/classicalprinting.html#id2626650
#
# etc etc
# or just copy the files to the share and access them file print$ from the windows client</pre>
```


## SSH - (remote) Secure SHell ##

The examples below use the 'default' choice of OpenSSH-Server.

You should configure SSH to work ONLY with Certificates, to remove the risk of attacking passwords with brute-force, and this should render it reasonably secure, even when accessible from the public internet. If you wanted to go a step further you could use Port Knocking (see https://help.ubuntu.com/community/PortKnocking), but don't forget that obscurity is not a replacement for true security (see http://bsdly.blogspot.co.uk/2012/04/why-not-use-port-knocking.html).

### Private and Public Keys ###

#### Recommendations ####

* Realms 
** Use a different key for each administrative boundary you wish to maintain. 
** Use the same key for all servers within that realm 
** Of course, ONLY distribute the public key, NEVER the private key! 
* Passphrase 
** Might you ever copy or insert this key into a non-secure location? 
*** If so consider a passphrase. 
** Of course if the machine you run it from has malware, it may be leylogged anyhow, but... 
* Algorithm 
** Use RSA algorithm with 4096 bit strength 
** As recommended by:
*** Microsoft - http://technet.microsoft.com/en-us/library/cc740209%28v=ws.10%29.aspx
*** Apache - http://www.apache.org/dev/release-signing Apache

#### Generate a keypair ####

```
# Usually done on client, before the public key is securely transferred to the server

# credit https://help.ubuntu.com/community/SSH/OpenSSH/Keys#Generating_RSA_Keys
mkdir ~/.ssh
chmod 700 ~/.ssh

ssh-keygen -t rsa -b 4096

# Enter to accept the default location. 
# You may choose NOT to enter a passphrase, 
# but then you must keep your keys stored securely. 
# if you need no passphrase then just Enter Enter
```

Please see also the section on [https://github.com/artmg/lubuild/wiki/Networked-Services#managing-encryption-keys Managing Encryption Keys] below

#### generate keys on Windows ####

Use PuttyGen to import and convert it to a PPK file - credit - http://linux-sxs.org/networking/openssh.putty.html

* Run PuttyGen 
* Accept SSH-2 RSA default keytype 
* Enter 4096 as number of bits 
* Click Generate and wiggle the mouse for randomness 
* Enter a comment indicating your Identity and the Realm of this key 
* Consider entering a passhrase (as per recommendations above) 
* Click Save Private Key as .ppk following Identity and Realm names in comment 
* Click Save Public Key as .pub using same name 
* From the menu choose Conversions / Export OpenSSH key and save with same name but no extension 


### set up server ###

```
# Install SSH Server
# credit https://help.ubuntu.com/12.04/serverguide/openssh-server.html

sudo apt-get install -Y openssh-server

# Back up the original config
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.original
sudo chmod a-w /etc/ssh/sshd_config.original

sudo gnome-text-editor /etc/ssh/sshd_config

## help - 
# man sshd_config
```

#### sshd_config Recommendations ####

```
# Choose a non-default port
#Port 22
Port 2200
# use multiple entries, each on separate lines, to open multiple ports

# Sudo should give you all the root access you need 
PermitRootLogin no

# strict Authentication
PubkeyAuthentication yes

RSAAuthentication no
PasswordAuthentication no
UsePAM no


# new keyfile location in case of encrypted home (see below)
AuthorizedKeysFile    /etc/ssh/%u/authorized_keys
```

#### install keys ####

```
## if you SSH to the machine you can use...
# ssh-copy-id "<username>@<host> -p <port_nr>"
## otherwise 

# you can copy the PUBLIC key directly using physical or network media

# in case user folder is encrypted move the keys to a non-encrypted location
# https://help.ubuntu.com/community/SSH/OpenSSH/Keys#Generating_RSA_Keys
REMOTEUSER=<username>
sudo mkdir -p /etc/ssh/$REMOTEUSER
sudo cp /etc/ssh/$REMOTEUSER/authorized_keys{,.backup_`date +%y%m%d.%H%M%S`}
cat id_rsa.pub | sudo tee -a /etc/ssh/$REMOTEUSER/authorized_keys

# For additional security you can prepend authorized_keys entries with command= or other restrictive options
# help - https://help.ubuntu.com/community/SSH/OpenSSH/Keys#Where_to_From_Here.3F

```

#### restart to read new config ####

 sudo /etc/init.d/ssh restart

#### set server start ####

```
# If you want manual start instead of automatic,
sudo mv /etc/init/ssh.conf /etc/init/ssh.conf.disabled
# credit http://askubuntu.com/questions/56753/

# alternative suggested by http://unix.stackexchange.com/questions/53671/
# echo 'manual' > /etc/init/mysqld.override
```

### connecting from client ###

```
# # This should normally be installed by default on Ubuntu distros
# sudo apt-get install openssh-client

# # if it was not already there
# # copy your PRIVATE key to local ssh folder
# mkdir -p ~/.ssh
# cp id_rsa ~/.ssh/id_rsa

ssh user@computer

# see also https://help.ubuntu.com/community/SSH/OpenSSH/ConnectingTo
```

### Troubleshooting ###

#### startup issues ####

```
# start the service with
sudo /etc/init.d/ssh start
# or 
sudo service ssh start

# check the status with
sudo /etc/init.d/ssh status
# or 
sudo service ssh status

# If you get no response, see if the daemon has started...
ps -A | grep ssh

# try running manually 
sudo sshd -t

# if you get error
# Missing privilege separation directory: /var/run/sshd
sudo mkdir -p /var/run/sshd
sudo chmod 0755 /var/run/sshd
# credit http://nixcraft.com/showthread.php/17231-Ubuntu-Linux-OpenSSH-Server-not-working-after-upgrade

sudo /usr/sbin/sshd -Dd

```

#### more ####

see ...
* https://help.ubuntu.com/community/SSH/OpenSSH/Keys#Troubleshooting
* https://help.ubuntu.com/community/SSH/OpenSSH/Configuring#Troubleshooting


### Managing Encryption Keys ###

```
#### Create ring and pair

# To create a new GPG key pair (& ring) following see - https://help.launchpad.net/YourAccount/ImportingYourPGPKey
 
#### Back up ring

# put your secure backup folder path here
cd .

# Export all keys incl Private to this folder
gpg --fingerprint > GPG.KeyList.txt
gpg --export-secret-keys --armor --output GPG.Private.Export.txt
gpg --export --armor --output GPG.Public.Export.txt

# copy entire keyring for good measure
cp -R ~/.gnupg ./gnupg

#### Restore an old key ring
```

## Remote Desktop Server ##

### Vino ####

Ubuntu now incorporates '''vino''' by befault - see https://help.ubuntu.com/community/VNC/Servers#vino

### Starting VNC over SSH ###

Using SSH tunnelling is recommended as a more secure way to allow VNC over the internet.<br />

* If you only want people to VNC to your visible desktop then see https://help.ubuntu.com/community/VNC#Let_other_people_view_your_desktop

Configure your SSH client (e.g. putty) with:

<pre>Hostname: &lt;remote IP or DynDNS&gt;
Connection Type: SSH
Port: 22 (default)
Connection - Data - username: &lt;case sensitive username on remote system&gt;
Connection - SSH - Preferred protocol: 2 only 
Connection - SSH - Auth - Private Key: &lt;PPK file created in PuttyGen&gt;
Connection - SSH - Tunnels - Forwarded Ports: 5900 -&gt; localhost:5900 
Session - Save as &quot;SSH Session&quot;</pre>
Either open the session to connect via secure shell and execute the following command or

<pre>x11vnc -safer -localhost -nopw -once -display :0</pre>
Alternatively load the &quot;SSH Session&quot; you saved and add this as the  

<pre>Connection - SSH - Remote Command:</pre>
before saving the session as &quot;VNC Session&quot; <br /><br />Now you can start your VNC client connection to '''localhost::5900'''

### Debugging SSH connections ###

If Putty gives you the error:

<pre>Network error: Connection refused</pre>
then first of all ensure that your destination IP address is still valid (e.g. no IP duplication or accidental changes due to missing reservations)<br /><br />If you have other issues with your Putty connection, try the following...

* Remember usernames on linux are case SENSITIVE
* Choose SSH type 2-only and try removing extra options (GSSetc?)
* Try setting in LogLevel VERBOSE or DEBUG in /etc/ssh/sshd_config and restart daemon before checking /var/log/auth.log
* It will not work if your home directory is encrypted (as the system cannot read the keys) - if so change the ssh config file to uncomment and use the following alternative path:

<pre>AuthorizedKeysFile /etc/ssh/%u/authorized_keys</pre>
* Try ensuring the permissions are correct on the .ssh folder and items

<pre>chmod go-w ~/
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys</pre>
help &gt; https://help.ubuntu.com/community/SSH/OpenSSH/Configuring<br />help &gt; https://help.ubuntu.com/community/SSH/OpenSSH/Keys

### Debugging VNC over SSH ###

If you get the error &quot;<code>XOpenDisplay failed</code>&quot; then try replacing <code>-display :0</code> with <code>-find</code> instead<br />help &gt; http://www.karlrunge.com/x11vnc/faq.html#faq-xperms<br />If that doesn't work you will need to work out the location of your XAuthority 'MIT cookie file' and add that as an -auth option, e.g. (for lightdm):

<pre>-auth /var/run/lightdm/root/:0 </pre>
<br /><br />

#### Others ####

credit &gt; [https://help.ubuntu.com/community/VNC/Servers https://help.ubuntu.com/community/VNC/Servers]

sudo apt-get install x11vnc

sudo x11vnc -storepasswd

Add the following to your startup applications

x11vnc -safer -allow 192.168.3. -usepw -ncache

or

echo '[Desktop Entry]

Name=VNC server

Exec=x11vnc -safer -allow 192.168.3. -usepw -ncache' &gt;~/.config/autostart/x11vnc.desktop

chmod +x ~/.config/autostart/x11vnc.desktop

####= old Ubuntu ####=

Credit &gt; http://ubuntuforums.org/showthread.php?t=1068793

sudo apt-get install vino

vino-preferences

Allow view &amp; control

Set password &amp; note hostname

Configure network to accept

Always display icon

then add to your startup

/usr/lib/vino vino-server



## syslog

### Architecture and Options

* syslogd
    * default system logging on ubuntu and many linux distros
    * defaults to writing locally
    * 
* rsyslogd
    * comes pre-installed on ubuntu and raspbian
* syslog-ng
    * server
    * FOSS with added functionality on freemium model with Premium Edition available
    * 
* ELK (ElasticSearch, Logstash, Kibana) 
    * FOSS stack to collect, store, search and visualise logs
* 

see also:

* logging in ubuntu [https://help.ubuntu.com/community/LinuxLogFiles]
* [http://askubuntu.com/a/55495] for further comparison

### rsyslogd server
```
sudo nano /etc/rsyslog.conf
## uncomment the following lines to allow listeners on default UDP & TCP ports
#$ModLoad imudp
#$UDPServerRun 514
#
#$ModLoad imtcp
#$InputTCPServerRun 514

# restart service
sudo service rsyslog restart

# by default this will send ALL logs received to syslog
# you may want to separate these out using conf files as below

# This gives one log file for all
LOG_FILE=/var/log/mylogs.log
sudo touch $LOG_FILE
sudo tee /etc/rsyslog.d/60-network.conf cat <<EOF!
\$template NetworkLog, "/var/log/netgear.log"
*.* -?NetworkLog
& ~
EOF

# This gives a log file per source hostname
# credit - http://www.rsyslog.com/article60/
LOG_LOCATION=/var/log/network
sudo mkdir -p $LOG_LOCATION
sudo tee /etc/rsyslog.d/60-network.conf cat <<EOF!
\$template DynaFile,"$LOG_LOCATION/%HOSTNAME%.log"
*.* -?DynaFile
& ~
EOF!

# you can choose which host sends to which file with...
# :fromhost-ip, isequal, "192.168.0.1" -?NetworkLog


# consider log rotation - http://www.aelog.org/use-the-raspberry-pi-as-a-syslog-server-using-rsyslog/
```

### syslog clients
```
## set your syslog server ip with...
#*.* @x.x.x.x
sudo nano /etc/rsyslog.conf

sudo service rsyslog restart
```
### syslog-ng
```
# syslog-ng is in repos
sudo apt-get install syslog-ng
nano /etc/syslog-ng/syslog-ng.conf
# credit - http://resources.intenseschool.com/raspberry-pi-as-a-syslog-server/
service syslog-ng restart
```
