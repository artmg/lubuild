#!/bin/bash

cat "$0"
echo
echo FYI: these are shell script samples (snippets), not meant to be run!
echo
read -p "Press [Enter] key to end"
exit 1

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
