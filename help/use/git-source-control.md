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

If you'd rather a GUI to peruse your files before commit, manage your branches and manipulate your repos then consider:

* Gittyup
	* Replaced the defunct GitAhead
	* cross-platform, open source, c++/qt graphical client
	* available via many linux repos and mac brew
		* cannot find windows choco package!
	* previously from a commercial developer, now open-sourced
* Visual Studio Code
	* the elephant in the room has a built in git client
	* the electron-based IDE is available on most OSs and in many populare package managers
	* considering how feature rich it is, it is relatively lightwieght 
	* there is also a 'no install' version at https://vscode.dev.
	* very rich ecosystem of plugins covering all sorts of code, test and execution technologies
	* since Microsoft open-sourced this slimmed-down brother to its commercial product and distributed it freely it has marched on to be probably the most widely used IDE overall
* GitKraken
	* Freemium cross-platform client
* Github Desktop
	* the official client on Windows and macOS
	* written for the Electron framework (a NodeJS runtime rendered by Chrome):
 the unofficial linux fork of 
* ShiftKey Git Desktop
	* the unofficial linux fork of official electron client
	* https://github.com/shiftkey/desktop
* git-cola
    * qt-based
* QGit
    * qt-based
    * minimal install - few dependencies
    * visually helpful
    * need to manually set up actions like merge or push!
    * eg: 
        * Settings
            * Working Directory / Diff against Working Dir
            * Commit / Defined in: Local Config
        * Actions / New
            * push
* LazyGit
	* terminal UI based on gocui
	* open source and cross platform

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


#### for Authentication see

