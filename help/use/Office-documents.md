
This article covers using generic Office documents, including 
word processing and spreadsheets. It assumes that you use the 
LibreOffice applications on your linux builds.

There is also a section on the related topic of 
Desktop Publishing (DTP) software.


## Interoperability with Microsoft Windows and Office

### Fonts

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

#### Selecting uninstalled Fonts

Please note that LibreOffice will NOT currently allow you to choose a Font that is not installed. 

The workaround suggested by the Debian team is to start with a template where Styles have already 
been set up on a Windows machine with Office and these Fonts installed. 
[https://wiki.debian.org/SubstitutingCalibriAndCambriaFonts#Drawback]


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

