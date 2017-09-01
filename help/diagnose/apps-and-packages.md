## Troubleshooting Apps

see also:

* Diagnose [https://github.com/artmg/lubuild/blob/master/help/diagnose/apps-and-packages.md]
	* Applications and Package Management


### Which version of XYZ is installed?
 
```
# Check the exact name of the package
dpkg -l | grep mypackage

# Then get detailed version info
dpkg -s fullpackagename
```

### Which Applications ...

#### ...are installed? 

```
# list all installed packages
dpkg --get-selections

# find if certain applications are installed:
dpkg --get-selections | grep searchterm

# output a list of all application commands from the start menus into Downloads folder
# credit - https://help.ubuntu.com/community/Lubuntu/Setup#Applications
sed -nrs '/^\[Desktop Entry\]/d;/^(\[|Name=|Exec=)/p;${g;p}' /usr/share/applications/*.desktop > ~/Downloads/Names-n-Commands.txt 

# list packages in ascending order of size
dpkg-query -W --showformat='${Installed-Size;10}\t${Package}\n' | sort -k1,1n
# credit - http://ubuntuforums.org/showpost.php?p=5846974&amp;postcount=2

# list files and locations from package
dpkg -L gedit
# credit - UBUNTU HACKS by Jonathan Oxer, Kyle Rankin &amp; Bill Childers (O'Reilly ISBN 0-596-52720-9)
# source - http://ubuntuforums.org/showpost.php?p=1666921&amp;postcount=5
```

####...are default file handlers?

```
gnome-text-editor ~/.local/share/applications/mimeapps.list
# If firefox does not recognise the file type it will also use this file to choose the default handler
# credit - https://bugs.launchpad.net/ubuntu/+source/firefox/+bug/918019/comments/12
# also - http://forums.opensuse.org/showthread.php/477775
# help - http://askubuntu.com/a/223921
# help - http://www.libre-software.net/change-the-default-application-ubuntu-linux
```

####...are currently selected alternatives?

```
# see all <names> that currently have alternatives configured in /etc/alternatives/
update-alternatives --get-selections

# check what is available in a specific <name> group
# in ascending order of detail returned...
update-alternatives --list <name>
update-alternatives --display <name>
update-alternatives --query <name>
```

#### ...depend on this one? 

```
apt-cache rdepends packagename
```

#### ...provides this file or binary?

```
dpkg -S filenameOrPath
```

### Executables 

#### command not found 

if you try executing a command in the current working folder, specify the path by prefixing a '''./''' e.g.

 ./myprog

#### identify dependencies

```
# check which libraries are required
objdump -p ./myprog | grep NEEDED

#
check which dependencies are not met 
ldd ./myprog | grep "not found"

#
# more about managing libaries:
# http://www.ibm.com/developerworks/library/l-lpic1-v3-102-3/
# 
```

### installation and cleanup

#### download and install newer version

If the Download is a tgz containing the binaries...

```
# unpack the new version
cd /opt/ && sudo tar -zxvf ~/Downloads/MyAppDownload*.tgz
# make this the default
sudo ln -s /opt/MyAppVersion-X.Y/MyAppName /usr/local/bin/myappname
```


#### .DEB unattend

```
http://www.microhowto.info/howto/perform_an_unattended_installation_of_a_debian_package.html

export DEBIAN_FRONTEND=noninteractive
apt-get update -q
apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" package 1 package2

# while read -r line; do [[ $line = \#* ]] && continue; sudo apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" $line; done < package_list

install debconf-utils
debconf-get-selections | grep unatt
echo mysql-server-5.5 mysql-server/root_password password xyzzy | debconf-set-selections
```
#### total purge of old packages

```
apt-get -y dist-upgrade
apt-get -y autoremove
aptitude -y purge '~c'
aptitude -y purge `dpkg --get-selections | grep deinstall | awk '{print $1}'`
apt-get autoclean
```

### other Package Manager issues ###

 sudo dpkg --configure -a      # complete any previously-interrupted installs

#### hanging at 98% ####

If you get issues where apt-get seems to hang at 98% and chew CPU on your system...

* Check whether any PPAs are giving you this issue: http://askubuntu.com/questions/156650/apt-get-update-very-slow-stuck-at-waiting-for-headers
* Consider whether any sites might be giving you issues with "pipelining" settings: http://www.webupd8.org/2010/04/fix-google-chrome-repository-making-apt.html

#### Odd issues on legacy distro versions ####

Sometimes when you do an ''apt-get update'' or ''install'' you get errors like:

* 404 Not Found
* failed to fetch
* use --fix-missing

If this is a legacy Ubuntu version, the package archives may have been, well, archived. In order to allow yourself to continue accessing packages (''despite'' the fact you are running UNSUPPORTED and potentially INSECURE versions)...

```
# back up your sources
sudo cp /etc/apt/sources.list{,.`date +%y%m%d.%H%M%S`}
# you may want to run a version of this FIRST with the localised repo
# e.g. (gb|us|it|xx).(archive|security).
sudo sed -i.bak -r 's/(archive|security).ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list
# credit - https://gist.github.com/dergachev/f5da514802fcbbb441a1
# sudo sed -i -e 's/archive.ubuntu.com\|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list
# help - http://unix.stackexchange.com/a/149588
```

