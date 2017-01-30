See also:

* [https://github.com/artmg/lubuild/blob/master/help/manipulate/photos.md]
	* image recognition (OCR, QR codes etc)
* 

## Printers and Scanners

 Try connecting to the local CUPS console: http://127.0.0.1:631/
 See: https://wiki.ubuntu.com/DebuggingPrintingProblems

### HP Printers

The simplest way to use HP devices on linux is with **HPLIP**. 
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

### Scanners

```
# troubleshooting for HP Scanners
x-www-browser http://hplipopensource.com/node/333
# more about the SANE linux scanning subsystem
x-www-browser https://wiki.archlinux.org/index.php/SANE
```

