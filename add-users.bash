### Users ###

NEWUSER=NewUserName
DISPLAYNAME=UserDisplayName

sudo adduser --encrypt-home --gecos $DISPLAYNAME,,, $NEWUSER
# credit - http://askubuntu.com/questions/132395/

### User rights  via group membership
sudo usermod -a -G audio,video,plugdev,netdev,fuse,lpadmin,scanner $NEWUSER

## if user already created use...
# sudo apt-get install -y ecryptfs-utils
# sudo ecryptfs-migrate-home -u user
## credit - http://www.howtogeek.com/116032/
## log in with this user BEFORE the next reboot



# If the user needs to have admin privilege they must be a ''sudoer''
groups $NEWUSER

sudo adduser $NEWUSER sudo
# credit - http://askubuntu.com/questions/7477/

