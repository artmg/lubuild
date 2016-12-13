
This article covers using generic Office documents, including 
word processing and spreadsheets. It assumes that you use the 
LibreOffice applications on your linux builds.

There is also a section on the related topic of 
Desktop Publishing (DTP) software.


## Interoperability

### Microsoft Windows and Office

#### Fonts 

The basic fonts are installed as part of [https://github.com/artmg/lubuild/blob/master/app-installs.bash]

This include msttcorefonts and the 
Google metric-equivalent fonts for Calibri and Cambrian

These latter allow you to see documents made using these Microsoft proprietary fonts 
with more or less the correct layout as you would if you had them installed.
# credit [https://wiki.debian.org/SubstitutingCalibriAndCambriaFonts]

The community is asking LibreOffice to install these by default in future 
[https://bugs.launchpad.net/ubuntu/+source/libreoffice/+bug/1612114]
and LibreOffice team is looking at ways to improve the experience
[https://design.blog.documentfoundation.org/2016/10/21/dealing-with-missing-fonts/]

see also:
* [http://askubuntu.com/a/594983]
* [http://askubuntu.com/a/181167]
* 

##### Selecting uninstalled Fonts

Please note that LibreOffice will NOT currently allow you to choose a Font that is not installed. 

The workaround suggested by the Debian team is to start with a template where Styles have already 
been set up on a Windows machine with Office and these Fonts installed. 
[https://wiki.debian.org/SubstitutingCalibriAndCambriaFonts#Drawback]

##### Embedding Fonts

Since LibreOffice 4, you have the option to embed fonts in your document, 
to ensure that the recipient will see it as you do, 
even if they don't have the Fonts installed on their own PC. 

Simply open **File / Properties / Font** and check `Embed Fonts in the document` 

However as of 5.2 the filesize may be incredibly large, as it chooses to embed 
any fonts referenced by any Style in the document, rather than whether or not the 
Style and / or Font is actually USED in the document as saved. 

This issue is being tracked as [https://bugs.documentfoundation.org/show_bug.cgi?id=65353] 
and the following two questions about how to work around the issue were unanswered: 
[https://ask.libreoffice.org/en/question/69433/how-do-i-remove-unused-embedded-fonts/] 
[https://ask.libreoffice.org/en/question/44689/how-to-cleanup-unused-embedded-fonts-from-odt-or-garbage-collect-inside-odt-file/] 

###### Workaround

If you manually open the ODT file with an Archive Manager, you will see the files 
in the folder **Fonts**. To know which is which view the file `content.xml`, 
to see the `<office:font-face-decls>` entries. 

Although you can delete the files from the Fonts folder using an Archive Manager, 
just doing that will provoke an error trying to open the document. 
You must also remove the `<office:font-face-decls>` entries, 
and possibly also remove the file entries from `META-INF/manifest.xml`.

###### Solution?

If you can't wait for the bug to be fixed, or you had to clean up a lot of files, 
you could develop a partially automated solution. You can use one of the 
[many libraries for editing ODF files](http://opendocumentformat.org/developers/) 
(see this [phython sample for replacing images](http://recipes.opendocsociety.org/recipes/swapping-old-new-image-from-documents-cli)). 

For testing around Font Embedding in ODF files, see also 
[http://plugtest.opendocsociety.org/doku.php?id=scenarios:20120419:fontembedding&s%5B%5D=embed]

Note that, if you want to create a PDF with embedded fonts, you are likely to get 
a more efficient (smaller) filesize if you export to PDF from LibreOffice than 
if you use a PDF Print Driver such as those based on ghostscript. 


### Apple Mac

#### .pages files

As of LibreOffice 5.0 there is support for some (older?) Mac word-processor file formats. 

If you are struggling to deal with a **.pages** file from a Mac user with iWork Pages, 
you have a couple of last ditch options:
* sign up to iCloud to use Apple's own convertor to render a DOC or PDF
* Open the archive cabinet, look for the _QuickLook_ folder and check out the _Preview.PDF_ inside



## Desktop Publishing (DTP) software

Although combined office suites like LibreOffice do allow you to do some publishing work, 
some of the features of Writer or Draw may be hard to use or just not quite allow you to 
manipulate documents and lay them out the way you want. 

Here we assume you want to produce some kind of multi-page newsletter that is 
visually both appealing and coherent. 

The main candidate that comes up again and again is **Scribus**, 
but others are covered in the section further below. 
For other software more related to graphical manipulation that multipage styling, 
like Gimp or Inkscape, see [??]


### Scribus



### Other Candidates

Software _mentioned_ by others, but not reviewed in depth here includes:

* Laidout
    * principally aimed at Impositioning, e.g. folding and cutting into booklets
    * can handle images, gradient fills, paths, meshes and warping
    * not really big on text
* LyX
    * non-WYSIWYG front-end to LaTeX typesetting system
* 

Other related software includes:

* gLabels
    * use printing labels to repeat designs many times across a single sheet

Discounted as not Free Open Source Software (FOSS):

* Pagestream

