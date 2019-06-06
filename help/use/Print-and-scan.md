See also:

* [https://github.com/artmg/lubuild/blob/master/help/manipulate/photos-and-images.md]
	* image recognition (OCR, QR codes etc)
* [https://github.com/artmg/lubuild/blob/master/help/manipulate/PDF-files.md]
	* work with portable documents, to extract or include scanned images

# Printers and Scanners

 Try connecting to the local CUPS console: http://127.0.0.1:631/
 See: https://wiki.ubuntu.com/DebuggingPrintingProblems

## HP Printers

The simplest way to use an HP printer on linux is with **HPLIP**. 
See this [http://hplipopensource.com/node/128 Technical Overview] 
and [http://hplipopensource.com/hplip-web/tech_docs/man_pages/index.html list of commands].

```
# check installed version of hplip
dpkg -l hplip
# see if the version is old
x-www-browser http://hplipopensource.com/hplip-web/gethplip.html

# validate installation
hp-check -r

# check your device is set up properly using HP Device Manager - Info pages (GUI)
hp-info
# and if not set it up
hp-setup

# check ink levels
hp-levels

# if you want to open the main device manager GUI
hp-toolbox
```

If you get a QT error, then you probably need an extra module
such as `python3-pyqt4` or `python3-pyqt5` 
- see [https://github.com/artmg/lubuild/blob/master/system-apps-manual.bash]

### diagnostics

* use hp-check
	* sudo hp-check
* increase CUPS logging level
	* [http://hplipopensource.com/node/225]
	* see logs in /var/log/cups/  (error_log, etc)

### troubleshooting connectivity

various recomendations include:

* check your Device URI:
	* starts with hp:/
	* has the ip address at the end
* check SNMP is active
	* [http://hplipopensource.com/node/216]
* see also [http://hplipopensource.com/node/224]
* ensure that avahi is active locally
	* comes up before cups? [https://bbs.archlinux.org/viewtopic.php?pid=954010#p954010]



### Scanners

```
# troubleshooting for HP Scanners
x-www-browser http://hplipopensource.com/node/333
# more about the SANE linux scanning subsystem
x-www-browser https://wiki.archlinux.org/index.php/SANE
```

## Brother Printers

* Browse to https://support.brother.com
* Search for your model
* Choose Downloads
* Pick Lunix / Linux (deb)
* Click on the **Driver Install Tool**
* Shift click on the EULA accept button to save the file to your downloads
* There should be instructions now, but you basically use the prompt to gunzip the file, sudo su and bash run the file
* it's interactive so you need to answer the questions
* Credit https://askubuntu.com/a/636364

### troubleshooting a Brother printer or scanner

If you are having issues where simple-scan reports 'scanner not detected'
then try running the relevant brsaneconfigX command, for example:

```
# query the network for any available scanners using the driverset version 4
brsaneconfig4 -q
```

credit: https://wiki.archlinux.org/index.php/SANE/Scanner-specific_problems#Brother


## Scanning software

Options for applications to scan images and documents.

Looking for Qt-based frontend to SANE to replace GTK SimpleScan

* skanlite
	* Qt 5
	* package in main repos
	* uses libkf5*
	* appears under active development
	* see KDE page [https://www.kde.org/applications/graphics/skanlite/]
	* User Guide [http://docs.kde.org/development/en/extragear-graphics/skanlite/]
	* Source code [https://www.kde.org/applications/graphics/skanlite/development]
	* no option for save to PDF

### Not suitable

* kipi-plugins AcquireImages feature - KDE Image Plugin Interface too large a framework
* Kooka - discontinued
* QScanner - one release only in 2014, files on sourceforge
* XSane uses GTK, latest release 2010 Nov xsane-0.998
* xscanimage (bundled in ubuntu sane package) uses GTK
* hocr-gtk
* gscanpdf uses GTK


### Out of scope

not quite what we were looking for

* YAGF - OCR of images already scanned using cuneiform and tesseract
* Vaultaire - frontend to scanimage and others to add metadata for organising scanned docs

* Scan Tailor
	* for post-processing scanned images
	* Qt 4 C++
	* package in main repos
	* established project, though no release for a year (since Sep 2016)
	* User Guide - [https://github.com/scantailor/scantailor/wiki/User-Guide]
	* source - [https://github.com/scantailor/scantailor]

