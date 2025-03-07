

see also:

* [https://github.com/artmg/lubuild/blob/master/help/use/Office-documents.md]
    * Office documents (like MS Office and other combination packages)
    * Desktop Publishing (DTP) packages
    * working with fonts in generic Office documents
    * interchange formats including contacts, events, emails
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
* https://github.com/artmg/lubuild/blob/master/help/use/coding
	* Text Editors and IDEs
	* as opposed to Hex viewers, see below for them
	* or markdown editors see https://github.com/artmg/lubuild/blob/master/help/use/markdown.md
* [https://github.com/artmg/lubuild/blob/master/help/manipulate/films-and-songs.md]
* [https://github.com/artmg/lubuild/blob/master/help/manipulate/FreeCAD-plans-and-designs.md]
* [https://github.com/artmg/lubuild/blob/master/help/diagnose/disk-recovery-and-forensics.md]
	* Check File Signatures ('Magic Characters') to discover what type of file you are looking at
* [https://github.com/artmg/lubuild/blob/master/help/use/local-search.md]
	* how to index and search locally stored file content
* [https://github.com/artmg/lubuild/blob/master/help/manipulate/data-extraction.md]
	* how to index and search locally stored file content
* [https://github.com/artmg/lubuild/blob/master/app-installs.bash]
	* which candidates are currently installed


The first section of this looks at manipulating files and folders in general. 
This includes sychronisation, deduplicating and bulk renaming

Then further down there are ways to inspect miscellaneous types of file, such as emails, or binaries


# Working with files and folders

## Bulk rename based on metadata

Although some file managers in Windows, Macos and Linux flavours can do some bulk renaming, 
they do not always allow the names to be based on the metadata describing the contents. 
Use cases for this include sorting photos easily by the date they were taken, 
or grouping music into albums and artists. 


### GUI tool

The requirement is for a tool that is:

* easy to use with a graphical user interface (GUI) 
* open source, and preferably an active project with multiple developers
* can use both EXIF image metadata and ID3 music metadata
* available across platforms (at least Macos, Ubuntu and Windows)
* uses reasonably lightweight and efficient subsystems

* Métamorphose 2
    * open source, cross platform and multiple contributor
    * replaced previous Metamorphose project
    * based on python and Qt
    * not many contributions recently, PPA way out of date and no Macos binary (needs make-ing)
    * however there is a new fork
    	* https://github.com/savoury1/metamorphose2
    	* also has ubuntu PPA
    		* 	https://launchpad.net/~savoury1/+archive/ubuntu/metamorphose2
    	* 
* Inviska rename
    * open source and cross-platform, using Qt
    * sole developer, site was out for a few months
    * code published but only as zips
    * fully-featured across all platforms
* Ant Renamer
    * seems like a solo project where code is published
    * written using Borland Delphi
    * unicode support only on Windows
* F2Utility
    * cross-platform
    * java-based
* ExifRenamer
    * Macos only
    * free not libre
* Exif ReName
    * not macos

### command line using exiftool

exiftool is commonly available through standard application repositories on linux variants
via homebrew core and as a windows download

Here is an example for the use case 
to rename all files in a folder to "YYYYmmdd_HHMMSS.ext" 
based on the date and time that the photo was taken (metadata)

```
# show the metadata for a single file
exiftool myPhoto.jpg
# help - http://www.sno.phy.queensu.ca/~phil/exiftool/
# show the shortnames for meta tags
exiftool -s myPhoto.jpg

# rename to "YYYYmmdd_HHMMSS.ext" and move into folder "renamed"
exiftool "-FileName<DateTimeOriginal" -d "%Y%m%d_%H%M%S.%%e" -directory=renamed .
```



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

#### Basic usage

```
# credit > http://samba.anu.edu.au/rsync/

rsync -av --delete --inplace /sr/folder/ /dest/folder/

# If you omit the trailing backslash on the source
# then that folder will be reproduced in dest
# With a trailing backslash, only its contents
# Backslash on dest makes no odds
# https://download.samba.org/pub/rsync/rsync.1

### testing

-n --dry-run
# don't actually make changes

--progress
# show how its doing


#### Special circumstances


# Regular backup to medium with limited space
--delete-during

# Daylight savings difference between FAT and NTFS
# allow modified times to vary by up to an hour
--modify-window=3601 
# credit > http://samba.anu.edu.au/rsync/daylight-savings.html

```

* [samba rsync official list of documation links](https://rsync.samba.org/documentation.html)


#### using 3rd 'compare' folder to find differences

```
# then delete the files removed in the mean time

    rsync -av --compare-dest=../B A/ C
    # ftp each file from C to remote site and move it into B.
    rsync -av --existing --ignore-existing --delete A/ B | tee dels
    # perform deletions mention in "del" on remote site.

# credit > http://lists.samba.org/archive/rsync/2006-June/015827.html
```

QUESTIONS: 

* do we really need compression if its local to local?!?!
	* -z
* should I not --delete every time I do a sync?


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

### arch ideas ###

GNU usbsync http://klingspor-thueringen.de/usbsync/ uses file in root to automatically sync USBs with multiple PCs
https://wiki.ubuntu.com/MultipleComputersSynchronization

### others ###

http://sourceforge.net/projects/freefilesync/ C++ wxWidgets


## Differences between Files and Folders 

If you have two instances of any of the following:

* a file, 
* a group of files, 
* a folder tree, 

and want to look beyond the similarities to find the differences. 

These may help you syncronise or deduplicate, 
but the focus here is on finding what is not identical. 

### Candidates

* GUI
	* meld
		* currently installed candidate 
			* [https://github.com/artmg/lubuild/blob/master/app-installs.bash]
	* xxdiff
	* kdiff3 (floss) Win/Nux - [http://askubuntu.com/questions/312604/how-do-i-install-xxdiff-in-13-04] 
	* diffMerge (free) Win/Nux 
* CLI
	* diff
		* usually installed in distros
	* 

### diff examples

```
# basic diff (show what the differences are)
diff file1 file2
# side-by-side
diff -y file1 file2
# quiet diff (just tell me if they are different)
diff file1 file2
```



## Deduplicate files and folders

As files get copied around, you are sometimes left with multiple copies. 
Some of these might be similar but different versions. 
How do you sort this all out? 

Relates to apps mentioned above for Differences between Files and Folders, 
but this is where you need to find the similar ones first! 


### Requirements ###

* M  run on Ubuntu and derivatives
* S  be provided in standard repos
* M  Scan a folder
* C  Scan multiple folders
* M  Identify files which have identical content
* S  quick scan to target files by name, date and size
* C  date scan allow hour offset for time-zone issues 
* C  interpret special file types (e..g. ZIP cabinets or Media files) to identify identical or similar content, showing differences (e.g. photo metadata)
* M  list duplicates grouped, with folder information
* S  have GUI to allow the user to choose which to remove

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
	* https://dupeguru.voltaicideas.net/
    * [http://www.hardcoded.net/dupeguru/]
    * based on Python 3 with Qt GUI
    * requires PPA
        * **not available for every release**
    * available also for macos (even though the UI is Objective C and Cocoa)
        * may be installed on macOS via `brew cask install dupeguru`
    * is quite a large package
    * the Media Versions, Picture Edition (PE) and Music Edition (ME) have all been merged into a single app
    * still maintained (just)

; Duplicate Files Finder
: both Windows and Linux versions
: someone is +1ing a lot, may be author

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



# Inspecting particular file types


## Emails

### summary of mail file formats

| Extension(s)      | Description                                                       | Main Applications                              | Open-Source Tools                                                                         |
| ----------------- | ----------------------------------------------------------------- | ---------------------------------------------- | ----------------------------------------------------------------------------------------- |
| .eml              | Individual email messages in text-based MIME format               | Windows Mail, Thunderbird, Outlook, Apple Mail | `email` (Python library), `emlx_to_eml` (converter), `libvmime` (C++ library)             |
| .emlx             | Individual MIME messages with Apple extensions                    | Apple Mail, Thunderbird                        | `emlx_to_mbox` (converter), `emlx-tools` (Python library)                                 |
| .mhtml, .mht      | Individual MIME HTML archive format                               | Internet Explorer, Microsoft Outlook           | `mhonarc` (mail-to-HTML converter), `BeautifulSoup` (Python library for parsing)          |
| .msg              | Individual emails in MS Office binary stream format               | Microsoft Outlook                              | `libmsg`, `msg-extractor`, `pytnef`, `Aid4Mail`                                           |
| .mbox, .mbx, .mbs | Multiple emails per text / MIME file separated by From_ envelopes | Unix mail, Thunderbird, Apple Mail             | `mailbox` (Python library), `mutt` (text-based mail client), `grepmail` (search tool)     |
| .sbd, .msf        | Folder-based storage containing `mbox` files and `msf` metadata   | Thunderbird                                    | `Thunderbird ImportExportTools NG`, `mbox` converters                                     |
| .Maildir          | Folder-based format with one file per message                     | Qmail, Postfix, Dovecot                        | `dovecot` (IMAP/POP3 server), `notmuch` (mail indexer), `mu` (maildir indexer/searcher)   |
| .mh               | Folder-based numbered emails files                                | nmh, GNU Mailutils                             | `nmh`, `mutt`, `reformail`                                                                |
| .pst, .ost        | Database format Personal / Offline Storage Table                  | Microsoft Outlook, Exchange                    | `libpst`, `libpff`, `readpst` (command-line converter), `pst-utils` (tools for PST files) |
| .dbx (also .iaf)  | Database format (and export)                                      | Outlook Express                                | `dbxconv` (converter), `libdbx` (library)                                                 |
_This table was added after the following and may make some of it redundant._

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

To open .EML files you can:

* drag them onto a browser - this should show the HTML MIME content but not the headers
* use weget linux package (GUI viewer and editor based on gmime C library and webkit viewer library)
* 

### Outlook Express IAF files

Get Passwords from IAF file Outlook Express email account export

* Using Perl
    * [http://www.forensicfocus.com/Forums/viewtopic/t=2788/]
* Using Ruby
    * [https://gist.github.com/kurochan/9038608]


### Quick mailbox archive

If you want to take an offline copy of your mailbox 
for archiving purposes, the Thunderbird client 
is a reasonable choice. 
It is available on multiple platforms, for now is well-supported and as open source should be available for a while. If your mailbox provides IMAP access, it makes it easy to download all messages from all (selected) folders, and IMAP automatically includes all content including attachments.

* Use your system's package manager to install Thunderbird
* if possible, obtain an app token from your email service
    - safer than using your main password
    - if asked, grant it IMAP read rights
* Open Thunderbird and begin configuring
* use Advanced settings to locate folders to save to
	- if you're doing this as an archive you probably care where they are stored locally
	- Server Settings / Message Storage / Local Directory
* ensure that all folders are selected for sync
	- or at least those you are interested in
* Tools / Preferences / Config Editor
	- search for `folders`
	- modify the setting `mail.server.default.check_all_folders_for_new`
	- set it true
	- this means it will sync the folders _without_ you having to view them all one by one
	- credit https://tech.tiefpunkt.com/2014/08/automatically-sync-all-folders-in-thunderbird/
* exit and restart Thunderbird to begin the full sync

The file-system contents after caching are very similar to the storage on many IMAP services, 
with the same-named folder structure, and each folder-leaf's contents storage in a file as raw text showing the MIME structure clearly. This makes it a very futureproof archive. 

However the simplest way to find and read the messages is likely to be via the Thunderbird client. This readily interprets all the message metadata from the .msf file accompanying each folder's raw data.

#### Import IMAP archives into Thunderbird

This assumes that you have previously created an archive of your IMAP folders by
* Attaching your Thunderbird client to your IMAP mail server
* Syncing all folders to your local machine
* Opening your profile folder and looking under the ImapMail folder
* keeping a copy of the msf file and the folder containing the mbox files from under it
* these would look like `imap.provider.com` or similar


To create a new Thunderbird profile, and open your IMAP archives in it, but without creating an account:

##### Create the empty profile

* Open the Thunderbird Profile manager:
	* Open Thunderbird
	* Help / Troubleshooting information / About:profiles
* New Profile
* Name: My archive profile
* Choose Folder
	* `~/MyArchives/Old.Email.Profile`
	* creating any new folders required
* Done
* Launch (your new) Profile in new browser
	* This will create the template profile in the newly created folder
	* it should prompt you to Set up your existing email address
* Set up Email Address: CANCEL
	* you probably don't need to Check use without email account
* Exit Setup
	* you probably should Quit Thunderbird

##### add in the archive data

* using a file browser like Finder,  view the Folder path above
	* find the file `prefs.js`
	* open with a text editor
	* insert the line and save
```
user_pref("mail.server.server2.directory-rel", "[ProfD]ImapMail/nickname.provider.com");
```
* Create the ImapMail folder and add in your imap archive folder and imap.msf file
	* we assume the path is just as in the prefs relative path above
##### get Thunderbird to recognise the folder

* Back in the Profile Manager
	* Launch (once again your new) Profile in new browser
	* it should prompt you to Set up your existing email address
* put dummy data in
	* Full name: a
	* email address: a@a
* Configure manually / Advanced Config / Ok
* Click down on Outgoing Server / back up on `a@a`
* Now there should be a red Delete button, click it
	* and Check remove message data then Remove
* Click on Local Folders and rename to ` nickname.provider.com (local) `
	* If you get the warning `The Local Directory path "is not suitable for message storage"` you can just Ok to disregard it
* 

Now when you reopen Thunderbird you should be able to open and read the emails as if you had just downloaded them.

## Hex Viewer ##

To inspect binary files to inspect and understand their contents

S be lightwieght on top of lubuntu
S allow editing
C allow understanding of more complex structures (e.g. tables - see below) 

NB: if you just want to find out what type of file it is, see
[https://github.com/artmg/lubuild/blob/master/help/diagnose/disk-recovery-and-forensics.md]
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


 
