## Config backup

This is a list of files you may wish to back up.
You might want to do this either / both:

* once you have completed your configuration 
	* in case the disk has failures you can restore it
* before doing a full re-install
	* just in case you want to bring them forward 	* rather than recreating them from scratch

The list for files is presented as SFTP commands.
Although you can use a USB device 
or network share to transfer the files, 
or SCP to copy individual files over SSH, 
the SSH File Transfer Protocol (SFTP) 
can get you more files with a single connection. 

See https://github.com/artmg/lubuild/blob/master/help/configure/Networked-Services.md#sftp

eg:

```
# substitute your username and server hostname below
echo you will need to enter your password after this
sftp user@server

cd /boot
get config.txt

cd /etc
# system ids
get hosts
get hostname
get nsswitch.conf

# filesystems to automount
get fstab

# system users, passwords, memberships and admins
get passwd
get shadow
get group
get sudoers

# service-specfic

get rsyslog.conf
get exports
get smb.conf
get smb.conf.master

get mpd.conf
get minidlna.conf

cd /etc/avahi
get avahi-daemon.conf
lmkdir avahi
lcd avahi
cd /etc/avahi/services
get *
lcd ..

lmkdir www
lcd www
cd /var/www
get *
lcd ..

cd /etc/default
get snapserver
get snapclient
```

## Other suggestions 

* package lists and sources
	* credit > http://askubuntu.com/questions/9135/best-way-to-backup-all-settings-list-of-installed-packages-tweaks-etc

