
Although general purpose computer hardware gives you more flexibility, 
you may be better off with simpler, more efficient solutions 
using "appliances", especially for networked services. 

The more limited but dedicated software can run well 
even on low powered hardware, and is often suited to limited memory 
capacity, or flash storage.

See also:

* [Configure inteface](https://github.com/artmg/lubuild/blob/master/help/configure/network-interface.md)
	* If you're trying to make a direct connection to a single device
	* useful when configuring new network equipment
* [General Network troubleshooting](https://github.com/artmg/lubuild/blob/master/help/diagnose/network.md)
	* general Network Diagnostics
	* If you want to find out more about what is on your local network
		* see Discovery / Services in  [https://github.com/artmg/lubuild/blob/master/help/diagnose/network.md#Discovery] 
* [Hardware Troubleshooting](https://github.com/artmg/lubuild/blob/master/help/diagnose/hardware.md) 
	* For issues turning radios on and off
* [Samba server](https://github.com/artmg/lubuild/blob/master/help/configure/network-shares-with-Samba.md)
	* Sharing folders Windows-style
* [https://github.com/artmg/lubuild/blob/master/help/configure/Networked-Services.md]
	* For configuring other Network Services 
* [Network Appliances](https://github.com/artmg/lubuild/blob/master/help/configure/network-appliance-firmware.md)
	* dedicated devices running specialist software




# Appliance 'firmware' options

## Network Appliances

### Dedicated distros ###

#### work on ARM or embedded ####

* OpenWrt
    * embedded system that can be flashed onto wide range of consumer devices
    * Pi is supported, but the distro is compiled for **armel** (no hardware maths acceleration) so it runs slower than some hardware of similar power [http://wiki.openwrt.org/toh/raspberry_pi_foundation/raspberry_pi]
    * mainly aimed at wireless and combo routers - compare
        * routers (no modem, no wireless) - [http://skinflint.co.uk/?cat=router]
        * with the [OpenWrt hardware list](http://wiki.openwrt.org/toh/start)
        * wlan router modems that support OpenWrt [http://skinflint.co.uk/?cat=wlanroutmod&xf=758_OpenWrt&sort=p]
        * wlan routers (no modem) that support OpenWrt [http://skinflint.co.uk/?cat=wlanrout&xf=758_OpenWrt&sort=p]
* DD-WRT
    *
* Tomato
    * 
* Alpine (ARMhf)
    *
* IPFire 
    * no support for Pi2, poor for ARM
    * better on Intel / AMD chipset
    * see [hardware requirements](http://wiki.ipfire.org/en/hardware/start)


#### Need Intel / AMD ####

* m0n0wall
    * very lightweight
* pfSense
    * FOSS for the appliances they sell, but they offer a **Community Edition**
    * requires Intel or AMD - x86 or x64
    * has full install to SDD / HDD or NanoBSD version to run from flash (see [downloads](https://www.pfsense.org/download/))
    * Includes firewall, router, DHCP server, gateway, OpenVPN, IPsec, proxy and anti-virus (Snort)
* ZeroShell
* NST
* PacketFence
    * network access control (NAC) solution: captive-portal for registration, centralized wired and wireless management, powerful BYOD management options, 802.1X support, layer-2 isolation of problematic devices.


#### other ####

See also:
* review of 10 with pros and cons - [http://www.mondaiji.com/blog/other/it/10175-the-hunt-for-the-ultimate-free-open-source-firewall-distro]
* wikipedia table showing ARM compatibility - [https://en.wikipedia.org/wiki/List_of_router_and_firewall_distributions]

also see MuGammaPi, and build out options for multi-NIC hardware


# Some hardware options

Of course the good old Raspberry Pi has a lot of flexibility 
with a low price tag. You can overcome the limitation of the single 
ethernet port by adding another one via USB, but you may still find 
throughput limited for the most bandwidth intensive application, 
especially if it's an edge device that many devices share. 

## reuse with OpenWrt

many 'dedicated' network appliances, like routers and gateways, 
can be given a new lease of life by flashing them with OpenWrt. 
See the firmware section below for ideas and links

## netboards

* ALIX or APU1 based 
    * e.g. [https://www.applianceshop.eu/parts/pcengines.html]

## alternative low power SBCs

* https://www.newit.co.uk/shop/




# OpenWrt

OpenWrt is a great alternative firmware for network appliances you may have bought, 
including routers, as it allows you to configure them just how you want, 
and utilise all the hardware capabilities they may physically possess. 

NB: This page does NOT include the per-device stuff about how to get the image on there in the first place!


## Prepare

```
# to establish an IP connection use procedures above - configure/network-interface.md 

# then test
ping 192.168.1.1
```

## Start

### first login

```
# credit - https://wiki.openwrt.org/doc/howto/firstlogin
telnet 192.168.1.1

# set your new password
passwd

# now switch modes
exit

ssh root@192.168.1.1
```

### firmware backups

Use [https://wiki.openwrt.org/doc/howto/generic.backup] to create **art** and **boot** backups

Then use the line snippets to create the full MTD backups, before zipping them with

 tar -cz -f /tmp/mtds.backup.tar.gz /tmp/mtd*.backup

Now, from another terminal,  

 # copy the files to the local working folder using scp
 scp root@192.168.1.1:/tmp/art.backup .
 scp root@192.168.1.1:/tmp/boot.backup .
 scp root@192.168.1.1:/tmp/mtds.backup.tar.gz .
 # check they arrived ok
 ls -l

Back on the router, check that tmp is not too close to 100% full. 
If it is then use **reboot** to clear it out automatically.


## Dumb AP

Use the [recipe for a Dumb AP](https://wiki.openwrt.org/doc/recipes/dumbap), 
no routing, simply switching all traffic through...

```
# back up the old versions
cp /etc/config/network  /etc/config/network.backup.`date +%y%m%d`
cp /etc/config/firewall /etc/config/firewall.backup.`date +%y%m%d`
cp /etc/config/dhcp     /etc/config/dhcp.backup.`date +%y%m%d`
cp /etc/rc.local        /etc/rc.local.`date +%y%m%d`

### DISABLE DHCP
# do this via luci interface of...
#uci set dhcp.lan.ignore=1
uci set dhcp.lan.ignore='1'
uci commit dhcp
# leave dnsmasq in case we need TFTP
/etc/init.d/dnsmasq restart
# or if not required could just delete /etc/rc.d/S60dnsmasq
# or 
# /etc/init.d/dnsmasq disable
# /etc/init.d/dnsmasq stop

### ALLOW ALL TRAFFIC
# for now to configure to pass ALL using firewall ACCEPT
# alternatively disable firewall
#/etc/init.d/firewall disable
#/etc/init.d/firewall stop
cat > /etc/config/firewall <<EOF
config defaults
    option syn_flood   1
    option input       ACCEPT
    option output      ACCEPT
    option forward     REJECT

config zone
    option name        lan
    list   network     'lan'
    option input       ACCEPT
    option output      ACCEPT
    option forward     ACCEPT
EOF

### ALLOW Multicast Forwarding
# no need to escape quotes and slashes when using cat redirect
cat >>/etc/rc.local <<EOF
echo "0" > /sys/devices/virtual/net/br-lan/bridge/multicast_snooping
EOF

### Set AP Hostname
# alternatively you can set this in the file /etc/config/network under the proper interface add:
#         option hostname 'hostname_you_want'
# this uses uci:
# NEW_HOST=hostname_you_want
uci set network.lan.hostname=$NEW_HOST
uci set system.@system[0].hostname=$NEW_HOST

### use DHCP for lan
uci set network.lan.proto=dhcp
# do we also have to remove the options ipaddr / netmask ??
# in case of issues edit the config file instead


# save the changes
uci commit system
uci commit network

### Avahi service advertising
# credit https://wiki.openwrt.org/doc/howto/zeroconf
# you MUST to be be a live network to do this
opkg update
# IF Config Avahi Advertising includes SSH 
opkg install avahi-daemon-service-ssh
# IF Config Avahi Advertising includes HTTP
opkg install avahi-daemon-service-http

### Apply changes
/etc/init.d/network reload

# you will now most likely loose connectivity to that session
```

### Set up WIFI

* curently done via interface
* set to use uci, driven with variables


## Back up

Using the LUCI web console, or the [manual ssh & scp instructions](https://wiki.openwrt.org/doc/howto/generic.backup#backup_openwrt_configuration), grab yourself a safe copy of the configs


## Troubleshooting

```

### Logs

#### Kernel Log
dmesg

#### System log
logread
# help - https://wiki.openwrt.org/doc/howto/log.essentials

#### Send logs to server

# set up destination server for system logs
# help - https://wiki.openwrt.org/doc/uci/system
uci set system.@system[0].log_ip=192.168.1.x
uci set system.@system[0].log_port=
# save the changes
uci commit system


### Networking
# if you need to refresh the dhcp lease ....
udhcpc
cat /var/dhcp.leases
cat /var/resolv.conf
cat /var/resolv.conf.auto


```

### Failsafe mode

If you really screw up the configuration, and have trouble accessing the device at all, then see the failsafe mode

 [https://wiki.openwrt.org/doc/howto/generic.failsafe]

and check [Procedures for Configuring Network Interface](https://github.com/artmg/lubuild/blob/master/help/configure/network-interface.md) to set an address in the 192.168.1.x network




## pfsense on nanobsd

### nanoBSD background and architecture

NanoBSD is basically the FreeBSD functionality and package set 
super-optimised for embedded purposes ('Appliances') 
by running it ReadOnly (as if using a Live USB image) 
which really suits a) flash media storage, and 
b) smooth restart after a power outage


* two code partitions
    * _.disk.full NanoBSD images contain whole disk (3 parts)
    * _.disk.image contains only a single code partititon
* single cfg partition
    * persistent config files to copy over /etc at boot up
    * see [how to persist changes BACK into cfg](https://www.freebsd.org/doc/en/articles/nanobsd/howto.html)
* 

[https://doc.pfsense.org/index.php/Full_Install_and_NanoBSD_Comparison]

* disk left in RO mode to prolong shelf-life
* _RRD_ (usage) graph data, DHCP leases, etc are transient
* console reboot will back up these transient files to restore them when you restart
* Log files are NOT persisted across reboot
* Not really made for expanding partition across media ('a la Pi)
    * [forumQ on expanding](https://forum.pfsense.org/index.php?topic=61434.0)
* running out of space is usally about improper configuration (or specification)
    * [https://forum.pfsense.org/index.php?topic=59474.0]
* 

If you received an embedded device that preshipped with pfsense, 
but only on a 2GB SD card, you could use an 8GB card instead, 
and on the next (upgrade/) install the use 4GB image. For help see:

* [one post about manual install](https://forum.pfsense.org/index.php?topic=75427.0)
* [step by step on installing pfsense onto generic APU device](http://www.yawarra.com.au/tutorials/how-to-install-pfsense-on-an-apu/).


Alternative is to [Full Install to flash](http://gegonotes.com/installing-pfsense/), 
which risks wearing the media and suffering filesystem corruptions.

See some misc command examples for disk manipulation 
[here](https://www.freebsd.org/doc/handbook/disks-adding.html), 
[here](https://www.freebsd.org/doc/handbook/usb-disks.html) and 
[here](http://bsdrp.net/documentation/technical_docs).


### pfsense general

from ssh shell...

```
# install 

```

#### Services

##### DHCP

- Yes

##### DNS

* Enable ('Unbound') DNS Resolver
* (listen on) Network Interface: LAN and localhost
* Outgoing: WAN
* Forwarding Mode: Y 
* DHCP Registration: Leases AND Static
* help - [https://doc.pfsense.org/index.php/Unbound_DNS_Resolver]

##### Avahi

```
# packages are case sensitive
pfSsh.php playback installpkg "Avahi"
```

##### Modem Access

- modem has internal interface on .1. network available so can be connected

##### Snort IDS/IPS

* Installation
    * [register account to get Oinkcode](http://hubpages.com/technology/How-to-Set-Up-an-Intrusion-Detection-System-Using-Snort-on-pfSense-20)
    * [Then setup Snort](https://doc.pfsense.org/index.php/Setup_Snort_Package)
        * Interfaces: WAN
        * for other settings see [Config.md]
* Operation
    * to Check Logs
        * 
    * to **disable rules** rather than using _suppression lists_
        * see comments in [OLD simple procs](https://forum.pfsense.org/index.php?topic=61018.0)
        * See Setup Snort Package above for how to disable rules

##### SMTP messages

* Create new gmail account with 2 step authentication to allow App Specific pwds
* Add App Specific password - Custom - SMTP sender
* Use [Gmail SMTP server](https://support.google.com/a/answer/176600?hl=en)
    * SMTP server (not relay)
    * SSL or TLS to allow send to anyone
* System / Advanced / Notifications / SMTP E-Mail
    * E-Mail server: smtp.gmail.com
    * SMTP Port of E-Mail server: 465
    * Secure SMTP Connection: Enable SMTP over SSL/TLS
    * Addresses - _see Config_

##### Certificates

Alternatives:

* Certificates from LetsEncrypt ?
	- free to obtain Domain Validation certs
	- should be trusted out of the box by most systems
	- uses ACME process
    * see current progress of pfsense package [https://redmine.pfsense.org/issues/5434]
* Generating device certificates from Signing Requests (CSR)
	- this didn't have the answer [https://forum.pfsense.org/index.php?topic=70122.0]
	- but this explains how to use the command line [http://www.schie.com/certificates-and-pfsense-how-to-sign-cert-requests/]

Procedures:

* Generate new CA
    * System / Cert Manager / CAs
    * New / create Internal CA
        * Key length: 4096 / Algorithm: SHA512
            * using high settings: CA key will NOT affect effort to encrypt traffic
        * Lifetime: 730
            * Choosing low value as assuming CA will be easy to replace :D

* Generate certificate for firewall box
    * Certificates / Add / Create Internal
        * Name: _see Certificate Name in Config_
        * Key: 2048 / Algo: SHA256 (defaults)
        * Lifetime: 730
        * Common Name: (use FQDN from System / General)
        * (rest as default)
    * System / Advanced / Admin
        * SSL Cert: choosen Name above
        * Save
    * System / Cert Manager / Certificates 
        * delete old webConfigurator default certificate

* To generate new certificates for other devices
	* System Cert Manager / Certificates / Add 
		- Method: Create an internal certificate
		- Descriptive name: My nicely description name
		- Certificate Type: Server Certificate
		- Common Name: hostname
		- Alternative Names: FQDN - hostname.fully.qualified.dm
		- Save
		- Export P12
		- Export Key but STORE SECURELY!


##### Proxy

Alternatives:

    * Squid rather than simply OpenDNS + block external DNS resolvers
    * [https://doc.pfsense.org/index.php/Setup_Squid_as_a_Transparent_Proxy]
    * Squid3 (proxy) - YES
        * Interface: LAN
        * Transparent (redirect :80)
        * local cache (depending on storage available) ?
        * MITM ? e.g. Peek And Splice (replaces SslBump)
        * Logging ?
    * SquidGuard3 (access control) - YES
        * blacklist: e.g.
            * shallalist.de
            * 
        * how to authenticate users - for reporting and elevation
        * e.g. based on MAC and (optionally) local logged-on username
            * pfsense natively supports LDAP & Radius
            * see [http://wiki.squid-cache.org/Features/Authentication]
            * [basic passwords from ncsa_auth](http://www.squidguard.org/Doc/authentication.html)
            * [Squid MAC ACLs](http://wiki.squid-cache.org/SquidFaq/SquidAcl#Can_I_set_up_ACL.27s_based_on_MAC_address_rather_than_IP.3F) and [examples](http://tecadmin.net/configure-squid-proxy-server-mac-address-based-filtering/)
            * [intro to squid ACLs](https://workaround.org/squid-acls/)
            * detailed and specific syntax and examples for [defining squid ACLs](http://www.squid-cache.org/Doc/config/acl/)
    * 
    * ? lightsquid (log reporting) ?
        * [http://hubpages.com/technology/Monitoring-Internet-Usage-With-LightSquid-and-pfSense]
    * ? HAVP - virus scan downloads (e.g. max 1 MB) ?
        * e.g. SquidClamAV (via ICAP)
    * ? DansGuardian ? web content filtering
        * 

##### bandwidth monitoring

    * for information on options 
		* see [https://doc.pfsense.org/index.php/How_can_I_monitor_bandwidth_usage]
	* BandwidthD
		- deprecating as upstream has no dev
		- shows simple but useful graphs
		- break down by local device 
	* ntopng
		- recommended instead of BandwidthD
		- may be more complex
		- not ideal for low memory / cpu systems
	* vnstat
		- used by new(ish) Status Traffic Totals package
	* netflow
		- uses softflowd package
		- relies on separate 'collector' node on network
		- more complex to set up but seems well liked
	* logstash
		- remote collection
		- combined with ELK for interpretation
		- NOT a simple setup, see below

##### Logs

It is often better to store logs remotely, whether they are for 
security, performance, or other kinds of monitoring. 
Most embedded systems are not designed for log storage, either 
they have small memory capacity, or the disks are flash and are not 
suited to constant writing and overwriting. 
Also they may not have the RAM or CPU capacity to do anything with data, 
other than to simply ship it elsewhere, for storage and further processing. 

* Remote Logging
    * Status / System Logs / Settings
    * Enable Remote Logging: check
    * Server 1: _see Syslog Server in Config_
    * Remote Syslog Contents: Everything
    * Save
* Log Analysis
    * for filter to interpret pfsense logs with ELK see [https://elijahpaul.co.uk/monitoring-pfsense-2-1-logs-using-elk-logstash-kibana-elasticsearch/] 
 
For configuring and using the remote collection service, 
see [https://github.com/artmg/lubuild/blob/master/help/configure/Networked-Services.md]

###### ELK

A suggested method:
* set up an ELK stack remote logging server
* add Softflowd on pfsense to feed netflow packet data 
* the (remote) logstash server inserts into ElasticSearch
* build a simple Kibana dashboard to track per-device usage, all usage, down vs. up, v4 vs v6, etc.

Other suggestions:
* install dnsmasq on the remote to cache dns lookups locally 
	- reduces pfsense traffic, CPU and risk of crash
* logstash filter only doing ip -> FQDN translations for IPv4 fields that match my internal LAN
* tell Kibana that the netflow.in_bytes field was measured in bytes
	- so that it would automatically convert to KB/MB/GB
* custom index template so that my FQDN fields weren't analyzed
* set up some graphs and tables to see total and individual usage
	-(traffic from pfsense router to an internal machine == downloads, 
	- and traffic from internal machines to my pfsense router == uploads)


### troubleshooting

For general help see [https://doc.pfsense.org/]

If _Saving Settings are slow_ [sic] on NanoBSD it may be due to pfsense bug:

* Diagnostics / NanoBSD
* Media = Read / Write (NOT RO)
* Permanent = check (keep media mounted RW always) and Save

If modem is inaccessible:

* see [pfsense Modem Access](https://doc.pfsense.org/index.php/Accessing_modem_from_inside_firewall)
* set up OPT2 on re1 .1.5/24 with NAT 

For capturing packets, use the [Diagnostics / Packet Capture feature](https://doc.pfsense.org/index.php/Sniffers,_Packet_Capture).


#### psfense service specific

##### Unbound DNS Resolver

Under Services / DNS Resolver / Advanced are

* Log level verbosity
    * to see logs: Status / System Logs / System / DNS Resolver

* Help
    * [https://doc.pfsense.org/index.php/Unbound_DNS_Resolver]
    * [https://unbound.net/]


###### CNAMES for aliases 

* Unbound does NOT fully support CNAMES - even though you can enter them into advanced options, the service is NOT authoritative so clients are unlikely to resolve them [https://www.bentasker.co.uk/documentation/linux/279-unbound-adding-custom-dns-records]
* The recomendation for CNAME support is to use BIND or NSD although these also have limitations [https://forums.freebsd.org/threads/unbound-resolver-or-server.49131/]
* In theory you could would put another DNS service onto a different local port and create a stub zone within Unbound, but Dnsmasq (DNS Resolver) does not really support CNAMES either [https://forum.pfsense.org/index.php?topic=78356.0]
* DNS Resolver Edit Hosts feature allows a kind of alias, but you still need to manually enter an IP. This means double-updating with DHCP leases, defying the whole point! [https://forum.pfsense.org/index.php?topic=98423.0]
* [https://redmine.pfsense.org/issues/2410]
* At the end of the day the simplest route to rename a device which does not supply its own hostname is to put the hostname you want on the DHCP lease and accept that the address will be static



