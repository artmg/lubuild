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

