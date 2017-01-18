
Although some of the tools for working with photos also apply to films and songs, 
they are treated separately here as we assume films and songs are bought, 
whereas photos are captured, unique and irreplaceable. 

See also:
* [https://github.com/artmg/lubuild/blob/master/help/manipulate/films-and-songs.md]
    * For ripping, converting and metatagging films and songs
* 



## renaming images based on metadata

The most common case for this would be to rename to "YYYYmmdd_HHMMSS.ext" 
based on the date and time that the photo was taken (metadata)

Exiftool is a great way to do this

```
# show the metadata for a single file
exiftool myPhoto.jpg
# help - http://www.sno.phy.queensu.ca/~phil/exiftool/
# show the shortnames for meta tags
exiftool -s myPhoto.jpg

# rename to "YYYYmmdd_HHMMSS.ext" and move into folder "renamed"
exiftool "-FileName<DateTimeOriginal" -d "%Y%m%d_%H%M%S.%%e" -directory=renamed .
```

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


## document recognition

For interpreting the data stored in image files

### Optical Character Recognition (OCR)

* ocrfeeder, including the tesseract engine, is installed by [Lubuild app-installs]


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

To generate QR codes consider:

* qrencode
	- create a png file from text supplied on the command line
	- also creates EPS and Ascii text files
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

