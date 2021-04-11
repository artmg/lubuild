
see also:

* [https://github.com/artmg/lubuild/blob/master/help/manipulate/PDF-files.md]
	* Portable Document Format (PDF) files originating from Adobe's specification
	* extracting images from PDF files
* [https://github.com/artmg/lubuild/blob/master/help/manipulate/photos-and-images.md]
	* working with individual photos and creating videos from them
	* also general image manipulation 
* [https://github.com/artmg/lubuild/blob/master/help/manipulate/miscellaneous-files.md]
	* Other common types of document
	* including email formats


# FreeCAD

## install

```
# either Install or Upgrade to latest stable version...
sudo add-apt-repository ppa:freecad-maintainers/freecad-stable
sudo apt-get update
sudo apt-get install freecad

# or Install or Upgrade to latest daily version...
sudo add-apt-repository ppa:freecad-maintainers/freecad-daily
sudo apt-get update
sudo apt-get install freecad-daily

# docs now lonline
# sudo apt-get install freecad-doc
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

## Start

* View - Architecture
* Open Fstd file


### Basics ###

Mouse navigation: http://www.freecadweb.org/wiki/?title=Getting_started#Navigating_in_the_3D_space


### base ###

You can place images onto planes to help you build your model

If you have a bitmap to work from, open it in Inkscape and Trace Bitmap 
(e.g. multipass 2 scans greyscale) - then save as SVG and DXF

You can also use Inkscape to select parts of vector PDF files, 
then save them to SVG files. Or see [manipulate/PDF-files.md] for PDF to SVG conversion. 

You have two ways to import SVGs: the default Drawing Import treats it as an image, 
or the [SVG as geometry](https://www.freecadweb.org/wiki/Draft_SVG) 
import treats it as objects. 

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

See also SweetHome3D section below for import and export options with FreeCAD.


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


### STL meshes

If you have an STL (STereoLithography) file it is a mesh, 
a combination of triangles rather than a parametric solid. 
To work on it in FreeCAD you should:

* Import from STL
* (optionally Mesh / Analyse / Evaluate and Repair - All the Above - Analyse)
* Part / Create Shape from Mesh
* Part / Refine Shape
* Part / Convert to Solid

see [https://www.freecadweb.org/wiki/Import_from_STL_or_OBJ]

Still, this is not exactly a parametric solid that you can manipulate easily, 
and until the Reverse Engineering Workbench is ready, 
you may have to reconstruct the part yourself.

Start by creating cross sections through the solid for what you want to model

* Part / Cross section

Then you can use Part Design to create your sketch by eye, 
then Pad to extrude, and Pocket to remove blocks

[https://www.freecadweb.org/wiki/PartDesign_Workbench]



## other features

Arch Survey (quick dimension entry) - http://forum.freecadweb.org/viewtopic.php?f=9&t=5659

### Addin workbenches

* CurvesWB
    * allows two 2d wires to be joined together into a 3d wire for complex pipes
    * also has wide ranging features for curved surfaces
    * https://github.com/tomate44/CurvesWB
* 

### Dependency Graph

This diagnostic tool may need addional libraries to work

* on macos GraphWiz is required
	* `brew install graphviz`
	* has quite a few dependency packages too
	* you may need to tell FreeCad the path, e.g.
		* /usr/local/Cellar/graphviz/<version>/bin/
* 



# SweetHome3D

* Interior 2D design application with 3D preview
* Java-based
* package in ubuntu repos
* mature and still under current development (as of Jan 2017)
* 

```
sudo apt-get install sweethome3d
# check the version of java you have installed
java -version

```

* Set the Preferences for your new project [http://www.sweethome3d.com/userGuide.jsp]
	- unit, wall thickness and height
* If you get a crash when trying to set preferences it may be an issue with Java3D 
	- there is a workaround in the FAQ
	- alternatively update manually by downloading the latest version
		+ the 'stable' version in repos may be a year or two out of date
		+ [https://sourceforge.net/projects/sweethome3d/files/SweetHome3D/]

```
# unpack the new version
cd /opt/ && sudo tar -zxvf ~/Downloads/SweetHome3D*.tgz
# make this the default
sudo ln -s /opt/SweetHome3D-5.4/SweetHome3D /usr/local/bin/sweethome3d
```

To get started see [http://www.sweethome3d.com/userGuide.jsp]


## Tips

### Extra models and textures

* Browse and search the extra object models at [http://www.sweethome3d.com/freeModels.jsp]
* Download them as a Library pack [http://www.sweethome3d.com/importModels.jsp]
* also the textures packs [http://www.sweethome3d.com/importTextures.jsp]

### Plugins

* see list at [http://www.sweethome3d.com/plugins.jsp]
* Download then install by running sweethome3d once and exiting again
* e.g. `sweethome3d Downloads/PluginName-x.y.sh3p`
* now when you run again from menu plugin should be available


### Roof with skylight

* any sloping element, such as roof, must be exported then reimported with rotation
	- [http://www.sweethome3d.com/support/forum/viewthread_thread,5100]
* skylights should be put in as windows before the rotation:
	- see [http://www.sweethome3d.com/blog/2015/05/28/how_to_design_a_sloping_ceiling_with_a_window.html]
	- also [http://www.sweethome3d.com/support/forum/viewthread_thread,4914]
* more comples shapes can use the 3D shape generator
	- [http://www.sweethome3d.com/support/forum/viewthread_thread,6600]
* 

### Sunlight

Here are some tips for simulating sunlight...
[http://www.sweethome3d.com/blog/2014/11/14/sunlight_simulation.html]
and showing how sunlight progresses through the day. 
Although your geographic location defaults to your capital from the locale, 
you can use Plan / Modify Compass... to set a more precise location for sun angles. 
[http://www.sweethome3d.com/blog/2016/12/24/how_to_get_a_nice_photo_rendering.html] 
also give plenty of tips on making the light look right. 

Unfortunately, however, with the `Sunflow` renderer used in SweetHome 
light does NOT bounce off surfaces. 
If you want to do advanced light simulations you can export to Blender, 
using an OBJ file in 3D View menu, and perhaps use Yafaray too. 


### Garden

* lawn and deck
	* for simple shapes you can use a Misc / Box, reduce the height and apply a texture
* 

### other

* If you plan to have furniture from Ikea, there are commercial models
	- Ikea 2013 Catalogue for a few dollars [https://3deshop.blogscopia.com/180-ikea-models-for-sweethome3d/]
* 

## Import / Export

### FreeCAD

* Yorik introduced `importSH3D.py` to import SweetHome3D objects into FreeCAD
	- written in Jun 2016, with fixes in Aug 2016
		+ [https://www.freecadweb.org/tracker/view.php?id=2584]
		+ [https://www.freecadweb.org/tracker/view.php?id=2674&nbn=1]
	- this is AFTER the main version `Release 0.16` - April 2016
		+ need to use the **daily / head** build for now
	- Requires `Export to HTML5` plugin for Sweethome3D (v5.2+)
		+ download [http://www.sweethome3d.com/plugins/ExportToXMLOBJ-1.1.sh3p]
		+ see Plugin section above to install
		+ for steps see [http://forum.freecadweb.org/viewtopic.php?t=16205]
	- Tsted with sh3d v5.4 and FC v0.17.10423 (built 170305)
		+ only partially acceptable

* To import from FreeCAD to Sweet Home
	- select the objects you wish to export (CTRL for multiple objects)
	- Export as Alias Mesh Objects (.obj)
	- Import as Furniture in Sweet Home, rotating as required
	- steps [http://www.sweethome3d.com/support/forum/viewthread_thread,6446]
	- 
	
