# Lubuild / Help / Diagnose / Network

## Connectivity

```
# Choose between traceroute and mtr
# * introduction to the two - https://www.digitalocean.com/community/tutorials/how-to-use-traceroute-and-mtr-to-diagnose-network-issues
# * one professional's view - https://blog.thousandeyes.com/caveats-of-popular-network-tools-traceroute/
# * several people's views - http://serverfault.com/questions/585862/why-mtr-is-much-faster-than-traceroute

### traceroute
# linux terminal equivalent of Windows tracert command
# not installed by default on Lubuntu
sudo apt-get install traceroute

traceroute host.domain.tld

### mtr
# mtr-tiny is a console app using ncurses for a tabular display, but without needing too many dependencies
# should be installed by default on Lubuntu
# sudo apt-get install mtr-tiny

mtr -rw host.domain.tld

```

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

