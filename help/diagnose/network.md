# Lubuild / Help / Diagnose / Network

For some background on network interfaces and utilities you may find [https://wiki.openwrt.org/doc/networking/network.interfaces] interesting - its NOT specific to Lubuntu, but practical and applicable nonetheless. 

## Connectivity

```
HOST_NAME=host.domain.tld

# tracepath - installed in lubuntu - by default ?
tracepath $HOST_NAME

# other tools
# Choose between traceroute and mtr
# * introduction to the two - https://www.digitalocean.com/community/tutorials/how-to-use-traceroute-and-mtr-to-diagnose-network-issues
# * one professional's view - https://blog.thousandeyes.com/caveats-of-popular-network-tools-traceroute/
# * several people's views - http://serverfault.com/questions/585862/why-mtr-is-much-faster-than-traceroute

### traceroute
# linux terminal equivalent of Windows tracert command
# not installed by default on Lubuntu
sudo apt-get install traceroute

traceroute $HOST_NAME

### mtr
# mtr-tiny is a console app using ncurses for a tabular display, but without needing too many dependencies
# should be installed by default on Lubuntu
# sudo apt-get install mtr-tiny

# standard 'linear' console output
mtr -rw $HOST_NAME

# interactive tabular output with quicker updates
mtr $HOST_NAME
```

## Names and Addresses


```
### DHCP addressing

#### All interfaces
# list of interfaces
nmcli dev

# details of each interface
nmcli dev show

# the next two commands look better on a wider console
# display the interfaces available
ip link show

# show the amount of traffic that has passed through each interface
cat /proc/net/dev

# check if an IP address is assigned to your interface
ip addr
# ifconfig # works but is deprecated in favour of ip addr

# see if the interface has any manually assigned parameters
cat /etc/network/interfaces

# display details of lease(s) obtained
cat /var/lib/dhcp/dhclient.leases

# /var/lib/dh* 
# no longer seems to hold anything useful

# dhclient
# doesn't do much on its own - see 

#### Renew DHCP address

# when renewing DHCP, try purging locally cached lease file
sudo dhclient -r -v && sudo rm /var/lib/dhcp/dhclient.* ; sudo dhclient -v
# credit - http://askubuntu.com/a/431385
# if you're still having issues, check the lease has been removed from the DHCP server too


#### Specific interface

INTERFACE=eth0

# display current settings
nmcli dev show $INTERFACE
# nmcli dev list iface $INTERFACE - old syntax
# ifconfig $INTERFACE - deprecated

### DNS Resolution

# By default, since around 12.04, NetworkManager has relied on a local DNS cache provided by
# dnsmasq running on localhost, which passes requests out when the host is not cached.
# credit - http://askubuntu.com/a/368935
# help - https://help.ubuntu.com/community/Dnsmasq
# FAQ - http://thekelleys.org.uk/dnsmasq/docs/FAQ

# Check the configuration
cat /etc/NetworkManager/NetworkManager.conf
# if you update this config (e.g. comment out dns=dnsmasq) then you need to restart nm afterwards
sudo restart network-manager
# To see this running check
dig -x 127.0.0.1
# and note the response comes from ;; SERVER: 127.0.1.1#53

# check the (dynamically generated) resolver settings
cat /run/resolvconf/resolv.conf 
# check the order of name resolution
cat /etc/nsswitch.conf
# help - http://manpages.ubuntu.com/manpages/wily/man5/nsswitch.conf.5.html

# check what DNS server is set on your network interface(s)
nmcli dev show | grep DNS

#### dnsmasq

# if your Network Manager conf (see above) uses dnsmasq then ...

# flush dns cache
/etc/init.d/dnsmasq restart
# is this a generic alternative? - sudo /etc/init.d/dns-clean    (  add option:    start    ??)

# temporarily switch name server by killing and hardcoding during restart
killall dnsmasq
dnsmasq --server=192.168.2.1
# credit - http://askubuntu.com/a/682058


#### browser dns cache

# ?? chrome://net-internals/#dns  - Clear Host Cache

# firefox - either restart browser
# or use DNS Flusher addon - https://addons.mozilla.org/en-us/firefox/addon/dns-flusher/

#### resolving

# Advanced options for attempting to resolve names

HOST_NAME=host.domain.tld

# verbose host output
host -v $HOST_NAME

nslookup -debug $HOST_NAME

# "domain information groper" from dnsutils (included by default in Lubuntu?)
dig $HOST_NAME
# use @a.b.c.d before other parameters to specify dns server
# help - http://manpages.ubuntu.com/manpages/trusty/man1/dig.1.html
# examples - http://www.tecmint.com/10-linux-dig-domain-information-groper-commands-to-query-dns/
```

## Wireless

# iwconfig # deprecated in favour of iw
iw dev



## Discovery

### Services

Browse a list of local services advertising themselves as being available to you
```
# CLI
sudo apt-get install -y avahi-utils
avahi-browse -a

# GUI
sudo apt-get install -y avahi-discover
avahi-discover
```

The Avahi (Bonjour/Zeroconf) service can broadcast names across your network, using Multicast DNS (mDNS). Unfortunately some routers can block these multicast packets, so the first thing to make sure is that you really are on the same network. If you are trying to resolve to a wired device, plug in a wire - if your remote device is on wifi, then go wireless too.

For more on ''Name Resolution'' see ''Networked Services'' page.

### Topology Map 

How to build up an idea of your network topology and devices

Even when hosts are not explicitly advertising their services for autodiscovery, you may be able to identify hosts and services using the following order of steps.

* ping sweep 
** follow up with reverse DNS lookup
** ARP check after the scan 
* TCP SYN scan
* full port scan

The first step is the simplest, quickest and least aggressive, but may not work on some networks. As you work down this list, although you are more likely to get results, each option becomes more time consuming, and importantly such actions can be considered signs of aggression. On a securely managed network, you, the discoverer, may find yourself being "discovered" by administrators, and potentially even banned!

If you choose to try such steps then one of the most popular and fully functioned tools is '''nmap''' and it's handy GUI '''zenmap'''. On the other hand, if you own the network, and want to discover who is doing this kind of scan, then '''Wireshark''' is a good starting point as a traffic analyser :)

#### nmap CLI 

```
sudo apt-get install -y nmap

SUBNET_SPEC=192.168.1.0/24

# quick ping scan showing hostnames, computer type and latency
sudo nmap -sn $SUBNET_SPEC

# basic reverse DNS lookup (no root)
nmap -sL $SUBNET_SPEC

# TCP SYN connection to 1000 of the most common ports
nmap $SUBNET_SPEC

# scan for ALL ports (using TCP SYN and UDP)
sudo nmap -sS -sU -PN -p 1-65535 $SUBNET_SPEC

# credit - http://bencane.com/2013/02/25/10-nmap-commands-every-sysadmin-should-know/
```

#### zenmap GUI 

 sudo apt-get install -y zenmap
 sudo zenmap

You may find this [beginners guide](https://www.linux.com/learn/tutorials/381794-audit-your-network-with-zenmap) useful

Other pictorial tools include:

* [cheops-ng tool](http://cheops-ng.sourceforge.net/index.php)
    * # old software, package no longer in repos - sudo apt-get install cheops-ng
* [OpenNMS server(s)](http://www.opennms.org/about/)
* [SpiceWorks IT-ad-supported free tools](http://www.spiceworks.com/free-network-mapping-software/)
* 

## Performance 

### ISP Diagnostics 

```
# browser based using an HTML5 (flash-free) server...
x-www-browser http://speedof.me

# bandwidth measurement from terminal
speedtest-cli
# install instructions?


#### old Network download speed tests ####

# quite a close sever for browser-based testing
x-www-browser http://speedtest.uk.net/
 
# the fastest ubuntu mirror seems to be kent for the moment
wget 'http://www.mirrorservice.org/sites/cdimage.ubuntu.com/cdimage/lubuntu/releases/13.10/release/lubuntu-13.10-desktop-amd64.iso' -O /dev/null
# 400-500KB/s is reasonable over wifi, 1MB/s is possible over ethernet
# or try germany...
wget 'http://mirror.skylink-datacenter.de/ubuntu-releases/13.10/ubuntu-13.10-desktop-amd64.iso' -O /dev/null
```

### Internal bandwidth tests 

server: iperf -s

client: iperf -c x.x.x.x

### What's using my bandwidth ? 

These are linux utilities to display network traffic per process per remote host...

Candidates:
* iftop (see cli options)
* nethogs
* lsof -i
* netactview (GUI)

Sources:
* http://serverfault.com/questions/248223/how-do-i-know-what-processes-are-using-the-network
* http://www.reddit.com/r/linux/comments/r1v5x/is_there_an_app_in_linux_that_shows_perprocess/
* http://how-to.wikia.com/wiki/How_to_monitor_network_traffic_on_a_Linux_or_Unix_like_OS

