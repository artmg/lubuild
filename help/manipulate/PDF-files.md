PDF files
========

see also:

* [https://github.com/artmg/lubuild/blob/master/help/manipulate/photos-and-images.md]
	* working with individual photos and creating videos from them
	* also general image manipulation 
* [https://github.com/artmg/lubuild/blob/master/help/use/Office-documents.md]
    * Office documents (like MS Office and other combination packages)
    * Desktop Publishing (DTP) packages
    * working with fonts in generic Office documents
* [https://github.com/artmg/lubuild/blob/master/help/manipulate/plans-and-designs.md]
	* Computer Aided Design programs
	* 3D design, including space layout and rendering, and 2D design
* [https://github.com/artmg/lubuild/blob/master/help/manipulate/miscellaneous-files.md]
	* Other common types of document
	* including email formats



## Viewing

The default PDF veiwer in Lubuntu is called "Document Viewer" 
also known as GNOME Evince, has capabilities including: 

* Fill in a Form (if Allowed by file)
* handles other common book, scan and fax formats
* show properties including embedded fonts
	- although it may not properly support security features like copy protection


### browse content and structure

for forensic, development or testing work...

* candidates:
    * PoDoFo library - http://podofo.sourceforge.net/
        * PoDoFoBrowser 
            * http://podofo.sourceforge.net/download.html#browser
            * QT based GUI
            * any repos?
	* qpdf
		* cli utility to extract from PDF to text readable format
		* cross platform, open source
		* can be found in many distro repos
    * see also http://forensicswiki.org/wiki/PDF#PDF_Tools
    * iTextRUPS is Java based
    * see also 	https://stackoverflow.com/a/29474423
    * 

see also https://github.com/artmg/lubuild/blob/master/help/diagnose/disk-recovery-and-forensics.md

### viewing metadata

See the Editing Metadata section below for utilities that can also display current metadata values


## Extracting

### Working with Fonts

Many Document Viewer apps will allow you to see what fonts are embedded in PDF documents
inlcuding: 

* Evince 
* qpdfview

You can also use the command line **pdffonts** from poppler-utils. 

To extract the fonts for local use, install **fontforge** from the ubuntu repos. 
Note that many fonts are only the subset of letters used, so won't include every character. 
For more on fontforge, see [http://designwithfontforge.com]

For even more techniques see [https://stackoverflow.com/a/3489099]

### Copy image files out from PDF documents

```
# requires poppler-utils
sudo apt-get install poppler-utils
# on Mac use:  brew install poppler
# but beware, there are LOADS of dependencies

#### raster images

pdfimages -all source-file-name.PDF /path/to/output/image-files
# -j will write JPEGs as such
# -all will extract all raster image types - equivalent to -png -tiff -j -jp2 -jbig2 -ccitt

#### vector graphics
pdftocairo -svg source-file-name.PDF /path/to/output/image-files.SVG

```



## working with images in PDF files

### zoom in closer

Evince (and Okular, a common alternative PDF viewer) have zoom limits 
that you may find troublesome on extremely large or small documents. 

You can open vector PDFs in **Inkscape**, although large and complex diagrams 
can take quite a long time to redraw as you move in this application 
designed for editing rather than just viewing. Some people suggest 
the open source alternative viewers xpdf and mupdf, 
but others say they can glitch on complex vector diagrams. 

Since Adobe stopped supporting their Reader for Linux in 2014, the best 
closed source (but gratis-free) alternative offering better zoom is
[Foxit Reader](https://www.foxitsoftware.com/downloads/). 
Note that although some features are richer in this giveaway, 
they have restricted other features to encourage you to buy their wares. 
So if you can't do something in Foxit for free, for instance form filling, 
check the libre software above to see if it can.


### Selectively print area of large diagram

* Open PDF in GIMP 
* Use the Rectangle Selection tool to highlight your print area 
* Menu / Image / Fit Canvas to Selection 
* File / Print / Image Settings - check the preview 
* you may need to change Page Setup / Orientation to match the proportions of the canvas area 
* now print directly, or to a PDF if you want to extract that selection for later 
* if you want multiple areas, just CTRL-Z to undo and select again 


### Copy image files out from PDF documents

see Extracting section above


### Create PDF from image files

```
# credit [https://askubuntu.com/a/446218]
# convert utility is from imagemagick package
convert x.jpg y.jpeg pictures.pdf
# list files in a "natural order" (1,2,3...) and proceed with conversion
convert `ls -1v` file.pdf
# for extensive list of options see
# [http://manpages.ubuntu.com/manpages/zesty/man1/convert-im6.1.html]
```

### Reduce PDF filesize by reducing image quality

qdpf is a mature and still current cross-platform open source command line (cli) utility, with its own C++ library so it requires relatively few external dependencies. It can inspect and manipulate the structure of PDF files packages are available in many linux repos, brew and choco.


```bash
#### simply using qpdf
sudo apt-get install qpdf

# generate a linearized (web-optimized) output file
qpdf --linearize input.pdf output.pdf
# this automatically invokes the default option --stream-data=compress

# other suggested options:
# qpdf --compress-streams=y --decode-level=generalized --recompress-flate --compression-level=9 --optimize-images --object-streams=generate
# as of early 2025 this converts to JPEG but does not lossily degrade to save space
```

for help see https://qpdf.readthedocs.io/

#### qpdf alternatives


```bash
#### using ghostscript
sudo apt-get install ghostscript

# credit http://askubuntu.com/a/477798
gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dNOPAUSE -dQUIET -dBATCH \
   -dPDFSETTINGS=/screen -sOutputFile=small.pdf original.pdf
# -dPDFSETTINGS = 
# /prepress   (default) is full quality
# /printer    slightly lower (300dpi)
# /ebook      lower (150dpi)
# /screen     lowest (72dpi)
# help - http://ghostscript.com/doc/current/Ps2pdf.htm

gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dNOPAUSE -dQUIET -dBATCH \
   -dDownsampleColorImages=true -dDownsampleGrayImages=true -dDownsampleMonoImages=true \
   -dColorImageResolution=75 -dGrayImageResolution=75 -dMonoImageResolution=75 \
   -sOutputFile=small.pdf original.pdf
# credit - http://stackoverflow.com/a/20681992


##### Using Ghostscript to rasterise

# You may try the solutions above to reduce image quality
# and still find there is something keeping the size large 
# as these might affect what you see (such as fonts)
# you cannot remove them, so try rasterising the document

# credit https://www.ghostscript.com/doc/current/Use.htm#Invoking
gs -dSAFER -dBATCH -dNOPAUSE -sDEVICE=pgmraw -r150 \
                -dTextAlphaBits=4 -sOutputFile='page-%00d.pgm' original.pdf
# if you want even smaller drop the resolution to -r75
# but check it is still legible
# We have yet to find a wat to reduce to greyscale only directly in GS
# consider ImageMagick's convert command


#### old notes on Processing Xsane scanned PDF files 

# also options to remove colour: 
# -sColorConversionStrategy=Gray -dProcessColorModel=/DeviceGray 
# (multiple input files will merge into multipage PDF)

# IS default compression is slightly lower quality than 'screen' ?
gs -dNOPAUSE -dQUIET -dBATCH -sDEVICE=pdfwrite -sOutputFile=output.pdf ~/out.pdf

# help > http://milan.kupcevic.net/ghostscript-ps-pdf/
```

Also ran:

* FileOptimizer is an established open-source file compressor for Windows and Wine that includes PDF amongst many file types it can squeze, but is only works losslessly, and will not denigrate image quality.
* http://gscan2pdf.sourceforge.net/ orphaned gui to link sane to GS
* http://svn.ghostscript.com/ghostscript/trunk/gs/doc/Ps2pdf.htm#PDFA scan to PostScript and convert


### completely remove images from PDF files

see section under Editing below


## Editing content

### Creating PDF files

The most common ways to create files include:

* Export a PDF directly from the application, such as LibreOffice, Inkscape, Gimp, etc
	* this allows more granular control of output, and may include the chance to set metadata as the file is written
* Print to PDF file
	* this is simpler but should work with ANY application that can print

On Ubuntu and many Linux systems, the Print to PDF printer driver will already be installed by default. If not you can simply install the `cups-pdf` package to enable the feature. 

For Windows systems see [Lubuild configure Windows # Print to PDF](https://github.com/artmg/lubuild/blob/master/help/configure/Windows.md#print-to-pdf) for troubleshooting on this feature.


### Editing file contents

Depending on how the file was created, 
you might find either of the following 
useful for modifying the contents and layout
of PDF files

* LibreOffice
	* defaults to opening in the Draw program 
	* this is the one that handles PDF content best
	* see also [use/Office documents](https://github.com/artmg/lubuild/blob/master/help/use/Office-documents.md)
* Inkscape
	* more appropriate for low level editing or complex contents
	* see also [manipulate/plans and designs](https://github.com/artmg/lubuild/blob/master/help/manipulate/plans-and-designs.md)

Watch out for the metadata when you write the final file


### Other editing

The following are on the default list of Lubuild apps

* pdftk
    * manipulate PDF files (e.g. split, combine) 
    * as alternative to installed GhostScript 
    * see http://askubuntu.com/questions/195037/is-there-a-tool-to-split-a-book-saved-as-a-single-pdf-into-one-pdf-per-chapter/195044#195044
* pdfshuffler
    * GUI for PDF page manipulation
    * PdfMod is more feature-rich but needs Mono; 
    * LibreOffice-PdfImport is already installed
* poppler-utils 
    * includes pdfimages to extract image files from PDFs


### split pages

* PDF Arranger
	* forked from defunct pdfshuffler
	* available for Linux and Windows
		* not required in macOS as buint-in Preview allows PDF editing
	* `pdfarranger` in choco, debian and other repos
* pdf-shuffler
	* linux only
	* was in many repos
	* project abandoned since 2018
* pdfsam
	* cross platform and open source
	* however as freemium software, premium features will be locked
	* over time the interface has become too full of locked features to really be usable


### completely remove images from PDF files

```
# coherentpdf has a draft option which removes them
cpdf -draft original.pdf -o version_without_images.pdf
# it's free for -$ non-commercial but NOT libre


```

## Editing metadata

To modify file properties, including pdf metadata ...

### cli ###

#### pdftk ####

The CLI portion of pdftk is referred to by the developer as "PDFtk Server", 
and it is widely used and distributed through repos on many linux distros.

You can use the pdftk cli tools:
 pdftk Example.pdf dump_data output pdfmeta.txt

then edit the pdfmeta.txt and

 pdftk Example.pdf update_info pdfmeta.txt output Example-new.pdf

if you want to update the modify time as well then copy the timestamp into

 touch -t YYMMDDhhmm.ss filename.pdf


Note that update_info does not erase the XMP stream 
which may also contain date metadata
To remove the XMP you can use the drop_xmp directive
http://manpages.ubuntu.com/manpages/utopic/man1/pdftk.1.html


#### exiftool ####

NB: Although the exiftool can write PDF metadata, it only adds updates.
It can make the metadata _appear_ blank, but it 
will NOT remove previously written PDF metadata
http://www.sno.phy.queensu.ca/~phil/exiftool/TagNames/PDF.html

```
# display current properties
exiftool path/filename.pdf
```

See suggestions of how to clear it in comments under http://askubuntu.com/a/39906

See also some XMP pdf tags - http://www.sno.phy.queensu.ca/~phil/exiftool/TagNames/XMP.html#pdf


#### peepdf ####

peepdf is mainly a forensic reading tool but may have some update capability

http://eternal-todo.com/tools/peepdf-pdf-analysis-tool


### GUI ###

GUI options include:
* PdfMtEd
	* based on exiftools
* Geeqie (Image Viewer)
	* in repos 
* pdfedit
	* does this do metadata?
* GPDFTool
but not sure how well supported or featured they are



### lifting restrictions on existing files

Before using any of the following techniques, please ensure that 
the changes you plan to make will not breach 
any terms or conditions of license agreements or usage rights!

#### Owner passwords

"OWNER" password restricts user rights but can be overridden

* http://stackoverflow.com/q/10772686


#### User Passwords

"USER" password prevents opening, and uses encryption

* Open Source pdfcrack - http://pdfcrack.sourceforge.net/faq.html
    - multi-core fork: version http://andi.flowrider.ch/research/pdfcrack.html
    - take also the makefile patch, apply the patch and make the exe
* Commercial GuaPDF - http://www.guapdf.com/


