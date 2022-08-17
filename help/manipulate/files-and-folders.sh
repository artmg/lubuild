#!/bin/bash

cat "$0"
echo
echo FYI: these are shell script samples (snippets), not meant to be run!
echo
read -p "Press [Enter] key to end"
exit 1

# This file is part of the public `Lubuild` repo

# it mainly concerns useful ways to deal with your data stores
# other keywords: examples

# see also:
#
# * [Lubuild use Music and multimedia](https://github.com/artmg/lubuild/blob/master/help/use/Music-and-multimedia.md)
#    * for and find to output to playlists
# * [Lubuild /z Misc script snippets](https://github.com/artmg/lubuild/blob/master/z-misc-script-snippets.sh)
#     * specifics relating to ?ubuntu installation and config
# * [macUP / backUP with 7-Zip](https://github.com/artmg/macUP/blob/main/backUP_with_7-Zip.md)
#     * ways to compress files into a single container for archiving etc



# THE BASICS #######################################################


## for each

### basics

for f in *; do echo "$f" ; done
# http://askubuntu.com/a/259735
# don't forget the output >>

#### generic do in each directory, which allows spaces and does not seem to include . self 
for D in *; do [ -d "${D}" ] && echo $D; done
# or 
for D in *; do
    if [ -d "${D}" ]; then
        echo "${D}"   # your processing here
    fi
done
# credit http://stackoverflow.com/a/4000741




## find

# examples of commands using this very useful and flexible tool


### basic find

#### find but output relative paths

find . -iname \*.txt -print
# see also http://unix.stackexchange.com/questions/104800/find-output-relative-to-directory

#### multiple types

## multiple expressions to find different file formats
# escaped brackets and stars; parenthesis or for precedence rules
# could use regex but some folks say it might be "less portable"?
# -o, -or; -iname is case insensitive
find . -type f \( -iname \*.mp3 -o -iname \*.wma  -o -iname \*.ogg \)
find . -type f \( -iname \*.jpg -o -iname \*.png  -o -iname \*.mp4 \)

find $PWD/MyMusicFolder -type f \( -iname \*.mp3 -o -iname \*.wma  -o -iname \*.ogg \) | sort >>"InitialPlayList.m3u";
# the $PWD gives find an absolute starting point, so this is how it returns the names


#### simple execute

# output fileame and file contents (like cat but with headers)
find . -name .gitignore -exec tail -n+1 {} +



### find folder and subfolder structure

# quick do in all next level folders...
# in folder     only first level        subdirs   in folder spaces allowed  execute command
find /path/name -maxdepth 1 -mindepth 1 -type d -exec sh -c '(cd "{}" && pwd)' ';' 

# create a script which will do an action in all subfolders of script location
SCRIPT_NAME=path/script-name.sh
export SCRIPT_NAME
cat >$SCRIPT_NAME <<EOF
#!/bin/bash
# recursively do action in all direct subfolders of folder containing script 
find "\$(dirname "\$0")" -maxdepth 1 -mindepth 1 -type d -exec sh -c '(cd "{}" && drive pull)' ';' 
EOF
chmod +x $SCRIPT_NAME


### find using metadata

#### Find based on date or time

# between a range
find . -newermt "2013-01-01 00:00:00" ! -newermt "2013-01-02 00:00:00"

# files modified since installation
find / -type f -newer /var/log/installer/syslog 

# include the date and time
 -printf "\n%AD %AT %p" 


#### exclude system directories

# usually best to INCLUDE dirs you DO want, but if you do a search from root
# you may want to prune proc sys dev

find / -path /sys -prune -o  -path /proc -prune -o  -path /dev -prune -o  


# files in order modified since install
find / -path /sys -prune -o  -path /proc -prune -o  -path /dev -prune -o   -path /run -prune -o  -path /mnt -prune -o  -type f  -newer /var/log/installer/syslog   -printf "\n%C+ %p" | sort


#### sort tree in date order

find . -type f -exec stat -f "%m%t%Sm %N" '{}' \; | sort -rn | head -20 | cut -f2-

# this will recurse the currect folder and all subfolders for files
# then display them sorted newest first (remove head to show them all)
# slow, but works in linux and macOS, bash and zsh
# credit https://superuser.com/a/416423
# in case of errors on macOS, try  /usr/bin/stat  instead



