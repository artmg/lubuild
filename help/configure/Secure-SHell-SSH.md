# Secure-SHell-SSH

see also:

* [general Networked Services](https://github.com/artmg/lubuild/blob/master/help/configure/Networked-Services.md)
	* Networked Services that are not covered in more specific articles, including discovery, file and printer sharing, logging and monitoring.
* [General Network troubleshooting](https://github.com/artmg/lubuild/blob/master/help/diagnose/network.md)
	* general Network Diagnostics
	* If you want to find out more about what is on your local network
		* see Discovery / Services in  [https://github.com/artmg/lubuild/blob/master/help/diagnose/network.md#Discovery] 
* [Configure inteface](https://github.com/artmg/lubuild/blob/master/help/configure/network-interface.md)
	* If you're trying to make a direct connection to a single device
	* useful when configuring new network equipment
* [Hardware Troubleshooting](https://github.com/artmg/lubuild/blob/master/help/diagnose/hardware.md) 
	* For issues turning radios on and off
* [Samba server](https://github.com/artmg/lubuild/blob/master/help/configure/network-shares-with-Samba.md)
	* Sharing folders Windows-style
* [Network Appliances](https://github.com/artmg/lubuild/blob/master/help/configure/network-appliance-firmware.md)
	* dedicated devices running specialist software



#### SFTP.IN

This is what is in the [general Networked Services](https://github.com/artmg/lubuild/blob/master/help/configure/Networked-Services.md) file - we should dovetail this with the SSH config info sections below

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


## SSH - (remote) Secure SHell

The examples below use the 'default' choice of OpenSSH-Server.

You should configure SSH to work ONLY with Certificates, to remove the risk of attacking passwords with brute-force, and this should render it reasonably secure, even when accessible from the public internet. If you wanted to go a step further you could use Port Knocking (see https://help.ubuntu.com/community/PortKnocking), but don't forget that obscurity is not a replacement for true security (see http://bsdly.blogspot.co.uk/2012/04/why-not-use-port-knocking.html).


### Private and Public Keys

#### Recommendations

* Realms 
  * Use a different key for each administrative boundary you wish to maintain. 
  * Use the same key for all servers within that realm 
  * Of course, ONLY distribute the public key, NEVER the private key! 
* Passphrase 
  * Might you ever copy or insert this key into a non-secure location? 
      * If so consider a passphrase. 
  * Of course if the machine you run it from has malware, it may be keylogged anyhow, but... 
* Algorithm 
  * Use RSA algorithm with 4096 bit strength 
      * As recommended by:
      * Microsoft - http://technet.microsoft.com/en-us/library/cc740209%28v=ws.10%29.aspx
      * Apache - http://www.apache.org/dev/release-signing Apache
  * some sources now suggest **ed25519** to be the best (least flawed) current choice for generating authentication keys
  		* NB: although RSA comments in public keys may be changed, they cannot in ed25519 
* Certificates
 * if you want to improve your key management consider using certificates   
      * for ideas see https://ef.gy/hardening-ssh
* 

#### Generate a keypair

```
# Usually done on client, before the public key is securely transferred to the server

# credit https://help.ubuntu.com/community/SSH/OpenSSH/Keys#Generating_RSA_Keys
mkdir -p ~/.ssh
chmod 700 ~/.ssh

ssh-keygen -t rsa -b 4096

# Enter to accept the default location. 
# You may choose NOT to enter a passphrase, 
# but then you must keep your keys stored securely. 
# if you need no passphrase then just Enter Enter
```

Please see also the section on [#managing-encryption-keys Managing Encryption Keys] below

##### Generate and install SSH Certificate

These instructions should be carried out from the client, so if you have already connected with an `ssh` session to the server, then you should `exit` first.

```
# example variables
REMOTE_HOST=MyServer
# only specify DOMAIN if you need FQDN to connect
REMOTE_DOMAIN=
REMOTE_USER=admin
# if you are happy with individual certs per server 
# then don't specify ADMIN_GROUP
ADMIN_GROUP=MyServerGroup
```

```
# Generate a new ED25519 SSH key pair
# this is 'the new standard' for keys
Key_Opts="${KEY_OPTIONS:-"-t ed25519"}"
# Or if your service doesn't support that, override with RSA:
# KEY_OPTIONS="-o -t rsa -b 4096"

Name_Group=${ADMIN_GROUP:-${REMOTE_HOST}}
Key_File=~/.ssh/${Name_Group}${REMOTE_DOMAIN}

if [ ! -e "${Key_File}" ]; then # if the Group key does not yet exist
    # generate without passphrase
    ssh-keygen $Key_Opts -f ${Key_File} -N "" -C "${Name_Group} ${REMOTE_DOMAIN} ${HOSTNAME%%.*} `date +%y%m%d` for ${REMOTE_HOST}"
    # the comment is to help you recognise it
fi

ssh-copy-id -o  StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${Key_File}.pub ${REMOTE_USER}@${REMOTE_HOST}${REMOTE_DOMAIN}

# Just do as far as the command above, as it waits for the password
```

```
# Now carry on from here

# save this in the ssh config file using 
# separate sections as the first might be common to all hosts in a group
tee -a ~/.ssh/config << EOF!

Host $REMOTE_HOST
    User ${REMOTE_USER}
    Preferredauthentications publickey,password
    IdentityFile $Key_File
Host $REMOTE_HOST
    Hostname ${REMOTE_HOST}${REMOTE_DOMAIN}

EOF!


# NOW TEST
ssh -o  StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${REMOTE_HOST}
```

If this fails then the remote ssh server may not 
be expecting the standard location for authorized_keys file. 
For example, logging in as root on **dropbear**, 
the file must be in `/etc/dropbear/authorized_keys`.

Use this test above to log in with the password and copy the file

```
cat /root/.ssh/authorized_keys >> /etc/dropbear/authorized_keys && chmod 0600 /etc/dropbear/authorized_keys && chmod 0700 /etc/dropbear && mv /root/.ssh/authorized_keys /root/.ssh/authorized_keys.`date +%y%m%d.%H%M%S`
```

#### generate keys on Windows

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


### set up server

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

#### sshd_config Recommendations

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

#### install keys

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

#### restart to read new config

 sudo /etc/init.d/ssh restart

#### set server start

```
# If you want manual start instead of automatic,
sudo mv /etc/init/ssh.conf /etc/init/ssh.conf.disabled
# credit http://askubuntu.com/questions/56753/

# alternative suggested by http://unix.stackexchange.com/questions/53671/
# echo 'manual' > /etc/init/mysqld.override
```

### connecting from client

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

### Moving files

Once you have SSH configured you can use it to 
move files to and from the server from your local client. 
The simplest way to do this is using SCP. 

```
scp user@myServer:path/to/file local/path
```

You can use wildcards and -r for recursion too. 
If you want to be specific about the files to include
or exclude then rsync can also use the ssh protocol

```
rsync -av -e ssh --exclude='unwanted*.ext' user@myServer:path/to/files* local/path
```

### Advanced client usage

#### Pipe files back from SSH

This is a technique for grabbing a series of files and sending them back in a single compressed cabinet. This can be useful for backing up a handful of configuration files.

```
# Create a tar.gz file as a backup of certain files on a remote server 
# obtained by piping the tar file of them through the ssh 'tunnel'

# this wrapping will put the output file into the script folder
(
  cd "$(dirname "$0")"

# this will not work if it needs sudo
# the - (minus) after -f means send the tar to stdout and the . represents which files you want from the folder
  ssh user@server "tar -cf - -C /srv/myfiles/ . orSpecificFile AndSpecificFolder/ | gzip -9c | cat" > SSH_BackUp_$(date +%y%m%d).tar.gz
)
```

#### Persistent session

This is a method to perform the authentication a single time, then issue multiple commands (such as SCP) to use the SSH session, before finally terminating the session.

An example use-case would be to manually navigate and copy a whole series of files back from the remote target.


_Coming soon_

#### Tunnel

An SSH tunnel is where a (network) port on the server (machine you are connecting to) is 'patched' to a port on your local device. 
The advantage is that must initiate the session using the 
robust and secure authentication mechanism that SSH offers, 
then you do not need to be quite so concerned about 
the security of the network service that run 'inside' the tunnel. 

_more details later_

An example of using a tunnel is shown below with a remote desktop, where the desktop session server runs on the server, but is NOT accessible over the network, but using the pre-established tunnel.


### Troubleshooting

#### startup issues

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

#### more

see ...

* https://help.ubuntu.com/community/SSH/OpenSSH/Keys#Troubleshooting
* https://help.ubuntu.com/community/SSH/OpenSSH/Configuring#Troubleshooting


### Managing Encryption Keys

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

## Remote Desktop Server

NB: Some of this section looks old and may be more Windows-oriented. 
See also [MuGammaPi article on Remote Desktops on Raspberry Pi OS](https://github.com/artmg/MuGammaPi/wiki/Remote-Desktop) 
which is a lot more command-line Linux focussed.

### Vino

Ubuntu now incorporates '''vino''' by befault - see https://help.ubuntu.com/community/VNC/Servers#vino

### Starting VNC over SSH

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

### Debugging SSH connections

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

### Debugging VNC over SSH

If you get the error &quot;<code>XOpenDisplay failed</code>&quot; then try replacing <code>-display :0</code> with <code>-find</code> instead<br />help &gt; http://www.karlrunge.com/x11vnc/faq.html#faq-xperms<br />If that doesn't work you will need to work out the location of your XAuthority 'MIT cookie file' and add that as an -auth option, e.g. (for lightdm):

<pre>-auth /var/run/lightdm/root/:0 </pre>
<br /><br />

#### Others

```
credit &gt; [https://help.ubuntu.com/community/VNC/Servers https://help.ubuntu.com/community/VNC/Servers]

sudo apt-get install x11vnc

sudo x11vnc -storepasswd

```

Add the following to your startup applications

```
x11vnc -safer -allow 192.168.3. -usepw -ncache
```

or

```
echo '[Desktop Entry]

Name=VNC server

Exec=x11vnc -safer -allow 192.168.3. -usepw -ncache' &gt;~/.config/autostart/x11vnc.desktop

chmod +x ~/.config/autostart/x11vnc.desktop

##### old Ubuntu

Credit &gt; http://ubuntuforums.org/showthread.php?t=1068793

sudo apt-get install vino

vino-preferences
```

Allow view &amp; control

Set password &amp; note hostname

Configure network to accept

Always display icon

then add to your startup

/usr/lib/vino vino-server


