This is about using ready-made guests from the Bitnami collection. Even though now owned by VWware, Bitnami appliances can run directly as virtual guests on Oracle's open-source VirtualBox.

For more general configuration of virtual guest systems and appliances, see [virtual-guest](../configure/virtual-guest.md)

## Bitnami basics

### Getting started

* This assumes you have Oracle VirtualBox open source virtualisation software installed already
* Double-click on the OVA file to create the new VM
	* Or from the VirtualBox Menu:
		* File / Import Appliance
* If you intend to keep this instance running:
	* remember malware authors love to exploit people inside your network who use common software stacks left running with default credentials, as a way to get a foothold inside what you _think_ is your 'secure' network
	* change the VM Network Adaptor to Host Only Network
	* change the login credentials to strong passwords
* Power up the new VM and wait for a minute or three, until the colourful login screen appears
* log in and remember you are without copy/paste
* also check in the bottom right corner of the VM console window, what is the 'host key' to let go of your mouse when you want to leave the VM

```
# Check the IP address assigned
ip addr

# maybe add this to your client /etc/hosts file
# <ip address>    bitnami

# on boot enable SSH
# credit - https://docs.bitnami.com/virtual-machine/faq/#how-to-enable-the-ssh-server
sudo rm -f /etc/ssh/sshd_not_to_be_run
# credit https://docs.bitnami.com/virtual-machine/faq/get-started/enable-ssh-password/
sudo editor /etc/ssh/sshd_config
```

temporarily set `PasswordAuthentication yes`

```
sudo systemctl enable ssh
sudo systemctl start ssh
```

Now you can switch to a local terminal session
allowing you to copy and paste commands

```
# log onto ssh
ssh bitnami@bitnami

# Now you are still inside the terminal, 
# but logged into the VM
```

### secure your shell

* Generate and push SSH Certs 

```
REMOTE_HOST=bitnami
REMOTE_DOMAIN=
REMOTE_USER=bitnami
ADMIN_GROUP=MyVMs.Test
```

* https://github.com/artmg/lubuild/blob/master/help/configure/Secure-SHell-SSH.md#generate-and-install-ssh-certificate
* carry on until test
* reset temporarily set `PasswordAuthentication no`
in `sshd_config`
* NOW CHANGE PASSWORD

```
passwd
```

Now you can simply connect to ssh as `bitnami` instead of `bitnami@$WP_SVR_IP` and you won't need the password. Do write it down safely for when you need to sudo though.

## Common applications

### Accessing phpMyAdmin

```
# As phpMyAdmin is only configured to respond to localhost
# you first need to set up a ssh tunnel 
# to to a port on your local machine
# 8888 is a suggestion, change it if that port is already assigned 
# 
# use a new command prompt
ssh -N -L 8888:127.0.0.1:80 bitnami

# you will see NO apparent response from that command
```

* now browse to http://127.0.0.1:8888/phpmyadmin
* mariaDB application user is `root` and password is displayed on virtual console.
* when you're done, 
	* return to the ssh -N command still running
	* press `CTRL-C` to kill it
* 

#### Large database import

If you upload a very large .sql.zip file, you may get the error: `You probably tried to upload a file that is too large.` 

Although there are ways to [increase the upload_max_filesize](https://docs.phpmyadmin.net/en/latest/faq.html#i-cannot-upload-big-dump-files-memory-http-or-timeout-problems) you might find it more expedient to:

* scp the file directly
	* this must be the `.sql` file inside, not the compressed `.sql.zip`
* run MariaDB console
	* ` mysql -u root -p `
* create the database and import the contents

```
create my_new_database;
use my_new_database;
source /home/bitnami/filename_of_uncompressed.sql
```

* for alternative workarounds, and suggested values, see https://stackoverflow.com/questions/20264324


### Configuration files

for common apps:

* Apache
	* ` /opt/bitnami/apache/conf/httpd.conf `
* phpMyAdmin
	* ` /opt/bitnami/phpmyadmin/config.inc.php `
* MariaDB
	* ` /opt/bitnami/mariadb/conf/my.cnf `
* 

### MariaDB



## Bitnami wordpress

### configure bitnami apps

```
# check out the credentials
cat ~/bitnami_credentials

# Username: user
# Password: mypassword

SQL_USER_PASSWORD=mypassword

# check the mysql credentials and password work
mysql -u root -p"$SQL_USER_PASSWORD" -Ae"SHOW DATABASES;"

# check out your wordpress settings
cat ~/apps/wordpress/htdocs/wp-config.php
#cat /opt/bitnami/apps/wordpress/htdocs/wp-config.php
```

### Using the Wordpress server

* check out the wordpress instance
* log into wp-admin
	* user: user
	* password: bitnami
* 

when you are done, either ...

```
# return to local prompt
exit

# when you're done
sudo /sbin/poweroff -h
```

### offline update of wordpress

* use this technique to avoid having to connect your staging instance to the internet
* from your management machine that has web access

```
curl -O https://wordpress.org/latest.tar.gz
scp latest.tar.gz bitnami@$WP_SVR_IP:
```

* now from your shell on the WP machine

```
# credit https://code.tutsplus.com/articles/download-and-install-wordpress-via-the-shell-over-ssh--wp-24403
tar xfz latest.tar.gz

# restore the files
cp wordpress/* /opt/bitnami/apps/wordpress/htdocs/. -Rf
```


