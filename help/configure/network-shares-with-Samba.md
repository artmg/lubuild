
## References

* For other recipes, please see also:
    * sharing printers - [https://github.com/artmg/MuGammaPi/wiki/Print-server]
    * sharing optical drives - WIP see below
* please see also [https://github.com/artmg/lubuild/blob/master/help/configure/Networked-Services.md]
    * For other Networked Services

NB: for linux **samba clients** see towards the end of this document

NB: see locally stored [Samba Tests.md] for other attempts including Optical Drives and Linux client Read-write


## Introduction 

Samba is an SMB server. 
It runs a daemon listening at port 445 that uses Server Message Blocks 
to share files and printers across a network. 
It has also been known as CIFS, the Common Internet File System. 
Because it is the default way for Windows to share files, 
it is commonly used as a cross-platform solution from Linux servers 
(rather than just using the NFS Network File System that only Unix understands). 
See more info at [https://en.wikipedia.org/wiki/Server_Message_Block]

The Samba config file may also turn on WINS, 
the Windows Internet Naming Service, 
so that computer names are broadcast and can be used instead of IP addresses

(_copied from [https://github.com/artmg/MuGammaPi/wiki/Shared-files]_)

### how to configure

* install
* create master conf
* testparm to copy to main conf

Although you may directly edit the configuration file **/etc/samba/smb.conf** the recommended process above ensures you are warned of any configuration errors. 


### setting up SAMBA

```
# install samba
sudo apt-get update
sudo apt-get install -y samba
# ensure install samba-common-bin is installed for testparm to work

# back up original
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.original
# save as master
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.master
# edit master file
sudo gnome-text-editor /etc/samba/smb.conf.master
# or just editor if you have no gui

# data stored under /srv/samba (following Filesystem Hierarchy Standard)
set SHARES_ROOT=/srv/samba/MySharedFolder

# create standard location for samba data (unless you plan to use a mounted device)
sudo mkdir -p $SHARES_ROOT

#### Sample shares
# unauthenticated access to a share
cat <<EOF | sudo tee /etc/samba/smb.conf.master 
[MyShare]
   path = $SHARES_ROOT
EOF

# help - https://www.samba.org/samba/docs/man/manpages/smb.conf.5.html


# test the master file and create real conf file
testparm -s /etc/samba/smb.conf.master && testparm -s /etc/samba/smb.conf.master | sudo tee /etc/samba/smb.conf
# credit - http://ubuntuforums.org/showthread.php?t=1462926
# NB only valid option lines that differ from the default will appear in the testparm output

### Restart services with new config ###
sudo /etc/init.d/samba restart
## OR alternatively
# sudo smbd reload
# sudo service smbd restart


# if you need any tweaks then repeat
sudo editor /etc/samba/smb.conf.master 

```


### advertising shares with Avahi

for basics on avahi ...
* please see [https://github.com/artmg/lubuild/blob/master/help/configure/Networked-Services.md]

The following configuration directive is YES by default ...

```
[global]
    multicast dns register = yes      # register itself with mDNS services like Avahi
```




## Client Access to Samba shares

### Access them from Linux ###

* for issues with Autodiscovery (including local Name Resolution) using mDNS:
   * see _Autodiscovery_ above for server-side issues
   * for client-side issues see [https://github.com/artmg/lubuild/blob/master/help/configure/Networked-Services.md]

```
### GUI Access
# help - https://help.ubuntu.com/community/Lubuntu/PCManFM#Browse_Windows_PCs_with_Samba

### CLI Access
# allow mounting samba / CIFS
sudo apt-get install -y cifs-utils

### prepare mount
MOUNT_LOCAL=/media/mylocalmount
MOUNT_SHARE=//otherpc.local/sharename
MOUNT_OPTIONS="-o -ro"
sudo mkdir -p $MOUNT_LOCAL
sudo mount -t cifs --verbose $MOUNT_OPTIONS $MOUNT_SHARE $MOUNT_LOCAL

# sync contents
# NB this is TEST ONLY MODE with dry run
rsync --dry-run -av --modify-window=3605 $MOUNT_LOCAL /media/localdrive/localcopy/ 
```


 
### Troubleshooting ####

#### Windows access issues

* Device not showing in Windows browse lists
    * From device running Samba try

```
smbclient -L localhost
```

 * Does the Workgroup setting on the clients match Samba config Workgroup?
 * Does NMB service need to be running too?
 * In some cases you may need to modify settings on the Windows client, e.g.
     * Network and Sharing Center / Advanced sharing settings (on left-hand pane)
         * All Networks / File sharing connections / **check** Enable file sharing for 40 & 56 bit encryption
     * Network Connections / (right-click network adapter) / Properties / 
     * Internet Protocol Version 4 / Advanced... / WINS / Enable NetBios over TCP/IP = TRUE
     * Check the firewall allows traffic on the specific network including "File and Printer Sharing (LLMNR-UDP-In)"
     * flush caches for DNS / NetBIOS / ARP from **Admin** command prompt with

```
ipconfig /flushdns & nbtstat -R & arp -d *
```

#### Other Troubleshooting ###

If you cannot see the server or share under "Windows Network" then check smb.conf 
to ensure you have set
```
Workgroup = WORKGROUP
```
at least in the global section (and you could even try adding it against the share for testing)

other settings that may help include
```
local master = yes
preferred master = yes
wins support = yes

multicast dns register = yes      # register itself with mDNS services like Avahi
```

#### issues with linux samba client

##### browsing

If you cannot browse samba servers on the network via a linux client such as ubuntu
edit the following file on the client /etc/samba/smb.conf

```
# add this in global to use broadcast FIRST
name resolve order = bcast host

service samba restart
```

##### authentication and authorisation

ensure that you have defined:
* the correct user credentials when you mount the cifs share
    * see section **XXXXXX** above 
* the correct back-end a) user/group and b) file and directory mode on the share and c) the corresponding user/group/mode on the filesystem
    * 



