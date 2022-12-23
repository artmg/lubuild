# Networked Services

see also:

* [Secure SHell SSH](../configure/Secure-SHell-SSH.md)
	* how to configure Secure SHell (SSH) services and clients, and how to use other services that piggy-back off SSH connections.
* [General Network troubleshooting](../diagnose/network.md)
	* general Network Diagnostics
	* If you want to find out more about what is on your local network
		* [Discovery / Services](../diagnose/network.md#Discovery)
* [Configure inteface](../configure/network-interface.md)
	* If you're trying to make a direct connection to a single device
	* useful when configuring new network equipment
* [Hardware Troubleshooting](../diagnose/hardware.md) 
	* For issues turning radios on and off
* [Samba server](../configure/network-shares-with-Samba.md)
	* Sharing folders Windows-style
* [Network Appliances](../configure/network-appliance-firmware.md)
	* dedicated devices running specialist software
* [Troubleshooting the OS](../diagnose/operating-system.md)
	* for help with OS version, kernel, logs, services, etc


## Network discovery

The **mDNS** service advertises available services, 
but it also advertises hostnames too, 
so is a handy broadcast ('peer-to-peer') name resolution service
for the `.local` network. 
. It goes by various names 
including Bonjour, Avahi, ZeroConf, 
but because of its wide support 
many services automatically install the files 
top configure their advertisement of services they make available. 
So in most cases you can install and it just works (hence zero configuration). 

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
see [Discovery / Services in Network Diagnostics](../diagnose/network.md#Discovery)

## Sharing Folders

### Locally

```
# to share folders locally use bindfs to mount a location in different places
sudo apt-get install bindfs
# help > https://help.ubuntu.com/community/Bindfs-SharedDirectoryLocalUsers

# use symlinks if you want it to appear elsewhere for the other users
# .e.g. ...
ln -s -T /home/shared /home/username/Documents/Pictures
```

### Across LAN

#### Prepare

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

#### Choices


; Samba
: Heavier | Windows compatible | ??Secure?? | common | simple from client
; SFTP (SSH File Transfer Protocol)
: quick and easy if SSH already set up 
; NFS
: lightwight | can automount in fstab or avahi (https://wiki.archlinux.org/index.php/avahi#NFS)
: see https://help.ubuntu.com/community/SettingUpNFSHowTo
; Avahi - Giver
: Push only!


#### SFTP

If you are connecting to a device that already serves SSH, 
e.g. you know you can connect to a remote command line, 
then it will be very easy to use SSH File Transfer Protocol, 
all you need is a suitable client. 
To copy a single file you can use SCP, but SFTP maintains the 
connection so you can transfer many files easily. 

If you are connecting from a Ubuntu or Lubuntu client, 
it's already built in via your file manager. 
Nautilus, Thunar and PCManFM all use the underlying gvfs and 
sshfs services to mount and display remote folders over SFTP. 

Look for the option "**Connect to Server...**".

If you're on Windows then you can use WinSCP, and a number 
of FTP clients also support SFTP. 

NB: if you can use the same credentials to connect to SSH 
but fail to connect to SFTP, then you should ensure your server 
does not have file transfer explicitly disabled

Technical Notes: SFTP here refers to SSH File Transfer Protocol,  
not to the deprecated Simple File Transfer Protocol. 
SFTP is technically different from both FTPS and FTP over SSH, 
fortunately however many FTP clients have been written to also use SFTP.

For more details on SFTP see the [section in teh Secure SHell SSH page](../configure/Secure-SHell-SSH.md#sftp).


#### Share with Samba

For the main article on configuring network shares with samba 
please see [Configure Samba](../configure/network-shares-with-Samba.md)

Below are simple instructions for setting up a basic Samba share in Lubuntu. 
For more explanation, background, and further examples of advanced use 
such as multiple shares, sharing printers and optical drives, 
or for details on accessing them with linux clients 
please see the above-mentioned article.

##### OUT

* dedupe between ...
 * here
 * [Configure Samba](../configure/network-shares-with-Samba.md)
  * including WINS and Windows access
 * [sharing printers](https://github.com/artmg/MuGammaPi/wiki/Print-server)

```
##### SAMBA
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

NB: by default, samba users are separate from linux system users.  
For more on advanced configuration please see [main Samba article](../configure/network-shares-with-Samba.md)


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

#####  Making shares accessible to Windows

see Lubuild / Collector / Services / Sharing Folders

###### Sample global

```
[global]
# Allow use of computer names
wins support = yes
# don't insist on authenticating users
security = share</pre>
```

###### Temporary shares

`sudo shares-admin`

#####  WebDAV

For ideas about using WebDAV on ubuntu, 
for instance to keep files syncronised with rsync, 
see [http://tomalison.com/reference/2010/04/03/webdav/ http://tomalison.com/reference/2010/04/03/webdav/]

There is also the Konqueror WebDAV client for KDE 


### Sharing printers

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



#### NFS

Networked File System is the native Linux means to share files across networks, 
and is simple and easy to use with Linux devices including Apple OSes. 
Windows has had some support for extensions that can mount or present NFS shares, 
but in most cases you will find it easier to use the SMB / CIFS protocol with Samba to support Windows clients. 

The NFS server "Exports" the volumes that can be "Mounted" by NFS clients.


##### Server

```
# Prepare variables
NFS_MOUNT_POINT=/mnt/myMediaLocation/myDataDir
NFS_EXPORT_NAME=myExportName
NFS_EXPORT_PERMS=usr:grp

###### Base software install
sudo apt-get update
# workaround for Raspbian distros `rpcinfo -p` showing "can't contact portmapper"
. /etc/*-release
if [[ "${ID}" == "raspbian" ]] ; then sudo apt-get purge -y rpcbind ; fi ;
# software install
sudo apt-get install -y nfs-kernel-server

# create mount point if not already there
sudo mkdir -p $NFS_MOUNT_POINT

###### best practice to collect export points
# you could share specific folders directly, but best practice suggests 
# collecting them into one place using bind mounts 
# and setting up specific permissions 

# srv is linux filesystem hierarchy standard, some people use nfs or nfsexports as alternative subfolder
sudo mkdir -p /srv/exports/$NFS_EXPORT_NAME

# check the mount has set the correct perms itself
ls -la /srv/exports/$NFS_EXPORT_NAME
# otherwise
sudo chown $NFS_EXPORT_PERMS /srv/exports/$NFS_EXPORT_NAME
ls -la /srv/exports/$NFS_EXPORT_NAME

###### Bind the data into the nfs exports directory
cat <<EOF | sudo tee -a /etc/fstab
$NFS_MOUNT_POINT      /srv/exports/$NFS_EXPORT_NAME    none   bind,nofail   0   0
EOF
# add nofail to ensure that ancilliary disk fails do not prevent devices from booting
sudo mount -a

###### make the export available - add to NFS filesystem access control list
cat <<EOF | sudo tee -a /etc/exports
/srv/exports/$NFS_EXPORT_NAME *(rw,sync,no_root_squash,no_subtree_check)
EOF

###### refresh the exports and start the server
sudo exportfs -a
sudo service nfs-kernel-server start


# or refresh and restart if config changed
# sudo exportfs -ra
# sudo service nfs-kernel-server restart


## see also
# [https://help.ubuntu.com/community/SettingUpNFSHowTo]
# [https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nfs-mount-on-ubuntu-14-04]
# [https://www.howtoforge.com/nfs-server-on-ubuntu-14.10]

```

###### Issues with Debian Jesse

```
# credit [https://www.raspberrypi.org/forums/viewtopic.php?f=28&t=149002&p=980161]
# Original [https://lists.debian.org/debian-devel/2014/05/msg00618.html]

cat <<EOF | sudo tee -a /etc/systemd/system/nfs-common.services
[Unit]
Description=NFS Common daemons
Wants=remote-fs-pre.target
DefaultDependencies=no

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/etc/init.d/nfs-common start
ExecStop=/etc/init.d/nfs-common stop

[Install]
WantedBy=sysinit.target
EOF

cat <<EOF | sudo tee -a /etc/systemd/system/rpcbind.service
[Unit]
Description=RPC bind portmap service
After=systemd-tmpfiles-setup.service
Wants=remote-fs-pre.target
Before=remote-fs-pre.target
DefaultDependencies=no

[Service]
ExecStart=/sbin/rpcbind -f -w
KillMode=process
Restart=on-failure

[Install]
WantedBy=sysinit.target
Alias=portmap
EOF

sudo systemctl enable nfs-common
sudo systemctl enable rpcbind
sudo reboot 
```


##### NFS Client

```
NFS_SERVER=myServerName
NFS_EXPORT=myExportFolder
LOCAL_MOUNT=myMountName
MOUNT_PERM=yes-or-no


# permit root commands later on
sudo echo

# detect unix release
. /etc/*-release
if [ -f "/etc/arch-release" ]; then ID=archarm; fi
if [ "$(uname)" == "Darwin" ]; then ID=macos; fi

#install

case "${ID}" in
  ubuntu|raspbian)
    if [ $(dpkg-query -W -f='${Status}' nfs-common 2>/dev/null | grep -c "ok installed") -eq 0 ];
    then
      sudo apt install -y nfs-common
    fi
    ;;
  archarm)
    sudo pacman -S --noconfirm nfs-utils
    ;;
  macos)
    # no need, NFS client built into macos
esac

# set options

case "${ID}" in
  ubuntu|raspbian)
    MOUNT_ROOT=/mnt/nfs
    EXPORT_ROOT=/srv/exports
    MOUNT_OPTIONS=
    # for a permanent mount that should avoid issues if unavailable...
    MOUNT_PERM_OPT="defaults,timeo=14,soft   0   0"
    ;;
  macos)
    # Sierra file system hierarchy suggests /Volumes for mounts
    # https://developer.apple.com/library/content/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/FileSystemOverview/FileSystemOverview.html#//apple_ref/doc/uid/TP40010672-CH2-SW7
    # also the security design recommends using reserved ports
    # export root determined with showmount -e servername
    # since macOS Big Sur the mount should use nfs protocol version four
    MOUNT_ROOT=/Volumes
    EXPORT_ROOT=/srv/exports
    MOUNT_OPTIONS="-o resvport,vers=4"
    MOUNT_PERM_OPT=
    ;;
  archarm)
    MOUNT_ROOT=/mnt/nfs
    EXPORT_ROOT=/srv/exports
    MOUNT_OPTIONS=
    # MOUNT_PERM_OPT="rsize=8192,wsize=8192,timeo=14,_netdev   0   0"
    MOUNT_PERM_OPT="defaults,timeo=14,soft   0   0"
    # or even using automount options
    # MOUNT_PERM_OPT="auto,x-systemd.automount,x-systemd.device-timeout=10,timeo=14,x-systemd.idle-timeout=1min   0   0"
    # credit [https://wiki.archlinux.org/index.php/NFS#Mount_using_.2Fetc.2Ffstab_with_systemd]
esac


sudo mkdir -p $MOUNT_ROOT/$LOCAL_MOUNT

if [[ "${MOUNT_PERM}" == "yes" ]] ; then
  # add the entry to the file system table
  cat <<EOF | sudo tee -a /etc/fstab
$NFS_SERVER:$EXPORT_ROOT/$NFS_EXPORT $MOUNT_ROOT/$LOCAL_MOUNT nfs $MOUNT_PERM_OPT
EOF
  # now mount from the fstab
  sudo mount -a
else
  # or just mount
  sudo mount -t nfs $MOUNT_OPTIONS $NFS_SERVER:$EXPORT_ROOT/$NFS_EXPORT $MOUNT_ROOT/$LOCAL_MOUNT
  # then test
  mount -t nfs
fi

```

##### Troublshooting NFS

* [http://www.tldp.org/HOWTO/NFS-HOWTO/troubleshooting.html]
* [https://wiki.archlinux.org/index.php/NFS/Troubleshooting]


## SSH - (remote) Secure SHell

These sections have been moved out into a new, separate article on [Secure SHell SSH](../configure/Secure-SHell-SSH.md)

Please update any links you have to point to the new article.

### Private and Public Keys

#### Generate a keypair

##### Generate and install SSH Certificate

#### generate keys on Windows

### set up server

#### sshd_config Recommendations

#### install keys

### connecting from client

### Managing Encryption Keys

## Remote Desktop Server

### Vino

### Starting VNC over SSH

### Debugging SSH connections

### Debugging VNC over SSH

## Name Resolution (DNS)

Services in the Domain Name System (DNS) look up a hostname, 
which often also has a domain name following a . dot, like `example.com`, 
and return the actual IP address (like `123.45.67.89`) of the server. 
They are likely to first check local hosts, 
then send queries elsewhere for devices that are not 
managed locally. 
It is very common to have a local cache 
to keep IP addresses for names that have been looked up recently. 

DNS servers are historically an infrastructure service, 
traditionally using `bind` but more commonly now using `unbound`. 
Now however it is now common to use mini versions 
running on clients for caching and forwarding, 
using services like `dnsmasq`, 
and even a resolver service like `systemd-resolved` 
to ensure that all local apps reference the right dns service. 

Although DNS was not designed for filtering purposes, there are blacklist filtering services such as `pihole`
that can block advertising and malware. 

#### unbound

Providing DNS services to a local network would often rely on `bind`, but the more recent `unbound` equivalent 
is often preferred for efficiency and modern features.

Here is a simple server install which:

* overrides the root key so that public servers can be queried
* listens on a specific adapter's IP address because resolved is listening on 127.0.0.53:53
* Allows queries from local networks
* forwards queries to local dns server on gateway

```
# install unbound
sudo apt install -y unbound

DNS_LISTENER_IP=192.168.1.23
DNS_LOCAL_SVR_IP=192.168.1.1
sudo tee /etc/unbound/unbound.conf << EOF!
# omit the include folder to make this file definitive 
# include: "/etc/unbound/unbound.conf.d/*.conf"

server:
    # listen on specific address as resolved is on 127.0.0.53:53
    interface: ${DNS_LISTENER_IP}

    # allow all local hosts to query
    access-control: 192.168.0.0/16 allow
    access-control: 10.0.0.0/8 allow

    # from unbound.conf.d/qname-minimisation.conf
    # See RFC 7816 "DNS Query Name Minimisation to Improve Privacy" for
    qname-minimisation: yes

    # from unbound.conf.d/root-auto-trust-anchor-file.conf
    # root trust anchor for crypto DNSSEC validation
    # commented out for tests using public server
    # auto-trust-anchor-file: "/var/lib/unbound/root.key"

# forward queries to lan
forward-zone:
    name: "."
    forward-addr: ${DNS_LOCAL_SVR_IP}@53

EOF!
sudo systemctl restart unbound
```

For more configuration hints see https://calomel.org/unbound_dns.html


##### Setting up unbound-control for stats and troubleshooting

If you want to be able to obtain statistics and diagnostics 
for the Unbound DNS Resolver service, you can use its `unbound-control` component.

This assumes that the DNS server already has unbound control enabled 
and bound to the correct interface.

```
DNS_LISTENER_IP=192.168.1.1
sudo tee -a /etc/unbound/unbound.conf << EOF!
remote-control:
    control-enable: yes
   
    # what interface & port are listened to for remote control.
    # give 0.0.0.0 and ::0 to listen to all interfaces.
    control-interface: ${DNS_LISTENER_IP}
    control-port: 8953

    server-key-file:   "/etc/unbound/unbound_server.key"
    server-cert-file:  "/etc/unbound/unbound_server.pem"
    control-key-file:  "/etc/unbound/unbound_control.key"
    control-cert-file: "/etc/unbound/unbound_control.pem"
EOF!
sudo systemctl restart unbound
```

You can now run commands locally on the server itself

	-c /etc/unbound/unbound.conf 

To run it from a remote server you would need to copy some keys and certs 
to the local machine and configure it

```
# see if it is already installed
unbound-control

# install unbound
sudo apt install -y unbound

# not sure if we need the resolver running locally
#sudo systemctl --now disable unbound.service
#sudo systemctl --now disable unbound-resolvconf.service

mkdir -p ~/unbound-control/
scp user@server:/etc/unbound/unbound_server.pem  ~/unbound-control/
scp user@server:/etc/unbound/unbound_control.key ~/unbound-control/
scp user@server:/etc/unbound/unbound_control.pem ~/unbound-control/
tee ~/unbound-control/unbound-control.conf << EOF!
remote-control:
    server-cert-file:  "$HOME/unbound-control/unbound_server.pem"
    control-key-file:  "$HOME/unbound-control/unbound_control.key"
    control-cert-file: "$HOME/unbound-control/unbound_control.pem"
EOF!

unbound-control -c ~/unbound-control/unbound-control.conf -s 192.168.1.1@8953 status

```



## DLNA / UPnP Media Server

Digital Livingroom Network Alliance (DLNA) extends the 
Universal Plug and Play (UPnP) network standard to provide audio services. 
This is to set up a **Media Server**, but to find out 
more about other components see
[Music and Multimedia article](../use/Music-and-multimedia.md)

For alternatives to ReadyMedia see [https://www.reddit.com/r/linux/comments/4zh324/how_dead_is_minidlna_readymedia_too_dead/]

### ReadyMedia

This uses a package that may be rather old...
to compile from the latest source see 
[http://www.htpcguides.com/install-readymedia-minidlna-1-1-4-raspberry-pi/]

see also [https://wiki.archlinux.org/index.php/ReadyMedia]

```
# On a bare system this adds about 75MB of dependencies
sudo apt install -y minidlna
sudo cp /etc/minidlna.conf /etc/minidlna.original.conf
sudo editor /etc/minidlna.conf

# sudo service minidlna force-reload is supposed to rebuild database
# but it doesn't appear to - is this a symptom of context/permissions issues?
# example perms
# drwxr-xr-x  minidlna minidlna /var/cache/minidlna
# drwxr-xr-x  root     root     /var/cache/minidlna/art_cache
# -rw-r--r--  root     root     /var/cache/minidlna/files.db

sudo service minidlna stop
sudo minidlnad -R
sudo service minidlna restart

```

see also 

* ???
	- avahi if needed (for DLNA and or SAMBA)
	- album art
* [https://github.com/artmg/MuGammaPi/wiki/Volumio-and-MPD]
	- album art publishing
* 

#### Announce

UPnP Content Directory Services make themselves known to Control Points 
using Simple Service Discovery Protocol (SSDP). Therefore it should not really 
be necessary to announce them through Avahi, which uses Multicast DNS-SD (mDNS).

```
# Avahi ports for MiniDLNA (NOT required for Control Points to discover Services!)
cat > /etc/avahi/services/minidlna.service <<EOF!
<?xml version="1.0" standalone='no'?>
<!DOCTYPE service-group SYSTEM "avahi-service.dtd">
<service-group>
 <name replace-wildcards="yes">%h</name>
 <service>
   <type>_ssdp._udp</type>
   <port>1900</port>
 </service>
 <service>
   <type>_trivnet1._tcp</type>
   <port>8200</port>
 </service>
</service-group>
EOF!

# restart the Avahi service
service avahi-daemon restart
```





### Media Player Daemon (MPD)


## http web server

### lightweight web server candidates:

The first two are more self contained. 
Opinions differ on which is smaller, faster, lighter 
or easier to get working:

* nginx
* lighttpd


The following are typically linked to a base framework, 
so make sense to use when you already rely on that framework:

* php/plack
* phython/flask
* Go/fasthttp
* Busybox/httpd ?

for benchmarks see [msoap/Raspberry Pi httpd benchmark.md](https://gist.github.com/msoap/7060974)


## Monitoring and Alerting

* Gathering event information from network devices
* analysing and reporting
* sending messages upon important events


### Architecture and Options

The main options for collecting logs to the syslog RFC standards:

* rsyslogd
	* comes pre-installed on ubuntu and raspbian
	* open source
	* single main owner (multiple contribs)
* syslog-ng
	* FOSS / freemium: open Community Edition with added functionality available in Premium Edition
	* corporately owned
* syslogd
	* project long abandoned
	* previously the default system logging on ubuntu and many linux distros
    * defaults to writing locally
* ELK (ElasticSearch, Logstash, Kibana) 
    * FOSS stack to collect, store, search and visualise logs
    * commonly run on cloud services
    * available in turnkey images such as bitnami

You could use a conbination of these, e.g. rsyslog to send files 
to a log collection server, then ELK to analyse from this


### rsyslog server

```
#### Listen on network
sudo editor /etc/rsyslog.conf
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


#### Single log file
# This gives one log file for all
LOG_FILE=/var/log/mylogs.log
sudo touch $LOG_FILE
sudo tee /etc/rsyslog.d/60-network.conf <<EOF!
\$template NetworkLog, "/var/log/netgear.log"
*.* -?NetworkLog
& ~
EOF


#### DynaFile
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

##### Syntax
#
# Note that these recipes all use the old basic syntax
# but for more complex needs you might prefer the 
# advanced filter language
#
# * https://www.rsyslog.com/filter-optimization-with-arrays/
# * https://www.rsyslog.com/recipe-apache-logs-rsyslog-parsing-elasticsearch/
```

#### Log Rotation

```
sudo tee /etc/logrotate.d/rsyslog-data.conf <<EOF!
$LOG_LOCATION/*.log $LOG_LOCATION/*/*.log {
        rotate 10
        size 500k
        compress
        notifempty
        postrotate
                invoke-rc.d rsyslog rotate > /dev/null
        endscript
}
EOF!

sudo logrotate /etc/logrotate.conf --debug
```

Note that the syntax for the post rotate command can vary between distros. At the end of the day there are so many ways to send the HangUP (HUP) signal to the rsyslogd PID, but if your rotation is not working then copy the syntax from the distro-included `/etc/logrotate.d/rsyslog`

#### moving log folder

You may choose to store your logs on a different volume, 
especially if you have your main OS on a flash drive. 

The basic steps are:

* quiesce the logging services
* copy any existing files
* mount or link the new location

* [example with mount](https://serverfault.com/questions/55984/how-can-i-move-var-log-directory)
	* can you only mount a single destination per volume?
* [eaxmple with symlink](https://askubuntu.com/questions/220358/how-to-change-location-where-logs-are-stored)
	* multiple destinations per target volume
	* any disadvantages?


For suggestions of folders that can be sent to tmpfs (RAM disk) 
to conserve Flash-based systems 
see [http://www.zdnet.com/article/raspberry-pi-extending-the-life-of-the-sd-card/]


### rsyslog clients

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

### Log Viewing

Open source, cross platform GUI tools for viewing logs 
and dynamically filtering which entries appear:

* klogg (forked from abandoned glogg)
* logstash
* ? splunk ?
* ? Fluentd ?
* Prometheus (may be more alerting)

Some options are java-based, 
but might be considered as part of a larger stack

* Graylog
* Apache Chainsaw log4j
* Otros

Not consider these for the stated reasons:

* logsniffer, development ceased 2016
* GoAccess, great lightweight C terminal/browser analyser, but too focussed on site log visitor stats (and only linux)
* LogExpert is Windows only 
* Logbert is Windows only 
* Lilith not developed for years
* 