see [#authentication-options] section below, e.g.

* [#store-personal-access-token]


### clone 

```
# Clone a repository to your computer
# This will create a local copy of the source files on your computer
# git clone https://github.com/USERNAME/REPOSITORY.git folder/destination/path
# if omitted the destination folder will be created in the current working directory

# e.g.
git clone https://github.com/artmg/lubuild.git

# NB: as an alternative you may want to use SSH not HTTPS
# git clone git@github.com:artmg/lubuild.git 
# check Authentication options below for details 


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

see section below in workflow examples

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

This applies to remotes that have been cloned 
using HTTPS not SSH, for instance 
`git@github.com:artmg/lubuild.git` rather than 

#### Generate
Use your Ubuntu or macOS terminal, however `zsh` might not like the syntax, so run ` sh ` or ` bash ` first.

Define your authentication variables in a block like this
```
SOURCE_HOST=github.com
SOURCE_USER=myuser
SOURCE_DEVICE=myserver
SOURCE_EMAIL=me@users.noreply.github.com
```
then copy and paste this code 
```
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

If you get `unknown key type ed25519` on macOS, and you have already installed `openssh` ([macUP Terminal GNU utils](https://github.com/artmg/macUP/blob/main/terminal.md#gnu-utils)) then do remember to run the code above in a sh or bash shell, not zsh.

##### Multiple accounts for same host

If you need to log in with different identities to the same source host, e.g. you have two different gitlab accounts, it is easy if the subdomains are different. If they are the same, you can still have two different apparent ssh hosts pointing to the same service. E.g. 

* main account
	* set ` SOURCE_HOST=gitlab.com `
	* set your other variables
	* follow the commands above
* secondary account
	* set ` SOURCE_HOST=gitlab.com-purpose `
		* the ` -purpose ` on the end is what differentiates them
	* set your other variables
	* follow the commands above
* now check your ~/.ssh/config

```
Host gitlab.com
  Preferredauthentications publickey
  IdentityFile ~/.ssh/id_gitlab.com_user

Host gitlab.com-purpose
  Preferredauthentications publickey
  IdentityFile ~/.ssh/id_gitlab.com-purpose_user
  HostName gitlab.com
  User git
```

* you will need to manually add those extra **HostName** and **User** entries at the end
* now to use that account for a repo you need to specify `-purpose` on the ssh address
* e.g.
	* ` git clone git@gitlab.com-purpose:user/repo.git `
	* or ` git remote add origin git@gitlab.com-purpose:user/repo.git `

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

##### failure to use SSH key

If these tests pass successfully, but 
you continue to get errors when pushing (etc), 
it may be because you cloned the repo over HTTPS not SSH. 
You can change this back to SSH using 

```shell
git config remote.origin.url git@github.com:artmg/lubuild.git
```

* credit [switching between HTTPS and SSL methods of access](http://superuser.com/a/683651)

alternatively
```sh
git remote set-url origin  git@github.com:artmg/lubuild.git
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

# optionally for forked repos
SOURCE_UPSTREAM_USER=myteam
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

```
git config --local user.name $SOURCE_USER
git config --local user.email $SOURCE_EMAIL
git config --local user.email $SOURCE_EMAIL
```

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

If you are using a clone for testing code on your repo, 
you may need to switch branches for different tests - 
see [Switching Branches](#switch-branches) below

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


#### Config backup

If you want to snapshot the current git configs, both globally and for your individual repositories, try the following code

**gitCheckAllConfigs.bash**
```bash
#!/bin/bash

# credit various answers to https://stackoverflow.com/q/3497123

OutFile="${PWD}/gitAllConfigs.txt"

echo "### git configs - GLOBAL" >${OutFile}
git config --global --list >>${OutFile}

find . \
    -maxdepth 2 -type d \
    -name ".git" \
    -execdir echo "" >>${OutFile} \; \
    -execdir echo -n "### " >>${OutFile} \; \
    -execdir pwd >>${OutFile} \; \
    -execdir git config --local --list >>${OutFile} \;
```

This assumes that your repos are all under the current working directory

### Other actions under development


#### Check the current status

If you have forgotten what state your local repo is in...

```
git status
git remote -v
git branch -vv
# git branch -av
```

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

# now get all the upstream branches
git fetch upstream
```

#### Switch branches

```
git status
# clear local changes
git stash
# if prevented then bin them manually
git checkout -- <filename(s)>
git status

git fetch
git checkout <branchname>

#git branch -u origin/<branchname> # this should be automatically done by the checkout
git branch -vv
git branch -av
```


#### Changelog

To find out what you need to add to CHANGELOG use

```
git log --oneline
```

#### Ready to release

```
# sync your dev with the upstream dev
git checkout dev
git fetch upstream
git merge upstream/dev
```

* Edit CHANGELOG to reflect actual version (remove `-beta` etc)

```
RELEASE_VERSION=YYYY.M.D
git commit -a -m "set version to ${RELEASE_VERSION} in CHANGELOG ready for release"
git tag -a v${RELEASE_VERSION} -m "v${RELEASE_VERSION} release with major change"
git push origin v${RELEASE_VERSION}
git push origin
git push --tags upstream
```

If you get errors when pushing upstream, check [failure to use SSH key](#failure%20to%20use%20SSH%20key)

##### Post-release Cleanup

Bring your origin up to upstream

```
git fetch upstream
git checkout master
git merge upstream/master
git push
git checkout dev
```

Delete any dev branches

```
git branch --delete mydevsubbranch
```

#### sync your fork

This is useful for team development on a fork. 
If you are working solo you may just want to 
refresh your fork, loosing all your changes – see [Hard Reset](#hard-reset-to-upstream).

Update: There is now a Fetch Upstream button in the Github web UI 
to Fetch and Merge Fast-forward, bringing your fork's current branch 
into line with the same branch on the upstream repo. 

You can do the same from your local using the [CLI instructions](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/syncing-a-fork#syncing-a-fork-branch-from-the-command-line)

```sh
git fetch upstream
# this will show any new branches
git checkout master
git merge upstream/master
git push

# automatically track any new upstream branchs
git checkout new-branch-name
```

##### Old Notes

: that you can keep your fork in sync via the GitHub web UI, 
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

...or see the 4th option, [Hard Reset](#hard-reset-to-upstream) below

For more about the difference between rebasing and merging see:

* [https://git-scm.com/book/en/v2/Git-Branching-Rebasing]
* [http://stackoverflow.com/questions/15602037/git-rebase-upstream-master-vs-git-pull-rebase-upstream-master]
* [https://www.atlassian.com/git/tutorials/merging-vs-rebasing]
* 


#### Merge - Work in Progress

```
git branch --set-upstream origin master
git branch --set-upstream-to=origin/<branch> master
git fetch
```

##### old notes on alternative Merge method

**DON'T DO THIS** It may junk useful changes

```
# or did we do a 
# git pull
# git reset --hard

git reset origin/master  # This is how to spot the local changes

git commit -a -m "Added in latest version of skeleton files"
git push -u origin master

```

#### Putting dev back on par with master

If you have a develop branch, but some commits have been sent directly to master, how can you get develop back up to date for further use?

```shell
# get all commits on all branches as 'origin/branch'
git fetch origin
# switch to your local master
git checkout master
# bring in the upstream changes
git merge --ff-only origin/master

# make sure this is the name of your develop branch
# we specify the origin in case other branches have that name (e.g. upstream)
git checkout --track origin/dev


# and bring in the changes needed
git merge origin/master

# credit https://stackoverflow.com/a/20103414
# check there for details on the FF switches


# once you are happy that the changes went ok, 
# push them up to your remote
git push
```


#### Hard reset to upstream

This will remove any changes in your forked branch, 
and make it even with the upstream master
but you will have no trace that this was done.


```
# Check the current status
git status
git remote -v
# if the upstream remote is not yet defined, then add it
# git remote add upstream https://github.com/ORIGINAL_OWNER/ORIGINAL_REPOSITORY.git

git branch -vv
# git branch -av

git fetch upstream

# trash this branch locally and revert to upstream
git checkout master
git reset --hard  upstream/master
git push origin --force

# or perhaps on a different branch
git checkout develop
git reset --hard  upstream/develop
git push origin --force

```


#### Switch clone to fork

You may have cloned a repo onto a proof of concept server to try out. Once you realise it needs some tweaks 
you fork it and make your modifications in development.

Now, how do you make your PoC instance use your fork instead?


```
# this might be simpler but not sure it does all that is needed
# git remote set-url origin https://github.com/$SOURCE_USER/$SOURCE_REPO.git

# what is below might not be working yet, so try the above

git remote rename origin upstream
git branch -avv # check so see links now go to upstream


git remote add origin https://github.com/$SOURCE_USER/$SOURCE_REPO.git
#git remote add origin git@$SOURCE_HOST:$SOURCE_USER/$SOURCE_REPO.git
git remote -v # see both now

git checkout origin/master
```


#### test a PR in isolation

If someone has submitted a Pull Request, 
you may want to perform tests on that 
in isolation from your main cloned repos.
Where xxx is the PR number...

Option 1: git-extras

```
git pr https://github.com/user_name/repo_name/pull/xxx
```

Option 2: standard git

```
git clone https://github.com/user_name/repo_name.git --depth 1 TestFolderName
cd TestFolderName
git pull origin pull/xxx/head
```

Unfortunately at v 2.31 you cannot pull a PR branch in clone using -b pull/xxx/head

