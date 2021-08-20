# Firewall development instance

This is about configuring a general purpose computer device to develop and test candidate configurations for firewall and or routing appliance software. Essentially the solution is a VirtualBox configuration that allows you to play with the software until it is configured ready. Furthermore it is designed so that it could temporarily be delivered into production, for service continuity for the time it takes to reconfigure a dedicated physical appliance with developed configuration. 

See also

* [Network Appliance Firmware](https://github.com/artmg/lubuild/blob/master/help/configure/network-appliance-firmware.md) for more general information on such appliances and software
* 

## Introduction

### Software example

We will use OPNsense as the example here, although pfSense, Untangle NG, IPFire etc could be used.

* This will be a Full (not Embedded) OPNsense install, 
    * but it has the option to enable RAM disk for embedded mode, 
    * so we can emulate an SD install. 
* as OPNsense seems to expect em drivers instead of pcn drivers, we use a NIC that the hypervisor presents to the guest as if it were an Intel gigabit MT 82540EM card, instead of AMD PCNet
	* We previously attempted to use the 'virtio' or 'vtnet' drivers, as they are supported by FreeBSD, in order to get better performance. However the configuration ended up filling the logs with DAD probe messages (IPv6 duplicate address detection), so we reverted to the (default?) Intel card.
* OPNsense normal expectations for connectivity are: 
    * The first interface is the LAN interface, e.g. em0
    * The second interface is the WAN interface. eg. “em1”
    * Possible additional interfaces can be assigned as OPT interfaces. If you assigned all your interfaces you can press [ENTER] and confirm the settings. OPNsense will configure your system and present the login prompt when finished.


### Hardware comparison

For hardware choices (arm vs x64 etc) see the end of this article. The short answer was the firewall devs support intel x86/x64 over other choices.
Fortunately we were able to free up a NUC device for this purpose. 

#### x86 Ubuntu Virtualbox on NUC hardware

* [Minimum spec](https://docs.opnsense.org/manual/virtuals.html#general-tips):
    * RAM 1GB
    * Vdisk 8GB

Both the internal Realtek RTL8111 and the USB AX88179 Ethernet chipsets are supposed to support 802.1q VLAN tagging. 

* The target physical configuration for this box ONCE deployed is: 
    * Uplink  -  USB ethernet
        * The trailing box is more noticeable route for the 'red' traffic
    * Downlink - Internal Ethernet
        * should connect to VLAN capable hardware
    * DMZ - Wifi
    	* if you actually need this use infrastructure mode
* the physical ports in ubuntu host are
    1: lo - loopback
    2: enp2s0 - internal ethernet
    3: wlp1s0 - wireless
    4: enxqqrrssttuuvv - USB ethernet
* so we will map in VM
    * nic1 - Internal Eth
    * nic2 - USB Eth
    * nic3 - wireless - (disconnected)

#### target multinic appliance

The physical appliance may have a non-default order for the NICs, so need manual configuration of Interfaces during boot. For instance it might be set up (re for Realtek):

* re0 is OPT1 (Dmz)
* re1 is WAN
* re2 is LAN


## Staging environment design

Here is an introductory diagram showing how the environments compare for different stages

```
PRE-PROD 
   |
   | 2 br usb eth 'WAN'
/-----\          
|APPLI|–– 3 br wifi 'DMZ/OPT1'
\-----/           
   | 1 br int eth 'LAN'
   |

DEVELOPMENT
------------ local network --------------
   ^                                |
   | 2 br                           V 2 nat+pf 21
/-----\                     ^    /-----\  *~~~*   vm  
|APPLI|––X 3 discon       (dh    |dsktp|--!SHR! shared
\-----/                  client) \-----/  *~~~* folder
   ^ 1  .1 router           v       | 1 
   |    dhcps                       V
   ----------- intnet1 --------------

TESTING incl subnets and firewall rules
    ------------ local network ----------------  
       ^              |   nat   |   nat   |   nat
       | 2 br         V 2 +pf   V 2 +pf   V 2 +pf
  5 /-----\        /-----\   /-----\   /-----\   
  ->|APPLI|––X 3   |dsktp|   |$cli4|   |$cli5|   
  | \-----/        \-----/   \-----/   \-----/   
  | 4^ ^ 1            | 1       | 1       | 1    
  |  | |              V         |         |      
  |  | --- intnet1 ----         V         |      
  |  -------- intnet4 -----------         V      
  -------------- intnet5 ------------------      
```

### Component machines

The preproduction is straightforward, as it is just the regular appliance firewall software running on a VM on the NUC used for testing. Development and testing however needs additional functionality, and for simplicity of access we suggest using a VirtualBox instance on your own desktop client machine, so you have direct access to the VirtualBox display console. Of course you could run this through a remote desktop to the NUC if you prefer to keep things separate.

The Desktop VM is where a browser can be used, to connect to the software configuration user interface (Configurator or WebUI). It can also be used for running command line tools. The simplest way to access this is via the VirtualBox display console, and once you have the Client Tools installed you can copy and paste commands and URLs. 

To make it easier to ship configuration files or scripts back and forth, we use a VM Shared Folder. We also set up port forwarding for secure shell (ssh on port 21), not only so you can run commands directly, but because this also allows you to tunnel other protocols, like a remote desktop or a socks proxy. 

When it comes to testing filtering or firewall rules between different VLANs, you can add additional NICs and move the subnet onto them. For these kind of tests a command line client should be enough, for pinging addresses or curl/wget -ting  urls. Theoretically you could also socks or reverse proxy from here, but we'll leave that up to you.

The preproduction deployment can also be used as `alternative production`, whilst rebuilding the appliance to match the tested config.


### Networking notes

==to tidy==

The Appliance VM should use a bridge rather than a NAT, so that it  'appears' plugged directly into the network, gets a realistic address and avoids duplicate addressing. The bridge is a simple configuration, but as it uses a `net filter` [driver on the host](https://www.virtualbox.org/manual/ch06.html#network_bridged) the host and other VMs can connect via that network interface. Except the default OPNsense WAN config is to block incoming traffic, especially to the admin console, so we need another way to build the box via the LAN

* bridge the USB Ethernet (WAN) to our network 
    * this will get DHCP initially, so we can network in here with config client first?
    * this will become uplink so it can stay as DHCP
    * if we connect the downlink to our network it would produce IP clashes
    * this allows the build to complete, but does not give access to WebGUI (Configurator)

==roll into solution description==
* proposed temporary solution
	* leave nic 2 bridged to usb ethernet with its dhcp client
	* leave nic 3 (bridged to wireless?)
	* nic 1 with its .1 address as router and dhcp server goes into internal virtual network
	* also on internal is second VM
	* this has dhcp client to get an address from the appliance software via the internal network and dhcp client to get a local address from bridge to the usb ethernet
		* if we really need to prevent traffic coming up via 2nd NAT interface, we could amend routing rules

* we won't set production MAC addresses on test environments as it may cause confusion if devices are in the same network

* it runs a proxy to redirect http traffic from local bridged address through to internal appliance address

#### other options failed or discounted

==to tidy==

* You could set up a WAN-only deployment
	* according to [this request](https://github.com/opnsense/core/issues/141) (and this article[](https://homenetworkguy.com/how-to/create-opnsense-vm-in-virtualbox-for-screenshot-or-evaluation-purposes/)) this would automatically allow the WebGUI over WAN
	* however it sounds like rules might move and it would not match our target deployment
	* and what above blocked private networks

* instead of opening up the config to allow WebGUI via WAN (yuk) lets create a temporary loopback
    * build a nginx proxy that connects to LAN inside virtual network
        * nic1 gets attached to NAT network
        * by default it will expect to become .1.1 with DHCP server
        * so proxy will have 1 bridged and 2 on NAT Network
* NAT Network on VM on 168.192.1.1/24 no DHCP
    * or simply use PF on the nat network
    * can't use PF on NAT as NAT we have no control over network numbering
    * Tried using NAT Network, but the NAT Service insisted on being the .1 gateway
        * https://www.nakivo.com/blog/virtualbox-network-setting-guide/
    * Need to try internal network instead
* Nginx with vagrant would be more CLI friendly
    * but time consuming & more code here
        * if you wanna try it later: https://devgrill.com/how-to-provision-an-nginx-server-on-virtualbox-using-vagrant/
    * let's just use a bitnami image
    * 

* alternatively simply use VirtualBox Port Forwarding
    * 
    * e.g. VBoxManage modifyvm "VM name" --natpf2 "http,tcp,,2222,10.0.2.19,22"
VBoxManage modifyvm "VM1" --natpf1 "http,tcp,,80,,80"
VBoxManage modifyvm "VM1" --natpf1 "http,tcp,,443,,443"
Listing all PF rules does not seem to be available through VBoxManage. It is easy with the GUI however. In the VM, select Machine, Setings, network and port forwarding will list the PF rules. If you ever need to remove a rule, you need to do this procedure to get the rule ID number. Then on your Host OS, assuming we want to remove PF rule number "1234":: VboxManage modify "VM1" --natpf1 delete "1234"


##### diagram move UP

DO once in test with pfsense DHCP and again with Gateway DHCP

192.168.xx.yy - client

* Main LAN
192.168.xx.1 gateway and DHCP

VirtualBox Host
* VHost nics
    1: loopback 
    - 127.0.0.1
    2: enp2s0 - internal ethernet    - not connected
    3: wlp1s0 - wireless    - not connected
    4: enxqqrrssttuuvv - USB ethernet  - connected to Main LAN
    - 192.168.xx.yy (dhclient)

Virtual Guest for OPNsense test
* so we will map in VM
    * nic1 - bridged to enp2s0 - Internal
        * 192.168.1.1 (fixed by guest's OPNsense software)
    * nic2 - bridged to enxqqrrssttuuvv - USB Eth - 
        - 192.168.xx.?? (dhclient)
    * nic3 - bridged to wlp1s0 - wireless

want to change the way I connect to nic1, that will become the pfsense LAN interface 
    * nic1 - NAT so I can connect via nic2
        * use PF rule .xx.?? :8080 to 192.168.1.1:80


* Things to try
* move to where wireless works ok
* Try working out which nic the PF binds to by default binding
    * force this by 'bind a NAT service to specified interface'
    * VBoxManage setextradata global "NAT/win-nat-test-0/SourceIp4" 192.168.1.185
    * can only find mention of bind to IP add not IF id, perhaps because the NAT engine uses sockets?
* Try it on NAT not NATNETWORK
    * even though NATNETWORK is the way to go as you have control over it's creation and config
    * you can bind the nat using --natbindip1
* try setting the PF source IP to the dhclient addr on virtual host
    * do I set it to the host's xx.yy or the guest's xx.??
    * 
* Check the GUI is up on nic1 by connecting to the Ethernet
* Try the NAT to the Nginx VM instead to make sure that is accessible from outside
* go back to using the proxy guest!

#### old

Following the setup above gives:

```
 OPNsense.localdomain
 LAN (em0)  -> v4: 192.168.1.1./24
 WAN (em1) -> v4/DHCP: 192.168.xx.28
```

When the host has .xx.24 wired and .xx.22 wireless

* Initially intended to remotely config using vnc on NUC
    * Uplink  -  Wifi 
        * initially the only one, also gives DHCP
    * Downlink - Internal Ethernet 
        * would not be needed until testing
    * Config client - USB ethernet
        * these two could perhaps swap

### Environment comparisons

Env   | Production
------|---
Model | APU2
Name  | myAppliance
LAN   | re2
WAN   | re1
DMZ   | re0

Env   | Pre- / Alternate Production
------|---
Model | Intel NUC
Name  | myNuc
LAN   | em1 bridged internal ethernet
WAN   | em2 bridged USB ethernet
DMZ   | em3 bridged wlp1s0 wireless infra

Envrnmt | Development
------- | ---
Model   | VirtualBox
Name    | OpnSenseDev
LAN     | em1 intnet
WAN     | em2 bridged en0 wireless
DMZ     | em3 disconnected llw0
Clients | desktop1

Envrnmt | Testing
------- | ---
Model   | VirtualBox
Name    | OpnSenseDev
LAN     | em1 intnet
WAN     | em2 bridged en0 wireless
DMZ     | em3 disconnected llw0
Clients | desktop1, cli4, cli5
VLANx   | em4 intnet4
VLANy   | em5 intnet5


## Virtual environments

### Tailor your setup

Use this template and store your own copy in a private config note

```
OPN_REL=21.7
OPN_VER=${OPN_REL}.1
OPN_IMG=OPNsense-${OPN_VER}-OpenSSL-dvd-amd64
VM_NAME=OpnSenseApp
VM_NAME2=OpnSenseDsk
VM_NAME4=OpnSenseCli4
VM_NAME5=OpnSenseCli5
DSK_IMG=turnkey-core-16.1-buster-amd64.ova
CLI_IMG=turnkey-core-16.1-buster-amd64.ova
VM_FOLDER=~/VMs
VM_NET=OpnNet

ENV_MODE=PROD
NET_IF_WAN=en0
# or DEV or TEST
# where you won't need these
NET_LAN=enxqqrrssttuuvv
NET_DMZ=wlp1s0


HOST_IP=192.168.xx.yy
OPN_RANGE=192.168.1.0/24
OPN_IP=192.168.1.1
```

### Download images

#### OpnSense image

```
# AMD64 DVD download url from https://opnsense.org/download/

mkdir -p "${VM_FOLDER}"
cd "${VM_FOLDER}"

wget https://www.mirrorservice.org/sites/opnsense.org/releases/${OPN_REL}/${OPN_IMG}.iso.bz2
wget https://www.mirrorservice.org/sites/opnsense.org/releases/${OPN_REL}/${OPN_IMG}.iso.bz2.sig
```

copy the key from https://opnsense.org/opnsense-20-7/

```
# credit https://docs.opnsense.org/manual/install.html#download-and-verification

nano OPN-${OPN_REL}.pub

openssl base64 -d -in ${OPN_IMG}.iso.bz2.sig -out /tmp/image.sig
openssl dgst -sha256 -verify OPN-${OPN_REL}.pub -signature /tmp/image.sig ${OPN_IMG}.iso.bz2
```
 
 You should see `Verified OK` as a response

```
bunzip2 -c ${OPN_IMG}.iso.bz2 > ${OPN_IMG}.iso
```

#### Other images

* Desktop image
	* we recommend Lubuntu - see the home page of this repo for more 
	* if you want something totally out of the box...
		* Turnkey does not have a ready-desktop OVA
		* TinyCore's CorePlus is only an Installation ISO
		* Kali is a project that keeps a good variety of images updated, but the OVAs are over 2.5GB
		* virtualboxes.org is extremely out of date, and although https://virtual-machines.github.io/ has a minimal Lubuntu 18.04 including guest additions with OVA < 400MB, there is no substantial chain of trust
		* cloud-images.ubuntu.com has an OVA at 520MB but is is only server (focal-server-cloudimg-amd64.ova) not desktop

* CLI comand line interface client
	* https://www.turnkeylinux.org/core
		* This should give you all you need to get started
		* ` wget http://mirror.turnkeylinux.org/turnkeylinux/images/ova/turnkey-core-16.1-buster-amd64.ova `
		* if you want to check sums
			* ` wget https://releases.turnkeylinux.org/turnkey-core/16.1-buster-amd64/turnkey-core-16.1-buster-amd64.ova.hash `
			* ` sha256sum -c turnkey-core-16.1-buster-amd64.ova.hash `
	* https://bitnami.com/stack/nginx/virtual-machine
		* this would allow you to also try a reverse proxy
		* ` wget https://bitnami.com/redirect/to/1597006/bitnami-nginx-1.21.1-4-r70-linux-debian-10-x86_64-nami.ova?with_popup_skip_signin=1 `
 
### VirtualBox host

Install the virtualisation software and make it ready to auto-start VMs

```
# ubuntu repo version tracks a few months behind
# if you REALLY need the latest version see
# https://www.virtualbox.org/wiki/Linux_Downloads#Debian-basedLinuxdistributions

sudo apt update
sudo apt install virtualbox 
# installing the extension pack can occasionally come unstuck so let see whether it's really required!
sudo apt install virtualbox-ext-pack

sudo mkdir -p /etc/vbox

sudo tee -a /etc/default/virtualbox <<'EOF'
VBOXAUTOSTART_DB=/etc/vbox
VBOXAUTOSTART_CONFIG=/etc/vbox/vboxauto.conf
EOF

# no quotes around EOF to allow variable expansion before sudo
# https://stackoverflow.com/q/4937792
sudo tee -a /etc/vbox/vboxauto.conf << EOF
default_policy = deny
$USER = {
    allow = true
}
EOF

sudo chgrp vboxusers /etc/vbox
sudo chmod 1775 /etc/vbox
sudo usermod -aG vboxusers $USER

VBoxManage setproperty autostartdbpath /etc/vbox
VBoxManage setproperty machinefolder $PWD
# set Host Key as Right Alt (as macbook has no Right Ctrl)
VBoxManage setextradata global GUI/Input/HostKeyCombination 65514
# credit https://forums.virtualbox.org/viewtopic.php?f=1&t=46523

```

### check your host platform state

```
VBoxManage -v
VBoxManage list vms
VBoxManage list runningvms
VBoxManage list hostinfo
lsb_release -a
VBoxManage list intnets
VBoxManage list bridgedifs
VBoxManage list hostonlyifs
VBoxManage list natnets
VBoxManage showvminfo $VM_NAME
```

### create the environment 

...by configuring the VM guests

NB: it is possible FreeBSD on your guest VM may number the nics in reverse:

* --nic1 = em1
* --nic2 = em0

Beware of this when configuring and diagnosing. If necessary check using 
Menu / Devices / Network / UNckeck Connection Network Adaptor 1/2 
or force MAC addresses and check in `ifconfig em0` / 1

```
cd $VM_FOLDER

### APPLIANCE

# new virtual drive attached via sata
VM_VDI_SIZE=8096
VBoxManage createhd --filename "${VM_NAME}/${VM_NAME}.vdi" --size $VM_VDI_SIZE

# new registered VM with RAM and OS type
VBoxManage createvm --name "${VM_NAME}" --register
VBoxManage modifyvm $VM_NAME --memory 1024
VBoxManage modifyvm $VM_NAME --ostype "FreeBSD_64" 

# Attach virtual drive via sata
VBoxManage storagectl $VM_NAME --name "SATA Controller" --add sata
VBoxManage storageattach $VM_NAME --storagectl "SATA Controller" --port 0 --type hdd --medium "${VM_NAME}/${VM_NAME}.vdi"

# for now insert the DVD into a newly IDE attached drive
VBoxManage storagectl $VM_NAME --name "IDE Controller" --add ide
VBoxManage storageattach $VM_NAME --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium ${OPN_IMG}.iso
#VBoxManage storageattach $VM_NAME --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium none

VBoxManage modifyvm $VM_NAME --nictype1 82540EM --nictype2 82540EM --nictype3 82540EM
VBoxManage modifyvm $VM_NAME --nic2 bridged --bridgeadapter2 $NET_IF_WAN

if [ "$ENV_MODE" == "PROD" ] ; then (
    VBoxManage modifyvm $VM_NAME --nic1 bridged --bridgeadapter1 $NET_IF_LAN
    VBoxManage modifyvm $VM_NAME --nic3 bridged --bridgeadapter3 $NET_IF_DMZ
); else (
    VBoxManage modifyvm $VM_NAME --nic1 intnet --intnet1 ${VM_NET}1
    VBoxManage modifyvm $VM_NAME --nic3 null
#    VBoxManage modifyvm $VM_NAME --cableconnected3 off

); fi


### DESKTOP

case "$ENV_MODE" in
DEV|TEST)
    VBoxManage import "${DSK_IMG}" --vsys 0 --vmname $VM_NAME2
    # needs a bit more juice for a desktop
	VBoxManage modifyvm $VM_NAME2 --memory 1024 --vram 32

    VBoxManage modifyvm $VM_NAME2 --nic1 intnet --intnet1 ${VM_NET}1
    VBoxManage modifyvm $VM_NAME2 --nic2 nat
    VBoxManage modifyvm $VM_NAME2 --natpf2 delete vm2ssh
    VBoxManage modifyvm $VM_NAME2 --natpf2 "vm2ssh,tcp,,2222,,22"

    # Create shared folder and automount it with default mountpoint
    mkdir -p "${VM_FOLDER}/VmShared"
    VBoxManage sharedfolder add $VM_NAME2 --name VmShared --hostpath "${VM_FOLDER}/VmShared/" --automount

    # Drive to install Guest Additions
    VBoxManage storagectl $VM_NAME2 --name "IDE" --add ide
    # get the medium path with   vboxmanage list dvds
    VBoxManage storageattach $VM_NAME2 --storagectl "IDE" --port 0 --device 1 --type dvddrive --medium "/Applications/VirtualBox.app/Contents/MacOS/VBoxGuestAdditions.iso"
    # VBoxManage storageattach $VM_NAME2 --storagectl "IDE" --port 0 --device 1 --type dvddrive --medium none

    ;;
esac


### CLIENTS

# for import options see https://www.virtualbox.org/manual/ch08.html#vboxmanage-import-ovf
# Check what's in it before committing
# VBoxManage import "${CLI_IMG}" --dry-run

if [ "$ENV_MODE" == "TEST" ] ; then (
    VBoxManage import "${CLI_IMG}" --vsys 0 --vmname $VM_NAME4
    VBoxManage import "${CLI_IMG}" --vsys 0 --vmname $VM_NAME5

    # *** IMPORT may take a MINUTE or TWO ***

    VBoxManage modifyvm $VM_NAME --nic4 intnet --intnet4 ${VM_NET}4
    VBoxManage modifyvm $VM_NAME --nic5 intnet --intnet5 ${VM_NET}5

    VBoxManage modifyvm $VM_NAME4 --nic1 intnet --intnet1 ${VM_NET}4
    VBoxManage modifyvm $VM_NAME4 --nic2 nat --natpf2 "vm4ssh,tcp,,2422,,22"

    VBoxManage modifyvm $VM_NAME5 --nic1 intnet --intnet1 ${VM_NET}5
    VBoxManage modifyvm $VM_NAME5 --nic2 nat --natpf2 "vm5ssh,tcp,,2422,,22"
); fi



#Misc system settings COPIED.
# VBoxManage modifyvm $VM --ioapic on
# VBoxManage modifyvm $VM --memory 1024 --vram 128

VBoxManage showvminfo $VM_NAME

VBoxManage showvminfo $VM_NAME | grep NIC

# VBoxHeadless -s $VM_NAME

```

* Help – see the [VBoxManage manual](https://www.virtualbox.org/manual/ch08.html)
* Credit for some early versions of the vboxmanage commands and settings goes to Marcus Stubbing's [Practical OPNsense book](https://books.google.co.uk/books?id=oU2eDwAAQBAJ&lpg=PA40&dq=vboxmanage%20createvm%20opnsense&pg=PA40#v=onepage&q=vboxmanage%20createvm%20opnsense&f=false)

#### Finalise desktop build

Turning TurnKeyLinux (TKL) into a browser client

* start the VM with Normal window
* Enter a password like turnkeyD1
* Skip the rest and Quit
* use a local shell on the virtual host
	* ` ssh root@localhost -p 2222 `
* log on / Advanced / Quit

```
# Add a desktop to TurnKeyLinux Core
VM_NAME2=OpnSenseDsk
sed -i "s/core/$VM_NAME2/g" /etc/hosts
sed -i "s/core/$VM_NAME2/g" /etc/hostname

# updates may take 1 or 2 mins
apt update
apt dist-upgrade -y
# if grub-pc asks to install, choose sda (no number)

# Qt-based LxQt desktop (another 2 mins)
apt install -y task-lxqt-desktop

# old attempts
# this manual method missed some useful bits
#apt install -y lxqt sddm xauth
# when I tried, sddm failed to start unless xauth explicitly installed
#apt remove confconsole
#dpkg-reconfigure sddm

mkdir -p /usr/lib/sddm/sddm.conf.d/
cat >/usr/lib/sddm/sddm.conf.d/autologin <<EOF!
[Autologin]
User=root
Session=lxqt.desktop
EOF!

apt install -y falkon

cat > $HOME/Desktop/Falkon.desktop <<EOF!
[Desktop Entry]
Type=Application
Name=Falkon browser
Icon=falkon
Exec=/usr/bin/falkon --no-sandbox
EOF!
gio set $HOME/Desktop/Falkon.desktop "metadata::trusted" true

reboot 0
```

* You might still need to right-click the Falkon icon and Trust it
* VirtualBox Guest Additions

```
# dependencies take a minute or two to install
apt install udisks2 bzip2 dkms linux-headers-$(uname -r)
udisksctl mount -b /dev/sr0
cd /media/root/VBox*

# and the build might take that long too
./VBoxLinuxAdditions.run

```

##### Alternatives no longer used

* Alternative desktop...

```
# GTK-based LXDE desktop
apt install -y task-lxde-desktop surf

mkdir -p /usr/share/lightdm/lightdm.conf.d/
cat >/usr/share/lightdm/lightdm.conf.d/12-autologin.conf <<EOF!
[Seat:*]
autologin-user=root
autologin-user-timeout=0
EOF!

#mkdir -p /etc/lightdm/lightdm.conf.d/
#cat >/etc/lightdm/lightdm.conf.d/12-autologin.conf <<EOF!
#[SeatDefaults]
#autologin-user=root
#EOF!

# lightdm --show-config
#groupadd -r autologin
#gpasswd -a root autologin

```

* Alternative browser:
	* lightest active browser choices: Otter for QT, Surf for GTK, Falkon for HTML5 compatibility. Did try Midori, but was not sure about it
	* surf didn't seem to install properly, 



#### Switching environments

NB: If you use a DEV or PROD configuration in TEST, 
you may need to re-assign VLANs to Interfaces 4 and 5 
for the Cli4 & 5 machines to connect to the router.

* OpnSense (WebGui) / Interfaces / Assignments
* Pick a VLAN and drop down
* choose em3 for IntNet4 and em4 for IntNet5

## Development cycle

### Configure the Firewall Router

#### Install OPNsense

* Start the VM in the interface (not headless)
    * the boot process takes a minute or two
    * around half a minute in, after configuring devices and interfaces, you may see
        * "Press any key to start the manual interface assignment"
        * You might need this option when configuring the physical appliance
* log in as installer / opnsense
    * accept most prompts as default
* Guided Install
    * wait a few minutes for the files to copy
* set the root password
    * e.g. same as vm
* when asked to reboot, shut down
* eject the DVD
    * `VBoxManage storageattach $VM_NAME --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium none `

#### configure proxy

You _might_ need the OpnSense machine active to get DHCP on the second proxy interface

* Power up VM interactively
* wait a minute or two for the config to finish, even once the monochrome login appears
* log on: bitnami / bitnami
* hostname will be debian
* .
* https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/

(would it have worked if I set it up for [transparent proxy](https://www.nginx.com/blog/ip-transparency-direct-server-return-nginx-plus-transparent-proxy/)?)


#### Configure OpnSense

Factory default configuration:

* LAN IP address will be reset to 192.168.1.1
* System will be configured as a DHCP server on the default LAN interface
* WAN interface will be set to obtain an address automatically from a DHCP server


*  Start VM
*  log in as root
*  

* if you have two or three NICs, then the default arrangement is set as:
    * LAN em0
    * WAN em1
    * OPT1 em2 (you may need to add this manually)
* 


### Configuration management

There is a file /conf/config.xml which keeps the current settings. This can be moved into a new instance:

* save config to USB `\conf\config.xml`
* to import config during install: From console menu  
	* install  
	* reboot  
	* restore
		* `opnsense-importer`
		* credit https://forum.opnsense.org/index.php?topic=22307
* 
* 

```
# 


```

The opnsense-shell stems from the rc.initial under M0n0wall and includes the commands opnsense-xxx whichall have man pages installed: beep; importer; installer; shell; version; bootstrap; code; fetch; login; patch; revert; sign; update; verify; 

##### Wrong, do it again!

If you get fatal issues with your configuration, 
and have to restart from scratch using the command line

* if you only have the `root@~` prompt, get the console using `opnsense-shell`
* choose option 4 to 'Reset to factory defaults'


#### Config files on VM

Theoretically, you could do similar to [[#shared drive]] to make config files available on the main Appliance VM, but you would need to [install VBox Guest Additions on FreeBSD](https://docs.freebsd.org/en/books/handbook/virtualization/#virtualization-guest-virtualbox) and perhaps it might be simpler just to:

* push config files to the VM using `scp` 
	* then use the importer commands
* OR
* use the desktop and the WebGui to push configurations


### Using test clients

```
ssh root@localhost -p 2422

# set routing so traffic goes via the firewall 'intnet' connection

ip route list
ip route delete default
ip route add default dev eth0
ip route list
ip address
```

Testing Notes:

* For ping tests see https://github.com/artmg/lubuild/tree/master/help/diagnose/network.md#filtering-tests
* by default there are no allow rules for OPNsense VLANs, except autorules for DHCP, and you may need to enable ICMP to This Firewall before you can even ping the router
* TinyCore clients use udhcpc client
* if you can't manage your tests from curl or wget, then maybe consider the lynx character browser?


#### Understanding more about OpnSense

Useful background to OpnSense architecture and build:

* [Architectural intro from the dev manual](https://docs.opnsense.org/development/architecture.html)
* [Custom building other packages into OpnSense](https://forum.opnsense.org/index.php?topic=21739.0)
	* showing how packages are put together AND how to interact with ssh shell
* [Development Workflow](https://docs.opnsense.org/development/workflow.html?highlight=pkg%20install)
	* how to install packages
	* how the source and other elements come together
* [Vagrant development environment](https://forum.opnsense.org/index.php?topic=22313.0)
* [checking and managing installed packages](https://forum.opnsense.org/index.php?topic=42.0)

commands to be aware of:

* opnsense-importer - applies the conf/config.xml to a fresh build
* pluginctl configctl ?


#### Other settings

* enable RAM disk
    * System > Settings > Miscellaneous > Disk / Memory Settings,
* Virtual Machines only:
    * Disable all off-loading settings in Interfaces > Settings
* 

### Finalise the setup

```
# take a snapshot of the clean install
VBoxManage snapshot $VM_NAME take <name of snapshot>


# Put the LAN back onto the actual network adapter
VBoxManage modifyvm $VM_NAME --nic1 bridged --bridgeadapter1 enp2s0           --nictype1 82545EM


VBoxManage modifyvm $VM_NAME --autostart-enabled on
sudo systemctl restart vboxautostart-service 
sudo reboot

# if you use the timesync hack from https://forum.opnsense.org/index.php?topic=5263.0
# vboxmanage setextradata $VM_NAME “VBoxInternal/Devices/VMMDev/0/Config/GetHostTimeDisabled” “1”

```

**Note**: Ensure you test the autostart in pre-production, to avoid extended outages during alternate-production.


## Hardware choices

### Considering Pi4

* Want to use RPi4 with USB 3 Gigabit Ethernet dongle for maximum throughput
* Not sure on impact of SD card speed - current u65 is 8GB at Class 10

* armv8 (natively architecture of RPi4) does not yet have OpnSense builds/pkgs
    * although armv7 does 
        * https://opnsense.rene.network/FreeBSD%3A12%3Aarmv7/20.7/sets/
* [FreeBSD on RaspberryPi](https://wiki.freebsd.org/arm/Raspberry%20Pi#Raspberry_Pi_3_or_Pi_4)
* can armv7 BSD 12.1 run on Pi4?
    * https://download.freebsd.org/ftp/snapshots/arm/armv7/ISO-IMAGES/12.2/FreeBSD-12.2-PRERELEASE-arm-armv7-RPI2-20200910-r365545.img.xz
    * ArchLinux can put armv7 build onto Pi4
* Installing OpnSense on FreeBSD 
    * using a bootstrap script https://docs.opnsense.org/relations/freebsd.html
    * OpnSense is normally build on top of HardenedBSD, but let's not make this too hard
    * https://github.com/opnsense/update#opnsense-bootstrap
    * with this script, can we still use the armv7 packages?
        * 
* 

* NB: See [OpnSense post on a Nano Pi device that looks a lot like the GLiNet MT300N ('Mango')](https://forum.opnsense.org/index.php?topic=12186.150)


### Trying Pi4

```
IMAGE_FILENAME=FreeBSD-12.2-PRERELEASE-arm-armv7-RPI2-20200910-r365545.img.xz
MEDIA_LABEL=mysd4
MEDIA_DEVICE=sda
```

* wget https://download.freebsd.org/ftp/snapshots/arm/armv7/ISO-IMAGES/12.2/$IMAGE_FILENAME
* write using xcat from https://github.com/artmg/lubuild/blob/master/help/configure/write-Distro-to-flash.md#flash-two-partitions
* after **sync** results in
    * 2 partitions: 50MB  FAT32 (LBA) + 3GB FreeBSD
* remove disk and place in Pi
* RESULTS
    * This boots in Pi2 
        * with ethernet up and sshd running (already set in /etc/rc.conf)
        * log on with freebsd/freebsd and root/root
    * Fails in Pi3 (rainbow screen)
    * Fails in Pi4 (no hdmi output on L or R)



### Trying Pi 2

```
IMAGE_FILENAME=OPNsense-19.1-test-OpenSSL-arm-armv6-RPI2.img.bz2
MEDIA_LABEL=mysd2
MEDIA_DEVICE=sdb
```

* wget https://www.mirrorservice.org/sites/opnsense.org/FreeBSD:11:armv6/19.1/$IMAGE_FILENAME
* write using bunzip2 from https://github.com/artmg/lubuild/blob/master/help/configure/write-Distro-to-flash.md#flash-two-partitions
* after **sync** remove disk and place in Pi2
* you may connect second Ethernet (USB adaptor) before startup, but this will become WAN
* if you want a console, connect USB TTL cable to pi https://github.com/artmg/MuGammaPi/wiki/Connect-over-USB#serial-ssh-over-usb-ttl
* now power on Pi - first boot takes almost 5 minutes
* the onboard Ethernet will be LAN - plug in a client and connect to http://192.168.1.1/
* login: root / password: opnsense
	* help - https://docs.opnsense.org/

* currently using Pi2 (newer version?)


#### Wizard config 

These include private details you may like to record somewhere

Where not specified, left as default

Attribute           | Value
------------------- | ------------------------------------
Device              | ?
Hostname            | ?
Domain              | ?
Override DNS        | Yes (from DHCP on WAN)
Time zone           | Europe/London
WAN Interface Type  | DHCP
LAN IPv4 Type       | Static IP
LAN IP Address      | 192.168.8.254 / 24 (use .7.254 whilst setting up)
User | 
Password | 

#### Interfaces

WAN - enabled - DHCP - Save - Apply

VLAN 80 - started

### Use x64 hardware

The path of least resistance may be to use a mainstream Intel processor 
instead of low-cost ARM CPUs. 

Considered using some virtualisation layer like KVM, or even docker 
if the performance hit was less, but the complication of multiple physical NICs and multiple virtual networks hosted off firewall seemed 
risk prone.

However, for initial test purposes, perhaps VirtualBox (with AutoStart) might be an easy path to entry. 


### Old trial code - DELETE?

```

if [ "$ENV_MODE" == "PROD" ]; then (

) else (

); fi

case "$ENV_MODE" in
PROD)
    echo prod
	;;
DEV)
    echo dev
	;;
TEST)
    echo test
	;;
esac

if [[ *\|$ENV_MODE\|* == '|DEV|TEST|' ]] ; then 
    echo not prod
); fi



### Create NAT Network with PF rules and bind to the right host ip address
# help https://www.virtualbox.org/manual/ch08.html#vboxmanage-natnetwork
VBoxManage natnetwork add --netname $VM_NET --network "${OPN_RANGE}" --enable --dhcp off
VBoxManage natnetwork modify --netname $VM_NET --port-forward-4 "http:tcp:[]:8080:[${OPN_IP}]:80"
VBoxManage natnetwork modify --netname $VM_NET --port-forward-4 "https:tcp:[]:8443:[${OPN_IP}]:443"
#VBoxManage natnetwork modify --netname $VM_NET --port-forward-4 delete http
VBoxManage setextradata global "NAT/${VM_RANGE}/SourceIp4" $HOST_IP


# support for the 802.1q VLAN tagging is very dependent on the guest OS 
# and its config – the host should 'just work' with bridged adapters
# some reports say only Intel 8254NXX support large frames and therefore tags
#VBoxManage modifyvm $VM_NAME --nic1 bridged --nictype1 82545EM
# others say only the default AMD NICs work because they do not strip tags
# https://distracted-it.blogspot.com/2016/02/humbledown-highlights-vlan-tag.html
# other say none of it work
# https://www.virtualbox.org/ticket/12038?cversion=0&cnum_hist=2

#VBoxManage modifyvm $VM_NAME --nic1 nat                                        --nictype1 82545EM
#VBoxManage modifyvm $VM_NAME --natpf1 delete "opn_http"
#VBoxManage modifyvm $VM_NAME --natpf1 delete "opn_https"
#VBoxManage modifyvm $VM_NAME --natpf1 "opn_http,tcp,,8080,192.168.1.1,80"
#VBoxManage modifyvm $VM_NAME --natpf1 "opn_https,tcp,,8443,192.168.1.1,443"
# to remove PF rule number "1234":: VboxManage modify "VM1" --natpf1 delete "1234"



```

#### Bitnami config OLD
* Start the VM
* enable ssh https://docs.bitnami.com/virtual-machine/faq/get-started/enable-ssh/#debian
* ssh bitnami@debian

```
##### Manual IP NO LONGER NEEDED ########################
# help https://docs.bitnami.com/virtual-machine/faq/configuration/configure-static-address/
# set the IP / GW
NIC_ID1=enp0s3
IP_RANGE1=192.168.80
IP_CURRENT1=29
NIC_ID2=enp0s8
IP_RANGE2=192.168.1

## Old attempted with SystemD .network files

sudo tee /etc/systemd/network/21-${NIC_ID1}.network << EOF
[Match]
Name=$NIC_ID1

[Network]
Address=${IP_RANGE1}.${IP_CURRENT1}/24
#Gateway=${IP_RANGE1}.1
DNS=${IP_RANGE1}.1
#DHCP=Yes
EOF
sudo tee /etc/systemd/network/22-${NIC_ID2}.network << EOF
[Match]
Name=$NIC_ID2

[Network]
Address=${IP_RANGE2}.2/24
Gateway=${IP_RANGE2}.1
#DNS=${IP_RANGE2}.1
EOF
sudo systemctl restart systemd-networkd.service

## this interfaces.d config does not appear to work

sudo tee /etc/network/interfaces.d/two-statics.conf << EOF
auto $NIC_ID1
iface $NIC_ID1 inet static
    address ${IP_RANGE1}.${IP_CURRENT1}
    netmask 255.255.255.0
    network ${IP_RANGE1}.0
    broadcast ${IP_RANGE1}.255
# iface $NIC_ID1 inet dhcp

auto $NIC_ID2
iface $NIC_ID2 inet static
    address ${IP_RANGE2}.2
    netmask 255.255.255.0
    network ${IP_RANGE2}.0
    broadcast ${IP_RANGE2}.255
EOF
sudo systemctl restart systemd-networkd.service
##### Manual IP NO LONGER NEEDED ########################




# your CONNECTION will probably drop at this point
# restart your ssh session

# configure the reverse proxy
sudo tee /opt/bitnami/nginx/conf/bitnami/reverse-proxy.conf << EOF
location /opn {
    proxy_pass http://192.168.1.1:80;
}
EOF
# restart the service
sudo /opt/bitnami/ctlscript.sh restart nginx


# not used
( 
location /head {
    proxy_pass                  http://192.168.1.1;
    proxy_set_header            Host $host;
    proxy_set_header            X-Real-IP $remote_addr;
    proxy_http_version          1.1;
    proxy_set_header            X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header            X-Forwarded-Proto http;
    proxy_redirect              http:// $scheme://;
}
)
```
