
## local search

This is for solutions to index and find files stored locally, 
either on this PC, or in attached or inserted devices, 
or on the local network. 

### requirements

* index content
	* from locally connected device filesystems
* rich doc formats 
	* including html, doc, xls
* quick results
* flexible and configurable

NB: this does NOT cover other OS requirements, 
such as how can I search on Android phone?


### cloud services

Note that the simplest way to include content from your cloud services 
into your local desktop search index, is to syncronise them locally. 
The way to do this depends on each specific cloud service, 
and is NOT within the scope of this document. 
Here we simply assume that the cloud data has been sync'ed locally 
before each time you index your local content. 


## Other Candidates

Recoll, detailed further below, quickly became the prime choice. 
Here is a list of other alternatives...

* Hot contenders
    * Tracker - aka MetaTracker - https://wiki.gnome.org/Projects/Tracker
        * was this old ubuntu default?
    * Cardapio
    * gnome-do - http://do.cooperteam.net/
        * combined launcher with search
    * indicator synapse +1 +1 
        * does it use zeitgeist? Try Virgilio skin http://ubuntuforums.org/showthread.php?t=1880394&page=4
        * http://www.omgubuntu.co.uk/2010/11/synapse-gnome-do-launcher-app-review-ubuntu/
    * catfish
* Front ends
    * Deskbar
    * Sezen
    * Omega (web search interface by Xapian)
* Large systems
    * lucene
        * java-based
    * alfresco
    * solr
    * libferris
        * mount FS (incl fuse) from other data sources
        * incl GDocs
* mentioned
    * Launchy
    * glimpse
    * htdig
    * sphinx
* NOT considered or dropped
    * Unity Dash
        * default Ubuntu 
        * uses Scope search engine with zeitgeist for filesystem
    * zeitgeist
        * activity tracker
* old, NOT maintained
    * Beagle
    * doodle
        * uses libextractor
    * Google desktop
    * strigi
    * pinot

see also [http://en.wikipedia.org/wiki/List_of_search_engines#Desktop_search_engines]


## Recoll

### Introduction

* [http://www.recoll.org/]
* uses Xapian 
    * both under active development
* filesystems only - must export other content to local fs to be indexed 
* requires helpers for some formats
* see instructions at [https://github.com/artmg/lubuild/blob/master/user-apps.bash]
* extensions
	- Recoll Web UI
    * also Omega below provides server-based results search for Xapian

