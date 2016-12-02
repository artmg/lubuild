
## Configure interface

If want to set up a direct connection to a single device, this should help. 

Otherwise, for:

* diagnosing issues with connectivity, resolution, addressing or performance - [General Network troubleshooting](https://github.com/artmg/lubuild/blob/master/help/diagnose/network.md)
* If you want to find out more about what is on your local network, see Discovery / Services in Network Diagnostics [https://github.com/artmg/lubuild/blob/master/help/diagnose/network.md#Discovery] 
* For issues turning radios on and off, see [Hardware Troubleshooting](https://github.com/artmg/lubuild/wiki/Troubleshooting#Hardware) 
* For configuring Network Services [https://github.com/artmg/lubuild/wiki/Networked-Services]



### Using DHCP


```
# other examples include wlan0 - see ifconfig for a list

INTERFACE=eth0

# display current settings
ifconfig $INTERFACE

# renew IP address on wired connection
sudo dhclient -r $INTERFACE
sudo dhclient $INTERFACE
ifconfig $INTERFACE
```

#### Troubleshooting
```
# show details of dialog with DHCP server whilst requesting lease
sudo dhclient -v $INTERFACE

# display details of lease(s) obtained
cat /var/lib/dhcp/dhclient.leases
```

### IP Addressing issues

If you are having addressing issues, ARP may be able to help you diagnose. See 
[http://www.tummy.com/articles/networking-basics-how-arp-works/]

Or perhaps check using an ARP scan
```
sudo arp-scan -l -I $INTERFACE
sudo arp-scan 192.168.1.0/24
sudo arp-scan --arpspa=192.168.1.0/24 --destaddr=MAC
```
#### temporary manual IP address

should we use ifconfig to add and change config (see [http://www.tecmint.com/ifconfig-command-examples/]) instead of **ip** ?

```
# credit - https://wiki.archlinux.org/index.php/Network_configuration#Manual_assignment
# This method does NOT persist across reboots. 
# That would be in /etc/network/interfaces
# set up variables
INTERFACE=eth0
SUBNET=192.168.4
IP_ADDRESS=$SUBNET.151
DEFAULT_GATEWAY=$SUBNET.1
SUBNET_MASK=255.255.255.0
BROADCAST_ADDRESS=$SUBNET.255
# enable the network interface:
sudo ip link set $INTERFACE up
# Assign a static IP address in the console:
sudo ip addr add $IP_ADDRESS/$SUBNET_MASK broadcast $BROADCAST_ADDRESS dev $INTERFACE
# Then add your gateway IP address:
sudo ip route add default via $DEFAULT_GATEWAY
# finally check the address
ip address show $INTERFACE
# and ping the gateway
ping -c 4 $DEFAULT_GATEWAY
```

If you later need to delete the temporary address use

 sudo ip addr del $IP_ADDRESS dev $INTERFACE


### change DNS order

sudo leafpad /etc/nsswitch.conf
hosts:          files dns mdns4_minimal mdns4 [NOTFOUND=return]
# help - http://manpages.ubuntu.com/manpages/wily/man5/nsswitch.conf.5.html

