
## core applications

The default PDF veiwer in Lubuntu is called "Document Viewer" 
also known as GNOME Evince, which handles other common book, scan and fax formats. 

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
[Foxit Reader](https://www.foxitsoftware.com/downloads/) 


### Selectively print area of large diagram

* Open PDF in GIMP 
* Use the Rectangle Selection tool to highlight your print area 
* Menu / Image / Fit Canvas to Selection 
* File / Print / Image Settings - check the preview 
* you may need to change Page Setup / Orientation to match the proportions of the canvas area 
* now print directly, or to a PDF if you want to extract that selection for later 
* if you want multiple areas, just CTRL-Z to undo and select again 

```
### Copy image files out from PDF documents ##

# requires poppler-utils
sudo apt-get install poppler-utils

#### raster images

pdfimages -all source-file-name.PDF /path/to/output/image-files
# -j will write JPEGs as such
# -all will extract all raster image types - equivalent to -png -tiff -j -jp2 -jbig2 -ccitt

#### vector graphics
pdftocairo -svg source-file-name.PDF /path/to/output/image-files.SVG

```

### Reduce PDF filesize by reducing image quality

```
#### simply using qpdf
sudo apt-get install qpdf

# generate a linearized (web-optimized) output file
qpdf --linearize input.pdf output.pdf
# this automatically invokes the default option --stream-data=compress

# ABOUT qpdf - http://qpdf.sourceforge.net/ - http://qpdf.sourceforge.net/files/qpdf-manual.html
#   * C++ library with relatively few external dependencies and offering cli executables
#    * inspect and manipulate the structure of PDF files
#    * debian package available
#    * active development with versions issued throughout 2014/5
#    * published under Artistic License


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

#### old notes on Processing Xsane scanned PDF files 

# also options to remove colour: 
# -sColorConversionStrategy=Gray -dProcessColorModel=/DeviceGray 
# (multiple input files will merge into multipage PDF)

# IS default compression is slightly lower quality than 'screen' ?
gs -dNOPAUSE -dQUIET -dBATCH -sDEVICE=pdfwrite -sOutputFile=output.pdf ~/out.pdf

# help > http://milan.kupcevic.net/ghostscript-ps-pdf/
```


#### Alternatives

include:
* http://gscan2pdf.sourceforge.net/ orphaned gui to link sane to GS
* http://svn.ghostscript.com/ghostscript/trunk/gs/doc/Ps2pdf.htm#PDFA scan to PostScript and convert




### completely remove images from PDF files
```
# coherentpdf has a draft option which removes them
cpdf -draft original.pdf -o version_without_images.pdf
# it's free for -$ non-commercial but NOT libre


```

## browse content and structure

for forensic, development or testing work...

* candidates:
    * PoDoFo library - http://podofo.sourceforge.net/
        * PoDoFoBrowser 
            * http://podofo.sourceforge.net/download.html#browser
            * QT based GUI
            * any repos?
    * see also http://forensicswiki.org/wiki/PDF#PDF_Tools
    * iTextRUPS is Java based
    * 

## split pages



## modify file properties ##

including pdf metadata 

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
It will NOT remove previously written PDF metadata
http://www.sno.phy.queensu.ca/~phil/exiftool/TagNames/PDF.html

 # display current properties
 exiftool path/filename.pdf

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



## lifting restrictions on existing files

Before using any of the following techniques, please ensure that 
the changes you plan to make will not breach 
any terms or conditions of license agreements or usage rights!

### Owner passwords

"OWNER" password restricts user rights but can be overridden

* http://stackoverflow.com/q/10772686


### User Passwords

"USER" password prevents opening, and uses encryption

* Open Source pdfcrack - http://pdfcrack.sourceforge.net/faq.html
    - multi-core fork: version http://andi.flowrider.ch/research/pdfcrack.html
    - take also the makefile patch, apply the patch and make the exe
* Commercial GuaPDF - http://www.guapdf.com/


