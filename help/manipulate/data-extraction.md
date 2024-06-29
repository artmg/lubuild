
see also:

* [https://github.com/artmg/lubuild/blob/master/help/manipulate/miscellaneous-files.md]
    * general working with files and folders, inspecting and managing

## General data manipulation software

See also the first two choices in [Anonymisation](#Anonymisation) below

* RStudio
	* open source cross-platform IDE for the R language 
	* R is a great choice of programming language for data preparation, and most things a data geek might want to do, but it IS a programming language
	* if data cleansing is your scope then also `install.packages("tidyverse")`
* Orange
	* very mature open-source, cross platform project
	* Python and C with Qt interface
	* data analytics, visualization, machine learning and data mining features
* Scriptella is ETL scripting in Java
* KETL integration platform in Java
* Jedox full BI, with OLAP and ETL
* Apatar open source ETL with three deployment modes
* 

## Extraction from unstructured sources

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

## web scraping and automatic ingestion

### Open source tools

* Scrapy
	* cross platform, open source python cli tool
	* extract data from websites
	* the Portia visual, no-code interface was withdrawn, as maintainer Zyte now offers hosted API tools
* MechanicalSoup 
	* uses Beautiful Soup for document navigation
		* open source python library for parsing html
		* creates a parse tree ready to interpret
	* and Requests for HTTP sessions
* UI.Vision RPA
	* automation for tasks and testing 
	* browser extension
* Selenium
	* web testing can be used to scrape
* Playwright
* Puppeteer
	* node library runs a chrome browser (optionally headless) so you can scrape a webpage using HTML DOM hierarchy
* Crawlee
	* part of Apify SDK so aimed at freemium usage
* 


#### free/open level from commercial players

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

#### machine learning tools

* Weka
	* collection of machine learning tools with GUI
	* https://www.cs.waikato.ac.nz/ml/weka/
* tensorflow zoo includes `faster rcnn` which can recognise the different 'segments' in invoice pdfs, which you can scan with Tesseract OCR
* see some comparisons between deep learning and encoded methods https://nanonets.com/blog/table-extraction-deep-learning/


### Analysing the web pages

To help you find element XPaths:
* Use the browser's DevTools
* Use the [SelectorGadget](https://rvest.tidyverse.org/articles/selectorgadget.html) bookmark tool
	* if it fails to loa due to in-page security, save the html from the Inspector and reload.
	* NB: You do NOT require any third party extensions
* Selenium uses the chosen browser's own XPath engine, and most browsers seem to be firmly rooted on XPath v1.0 

If you want to use class: 
* you can use css selector with .
* See the most ironclad way to specify class: https://stackoverflow.com/a/34779105

### scraping react with Selenium

React and other Single Page Application (SPA) web frameworks are not as easy to scrape, as the page content is loaded by javascript **after** the initial GET. The web-client automation solution 'Selenium WebDriver' can help with this. Selenium is a Java app, so to avoid messing around downloading JVMs you can just get it in a docker image, along with the browser of your choice.

If you are running off Linux, e.g. macOS, you might find `podman` a simpler solution than Docker Desktop. To get started with Podman see https://github.com/artmg/macUP/blob/main/virtualisation.md#podman

Note that there are podman specific images available at quay.io/redhatqe/selenium-standalone which have Chrome, Firefox and VNC debugging, but they are not updated as regularly an may not support all architectures. Equally, you can simply run regular docker images, such as the community apple-silicon-supporting seleniarm/standalone-chrome.

#### Selenium in Podman from R on macos

Using RStudio with packages `selenium`, `selenider` and `rvest` to connect to a Selenium Docker image running in Podman under macos.

```zsh
# do this once to set up
#
### prepare Selenium server VM on macOS
# podman is so much easier to set up and manage on macOS than docker
brew install podman
podman machine init
# sudo /opt/homebrew/Cellar/podman/5.0.3/bin/podman-mac-helper install
podman pull selenium/standalone-firefox
```

```r
# add depedencies into your R environment
install.packages(c("selenium","selenider"))
# using new package as RSelenium did not keep up with server version changes
```

If you run images locally, then when the firewall prompts, you can also **deny** `gvproxy` from listening on the network.

```zsh
# do this every execution session
#
### run Selenium server on macOS
podman machine start
podman run --rm -it --shm-size=2g -p 4444:4444 -p 5900:5900 -p 7900:7900 selenium/standalone-firefox

### use new window to open console
open vnc://localhost:5900
# password: secret

# FYI to shut down...
# Ctrl-C to stop running server
# then stop the VM
#
# podman machine stop

# when you're all done, and want no more selenium, 
# but you want to clear out your disk space...
#
# podman machine reset
```

If you want to check the console open http://localhost:4444/

##### Help with selenium and selenider

* [selenider vignette](https://ashbythorpe.github.io/selenider/)
* [selenider CRAN doc](https://cloud.r-project.org/web/packages/selenider/selenider.pdf)
* [selenider and rvest](https://ashbythorpe.github.io/selenider/articles/with-rvest.html)
* [getting started](https://www.selenium.dev/documentation/webdriver/getting_started/first_script/) - although the examples don't include R
* bookmark tool to select elements https://rvest.tidyverse.org/articles/selectorgadget.html


##### Environment block

Copy this somewhere safe and set your variables
Then its read to paste in each time you run

```r
Sys.setenv("BROWSE_LOGIN"="customer.myservice.com//login?local=True")
Sys.setenv("BROWSE_USERNAME"="user@example.com")
Sys.setenv("BROWSE_PASSWORD"="I57RiP{pTLSyF")
Sys.setenv("BROWSE_TESTPAGE"="customer.myservice.com/page/999")

```



```r
# install.packages(c("selenium", "selenider"))
library(selenider)
ide <- function() {
  open_url("https://addons.mozilla.org/en-GB/firefox/addon/selenium-ide/")
}
# Start a selenider session based on selenium-r client only
session <- selenider_session(driver = selenium::SeleniumSession$new())
# this of course depends on having the server already running locally
# it adds deferred events to auto close the session on exit


```

* [selenium vignette](https://ashbythorpe.github.io/selenium-r/articles/selenium.html)
* [CRAN selenium doc](https://cran.r-project.org/web/packages/selenium/selenium.pdf)
* [Appsilion: Webscraping Dynamic Websites with R](https://www.appsilon.com/post/webscraping-dynamic-websites-with-r)

#### Alternatives

With no recent updates to the package, [RSelenium and selenium > 4.8.3](https://github.com/ropensci/RSelenium/issues/280#top) are no longer compatible, hence using `selenium` package. Otherwise if you really want to use RSelenium, [navigate with RSelenium vignette](https://cran.r-project.org/web/packages/RSelenium/vignettes/basics.html#navigating-using-rselenium) and use:

```r
# install.packages("RSelenium")
library(RSelenium)
remDr <- rsDriver(port=4444L)
# This will check and download: 
# * Selenium Server
# * chromedriver 
# * geckodriver 
# * phantomjs 
```

Other Alternatives
* rvest with phantomJS
	* [RBloggers on PhantomJS scraping](https://www.r-bloggers.com/2016/03/web-scraping-javascript-rendered-sites/)
	* [Datacamp: Web Scraping with R and PhantomJS](https://www.datacamp.com/tutorial/scraping-javascript-generated-data-with-r)
* look get the JSON directly by finding the API called by JS:
	* [SO: Avoid PhantomJS by getting the JSON](https://stackoverflow.com/a/60696253)
	* https://stackoverflow.com/a/61196619
* 


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
* See R and tidyverse below


## Anonymisation

There are several different approaches to anonymisation, but one calls for simply inspecting text and either replacing with generic placeholders like name surname, or simply removing the PII altogether. 

TACIT is intended for crawling social media, but it also has direct import, allowing you to use its pre-processing modules. It [does have useful features](https://doi.org/10.3758/s13428-016-0722-4) like stemming (all verb forms to infinitive) and co-currence analysis (which phrases appear together). There are also classifying tools and other advanced analysis features. It is not clear how capable it is of keyword extraction. It is Java-based and [runs as an Eclipse application](https://github.com/USC-CSSL/TACIT/wiki/Quick-Start-Instructions) – clearly not lightweight but it does have a GUI!  

Looked at [CRATE](https://crateanon.readthedocs.io/) (Clinical Records Anonymisation and Text Extraction) the open-source health-industry-led project, but the docker-delivered browser-based database analysis system seemed somewhat overkill for our immediate need. 

TextWash looks like a great fit, so I tried that out. It took quite a bit of installing to discover it is not a very mature product yet, and not fit for our purpose (not without better instructions). It uses conda and at the time of writing relied on almost-end-of-life python v3.8. 

TextClean is a candidate but looks pretty hardcore with its interactive prompt.  This is a collection of R libraries that you can use for all sorts of manipulation, but it does require your to write R code to be interpreted, whether interactively or in a program. See more on R below.

Nltk.org is the Natural Language Tool Kit for python, which obviously requires programming to do anything. And it goes a little bit further than the simple ‘wordfreq’ pyPi package, although that does support 40 languages!

