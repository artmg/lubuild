

see also:

* [https://github.com/artmg/lubuild/blob/master/help/use/Office-documents.md]
    * Office documents (like MS Office and other combination packages)
    * Desktop Publishing (DTP) packages
    * working with fonts in generic Office documents
* [https://github.com/artmg/lubuild/blob/master/help/manipulate/PDF-files.md]
	* Portable Document Format (PDF) files originating from Adobe's specification
	* extracting images from PDF files
	* working with fonts in PDFs
* [https://github.com/artmg/lubuild/blob/master/help/manipulate/photos-and-images.md]
	* working with individual photos and creating videos from them
	* also general image manipulation 
* [https://github.com/artmg/lubuild/blob/master/help/manipulate/plans-and-designs.md]
	* Computer Aided Design programs
	* 3D design, including space layout and rendering, and 2D design
* [https://github.com/artmg/lubuild/blob/master/help/manipulate/films-and-songs.md]
* [https://github.com/artmg/lubuild/blob/master/help/manipulate/FreeCAD-plans-and-designs.md]
* [https://github.com/artmg/lubuild/blob/master/help/manipulate/disk-recovery-and-forensics.md]
	* Check File Signatures ('Magic Characters') to discover what type of file you are looking at
* 


## Emails

### MIME / MHTML / EML and other email attachment or multipart formats

To extract files from MIME text files

```
# munpack from mpack package

sudo apt-get install mpack
munpack mimefilename.ext

# example in loop
for f in *.mht; do mkdir -p "unpack/$f"; munpack "../../$f" -C "unpack/$f" ; done

# alternatives:
# * mu-extract from maildir-utils 
# * base64 -d from gnu
# * 

```
### Outlook emails ###

* Open saved emails 
** M standard .eml files
** M Outlook .msg files including Office 2013
* M View or Extract attachments
* S allow copy of content to other formats
* C preferably without setting up email account

Candidates:

* MsgConv
	* produces EML from MSG
	* for procs see [http://askubuntu.com/a/363615]

```
# includes lots of perl libs but only around 7MB total
sudo apt-get install libemail-outlook-message-perl
# create EML file from MSG
msgconvert myfile.msg
```

* sylpheed 
** Opens .EML
*** Have to click through 4 dialogs first
*** displays text and allows Open / Save attachments

* thunderbird
** does not open .MSGs correctly
** for requirements and current procs see [Lub App Thunderbird config.md]

see also:

* readpst
	[https://github.com/artmg/lubuild/blob/master/app-installs.bash]

### Outlook Express IAF files

Get Passwords from IAF file Outlook Express email account export

* Using Perl
	* [http://www.forensicfocus.com/Forums/viewtopic/t=2788/]
* Using Ruby
	* [https://gist.github.com/kurochan/9038608]


## File and Folder syncronisation

Rather than clients for synchronising content to and from specific cloud file storage services, 
these focus on accessing your own local or internal resources. 

### rsync

credit > https://help.ubuntu.com/community/rsync
is on ubuntu by default
for remote files use SSH, unless samba share on private network is mounted

rsync -a source --delete destination

--delete is like /purge

#### two way rsync

```
rsync -avuz source/ dest/
rsync -avuz dest/ source/
# credit [http://www.linuxquestions.org/questions/showthread.php?p=2899735#post2899735]
```

#### grsync

graphical interface


### unison

* Windows & Linux gui tool written in Objective CAML
* Discontinued
* [http://en.wikipedia.org/wiki/Unison_(file_synchronizer)]
* Allows sync chains in various topolgies, see > http://sunoano.name/ws/public_xhtml/unison.html


### Conduit

GNOME sync app with plugins for files, photos, emails, PIMs, and many online services
help > http://live.gnome.org/Conduit/Documentation/UserDocumentation


### open source tools

#### code ideas

Synchrorep http://www.iceberg.0rg.fr/ is Python based and supports ftp, samba & ssh mounted shares
Conduit http://live.gnome.org/Conduit/Development is Python based with many customm data providers

###arch ideas###

GNU usbsync http://klingspor-thueringen.de/usbsync/ uses file in root to automatically sync USBs with multiple PCs
https://wiki.ubuntu.com/MultipleComputersSynchronization

###others###

http://sourceforge.net/projects/freefilesync/ C++ wxWidgets


## Deduplicate files and folders

As files get copied around, you are sometimes left with multiple copies. 
Some of these might be similar but different versions. 
How do you sort this all out? 

### Requirements ###

M  run on Ubuntu and derivatives
S  be provided in standard repos
M  Scan a folder
C  Scan multiple folders
M  Identify files which have identical content
S  quick scan to target files by name, date and size
C  date scan allow hour offset for time-zone issues 
C  interpret special file types (e..g. ZIP cabinets or Media files) to identify identical or similar content, showing differences (e.g. photo metadata)
M  list duplicates grouped, with folder information
S  have GUI to allow the user to choose which to remove

Note that this is related to, but NOT the same as,  
identifing the differences between files and/or folders


### Candidates ###

find more at http://askubuntu.com/a/118389


#### GUI 

* fslint
    * [http://www.pixelbeat.org/fslint]
    * in repos
    * seems a little superficial on first glance
    * based on filesize only? (shows date) - how to check contents?
    * can't view by folder
        * can only "select all in same folder"

* dupeguru
    * [http://www.hardcoded.net/dupeguru/]
    * requires PPA
        * **not available for every release**
    * also has Media versions  (picture/music)
    * still maintained (just)

; Duplicate Files Finder
: both Windows and Linux versions
: someone is +1ing a lot, may be author

* check whether any of the DIFF programmes have dupe finder features:
    * meld - current installed candidate
    * xxdiff
    * kdiff3 (floss) Win/Nux - [http://askubuntu.com/questions/312604/how-do-i-install-xxdiff-in-13-04] 
    * diffMerge (free) Win/Nux 

##### tests

* DupeGuru

```
sudo add-apt-repository -y ppa:hsoft/ppa
sudo apt-get update
sudo apt-get install dupeguru
```
Explore to sources 
Add (Paste the foldernames ed folder from above (3 sources PLUS 1 destination)
 in

Not available for 15.10!


#### CLI 

; fdupes - http://packages.ubuntu.com/fdupes
: size/date, then MD5, then bitwise
:: can prompt user for choice to delete/keep
: in repos

; rdfind - http://rdfind.pauldreik.se/
:: can rank which to autoreplace with links
: in repos



## Hex Viewer ##

To inspect binary files to inspect and understand their contents

S be lightwieght on top of lubuntu
S allow editing
C allow understanding of more complex structures (e.g. tables - see below) 

NB: if you just want to find out what type of file it is, see
[https://github.com/artmg/lubuild/blob/master/help/manipulate/disk-recovery-and-forensics.md]
to Check File Signatures ('Magic Characters') 

* lfhex
    * handles files bigger than memory
    * Qt - very lightwieght
    * in repos
* QHexEdit2
    * (is it an app, or just a widget?)
    * Qt / C++
* wxHexEditor
    * edits massive files AND disk sectors
    * wxWdigets/C++
* Bless
    * full featured
    * gui AND console
    * mono / gtk+

more...

* jeex
    * GTK
* dhex
    * include diff mode
* hexcurse
* hexedit (rigaux)


#### if you want hex and tables ....

* Okteka
    * KDE app needs many libraries on LXDE
    * does tables


 
