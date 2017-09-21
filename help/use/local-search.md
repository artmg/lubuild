
## local search

This is for solutions to index and find files stored locally, 
either on this PC, or in attached or inserted devices, 
or on the local network. 

### requirements

* index content
	* from locally connected device filesystems
* rich doc formats 
	* including html, doc, xls
* quick results
* flexible and configurable

NB: this does NOT cover other OS requirements, 
such as how can I search on Android phone?


### cloud services

Note that the simplest way to include content from your cloud services 
into your local desktop search index, is to syncronise them locally. 
The way to do this depends on each specific cloud service, 
and is NOT within the scope of this document. 
Here we simply assume that the cloud data has been sync'ed locally 
before each time you index your local content. 


## Other Candidates

Recoll, detailed further below, quickly became the prime choice. 
Here is a list of other alternatives...

* Hot contenders
    * Tracker - aka MetaTracker - https://wiki.gnome.org/Projects/Tracker
        * was this old ubuntu default?
    * Cardapio
    * gnome-do - http://do.cooperteam.net/
        * combined launcher with search
    * indicator synapse +1 +1 
        * does it use zeitgeist? Try Virgilio skin http://ubuntuforums.org/showthread.php?t=1880394&page=4
        * http://www.omgubuntu.co.uk/2010/11/synapse-gnome-do-launcher-app-review-ubuntu/
    * catfish
* Front ends
    * Deskbar
    * Sezen
    * Omega (web search interface by Xapian)
* Large systems
    * lucene
        * java-based
    * alfresco
    * solr
    * libferris
        * mount FS (incl fuse) from other data sources
        * incl GDocs
* mentioned
    * Launchy
    * glimpse
    * htdig
    * sphinx
* NOT considered or dropped
    * Unity Dash
        * default Ubuntu 
        * uses Scope search engine with zeitgeist for filesystem
    * zeitgeist
        * activity tracker
* old, NOT maintained
    * Beagle
    * doodle
        * uses libextractor
    * Google desktop
    * strigi
    * pinot

