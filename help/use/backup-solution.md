# Backup solution

Synchronising your documents to the cloud is a convenient way 
to have them 'always there', but this is not always a 
secure and bulletproof way to guarantee hanging onto your vital data. 

Whether its accidental deletion, or malicious malware destruction, 
you would be well advised to assure that your most 
important documents are safeguarded by backup. 
It might not hurt to keep your configuration details and settings 
backed up, to ensure you can recover quickly in the case of 
disk failure, device loss, or other serious issue.

This article focusses on open source solutions for linux-like systems. 

See also:
* [macUP / disks and data #time-machine-backup](https://github.com/artmg/macUP/blob/main/disks_and_data.md#time-machine-backup)
	* the built-in Time Machine solution available on Apple macOS
	* how to [use linux samba to host a Time Machine share](https://github.com/artmg/macUP/blob/main/disks_and_data.md#offer-a-linux-samba-share)
* 

## Candidates

By searching for Time Machine style backup or alternatives for Linux, 
you find the following names cropping up

* [Borg Backup](https://www.borgbackup.org/)
	* Supported on Linux, macOS, BSD, ...
		* Windows can use it via its Linux Subsystem
	* Compressed encrypted backups
	* Can back up just changed chunks in larger files
	* that can be mounted with FUSE
	* store to local, ssh, sftp, S3, ...
	* front-ends include: Vorg, Vorta, Borgmatic
	* does not rely on, nor is it improved by, using filesystem journaling 
* Restic
	* often mentioned in comparisons with borg
	* in some ways less efficient than borg (but in others more)
	* Windows supported by its Go language client
	* deduplication between mutliple source devices makes it well suited to multi-machine use cases, especially server estates
* Kopia.io
	* some people suggest this is the sweetspot between borg and restic - compressed AND dedpued between machines
* [Cronopete](https://gitlab.com/rastersoft/cronopete)
	* mature
	* uses vala with meson/ninja
	* 
* Deja Dup
	* might lack restartability
* systemback
	* allows multiple restore points
* [Backintime](https://github.com/bit-team/backintime)
	* python code to rsync via sshfs
	* mature project
* backup-manager
	* in the repos, and self-contained
	* is this related to Duplicity ?
* 

Disk snapshotting (like the COW snapshot management in Apple's Time Machine)

Rather than focussing 'full backup solution' use cases, this is more about rolling back (recent?) change

* snapper on btrfs
	* does this rely on btrbk?
* incremental snapshot on zfs
* Timeshift
	* third party FOSS software to achieve similar goals

Simple Rsync incremental backups:

* [laurent22/rsync-time-backup](https://github.com/laurent22/rsync-time-backup)
* [Cytopia Linux Time Machine](https://github.com/cytopia/linux-timemachine)
* rdiff-backup

With some of these, especially the simpler, 
you might need to control the throttling yourself, 
to prevent the backup consuming your resouces 
whilst you're trying to work.

Use nice and ionice

Other mentions:

* kup
* KBackup
* 

for more leads see:

* https://alternativeto.net/software/time-machine/?platform=linux
* https://news.ycombinator.com/item?id=22674187
* 