# APPLIED EXAMPLES #######################################################


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

# this adds the date and timestamp as YYMMDD . HHMMSS to the filename




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
# to test first, simply omit the -delete parameter
# this beats the longer winded method below
find . -depth -type d -empty -exec bash -c 'echo rmdir $1' _ {} \;
find . -depth -type d -empty -exec rmdir {} \;



## Extracting from folders

### List out files of a type within folder

SRC_ROOT=my/path
FILE_MIME=video/
OUT_FILE=~/photos

(
cd "${PATH1}"
# credit https://stackoverflow.com/a/60559975#comment116644046_60559975
find . -type f -print0 |
  xargs -0 file --mime-type |
  grep -F "${TYPE1}" |
  rev | cut -d ':' -f 2- | rev \
    >"${OUTF}"1.txt
)
# To make the list richer, like size/date, could I pipe it to
# ls -lh or even ` | ls -lh | awk '{print $5, $NF}' `         ?


# The rest of these assume that the tree or folder lists 
# have been generated with something akin to the following, 
# or by taking relative folder names with trailing slashes from the list above
find . -type d -printf "%p/\n"


### Trees - all files and folders

# This will extract each tree mentioned into the file
# and place it as a foldertree in the destination, with all roots flat in the same folder
# with names comprised from their path 

TREE_LIST=my_list_of_tree_rel_paths.txt
SRC_ROOT=path/to/trees/now
DEST_ROOT=wheretoputthem

cat $TREE_LIST | while read srcpath ; do 
  # this assumes each relative path starts with ./ and ends with / so let's truncate those
  truncpath=${srcpath:2:-1}
  echo "$SRC_ROOT/${truncpath}"
  # and convert them from slashes 
  destpath=${truncpath//\// – }
  echo "$DEST_ROOT/${destpath}"
  mkdir -p "$DEST_ROOT/${destpath}"
  mv "$SRC_ROOT/${truncpath}/*" "$DEST_ROOT/${destpath}/"
done


### type from Folder - only given type files from specified folder only without traversing

# remove the -maxdepth 1 if you want to take from an subfolder

TREE_LIST=my_list_of_tree_rel_paths.txt
SRC_ROOT=path/to/trees/now
DEST_ROOT=/abs/path/whereto/putthem
FILE_MIME=video/

cat $TREE_LIST | while read srcpath ; do 
  # this assumes each relative path starts with ./ and ends with / so let's truncate those
  truncpath=${srcpath:2:-1}
  pushd "$SRC_ROOT/${truncpath}"
  # and convert them from slashes 
  export destpath=$DEST_ROOT/${truncpath//\// – }
  echo "$destpath"
  mkdir -p "$destpath"
  find . -maxdepth 1 -type f -print0 |
    xargs -0 file --mime-type |
    grep -F "${TYPE1}" |
    rev | cut -d ':' -f 2- | rev | cut -c 3- | 
    xargs -I '{}' mv '{}' "$destpath"
  popd >/dev/null
done
# could this have used find truncpath to avoid pushd and allow dest to be relative?


### Types from tree - move only files but create the folder structure

# not quite working when passing filenames with spaces to the mv command

TREE_LIST=my_list_of_tree_rel_paths.txt
SRC_ROOT=path/to/trees/now
DEST_ROOT=/abs/path/whereto/putthem
FILE_MIME=video/

cat $TREE_LIST | while read srcpath ; do 
  # this assumes each relative path starts with ./ and ends with / so let's truncate those
  truncpath=${srcpath:2:-1}
  pushd "$SRC_ROOT/${truncpath}"
  # and convert them from slashes 
  export destpath=$DEST_ROOT/${truncpath//\// – }
  echo "$destpath"
  mkdir -p "$destpath"
  find . -type f -print0 |
    xargs -0 file --mime-type |
    grep -F "${TYPE1}" |
    rev | cut -d ':' -f 2- | rev | cut -c 3- | 
    xargs -I{} bash -c 'destfold="$destpath/$(dirname {})" ; mkdir -p "$destfold" ; mv "{}" "$destfold"'
  popd >/dev/null
done
# could this have used find truncpath to avoid pushd and allow dest to be relative?


