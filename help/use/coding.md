

see also:

* source code publishing, collaboration and version control with GitHub
	* [https://github.com/artmg/lubuild/blob/master/help/use/git-source-control.md]
* markdown-specific editors
	* https://github.com/artmg/lubuild/blob/master/help/use/markdown.md


## C++

### learning resources

* simple tutorial
	[http://www.cplusplus.com/doc/tutorial/]
* fun problems to solve
	* these could be solved using any language, 
		* but maybe C++ makes you think more, as it is lower-level
	* a handful of mainly simple problems
		* [http://www.shiftedup.com/2015/05/07/five-programming-problems-every-software-engineer-should-be-able-to-solve-in-less-than-1-hour]
	* a few dozen problems of varying difficulty
		* [https://adriann.github.io/programming_problems.html]
	* Project Euler has a long stream of increasingly difficult maths-oriented problems
		* [https://projecteuler.net/archives]
	* a mixed bag of coding problems for secondary students with C++ solutions
		* [https://tausiq.wordpress.com/easy-programming-problems-with-solutions/]
	* links to lots of other sources of coding problems
		* [https://softwareengineering.stackexchange.com/a/764]


### cross platform c++ console ide

The requirement is for a free / libre C++ IDE that allows 
programs to be both written on and compiled for 
both Windows and Linux systems. 
Ideally the solution should be reasonably lightweight, 
and allow for simple, standard C++ syntax code 
that will run on a console. 

The chosen candidate here is **Code::Blocks**, 
although CodeLite is probably another close contender. 
Eclipse with the C++ plugin would have worked, albeit with more bulk, 
and Qt Creator was only discounted as the console code 
was not classic C++ style. 

See [#purpose-built-ides] section below for more details on alternatives. 

```
# install `codeblocks` package, and all dependencies, from ubuntu repos 
sudo apt-get install codeblocks g++
# since ubuntu 17.04 the codeblocks version is reasonably recent
# NB on fresh install all the compiler/debug/widgets might take 700MB!
```

* for Windows pick installer that includes MinGW compiler

### reusing common functions

If you want to use common functions you have written 
from multiple programs, you can create a functions source file (.cpp) 
and declare them in a header (.hpp) that you can #include from your code 
and add your include path into the compiler settings

* introduction to principles [http://www.cplusplus.com/forum/beginner/79689/#msg429444]
* avoiding nesting of headers [https://stackoverflow.com/a/23163775]
* in depth explanation of headers [http://www.cplusplus.com/forum/articles/10627/]

Note that all functions in your included headers are usually compiled 
into the executable, even if your code did not actually call them. 


## Java

One solution for cross-platform programming is to use the 
Java Runtime Environment (JRE), compiling code into .JAR files 
that will work on any platform where a JRE is installed

* Oracle JDK
	* The Java Development Kit (JDK) is for coders to develop Java programs
	* it includes a JRE for running the programs
	* closer implementation to the original reference Sun Java
	* sometimes more compatible with apps than OpenJRE / OpenJDK
	* if you want the 'Java EE JDK' you still need the basic Java SE JDK first
		* the EE components that go on top is now called GlassFish
	* to use Oracle Java on Ubuntu see [https://help.ubuntu.com/community/Java]
* Eclipse IDE
	* perhaps a little heavyweight but very comprehensive and commonly used
	* Use Help / Install Software to add the following plugins...
* JavaFX
	* this is the latest 'widget' system for Oracle Java
		* allows you to build graphical user interface (GUI) windows for apps
	* use SceneBuilder to create the GUIs
	* works well with MVC (Model View Controller) architectural pattern
* EGIT
	* plugin for Project / Team / Share to work with GitHub and other git repos


## Python

Popular with Data Scientists, school kids and many hobbyist projects (perhaps due to its low barriers to entry) Python is an increasingly common choice of language outside of specialist niches. Its continued development is supported by partners around the world and from among the largest technology companies. 

On the off chance it is not already installed by something else:

```
sudo apt install python3
```

A common choice of IDE is IDLE:

```
sudo apt install idle3
```

although print commands are not handled that efficiently at runtime.


## IDEs

### code editors

This section is focused on free/libre code editors that run using Qt widgets

If you simply want markdown-specific editors for richer text formatting see https://github.com/artmg/lubuild/blob/master/help/use/markdown.md


* Previously using Geany as lightweight IDE
	* edit and execute Shell scripts
	* also use as general editor for markdown text
* want to consider qt-based alternative
	* for smaller footprint when moving to LxQt desktop
	* syntax highlighting

* JuffEd
	* Qt, C++, with QScintilla library
	* current editor for Lubuntu Next / LxQt
	* reasonable syntax highlighting
		* not currently including markdown
	* can it launch execute in shell?
	* juffed-plugins package also in repos
	* not loads of development in last few years, but some PRs accepted
* Tea
	* lightweight
	* still under development at July 2017
	* odd paradigm, almost wants to be a file and personal manager too
	* supports markdown and shell with an execute button
* Notepadqq
	* requires ppa:notepadqq-team/notepadqq
	* most active in 2015 but still some commits
* neovim-qt
	* c++, qt
	* in repos
	* some depends, including neovim which adds python libs
	* but it's just a GUI version of vim
* Kate
	* depends on KDE libraries
* QVim
	* Qt port of GVim
	* lots of plugins
* QSciTE 
* FeatherPad?


### Fully cross-platform, open source

This section looks at more richly featured Text Editors
(think Notepad++) that are supported on Linux, Windows and Mac. Also those that are fully open-sourced.

* Bluefish
	* mature and current project with multiple devs
	* may require GTK
* Howl
	* relatively new
* Atom
	* heavywight, needs Electron
* Brackets
	* only focussed on web-development 


Using the mature and popular python-based `neovim` APIs 
there are also:

* gonvim
	* go language and qt
	* builds available for Windows, Macos, Linux
	* quite new and only a few releases so far
* neovim-qt
	* self-compile, not sure if this has ready builds
* Oni
	* uses nodeJS, yarn (code package mgr), python
	* may also use electron



### purpose built IDEs

This section is focused on free/libre IDEs that run using Qt widgets

* Eric Python IDE
	* built on Qt toolkit (seems to be coded in python)
	* Languages: Python and Ruby
		* with shells and debuggers
	* Scintilla integrated
	* task manager
* MonkeyStudio
	* Qt and C++
	* 22 languages (also uses QScintilla)
	* mature but not much recent development
* KDevelop
	* C++ and Qt
	* part of KDE project
	* supports plugins
* QtCreator
	* the IDE built by the developers of Qt
	* originally planned to be lightweight
* BabyDevelop
	* written in Qt / C++
	* small footprint
	* focus is on developing C++
	* no movement since 2014

* Not qt: 
	* CodeLite
		* written in C++ with GTK2
		* for code including C++
		* add-on (paid?) for WxWidgets
		* includes plugins for git
		* is it limited to GDB for debugging?
		* Windows, Linux and Macos
	* CodeBlocks
		* written in C++ with wxWidgets
		* accepts a variety of compilers
		* mature project but not many updates recently
		* lightweight and easy for beginners to get started
		* GitBlocks plugin not complete (Aug'17)
		* GDB debugging on Windows had problems but should be sorted
	* atom
		* runs on electron framework (web-oriented)
		* good markdown integration
		* developed by github
		* HTML, JavaScript, CSS, and Node.js integration
	* Bluefish
		* uses GTK+ toolkit
		* no markdown
	* Light Table
		* different paradigm to most IDEs
		* not sure about performance or dependencies
	* Komodo Edit
		* rich and mature IDE project
		* based on Mozilla platform

* Not free/libre
	* sublime text 
		* is it still under development?
		* is a package available?


## Other languages

* Basic
	* Gambas3 (use PPA)
	* Basic256 `ppa:basic256/basic256`
* Smalltalk
	* Squeak
* other coding packages in ubuntu repos
	* laby 
	* kturtle 
	* scratch


## Build and test examples

### Build Samba on Raspbian

```
### remove previous install from repos
sudo systemctl stop smbd.service
# remove the samba package and all it's now unneeded dependencies
sudo apt remove samba --autoremove -y

# install screen for remote continuity
sudo apt install -y screen
screen
# to reconnect use   screen -r

### Install the prereqs
#### Official way
# https://wiki.samba.org/index.php/Package_Dependencies_Required_to_Build_Samba#Packages_Required_to_Build_Samba
# e.g. https://git.samba.org/?p=samba.git;a=blob_plain;f=bootstrap/generated-dists/debian10/bootstrap.sh;hb=v4-12-test
# NB: would need PhantomJS to GET this as it has client-side javascript
# Consider using the verified dependencies for your distro and version – 
# may include extra packages used for CI, but it should be comprehensive.
# To elevate your prompt use:    sudo bash

##### Official way is missing...
sudo apt install libavahi-client-dev libtracker-miner-2.0-dev libtracker-sparql-2.0-dev

#### alternative way

http://apt.van-belle.nl/debian/dists/buster-samba412/main/source/Sources.gz
See Package: samba / Build-Depends:               

# credit https://lists.samba.org/archive/samba/2020-April/229168.html
wget -O - http://apt.van-belle.nl/louis-van-belle.gpg-key.asc | sudo apt-key add -
echo "deb-src http://apt.van-belle.nl/debian buster-samba412 main contrib non-free" | sudo tee -a /etc/apt/sources.list.d/van-belle.list
sudo apt update
sudo apt build-dep samba

# added the following above the 'official' way used above
#  dh-exec libcmocka-dev libcmocka0 libldb-dev libldb2 librados-dev libtalloc-dev libtdb-dev libtdb1
#  libtevent-dev python3-etcd python3-extras python3-fixtures python3-ldb python3-ldb-dev python3-linecache2
#  python3-mimeparse python3-pbr python3-setuptools python3-talloc python3-talloc-dev python3-tdb
#  python3-testtools python3-traceback2 python3-unittest2


### clone the single branch
cd ~
git clone --single-branch --branch=v4-12-stable --depth=1 https://gitlab.com/samba-team/samba.git
# was
#git clone --single-branch --branch=artmg-tmsize-overflow-fix --depth=1 https://gitlab.com/artmg/samba.git

### build
cd samba


## If you are rebuilding on the same machine
# first remove the old version
# sudo systemctl stop smbd.service
# sudo make -j$(nproc) uninstall


# see alternative configure options
# https://vapour-apps.com/build-samba-4-9-from-source-on-debian-9-or-ubuntu-18-04/


# simple configure
#./configure

# remove unwanted functionality

#./configure  --without-ad-dc --enable-avahi --enable-debug
# we don't need domains
# ensure avahi (even though this is supposed to be default anyhow)
# enable debug, well you must be building for a special reason
# help https://wiki.samba.org/index.php/Build_Samba_from_Source

# FYI from ./configure output on raspbian buster lite
#Checking uname machine type              : armv7l
#Checking if size of size_t == 4                          : ok
#Checking if size of off_t == 8                           : ok

#dpkg-architecture -qDEB_HOST_MULTIARCH
# e.g.   arm-linux-gnueabihf



### trying more complex configure

# credit https://kirb.me/2018/03/24/using-samba-as-a-time-machine-network-server.html
# see also https://lists.samba.org/archive/samba/2019-April/222220.html


# prereqs for --enable-spotlight
sudo apt install build-essential avahi-daemon tracker libtracker-sparql-2.0-dev

DEB_HOST_MULTIARCH=$(dpkg-architecture -qDEB_HOST_MULTIARCH)

./configure \
    --prefix=/usr --exec-prefix=/usr --sysconfdir=/etc \
    --localstatedir=/var --libdir=/usr/lib/$DEB_HOST_MULTIARCH \
    --with-privatedir=/var/lib/samba/private \
    --with-smbpasswd-file=/etc/samba/smbpasswd \
    --enable-fhs --enable-spotlight --with-systemd \
    --enable-avahi 

## see even
# https://lists.samba.org/archive/samba-technical/2018-October/130648.html

# NB some projects compiling on Pi avoid multi-thread compiling
# e.g. https://www.domoticz.com/forum/viewtopic.php?t=26124
# because they risk going into swap death. 
# Monitoring the memory consumption on a Pi 2 compiling Samba with
# make -j 4
# there was always enough free memory to avoid using swap
# both during compile and during linking
make -j$(nproc)

sudo make -j$(nproc) install

# throws up errors
# samba4.so: invalid string offset for section `.strtab'
# https://lists.samba.org/archive/samba/2019-October/226558.html
# https://bugzilla.samba.org/show_bug.cgi?id=13754

# sudo systemctl unmask smbd.service
sudo systemctl restart smbd.service



# When not using the full enough list of options, 
# AVAHI is not auto configured
# for an example avahi service file
#sudo tee /etc/avahi/services/samba.service << EOF!
#<?xml version="1.0" standalone='no'?><!--*-nxml-*-->
#<!DOCTYPE service-group SYSTEM "avahi-service.dtd">
#EOF!
# see https://mudge.name/2019/11/12/using-a-raspberry-pi-for-time-machine/

```

#### rebuild


```
sudo systemctl stop smbd.service
sudo make uninstall

# ./configure with whatever options you need
make -j$(nproc) && sudo make -j$(nproc) install
sudo systemctl unmask smbd.service
sudo systemctl restart smbd.service
```

##### later Build Tests for v12

```
screen
mkdir samba.4.12
cd samba.4.12

git clone --single-branch --branch=v4-12-stable --depth=1 https://gitlab.com/samba-team/samba.git

cd samba
DEB_HOST_MULTIARCH=$(dpkg-architecture -qDEB_HOST_MULTIARCH)


./configure \
    --prefix=/usr --exec-prefix=/usr --sysconfdir=/etc \
    --localstatedir=/var --libdir=/usr/lib/$DEB_HOST_MULTIARCH \
    --with-privatedir=/var/lib/samba/private \
    --with-smbpasswd-file=/etc/samba/smbpasswd \
    --enable-fhs --enable-spotlight --with-systemd \
    --enable-avahi 

make

# sudo make install



./configure \
                --prefix=/usr \
                --enable-fhs \
                --sysconfdir=/etc \
                --localstatedir=/var \
                --libexecdir=/usr/lib/$DEB_HOST_MULTIARCH \
                --with-privatedir=/var/lib/samba/private \
                --with-smbpasswd-file=/etc/samba/smbpasswd \
                --with-piddir=/var/run/samba \
                --with-pammodulesdir=/lib/$DEB_HOST_MULTIARCH/security \
                --with-pam \
                --with-syslog \
                --with-utmp \
                --with-winbind \
                --with-shared-modules=idmap_rid,idmap_ad,idmap_adex,idmap_hash,idmap_ldap,idmap_tdb2,vfs_dfs_samba4,auth_samba4,vfs_nfs4acl_xattr \
                --with-automount \
                --with-gpgme \
                --libdir=/usr/lib/$DEB_HOST_MULTIARCH \
                --with-modulesdir=/usr/lib/$DEB_HOST_MULTIARCH/samba \
                --datadir=/usr/share \
                --with-lockdir=/var/run/samba \
                --with-statedir=/var/lib/samba \
                --with-cachedir=/var/cache/samba \
                --enable-avahi \
                --disable-rpath \
                --disable-rpath-install \
                --with-socketpath=/var/run/ctdb/ctdbd.socket \
                --with-logdir=/var/log/ctdb \

# added for our use case
                --enable-spotlight \
                --without-ad-dc \
                --enable-debug \


# failed! https://pastebin.com/McaDiFdj
                --without-ldap \
                --without-ads \

# See here for a fuller list of exclusions:
# https://lists.samba.org/archive/samba/2018-February/213891.html


# don't want this to stop on compile warnings
                --enable-developer \



# not needed in our usecase
                --with-ldap \
                --with-ads \
                --with-dnsupdate \


# failed with missing depends
                --bundled-libraries=NONE,pytevent,iniparser,roken,replace,wind,hx509,asn1,heimbase,hcrypto,krb5,gssapi,heimntlm,hdb,kdc,com_err,compile_et,asn1_compile \
                --builtin-libraries=ccan,samba-cluster-support \
                --with-cluster-support \

```

#### Debug

see links in OUT / Debugging section above


```
sudo smbstatus
# this shows nothing

sudo systemctl status smbd.service
# shows 4 PIDs

ps -A | grep smbd
# should confirm which of above is plain old smbd (probably first)

sudo gdb -p 4465

info shared



ls -la /usr/lib/samba/vfs/fruit.so
ls -la /usr/lib/arm-linux-gnueabihf/samba/vfs/fruit.so

+ install /usr/lib/arm-linux-gnueabihf/samba/vfs/fruit.so (from bin/	default/source3/modules/libvfs_module_fruit.inst.so)



```

