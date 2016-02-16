

## Using GitHub ##

### Basics

#### install
```
sudo apt-get install -y git
# no longer require git-core, see - http://askubuntu.com/a/5935
```

#### clone 
```
# Clone a repository to your computer
# This will create a local copy of the source files on your computer
# git clone https://github.com/USERNAME/REPOSITORY.git folder/destination/path
# if omitted the destination folder will be created in the current working directory

# e.g.
git clone https://github.com/artmg/nixnote2-packaging.git
```

### check what has changed

# breif overview
git status

# full details of changes not yet added
git diff

# changes cached but not yet committed
git diff --cached

# difference between local and most recent commit
git diff HEAD


### loading changes back into the git repo ###

#### Caching your GitHub password in Git
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
