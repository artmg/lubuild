# OpenWrt

OpenWrt is a great alternative firmware for network appliances you may have bought, 
including routers, as it allows you to configure them just how you want, 
and utilise all the hardware capabilities they may physically possess. 

NB: This page does NOT include the per-device stuff about how to get the image on there in the first place!

See also:

* [Procedures for Configuring Network Interface](https://github.com/artmg/lubuild/blob/master/help/configure/network-interface.md)


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