see also [http://en.wikipedia.org/wiki/List_of_search_engines#Desktop_search_engines]


## Recoll

### Introduction

* [http://www.recoll.org/]
* uses Xapian 
    * both under active development
* filesystems only - must export other content to local fs to be indexed 
* requires helpers for some formats
* see instructions at [https://github.com/artmg/lubuild/blob/master/user-apps.bash]
* extensions
	- Recoll Web UI
		* see below
    * also Omega below provides server-based results search for Xapian

### out from user-apps

```
# simple manual install procs:
#
# * Use the Lubuntu Software Center to install the app   recoll 
# * run it from Start / Accessories / Recoll
# * in the dialog  First indexing setup  choose  Start Indexing Now  at the bottom
# * you should see it running through a list of filenames at the bottom
# * once it's done you should be able to search

# recoll stable PPA
sudo add-apt-repository -y ppa:recoll-backports/recoll-1.15-on
sudo apt-get update

# install filesystem search engine
# plus helpers for common doctypes
# help - http://www.lesbonscomptes.com/recoll/features.html#doctypes
# see also - http://packages.ubuntu.com/xenial/recoll
sudo apt-get install -y recoll \
 antiword xsltproc catdoc unrtf libimage-exiftool-perl python-mutagen aspell

mkdir -p $HOME/.recoll
cat > $HOME/.recoll/recoll.conf <<EOF!
# This is the indexing configuration for the current user
# These values override the system-wide config files in:
#   /usr/share/recoll/examples
# help - [http://www.lesbonscomptes.com/recoll/usermanual/usermanual.html#RCL.INSTALL.CONFIG.RECOLLCONF]

topdirs = ~ \


# these try to ignore the bulk of the hidden .* folder trees under home

skippedPaths = \
~/. \
~/.bin \
~/.cache \
~/.config \
~/.dropbox \
~/.local \
~/.mozilla \
~/.wine \
/*/.dropbox.cache \
/*/.dropbox-dist 

skippedPathsFnmPathname = 0

EOF!

##### General knowledge on Mime Types in Recoll

# on your system, the Mime Types are defined in either:
# /etc/mime.types
# /usr/share/mime/types
# ~/.local/share/mime/types
# and the applications associated are
# /usr/share/applications/defaults.list
# ~/.local/share/applications/mimeapps.list 
# for more info on Mime Types see [https://github.com/artmg/lubuild/blob/master/help/configure/Desktop.md]

# To change the recoll config (including mime types) ...
# make changes locally ~/.recoll
# make changes globally /usr/share/recoll/examples

# to add new viewers/editors onto Recoll **Open With** Context menu see
# https://bitbucket.org/medoc/recoll/wiki/UsingOpenWith

##### Some local config fixes

cat > $HOME/.recoll/mimeview <<EOF!
# This is the fix for the error in Lubuntu where Recoll reacts to Open Folder/Parent with
# "The viewer specified in mimeview for inode/directory" dolphin "is not found" "Do you want to start the preferences dialog"
[view]
inode/directory = pcmanfm %f
inode/directory|parentopen = pcmanfm %f
# help [http://www.lesbonscomptes.com/recoll/usermanual/RCL.INSTALL.CONFIG.html]
EOF!

cat > $HOME/.recoll/mimeconf <<EOF!
# This is part of the fix for the error in Lubuntu where Recoll ignores .md files
# and recollindex shows error "mimetype: can't interpret 'file' output:"
[index]
text/x-markdown = internal text/plain
text/x-basic = internal text/plain
text/x-powershell = internal text/plain
EOF!

cat > $HOME/.recoll/mimemap <<EOF!
# This is part of the fix for the error in Lubuntu where Recoll ignores .md files
# and recollindex shows error "mimetype: can't interpret 'file' output:"
.md = text/x-markdown
.mediawiki = text/x-markdown
.bash = application/x-shellscript
.bas  = text/x-basic
.cls  = text/x-basic
.ps1 = text/x-powershell
EOF!
# some of these last couple may be needed in other indexes below


#### diagnosing indexing issues
# see [https://bitbucket.org/medoc/recoll/wiki/ProblemSolvingData]


#### set up multiple indexes for Removeable Media ####

cd <my container root folder> ###### do this for each offline container you want to index


mkdir .recoll
cat > .recoll/recoll.conf <<EOF!
# This is the Recoll configuration file for the index for this offline container

##### how to use multiple indexes for Removeable Media #####

# help https://bitbucket.org/medoc/recoll/wiki/MultipleIndexes
# * Create separate index folder
# * Create config file
# * Build index
# * use menu Preferences / External Index to include this index when searching

# user guide Creating -  http://www.lesbonscomptes.com/recoll/usermanual/#RCL.INDEXING.CONFIG
# user guide Using - http://www.lesbonscomptes.com/recoll/usermanual/#RCL.SEARCH.GUI.MULTIDB
# sample scripts http://www.linuxplanet.com/linuxplanet/tutorials/6512/3

# Help on Config files - http://www.lesbonscomptes.com/recoll/usermanual/#RCL.INSTALL.CONFIG.RECOLLCONF.FILES
# Advanced options - http://www.lesbonscomptes.com/recoll/usermanual/#RCL.INSTALL.CONFIG.RECOLLCONF

topdirs  =  $PWD
skippedNames  =  .recoll*  .Trash*  z_History

# once the container reaches this % full, indexing will stop
maxfsoccuppc = 95 

# KB Size limit for compressed files. -1 defaults to no limit, 0 ignore compressed
compressedfilemaxkbs = -1

# MB Max text file size - as very large are usually logs, default 20MB - to disable -1 
textfilemaxmbs = 20

EOF!

##### missing mimetypes copied from main config
cat > .recoll/mimeconf <<EOF!
[index]
text/x-markdown = internal text/plain
text/x-basic = internal text/plain
text/x-powershell = internal text/plain
EOF!
cat > .recoll/mimemap <<EOF!
.md = text/x-markdown
.mediawiki = text/x-markdown
.bash = application/x-shellscript
.bas = text/x-basic
.cls = text/x-basic
.ps1 = text/x-powershell
EOF!

##### recoll index refresh script in each device root
cat > reindex_me.sh <<EOF!
#!/bin/bash

# set $DIR to folder containing current script
# credit - http://stackoverflow.com/a/246128
DIR=\$( cd "\$( dirname "\${BASH_SOURCE[0]}" )" && pwd )

recollindex -c \$DIR/.recoll
EOF!
chmod +x refresh_me.sh

##### Build the index now #####

recollindex -c .recoll


##### Add these as external indexes available

# although the history file in the recoll folder lists entries under allExtDbs section, 
# these are not cleartext paths so cannot be set by editing the files. 
# Use this variable instead...
export RECOLL_EXTRA_DBS=/path/to/index1/recoll/xapiandb/:/media/$USER/volume2/.recoll/xapiandb/:/media/$USER/Volume3/.recoll/xapiandb/
# NB: this will only stick for a single instance
# - how to make these permanent options of external indexes??

```

### web UI

This simplest way to run this is using the Bottle Python built-in web server, 
although this only provides single-user, single threaded access

* `sudo apt-get install recoll python-recoll`
* download [https://github.com/koniu/recoll-webui/archive/master.zip]
* extract to bin folder
* `./webui-standalone.py`
* browse to localhost:8080

For advanced config see [https://www.lesbonscomptes.com/recoll/pages/recoll-webui-install-wsgi.html]


#### example desktop entry

```
$HOME/Desktop/Search.desktop
[Desktop Entry]
Encoding=UTF-8
Type=Application
Name=Recoll Web UI
Exec=lxterminal --title="Recoll Web UI" --command="python $HOME/.bin/recoll-webui/recoll-webui-master/webui-standalone.py"
Terminal=false
Categories=Utility;
Comment=Enable browser-based search using Recoll Web interface
GenericName=Local browser-based search
Icon=recoll
Keywords=Search;Full Text;
```


### weightings for folder trees indexed

* requirement
	* modify the order of results based on files location
	* identify that files in certain locations should appear earlier or later

* will fields help?
	* globally settings /usr/share/recoll/examples/fields
	* [https://www.lesbonscomptes.com/recoll/usermanual/webhelp/docs/RCL.INSTALL.CONFIG.FIELDS.html]
	* can they be overridden per-folder?
* localfields
	
* how about per tree tags?
	* [https://www.lesbonscomptes.com/recoll/usermanual/usermanual.html#RCL.INDEXING.EXTTAGS]

### Troubleshooting

#### Slow results

* If you notice a delay of a few seconds displaying the results list 
	* try changing the Result List Font from the default
	* Preferences / GUI Configuration / Result List / Result list font
	* [https://www.lesbonscomptes.com/recoll/BUGS.html#b_1_13_04]


#### Understanding what's in the index (and why it's so big)

```
# see xapian delve [https://xapian.org/docs/admin_notes.html#inspecting-a-database]
sudo apt install -y xapian-tools
# see [http://getting-started-with-xapian.readthedocs.io/en/latest/practical_example/indexing/verifying_the_index.html]
```

