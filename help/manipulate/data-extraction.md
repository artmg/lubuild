
see also:

* [https://github.com/artmg/lubuild/blob/master/help/manipulate/miscellaneous-files.md]
    * general working with files and folders, inspecting and managing

## Extraction from unstructured sources

How to take a source where the table or other structure is not immediately obvious to a data import mechanism, and to use some simple logic to recognise or describe what the structure is. Then to prepare that data into a recognisable form, such as a table, for other systems to easily import and work on.
An example of this might be to parse and interpret html code 
to recognise the data columns and rows, 
so that this can be saved easily as a table. 


### from pdfs

* textricator
	* extract text from pdfs
	* three modes: text, table, form
	* layout described in YAML config
	* cli to produce json or CSV
* excalibur-py
	* uses ghostscript to extract text from pdfs
	* self-contained webserver to choose table in pdf
	* based on Camelot and inspired by Airflow
* tabula
	* tables from pdf (text and image)
	* 


### Copy a website

If you want to make a copy of an existing published website to mock up potential changes 

`brew install httrack`

* either use cli command 
    - extensive help https://www.httrack.com/html/fcguide.html
* or use locally-spawned, browser-based gui command `webhttrack`

#### single webpage

simpler way to capture a single page, to obtain html image css and javascript source files (as delivered, not necessarily server-side source):


```
brew install wget

wget -E -k -K -p http://site/document

# credit https://www.gnu.org/software/wget/manual/wget.html#Recursive-Retrieval-Options
# -p, --page-requisites
# -k, --convert-links
# -K, --backup-converted
# -E, --adjust-extension  (e.g. .asp -> .html)

## other hosts
# if you want to get content from other hosts too...

# -H, --span-hosts - https://www.gnu.org/software/wget/manual/wget.html#Spanning-Hosts
#

```

### web scraping and automatic ingestion

* scrapy
	* cross platform, open source python cli tool
	* extract data from websites
	* 
* portia
	* from scrapy team
	* visual, no coding
	* 
* Beautiful Soup
	* open source python library for parsing html
	* creates a parse tree ready to interpret
* UI.Vision RPA
	* automation for tasks and testing 
	* browser extension
* selenium
	* web testing can be used to scrape
* 


### free/open level from commercial players

* talend
	* 'open studio' free featureset from commercial developer
	* mac and windows versions running as self-contained web apps
	* separate modules for preparation, integration, quality, 
* KNIME
	* data mining front end in Java
* RapidMiner
	* free license is limited to 10,000 rows of data
* Octoparse
	* web scraping free up to 10,000 records
* ScrapeStorm
	* auto recognise content up to 100 rows per day

### machine learning tools

* Weka
	* collection of machine learning tools with GUI
	* https://www.cs.waikato.ac.nz/ml/weka/
* tensorflow zoo includes `faster rcnn` which can recognise the different 'segments' in invoice pdfs, which you can scan with Tesseract OCR
* see some comparisons between deep learning and encoded methods https://nanonets.com/blog/table-extraction-deep-learning/


## data cleansing

once you have the data inside, you might want to 
increase the consistency between items to prepare it for solid analysis. For instance, categories may have been entered differently by different people, but actually relate to the same topic. 

* OpenRefine
	* previously google refine
	* open source
	* uses Java (e.g. openJDK) to run local service
	* local web client to manipulate data
	* extensions for many data formats
	* API for programmtic manipulation in R, python, bash etc
	* https://openrefine.org/
* 


## General data manipulation software

* RStudio
	* open source cross-platform IDE for the R language 
	* R is a great choice of programming language for data preparation, and most things a data geek might want to do, but it IS a programming language
* Orange
	* very mature open-source, cross platform project
	* Python and C with Qt interface
	* data analytics, visualization, machine learning and data mining features
* Scriptella is ETL scripting in Java
* KETL integration platform in Java
* Jedox full BI, with OLAP and ETL
* Apatar open source ETL with three deployment modes
* 

