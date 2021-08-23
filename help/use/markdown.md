Markdown
=======

see also:

* https://github.com/artmg/lubuild/blob/master/help/use/coding
	* general Text Editors and IDEs for other language syntax

* see **Requirements and Decisions** section below for:
    * requirement for markup languages
    * reasons for choosing Markdown as preference over MediaWiki

## Markdown cloud integration

### Browser-based editor

(should this move into editors below?)

#### StackEdit

* browse to https://stackedit.io/
* Click on Start Writing at the top
* sign in to Google if you wish to store your markdown docs there
* Not sure where the content is stored if you don't sign in
* recent versions may have introduced a DB instead of all 'file'based storage
* Project not actively developed since 2019 - no viable fork

#### HackMD

* register at https://hackmd.io/ with freemium limited account
* appears to use their private git, but can also sync with public GitHub
* 


### Google docs

Convert from a formatted Google Doc to markdown:

* Ed Bacher's *Docs To Markdown* chrome addin https://gsuite.google.com/marketplace/app/docs_to_markdown/700168918607
* L Maddox's gdocs2md (forked and improved from others)
	* https://github.com/lmmx/gdocs2md-html
* If its a table use MarkDown Table maker add in
	* https://gsuite.google.com/marketplace/app/markdowntablemaker/46507245362
* 


If you want to write markdown in using Docs editor:

* preview with Mustakim's MarkdownPreview (doc script or addin)
	* https://github.com/mustakimali/GDocsMarkdownPreview
* Optimise your Docs settings 
	* https://www.digitalonlinetactics.com/post/tactics/google-docs/edit-markdown-in-google-docs/
* Or just use it as it is and turn off or Undo formatting corrections https://www.digitalonlinetactics.com/post/tactics/google-docs/edit-markdown-in-google-docs/#comment-4818763694
* 

## Convert markdown documents

