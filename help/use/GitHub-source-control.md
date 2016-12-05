


## Using GitHub ##


### Basics

#### install

##### cli

```
sudo apt-get install -y git
# no longer require git-core, see - http://askubuntu.com/a/5935
```

##### gui

options for graphical git clients:

* git-cola
    * qt-based
* QGit
    * qt-based
    * minimal install - few dependencies
    * visually helpful
    * need to manually set up actions like merge or push!
* 



#### clone 

```
# Clone a repository to your computer
# This will create a local copy of the source files on your computer
# git clone https://github.com/USERNAME/REPOSITORY.git folder/destination/path
# if omitted the destination folder will be created in the current working directory

# e.g.
git clone https://github.com/artmg/nixnote2-packaging.git


### check what has changed

# breif overview
git status

# full details of changes not yet added
git diff

# changes cached but not yet committed
git diff --cached

# difference between local and most recent commit
git diff HEAD

# check multiple local folders
# credit http://stackoverflow.com/a/12495234
find . -mindepth 1 -maxdepth 1 -type d -print -exec git -C "{}" status \;

```


### loading changes back into the git repo ###

#### Caching your GitHub password in Git

as an alternative to this, see Authentication below

```
# If you're cloning GitHub repositories using HTTPS and git v>=1.7.10
# credit - https://help.github.com/articles/caching-your-github-password-in-git/

# Set git to use the credential memory cache
git config --global credential.helper cache

# Set the cache to timeout after 1 hour (setting is in seconds) instead of default 15 mins
git config --global credential.helper 'cache --timeout=3600'

git config --global user.email "artmg@users.noreply.github.com"
```


#### sync recent changes

```
# add new files
git add .

# commit
git commit

git push

# credit [commiting to git from linux command-line](http://blog.udacity.com/2015/06/a-beginners-git-github-tutorial.html)
```


#### refresh all local folders from master

```
# credit http://stackoverflow.com/a/12495234
find . -mindepth 1 -maxdepth 1 -type d -print -exec git -C "{}" pull \;
```


### working with upstream

#### add upstream remote

If you have forked a repo, then first you should declare it in your local repo as the upstream remote:

```
# credit https://help.github.com/articles/configuring-a-remote-for-a-fork/
# check the existing remotes
git remote -v

# add the upstream remote
git remote add upstream https://github.com/ORIGINAL_OWNER/ORIGINAL_REPOSITORY.git

# verify the new upstream remote
git remote -v 
```

#### sync your fork

providing you have already added the upstream remote you can 

```
# credit - https://help.github.com/articles/syncing-a-fork/
# fetch upstream changes into upstream/master
git fetch upstream

# check out your fork's master
git checkout master

# merge upstream into your fork
git merge upstream/master

# push these changes into your fork's github repo
git push

```

### editing GitHub wiki locally ###

```
# install Gollum (Github's wiki service) locally... 
# credit - https://github.com/gollum/gollum/wiki/Installation
# prereqs
sudo apt-get install ruby1.9.1 ruby1.9.1-dev make zlib1g-dev libicu-dev build-essential git
# the main package
sudo gem install gollum
# language addins
sudo gem install github-markdown
sudo gem install wikicloth
# help - https://github.com/gollum/gollum


# start the service
# e.g. credit - http://theoryl1.wordpress.com/2013/09/11/gollum-on-ubuntulinux-mint/
# which also suggests how to create upstart auto service
mkdir ~/Wiki
cd ~/Wiki
git init
gollum .

# open browser to the local server
x-www-browser http://localhost:4567/
```

## Authentication

see also:
* caching your github password (above)

How to avoid keep entering your password to authenticate with GitHub, 
especailly when using scripted git push, 
instead using tokens or certificates or other means to authenticate 

The article [https://git-scm.com/book/en/v2/Git-Tools-Credential-Storage] 
explains two broad methods:
* use SSH transport instead
* use one of the Credential Storage options over HTTP(S) transport


### stored Personal Access token

Note that you should guard these tokens as if they were passwords, 
as they allow wide ranging access to your repos. 



* Generate a new Personal Access Token 
    * [https://github.com/settings/tokens/new]
* Give it a name 
    * you might have different ones for different devices, to cut off any compromises
* Choose a scope
    * for now **repo** is enough (or even **public_repo** ?)
* credit [https://help.github.com/articles/creating-an-access-token-for-command-line-use/] 

```
# paste the token into the editor in the form
# http[s]://<username>:<password>@<host>
# (so username goes before domain)
editor ~/.git-personal-access-token


# now include that credential helper
git config --global credential.helper 'store --file ~/.git-personal-access-token'

# and do email if you have not already
git config --global user.email "artmg@users.noreply.github.com"
```
Now all your local git access should include these credentials automatically

Periodically review the tokens you have at [https://github.com/settings/tokens]

#### other

see also:
* [http://superuser.com/a/683651]
    * switching between HTTPS and SSL methods of access
* 


### deploy keys

[https://developer.github.com/guides/managing-deploy-keys/#deploy-keys]

can be set up per repo


