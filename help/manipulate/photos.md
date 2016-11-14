
Although some of the tools for working with photos also apply to films and songs, 
they are treated separately here as we assume films and songs are bought, 
whereas photos are captured, unique and irreplacable. 

See also:
* [https://github.com/artmg/lubuild/blob/master/help/manipulate/films-and-songs.md]
    * For ripping, converting and metataging films and songs
* 



## renaming images based on metadata

The most common case for this would be to rename to "YYYYmmdd_HHMMSS.ext" 
based on the date and time that the photo was taken (metadata)

Exiftool is a great way to do this

# show the metadata for a single file
exiftool myPhoto.jpg
# help - http://www.sno.phy.queensu.ca/~phil/exiftool/
# show the shortnames for meta tags
exiftool -s myPhoto.jpg

# rename to "YYYYmmdd_HHMMSS.ext" and move into folder "renamed"
exiftool "-FileName<DateTimeOriginal" -d "%Y%m%d_%H%M%S.%%e" -directory=renamed .

