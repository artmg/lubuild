#!/bin/bash

cat "$0"
echo
echo FYI: these are shell script samples (snippets), not meant to be run!
echo
read -p "Press [Enter] key to end"
exit 1

# see also:
# * https://github.com/artmg/lubuild/blob/master/z-misc-script-snippets.sh
# * https://github.com/artmg/lubuild/blob/master/help/use/Music-and-multimedia.md
#    * for and find to output to playlists
#


## Empty folders

### Extract files from folder structure

# I wanted to find and move files including relative path
# which you could do with find, see - https://unix.stackexchange.com/a/59159
# but the alternative rysnc seemed neater
#     archive  ignore empty       move not copy
rsync -av --prune-empty-dirs --remove-source-files Source/ Target/


### delete empty folders in tree

# a much simpler approach if you can accept deletion
find . -type d -empty -delete
# credit https://unix.stackexchange.com/a/107556


## Loop through list of pathnames

# These are meant to be used interactively

### and output num files dirs and datasize

DELIM=
cat <<EOF |
$HOME/Documents
$HOME/Desktop
EOF

while read line
do
    pushd "${line}" >nul
    echo $line $DELIM `find .//. ! -name . -type d -print | grep -c //` $DELIM `find .//. ! -name . -type f -print | grep -c //` $DELIM `du -sh`
    # credit https://unix.stackexchange.com/a/1126
    popd >nul
done
echo pathname $DELIM folders $DELIM files $DELIM datavolume

## take multiple named files

### concatenate files removing headers

# If there are multiple table files (e.g. CSVs) 
# and you want to concatenate them into one single table
# removing headers from all but the first
# then you can simply add the first line from any 
# credit - http://apple.stackexchange.com/a/88564

{ cat Historical*.CSV | head -n1 ; for f in His*.CSV; do tail -n+2 "$f"; done; } > JoinedUp.`date +%y%m%d.%H%M%S`.csv

