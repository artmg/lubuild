

## install
```
sudo add-apt-repository ppa:freecad-maintainers/freecad-daily
sudo apt-get update
#sudo apt-get upgrade
sudo apt-get install freecad freecad-doc
```
### Versions

#### 160202
```
OS: Ubuntu 15.10
Word size of OS: 64-bit
Word size of FreeCAD: 64-bit
Version: 0.16.6321 (Git)
Build type: None
Branch: master
Hash: a583697e5a5e3e2c127f5ac5c63dd7668a2d76d7
Python version: 2.7.10
Qt version: 4.8.6
Coin version: 4.0.0a
OCC version: 6.8.0.oce-0.17
```
#### 1409xx...
```
Using version:
Version: 0.14.2935 (Git)
OS: Ubuntu 14.04.1 LTS 64-bit

OS: Ubuntu 14.04.1 LTS
Word size: 64-bit
Version: 0.14.3702 (Git)
Branch: releases/FreeCAD-0-14
```

## Import / Export

The [FreeCAD-supported formats](http://www.freecadweb.org/wiki/index.php?title=FreeCAD_Howto_Import_Export) 
shows what file types you can open and write to.

If you want a better understanding of the industry-prevelence of formats, 
see [https://www.quora.com/What-is-the-most-popular-file-format-used-for-sharing-CAD-files]

To validate the results of any export, you may consider re-importing from that same file 
to check the fidelity of objects saved.

In initial experiments with 3d building projects, 
STEP maintained the independence of named objects in the drawing, 
whereas IGES compacted all objects into a single one, making it probably the least useful. 

### Add IFC support

IFC (Industry Foundation Classes) is an ISO standard that builds on STEP (and therefore on IGES)

* Before using the instructions below, check whether the IfcOpenShell package has made it into the freecad extras PPA
* Check FreeCAD about version for Python version and bitsize
* download appropriate item from [http://ifcopenshell.org/python.html]
* "Place the extracted archive in the site-packages folder of your Python distribution"
    * 
    * python -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())"
    * # credit - http://stackoverflow.com/a/122340
    * sudo unzip ~/Downloads/ifcopenshell-python*.zip -d /usr/lib/python2.7/dist-packages
    * # test
    * python -c "import ifcopenshell"
* For instructions on compiling from source see Yorik's notes https://github.com/yorikvanhavre/IfcOpenShell
    * or IfcOpenShell original https://github.com/IfcOpenShell/IfcOpenShell
    * 


### Add DGW support

TO export to the DGW (Autodesk AutoCAD) format, you have to use the ODA free-to-download (not FOSS) convertor package 
from [https://www.opendesign.com/guestfiles/TeighaFileConverter] e.g. [https://download.opendesign.com/guestfiles/TeighaFileConverter/TeighaFileConverter_QT5_lnxX64_4.7dll.deb]


## Start

* View - Architecture
* Open Fstd file

### Basics ###

Mouse navigation: http://www.freecadweb.org/wiki/?title=Getting_started#Navigating_in_the_3D_space


### base ###

If you have a btimap to work from, open it in Inkscape and Trace Bitmap 
(e.g. multipass 2 scans greyscale) - then save as SVG and DXF

If you have a scanned PDF sketch with measurements...

* Terminal> pdfimages docname.pdf imagename
* Image - add to plane - (e.g. plan on XY) - http://www.freecadweb.org/wiki/index.php?title=Image_Module
* Sketcher - add sketch - http://www.freecadweb.org/wiki/index.php?title=Sketcher_Workbench
* Begin adding lines with constraints to match scan

See also http://www.freecadweb.org/wiki/index.php?title=Sketcher_Tutorial


### Drawing Module ###

NB: if you don't find how to add the drawing features to the current workbench, 
or can't find one with the right combination, View / Workbench / Complete

* Drawing / New A3 page
* Select object/group and Add View
* On Page reposition/orient objects

(credit - http://www.blender3darchitect.com/2010/07/tutorial-freecad-creating-2d-views-for-technical-drawing/ )



### Learn ###

FreeCAD How to:
* Print to lay all four perspectives onto paper/pdf
* show measures on drawings
* add door arcs
* add labels


### Issues with Dimensions ###

* use ALT to Link the Dimension to geometry
* Shift for radius?

* Edit / Preferences / Draft / Visual Settings 
* Dimension Lines - Text inside (once debugged should be "Text above" to default to 3D dimensions)

* Tools / Edit Parameters / Base App / Preferences / Mod / Draft
* dimPrecision = 0

* http://forum.freecadweb.org/viewtopic.php?f=3&t=7328
* http://www.metalshaperman.com/?p=2028

#### other features ####

Arch Survey (quick dimension entry) - http://forum.freecadweb.org/viewtopic.php?f=9&t=5659


