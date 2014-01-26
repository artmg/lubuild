### Users ###

NEWUSER=NewUserName

adduser --encrypt-home $NEWUSER
# credit - http://askubuntu.com/questions/132395/

## if user already created use...
# sudo ecryptfs-migrate-home -u user
## credit - http://www.howtogeek.com/116032/
## log in with this user BEFORE the next reboot

# If the user needs to have admin privilege they must be a ''sudoer''
groups $NEWUSER

sudo adduser $NEWUSER sudo
# credit - http://askubuntu.com/questions/7477/

