

see also:

* source code publishing, collaboration and version control with GitHub
	* [https://github.com/artmg/lubuild/blob/master/help/use/GitHub-source-control.md]

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


## IDEs

### code editors

This section is focused on free/libre code editors that run using Qt widgets

* Previously using Geany as lightweight IDE
	* edit and execute Shell scripts
	* also use as general editor for markdown text
	* see also [https://github.com/artmg/lubuild/blob/master/help/use/markdown.md#edit-markdown-documents]
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
		* no markdown

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