* pandoc
    * convert between markdown and numerous other formats
    * installed via [Lubuild app-installs.bash](https://github.com/artmg/lubuild/blob/master/app-installs.bash)
    * sample command # pandoc -f markdown -t html -o output.htm input.txt
	* if you get UTF-8 errors you can try [iconv](https://pandoc.org/MANUAL.html#character-encoding)


## Edit markdown documents

### Requirements

* single pane WYSIWYG (rather than multi-pane with preview)
* Document navigator for jumping between TOC section headings
* hyperlinked URLs - click to open (either browser or editor if local)
* prefer Qt-based widget system 


### Cross-platform

There are some FOSS candidates below that work on 
multiple platforms. However, despite the fact it is 
NOT open source, my current favourite is the very-cross-platform **Obsidian**. 

It is a free (beer) rich editor for collections of markdown files, 
that helps to edit, find, organise and cross-link. 
Although it's part of a freemium service there is 
ZERO lock-in, because you're editing markdown files
stored locally, and you can switch over to an alternative editor any time you fancy.

As it's available on Choco for Windows, Brew for Mac and AppImage/ Snap/ Flatpak for Linux, 
it's very easy to start using. There are Android and iOS apps too, so where ELSE would you consider using it.

### Linux candidates

These are open source applications readily available for Ubuntu linux. 
For Android Apps see the section below. 

* Geany
	- popular generic text editor with markdown features
	- installed via [Lubuild app-installs.bash](https://github.com/artmg/lubuild/blob/master/app-installs.bash)
    * built-in highlighting for markdown
        * **could be improved?**
        * although "Kate" editor might offer marginally better support, that relies on KDE
	* also allows mediawiki-format highlighting
		* scite ?
    * plugin for live reviewing sidebar
        * `sudo apt-get install geany-plugin-markdown`
        * depends on libWebkitGtk (slightly heavyweight?)
        * panes move separately so ok for checking, less for wysiwyg
	* use Symbols sidebar for Table of Contents
	* auto-indents but no auto bullets
	* no URL hyperlinks
	- built using GTK2 toolkit and depends on these llibraries
* ReText
    * proper wysiwyg editor
    * written in Python with Qt widgets
    * still a very actively developed project
    * somewhat slow and occasionally glitchy
	* auto-bullets and table mode 
	* no URL hyperlinks
	* supports python markdown extensions
	* does it have TOC navigation?
* Ghostwriter
	* Qt and C++
	* [https://github.com/wereturtle/ghostwriter]
	* author has PPA 
	* simple styling (can it be colour-differentiated?)
	* pull out table of contents
* QOwnNotes1
	* Qt and C++
	* focussed on integration with OwnCloud
	* project active for a couple of years with many commits in past year (to Aug 2017)
	* single developer
	* author has PPA for Ubuntu (and Arm builds for Pi)
		* ppa:pbek/qownnotes
	* based on author's own Qt Widget qmarkdowntextedit
* Joplin ?
	* sometimes mentioned as a competitor to QOwnNotes
	* has many different sync providers
	* includes Android client
	* but does it **simply edit** markdown files?
* CuteMarkEd
	* Qt and C++
	* commits have waned drastically in past year 
	* needs compiling for ubuntu
	* split pane interface includes table of contents
* Qute
	* project doesn't look very active
	* no ubuntu package
* UberWriter
	* Qt & python
	* very simple
	* no longer active
* Scite
	* GTK+ and Scintilla-based editor
	* does it have language support for Markwdown and Mediawiki ??
* remarkable
	* GTK + python
	* active project [https://github.com/jamiemcg/remarkable]
	* 2 pane (edit + live preview)
* atom
	* electron-based
	* generic code editor with preview mode including Markdown
* others?
	* VS Code
		* VisualStudio seems a heavyweight solution
		* but as MS are opening to wider platforms
		* you might find this a neat solution
	* springseed / flame ??
	* haroopad
		* well featured but no activity since 2013
	* LightMd_Editor
		* only developed over one year (2015)
	

see also:

* [http://codeboje.de/markdown-editors/]
* [http://www.linuxbsdos.com/2014/10/05/the-best-markdown-editors-for-linux/]
* [http://mashable.com/2013/06/24/markdown-tools/]

### Android Markdown editor apps

* Writer (jamesmc)
    * lightweight editor using markdown to highlight onscreen
* MarkdownX
* Monospace Writer
* JotterPad
    * does free version have preview?

* Markdrop
* Draft

* Suggestions by users of QOwnNotes
	* Markor
		* decent editor
		* no 'search in files'
			* use aGrep as alternative
	* Epsilon
	* QuickEdit Text Editor
	* Joplin ?

#### Android sync

Dropbox for Android does not simply make your files available on the device filesystem for third party editors, as it does on PCs.

The technique below uses **FolderSync** to move your data daily, and I used **Markor** for editing, **aGrep** for search, and **Amaze** as file manager. You might consider the new Obsidian mobile client. 

* Dropbox setup
	* Create new folder for mobile content
	* Create new limited account for mobile
		* Set Notifications OFF for News and Files
	* Share mobile folder with new limited account

* Note your choices: 
	* MyNotesFolder
	* MyDropboxAcct

* Install Amaze File Manager
	* in Android create: MyNotesFolder
* Install FolderSync (not Pro) onto mobile
	* Permissions: 
		* File: Write to Device, Emulated Android
* Add account MyDropboxAcct
	* use Browser to authenticate and Allow
* Create Two-way sync
	* local folder browse 'MyNotesFolder'
	* ensure that the **Sync Deletions** is turned **on**
	* schedule: daily
* Install Markor on mobile as markdown Editor
	* Settings / Notebook select local folder
* Install aGrep as search app
	* add the Target Directory
	* add md as a target extension
	* Use the Menu / View option to open in Markor for editing


### macOS editors

* macdown
	* foss
	* mac only
	* may be installed from brew cask
	* uses Hoedown for rendering and Prism for syntax highlighing 
* sublime text
	* nagware
	* but quite a powerful editor, nonetheless
* Ghostwriter
	* foss, but no mac package ready - _should_ build
* ReText
	* python-based so should work ok
* QOwnNotes
	* mac packages available (not yet via homebrew)

see also:

* https://superuser.com/questions/174976/markdown-live-preview-editor
* https://softwarerecs.stackexchange.com/questions/6915/a-good-editor-for-technical-tutorials-on-mac
* https://softwarerecs.stackexchange.com/questions/25/markdown-editor-for-osx-that-includes-a-preview-ideally-in-real-time


## Why use Markdown?

### Requirements and Decisions

Objective: write formatted text from anywhere

I have experimented with various ways of marking up notes on different devices. 
Full html is longwinded and unreadable for simple text editors, 
so I have looked at simpler methods


#### Requirements

+++ clearly readable for humans
+++ quick to write
++ simple automatic means to create full html
    + one that is in relatively common use
++ based on an existing standard / practice

+ Supports tables that are quick, visually clear and flexible in case of error


#### Candidates

http://en.wikipedia.org/wiki/Lightweight_markup_language

#### initial comparison results

* Readability and Speed
	- I found == headers == nice and clear
		+ (AsciiDoc Creole MediaWiki txt2tags)
* Readability
	- Link name should appear before the URL
		+ (Markdown reStructuredText Textile Texy! txt2tags)
* Speed
	- Single characters for bold & italic
		+ (AsciiDoc, Curl, Textile, Texy!)
* Flexibility
	- ++ Should NOT error if header does not have trailing markup to match exactly
	- ++ Should allow minor typos in table format and still render reasonably
* Compatibility
	+ could prefer # for headers as bash scripts use # for comments

#### Decision 

Since 2010 have used a mix of Markdown and MediaWiki
with pandoc as conversion command

Now (150423) looking to improve table handling and standardise on one

I make much use of GitHub, less of MediaWiki currently
 

##### Addendum 101005

I have now written many notes in txt2tags. I have not used autoconversion programs much, 
so far, but now I am considering them I wonder if the the rigidity of txt2tags syntax 
is not a bit of a hinderance to efficiency + readability, 
and perhaps an alternative Markdown might prove more useful


Markdown
see /Wallet/Service/Help/Markdown_Cheat_Sheet.pdf
see http://xbeta.org/wiki/show/Markdown

for editors see Lub App candidates.txt


Phython Markdown
http://www.freewisdom.org/projects/python-markdown/
or
just get lib\markdown2.py from https://github.com/trentm/python-markdown2

or consider PHP / publishing http://michelf.com/projects/php-markdown/extra/


##### Original Decision in 2009

txt2tags http://txt2tags.sourceforge.net/userguide/index.html

Readability made txt2tags the only serious contender
txt2tags also close runner up in speed 
(on Bold Italic but also on raw monospace) 


