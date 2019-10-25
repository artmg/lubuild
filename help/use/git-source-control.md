## Using Git

As you can see, we have loved GitHub.com 
for many years now, but other services are available, 
such as GitLab.com that also allows free Private repos. 
Most of what you will read below goes for any 
git hosting service you might like to use, 
including any internal one you set up and host yourself. 


## Basics

### install

#### cli

```
sudo apt-get install -y git
# no longer require git-core, see - http://askubuntu.com/a/5935
```

#### gui

options for graphical git clients:

* git-cola
    * qt-based
* QGit
    * qt-based
    * minimal install - few dependencies
    * visually helpful
    * need to manually set up actions like merge or push!
* 

```
sudo apt-get install -y git
```
* Settings
	* Working Directory / Diff against Working Dir
	* Commit / Defined in: Local Config
* Actions / New
	* push

### configure

#### ignore certain file patterns

Do not sync file changes if they meet certain pattern criteria 
(e.g. backup files)

```
cat >$HOME/.gitignore_global <<EOF!
#geany backup files
*~
*.*~
#ghostwriter backup files
*.md.backup
EOF!
git config --global core.excludesfile ~/.gitignore_global
```

##### files that never get ignored

It is possible that you had some files (especially hidden ones) 
that found their way into your repo before you git_ignored them. 
They will seem to keep re-appearing, annoyingly, 
despite now being in your gitignore. 

Here's how to get rid of them

```
# banish .DS_Store files that found their way into a repo via a mac
# credit https://stackoverflow.com/a/107921
find . -name .DS_Store -print0 | xargs -0 git rm -f --ignore-unmatch
```


#### Authentication

