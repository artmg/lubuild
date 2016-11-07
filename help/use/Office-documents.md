
This article covers using generic Office documents, including 
word processing and spreadsheets. It assumes that you use the 
LibreOffice applications on your linux builds.

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

