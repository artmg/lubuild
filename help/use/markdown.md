* see **Requirements and Decisions** section below for:
    * requirement for markup languages
    * reasons for choosing Markdown as preference over MediaWiki

## Convert markdown documents

* pandoc
    * convert between markdown and numerous other formats
    * installed via [Lubuild app-installs.bash](https://github.com/artmg/lubuild/blob/master/app-installs.bash)
    * sample command # pandoc -f markdown -t html -o output.htm input.txt

## Edit markdown documents

### Requirements

* single pane WYSIWYG (rather than multi-pane with preview)
* Document navigator for jumping between TOC section headings
* hyperlinked URLs - click to open (either browser or editor if local)
* prefer Qt-based widget system 

### Candidates

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


### macOS editors


* macdown
	* foss
	* mac only
	* may be installed from brew cask
	* uses Hoedown for rendering and Prism for syntax highlighing 
* sublime text
	* nagware
* Ghostwriter
	* foss, but no mac package ready - _should_ build
* ReText
	* python-based so should work ok
* QOwnNotes
	* mac packages available (not yet via homebrew)



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