see [#authentication-options] section below, e.g.

* [#store-personal-access-token]


### clone 

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

Note that you can keep your fork in sync via the GitHub web UI, 
by creating a Pull Request, Switching Bases, and Merging - 
see [https://www.sitepoint.com/quick-tip-sync-your-fork-with-the-original-without-the-cli/] for a very clear guide. 
However this is not a proper rebase, but a merge **commit**, 
and it will leave your repo 'one commit ahead' 
even if it now contains identical code.

To perform a proper rebase instead, then use the command line 
technique explained below.

* First ensure you have a local clone, 
* and have added the upstream remote as above.
* NB: If you have any local changes you want to keep
	- first checkout (-b ?) to retain them
	- see [http://blog.bigbinary.com/2013/09/13/how-to-keep-your-fork-uptodate.html]
	- or [https://www.atlassian.com/git/articles/git-forks-and-upstreams]
* 

```
# credit - https://help.github.com/articles/syncing-a-fork/
# fetch upstream changes into upstream/master
git fetch upstream

# Option 1
#  This will make your fork look just like the upstream
#  but you will have no trace of the fact you did this sync
git rebase upstream/master

# Option 2
#  This is a merge commit just like the one in the webui mentioned above
#  but (will) it keep your own changes intact (?)
#  The merge commit might be a useful way to track who did what when 
#  if you are multiple people working on the same downstream
#
#  check out your fork's master
#git checkout master
#  merge upstream into your fork
#git merge upstream/master

# Option 3
#  not sure how valid this one really is!!
#git pull upstream master


# push these changes into your fork's github repo
git push

```

For more about the difference between rebasing and merging see:

* [https://git-scm.com/book/en/v2/Git-Branching-Rebasing]
* [http://stackoverflow.com/questions/15602037/git-rebase-upstream-master-vs-git-pull-rebase-upstream-master]
* [https://www.atlassian.com/git/tutorials/merging-vs-rebasing]
* 


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

## Authentication options

see also:
* caching your github password (above)

How to avoid keep entering your password to authenticate with GitHub, 
especailly when using scripted git push, 
instead using tokens or certificates or other means to authenticate 

The article [https://git-scm.com/book/en/v2/Git-Tools-Credential-Storage] 
explains two broad methods:
* use SSH transport instead
* use one of the Credential Storage options over HTTP(S) transport


### Using SSH keys

#### Generate

```
SOURCE_HOST=github.com
SOURCE_USER=myuser
SOURCE_DEVICE=myserver
SOURCE_EMAIL=me@users.noreply.github.com

# Generate a new ED25519 SSH key pair
Key_Opts="${KEY_OPTIONS:-"-t ed25519"}"
# Or if your service doesn't support that, override with RSA:
# KEY_OPTIONS="-o -t rsa -b 4096"

KEY_FILE=~/.ssh/id_${SOURCE_HOST}_$SOURCE_USER
# generate without passphrase
ssh-keygen $Key_Opts -f $KEY_FILE -N "" -C "$SOURCE_HOST $SOURCE_EMAIL $SOURCE_DEVICE $SOURCE_USER `date +%y%m%d`"
# the comment is to help you recognise it

# save this in the ssh config file
tee -a ~/.ssh/config << EOF!
Host $SOURCE_HOST
  Preferredauthentications publickey
  IdentityFile $KEY_FILE
EOF!

cat $KEY_FILE.pub


#### Optionally copy key to keyboard

# detect OS
. /etc/os-release
. /etc/*-release
if [ -f "/etc/arch-release" ]; then ID=archarm; fi
if [ "$(uname)" == "Darwin" ]; then ID=macos; fi

case "${ID}" in
  ubuntu|raspbian|archarm)
    # may need to install the 'xclip' package
    xclip -sel clip < $KEY_FILE.pub
    ;;
  macos)
    pbcopy < $KEY_FILE.pub
esac
```

#### Install

* Go into your Account Settings 
* Add a new SSH Key
* Paste this in
* Save

Alternatively you can save this as a per-machine/repo deploy key - see below

#### Test access key

```
# test
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -T git@$SOURCE_HOST
# optionally diagnose
# ssh -vvvT git@$SOURCE_HOST
```

### store Personal Access token

Note that you should guard these tokens as if they were passwords, 
as they allow wide ranging access to your repos. 

* Log into Github web interface
* Generate a new Personal Access Token 
    * [https://github.com/settings/tokens/new]
* Give it a name 
    * you might have different ones for different devices, to cut off any compromises
* Choose a scope
    * for now **repo** is enough (or even **public_repo** ?)
* credit [https://help.github.com/articles/creating-an-access-token-for-command-line-use/] 

```
# paste the token into the editor in the form
# http[s]://<username>:<password>@<userUrl>
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

A deploy key is a more granular kind of SSH key.
If an SSH key is associated with your git account, 
then it will have full permissions over all repos, 
so you might not want to install the private key 
onto devices over which you have less control. 

If you have test or deploy computers you can still
use with the flexibility and security of SSH keys. 
Create a key per computer/cluster that you assign to 
one or more repos with either read or read-write permissions.

You use the same technique above #using-ssh-keys
but then you simple add the public key to the 
Project's Repository Settings

For more see https://developer.github.com/guides/managing-deploy-keys/#deploy-keys


## Workflow examples

### Scenarios

When you are deploying a new service 
linked to source-controlled configuration files 
you are likely to be in one of the following three scenarios: 

Scenario | Narrative | Steps
--- | --- | ---
New Repo | This is the first time I am deploying this service, and I have a bunch of scripts / config file templates to use as a stating point | New, Load, Push
Fork | This is the first time I am deploying this service, and I want to fork an existing repo containing a template configuration | Fork, Clone
Redeploy | I have a repo that works, I am just rebuilding the servers | Clone

### Repo Hosting setup

#### New

If you are creating a new empty repository to load manually: 

* open the repo hosting gui (e.g. github.com)
* ensure you have logged in with an account that has permissions to create a new repo
* Near you account setup you should find an Add New Repository button
* leave empty, for now do not add a ReadMe

#### Fork

If you are creating a new repository based on a pre-existing 'template' repo then it should be as simple as

* open the repo hosting gui (e.g. github.com)
* ensure you have logged in with an account that has permissions to create a new repo
* browse to the other repo you want to use as a template
* use the 'Fork' button

### Prerequisites

#### environment block

here is the block of environment variables describing your scenario

```
SOURCE_HOST=gitlab.com
SOURCE_USER=myuser
SOURCE_DEVICE=myserver
SOURCE_EMAIL=email@me.com
SOURCE_REPO=myrepo
SOURCE_FILEMODE=true
```

* you might pick filemode false if your repo was from a different OS


#### Authentication

If you are simply cloning and pulling from a public repository, 
then you can skip this section. 

If however you need to Push back up to a repo, 
including if your repo is New, 
or your chosen repository is _not_ publicly visible, 
then this is how you ensure that your git source repository 
'recognises and trusts' your new local server instance. 

* we recommend you generate a key per device
	* include the `SOURCE_DEVICE=` in the environment block
* generate and add the key locally
	* Use the code in the `# Using SSH keys` section above
	* up until you output the public key
* Add as Deploy Key
	* Browse to repo's admin page
	* In the Repository Settings
	* Look for Deploy Keys to Add New
	* Paste in the Public Key
	* Perhaps add the last part of the comment into the title/name
	* Choose whether you want read only or read write access
* Test access key
	* use the code in section `# Test access key` above 
* 

_If you are using a private repo, 
you will need the git config user.* options and maybe your key._



#### Git client

```
#### use your package manager to silently install git and dependencies
sudo apt install -y git
```

### Local Actions

#### Clone

If Cloning is all you need, this is the simplest part

```
# This will clone into the CURRENT FOLDER, and assumes its empty
git clone git@$SOURCE_HOST:$SOURCE_USER/$SOURCE_REPO.git .
```

If you need to Push after then you should also...
```
if [[ $SOURCE_DEVICE ]] ; then
  git config user.name $SOURCE_USER-$SOURCE_DEVICE
else 
  git config user.name $SOURCE_USER
fi
git config user.email $SOURCE_EMAIL
```

#### Load

_(would it be clearer to split Load and Connect??)_

* Create the empty folder
* Load it with any templates you need
* connect this folder with the New repo you set up earlier
* you can continue to refine them even after this

```
git init
if [[ $SOURCE_DEVICE ]] ; then
  git config user.name $SOURCE_USER-$SOURCE_DEVICE
else 
  git config user.name $SOURCE_USER
fi
git config user.email $SOURCE_EMAIL
git remote add origin git@$SOURCE_HOST:$SOURCE_USER/$SOURCE_REPO.git
if [[ $SOURCE_FILEMODE ]] ; then
  git config core.fileMode $SOURCE_FILEMODE
fi
```


#### Push

```
git add *
git add .gitignore
git status
git commit -m "New repo from blank or template config"

git push -u origin master
```


### Other actions under development

#### Merge - Work in Progress

```
git branch --set-upstream origin master
git branch --set-upstream-to=origin/<branch> master
git fetch
```

##### alternative Merge method - currently borken

**DON'T DO THIS** It may junk useful changes

```
# or did we do a 
# git pull
# git reset --hard

git reset origin/master  # This is how to spot the local changes

git commit -a -m "Added in latest version of skeleton files"
git push -u origin master

```


