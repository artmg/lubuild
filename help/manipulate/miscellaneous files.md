
## MIME / MHTML / EML and other email attachment or multipart formats

To extract files from MIME text files

```
# munpack from mpack package

sudo apt-get install mpack
munpack mimefilename.ext

# example in loop
for f in *.mht; do mkdir -p "unpack/$f"; munpack "../../$f" -C "unpack/$f" ; done
```

# alternatives:
# * mu-extract from maildir-utils 
# * base64 -d from gnu
# * 

