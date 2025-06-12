
Although some of the tools for working with photos and images also apply to films and songs, 
they are treated separately here as we assume films and songs are bought, 
whereas photos are captured, unique and irreplaceable. 

See also:
* [https://github.com/artmg/lubuild/blob/master/help/manipulate/films-and-songs.md]
    * For ripping, converting and metatagging films and songs
* [https://github.com/artmg/lubuild/blob/master/help/manipulate/PDF-files.md]
	* Portable Document Format (PDF) files originating from Adobe's specification
	* extracting images from PDF files
* [https://github.com/artmg/lubuild/blob/master/help/use/Office-documents.md]
    * Office documents (like MS Office and other combination packages)
    * Desktop Publishing (DTP) packages
* [https://github.com/artmg/lubuild/blob/master/help/use/Print-and-scan.md]
	* acquire images and documents from scanning devices
* [https://github.com/artmg/lubuild/blob/master/help/manipulate/plans-and-designs.md]
	* Computer Aided Design programs
	* 3D design, including space layout and rendering, and 2D design
* [https://github.com/artmg/lubuild/blob/master/help/manipulate/miscellaneous-files.md]
    * manage files and folders, including sync, dedupe and bulk rename
	* inspect miscellaneous file formats like binary or email


## Viewing images

### image viewer

In LXDE the "Image Viewer" application is **GPicView** which:

* is light
* has slideshow and zoom
* but Fit to Window does NOT stretch
* there is no Print option

what image viewer to add as option?

LXQt plans to use LxImage-Qt

```
# PhotoQt 
sudo apt-add-repository ppa:lumas/photoqt
# this is recommended by dev, rather than old source sudo add-apt-repository ppa:samrog131/ppa
sudo apt update
sudo apt install photoqt 
# Pros and cons:
# Seems the most recommended QT photo viewer
# Uses GraphicsMagick library to support wide range of formats
# still in active development
# quite a lot of dependencies - is it that lightweight? (37MB on my system)
```

* Other QT based image viewers to consider:
	* QIviewer
		- very simple app
		- not in repos
	* nomacs
	* QGraphicsView
+ CLI image manipulators:
	* feh
	* nitrogen
* Other viewers, but use GTK4:
	* gwenview
	* gThumb
	* viewnior

### view image metadata

* command line 
    * exiftool
	    - for more info see below
* GUI
    * ImageMagick
        * ImageInfo menu option displays metadata for currently open file
        * also installs command line    identify -format %[exif:*] myimage.jpg


### poster print over multiple pages

* PosteRazor
    * image via GUI
* pdfposter
    * source pdf via command line



## renaming images based on metadata

moved out to [https://github.com/artmg/lubuild/blob/master/help/manipulate/miscellaneous-files.md]


## manipulating image files

### compressing image data

Some image file formats have the capability to be compressed, 
with (lossy) or without (lossless) a denigration of image quality. 
Lossy compression, either by reducing quality or pixel resolution, 
may be acceptable depending on your purpose for storing the image.
#### cross platform GUI

Focussing on FOSS solutions that can easily be installed on a variety of desktop OSes. 
PDF image compression would be a nice to have.

* Caeseum
	* strong contender from mature project
	* JPG, PNG, WebP, and TIFF - lossless and lossy
	* good batch processing
	* in choco, mac needs DMG - is linux CLI only?
* ImageOptim
	* very popular independent project
	* mac-oriented, nice GUI with good Finder integration 
	* Some linux support, (windows not sure)
	* does not keep EXIF (by default)
* Squoosh
	* Google browser-based PWA with app wrapper
	* purports to do everything in browser with web servers
	* popular
	* lots of tweaking options with instant visualisation and metrics
* FileOptimizer
	* Windows, so needs Wine for unix
	* Wide range of formats, including PDF
	* lossless only
* Curtail
	* python
	* lossy and lossless
	* might just be linux?
* Trimage
	* simple but effective compression
	* limited, only lossless
* E-Mage
* Imagine
	* relative newcomer - not very active project
	* Electron-based
	* jpeg, png, webp
	* win, mac, linux

## Create photo collage

If you have multiple images, you may wish to crop, resize, and splice 
them together into a photo collage.
You may also be able to use these to put together multiple images 
into a photo montage, but this requirement is more for cutting and gluing. 

* Inkscape
	* import images, resize and crop
	* use layers
	* can be slow to refresh images
* Gimp (without extra plugins)
	* Extremely flexible control over results, but can be time consuming
	* here's a video intro to the basic steps [https://youtu.be/-EKm38ubGxE]
	* here's a compact text tutorial, with some shots, of a more complex example [http://emptyeasel.com/2008/08/29/how-to-create-a-photomontage-in-gimp/]
	* and here's a real step-by-step in case you get stuck on the manipulation [https://digital-photography-school.com/create-a-collage-in-gimp/]
	* Here's an overview of the process
		* Open images as layers
		* add layer masks
		* use gradients on mask to blend your image into others
	* Tips
		* Have an idea of the overall layout before you start
			* you can fit canvas to layers as you go
			* or you can set your final size/resolution from the start
		* look for shortcuts in manipulating selections in mask layers
* G'MIC montage plugin for Gimp
	* gimp-gmic package in repos
	* uses c++ libgmic for functions
	* Open as Layers > choose your images
	* Filters > G'Mic / Arrays & tiles > Montage
	* good for layout but assumes you have pre-scaled and cropped layers
* fotowall
	* new fotowall 1.0 retro released after long haitus (may be final)
	* very flexible and quick to put images together as you wish
	* once you crop you can't uncrop without reloading image
	* [https://www.enricoros.com/opensource/fotowall/download/binaries/]
	* original not in repos since trusty
	* in ppa:dhor/myway
* photocollage
	* simple and lightweight
	* good for splicing and arranging but no crop or resize
	* written in Python using GTK interface and Python Imaging Library (PIL)
	* in ubuntu repos since 17.04
	* in ppa:dhor/myway before then
* shapecollage
	* algorithmic creation of specific outlined shape
* metapixel
	* cli program

Instagram has an android app called Layout, 
and there are also many web-based collage services, 
e.g. [http://www.creativebloq.com/photography/collage-maker-11135210]


## Creating videos from images

### Candidates

* OpenShot
	- this is the Ubuntu Studio default video creation app
* ffDiaporama
	- Qt-based
	- no recent development (2014)
* FFmpegYAG
	- simple graphical front end (GUI) for ffmepg
* VLMC
	- from the VideoLAN stable that created VLC
* The following are more Video Editing less video creation:
	- (sometimes referred to as Non-Linear Editing or NLE)
	- Cinelerra
	- LiVES
	- KDEnlive
	- PiTiVi
	- Shotcut
	- Blender (also includes editing features)


## converting images to drawings

### tracing

Tracing is a way to convert bitmap (raster) images to vector images, 
to manipulate the shapes themselves, rather than the way they have been rendered. You should consider using a raster graphics program, 
like GIMP, to clean up or simplify the original image, 
or to crop out parts not required.

Inkscape has some useful tracing options, 
see [https://inkscape.org/en/doc/tutorials/tracing/tutorial-tracing.en.html] 
for an introduction to these. 

However these are based on Potrace, which creates filled shapes. 
In some circumstances this may be what you want, but in the case of images 
that began as line drawings, a center-line trace may give you better results. 

You can use command line **Autotrace** with it's **-centerline** option, 
online services based on Autitrace, such as [http://online.rapidresizer.com/tracer.php], 
or use the an Inkscape plugin that wraps AutoTrace using python-Pillow:

[https://github.com/fablabnbg/inkscape-centerline-trace]

* download the latest .deb [release](https://github.com/fablabnbg/inkscape-centerline-trace/releases)
* restart Inkscape
* look under menu option:
	- Extensions -> Images -> Centerline Trace ...

NB: Although AutoTrace is rather old (2002), the docs do point to 
other comparable projects of the time [http://autotrace.sourceforge.net/] 
as well as suggestions of how to work with fonts


### posterising

Turning graduations of colour into abrupt hue changes, 
to make photos look more like paintings or cartoons

For more advanced options see online services such as:

* (add candidate websites to list)


## backing up from image services

### instagram

If you want to back up photos and their captions from Instragram 
there are various free downloads and third party services, 
or you can even save to another service with ifttt. 
However you could simply use a foss python script, that can be automated, 
like instaLooter, taken over from instaRaider. [https://github.com/althonos/instaLooter]

* requirements: 
	* python
	* PIL or Pillow as well as piexif for metadata
* installation
	* easy with pypi or pip
	* see [http://instalooter.readthedocs.io/en/latest/install.html]
* runtime options:
	* `python instaRaider.py -u myusername` 
	* `-N`, --new   just get new files not already in destination
	* `-m`, --add-metadata    add date and caption metadata
	* credit [http://instalooter.readthedocs.io/en/latest/usage.html]

## Recognising content

Systems for recognising content in photos:

* faces of individual people
* elements of scenes
* similarities of content
* (partial) duplication

and for metadata tagging them based on this, 
or categorising or organising in other ways.

* DigiKam
	* Face recognition
		* uses OpenCV's `Deep Neural Network` module
		* previously used OpenTLD
* OpenBR ?
	* Face detection, normalisation, extraction and matching
* 

## turning images into text

Document recognition is 
interpreting the textual or numerical data (words and numbers) 
stored in image files


### Optical Character Recognition (OCR)

* ocrfeeder, including the tesseract engine, is installed by [Lubuild app-installs]

If you want a cross-platform GUI for the Tesseract engine, the only one mentioned on the [Tesseract 3rd party list](https://tesseract-ocr.github.io/tessdoc/User-Projects-%E2%80%93-3rdParty.md) is:

* normcap
	* python front end for tesseract
		* allows you to clip an area of screen to recognise
		* the resulting text is pasted onto the clipboard
	* install engine and languages using your package manager
	* `pip install normcap` to install
	* `./normcap` to run
	* see https://github.com/dynobo/normcap#python-package

#### tesseract command line usage

If you don't want to install a GUI 
it is quite straightforward to use...

`tesseract my-image.tiff text-file-to-output`

It will not work directly with PDF files, 
but see if your PDF viewer can export as TIFF 
to a multipage image instead.

For more instructions see 
https://tesseract-ocr.github.io/tessdoc/Command-Line-Usage.html


### QR codes

Quick Response (QR) codes are square pixellated barcodes used to read information 
from mobile devices with a camera. 

#### interpreting

* zbar-tools
	- command line read from file or webcam
	- zbarimg to decode image files
	- zbarcam to use webcam
	- a few dependencies
* qtqr
	- Gui to decode and encode
	- uses zbar library
	- 

Note that your image may need some preprocessing to regularise:
* brightness and contrast
* rotation and skew
* image file encoding (format/type)


#### creating

To generate QR codes consider the following software. 
For help on syntax see 
https://github.com/zxing/zxing/wiki/Barcode-Contents

* qrencode
	- create a png file from text supplied on the command line
	- also creates EPS and Ascii text files
	- can be installed on mac with `brew install qrencode`
* qreator
	- similar
* qtqr
	- Gui to create, view and save QR codes
	- built on Qt and Python
	- 
* Portable QR-Code Generator
	- also supports Geo or Wifi Access protocol codes
	* written in Java (so requires JRE runtime)
* 

