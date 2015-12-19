# required software
sudo apt-get install -y ecryptfs-utils

### Users ###

NEWUSER=NewUserName
DISPLAYNAME=UserDisplayName

sudo adduser --encrypt-home --gecos $DISPLAYNAME,,, $NEWUSER
# credit - http://askubuntu.com/questions/132395/

# add a user non-interactively (unlike the adduser wrapper):
# dependent package
# sudo apt-get install -y whois 
# sudo useradd -m -U newusername -p `mkpasswd newpassword`</pre>
# not sure this has an encrypt home option, tho

## if user already created use...
# sudo ecryptfs-migrate-home -u user
## credit - http://www.howtogeek.com/116032/
## log in with this user BEFORE the next reboot (not sure why)

### User rights  via group membership
sudo usermod -a -G audio,video,plugdev,netdev,fuse,lpadmin,scanner $NEWUSER
# separated for when it does not exist
sudo usermod -a -G fuse $NEWUSER



# If the user needs to have admin privilege they must be a ''sudoer''
groups $NEWUSER

sudo adduser $NEWUSER sudo
# credit - http://askubuntu.com/questions/7477/

