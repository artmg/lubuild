
This is to set up a Virtual Machine running a different operating system, 
such as Windows, but that has direct access to the power of the video card. 
The most likely use case for this would be games with no Linux port, 
or that do not work with Wine.

see also:
* [https://github.com/artmg/lubuild/blob/master/help/use/games.md]
    * general gaming stuff
* [https://github.com/artmg/lubuild/blob/master/help/diagnose/video-display.md]
    * ancilliary diagnostics around video output devices
* []


## OUT

### VirtualBox

Although VirtualBox is the simplest way to set up VMs, 
it does not yet support GPU Passthrough

For step-by-step instructions to create a Windows Virtual Machine on your PC under Ubuntu using virtualbox see [https://itsfoss.com/install-windows-10-virtualbox-linux/] 
NB: you can just install **virtualbox** with no version specifier


## Introduction

Graphical Processing Unit (GPU) is a common way to refer to a video card, 
containing a specialised processor and memory dedicated to generating lovely images on your screen. 

GPU Passthrough involves dedicating a GPU to a guest virtual machine, 
so the main hosting desktop will not be able to use it. 
Physically the main desktop will be plugged into the onboard graphics controller.

QEMU is used to run virtual machine "guests" on this host desktop
IOMMU is the hardware mapping technology that allows passthrough
VFIO is the PCI passthrough technique recommended with QEMU 

Note that if I was going to do this all over again, I would probably 
choose to use virtlib and virt-manager (maybe qt version) as a nicer front end


### Prepare

If you have previously installed Third Party Video Drivers 
for the GPU you will pass through, you may not need these any more, 
so you should remove these. 
* [https://github.com/artmg/lubuild/blob/master/help/diagnose/video-display.md]


### get the hardware IDs for your GPU

```
lspci | grep VGA
lspci -nn | grep 01:00.
```
You need the PnP IDs from the end of the line 
for both the video and audio devices on the graphics card
e.g. 10de:1c02,10de:10f1,8086:1901 
and also the PCI IDs from the beginning 
e.g. 01:00.0,01:00.1

### turn vt-d on in mobo

* Boot into UEFI menu
* "Intel Virtualisation = Enabled"
* "vt-d = Enabled"

### set up VFIO
```
# credit - https://www.evonide.com/non-root-gpu-passthrough-setup/
# this is simpler than old pci-stub.ids= in grub [https://davidyat.es/2016/09/08/gpu-passthrough/]
sudo editor /etc/modules

vfio
vfio_iommu_type1
vfio_pci
kvm
kvm_intel

sudo editor /etc/modprobe.d/vfio-pci.conf

options vfio-pci ids=
(use ids from above)

### enable in kernel and block ids

sudo editor /etc/default/grub

add to GRUB_CMDLINE_LINUX="" 
intel_iommu=on

sudo update-grub

### Update kernel's copy of files for startup

sudo update-initramfs -u

```

if you get a missing firmware error see 
https://01.org/linuxgraphics/intel-linux-graphics-firmwares


### reboot
```
# check it's enabled
dmesg | grep -e DMAR -e IOMMU
# credit [https://ubuntuforums.org/showthread.php?t=2322179]
# look for line `DMAR: Intel(R) Virtualization Technology for Directed I/O`
# that shows all IOMMU configuration was successful
# credit - [http://vfio.blogspot.co.uk/2016/09/intel-iommu-enabled-it-doesnt-mean-what.html]

find /sys/kernel/iommu_groups/ -type l
# https://ubuntuforums.org/showthread.php?t=2266916

```

### qemu setup

Just used the Ubuntu package for OVMF (VM equivalent of UEFI/bios)
following [https://www.evonide.com/non-root-gpu-passthrough-setup/] 
to install QEMU

#### group not viable

If you get error `vfio: error, group x is not viable, please ensure all devices within the iommu_group are bound to their vfio bus driver` you can check the check the groupings with the code at 
[https://ubuntuforums.org/showthread.php?t=2322179&p=13478605#post13478605]

The simplest solution is to add ALL devices in the IOMMU Group to the VM. 
Otherwise you will need to override the ACS security (as per passthrough setup articles. 

## Post-install

* After you have booted to your Windows installation ISO go through Windows Setup
* As soon as Windows install is complete shutdown and SAVE a copy of your disk image
    * in case you need to come back to this point later

### Windows updates

* Use windows update to get to SP1, two or three reboots
* When updater gets stuck, disable updates and shutdown
* Ensure Windows Update Service (wuauserv) is Stopped / Manual
* Obtain KB3020369 & KB3125574 & KB3172605 & sdelete and place on ISO with Brasero
    * KB 3185278 is Sept 2016 Rollup - not using for now
* After installing each Stop the service again
    * credit http://www.sevenforums.com/windows-updates-activation/400285-new-install-windows-7-checking-updates-doesnt-finish-post3279171.html#post3279171
* Recheck for latest updates, install, reboot - continue until Up To Date
* Clean up restore points, update & SP caches (System / Protection & Disk cleanup)
* sdelete -z to zero unused space ready for shrinking
* Power down VM and qemu-img convert to create a shrunk copy of disk image
You now have a fully updated Windows image to use

Set up autologon with netplwiz # credit https://technet.microsoft.com/en-us/library/ee872306.aspx
grab a copy of your video drivers from vendor site
write onto ISO image using (e.g.) Brasero
Mount this and install vendor drivers into image

### NVidia Error 43

If Device Manager shows error Code 43 on your Nvidia, you are not alone. This Nvidia bug 
is suggested by some to be a way to disuade people from using certain GPUs in VMs, 
because it effectively makes the virtual passthrough configuration unsupported. 

If you have gone through the Windows Update process, the driver auto-installed by Windows 
is from NVidia, so you may notice this issue even if you haven't installed it manually. 


#### QEMU hacks

There is a vendor id hack in QEMU that is supposed to work around this issue, 
by changing the vendor id to _any_ value that the 'bug' is not looking for, for instance:
```
OPTS="$OPTS -cpu host,kvm=off,hv_vendor_id=Nvidia43fix"
# credit https://www.redhat.com/archives/vfio-users/2016-July/msg00099.html
```
If this doesn't work you might also try:
* explicitly including other "don't use hyperv" options
* add the ioh3420 qemu emulation device - credit http://superuser.com/a/854697
    * or maybe the actual PCI bridge device in the iommu group?
* upgrade to the very latest **qemu** version from [qemu.org/Download]
    * and perhaps a more recent kernel?


#### use OVMF uefi instead of BIOS

* The simplest way to use QEMU is in BIOS style. 
* If you installed Windows in BIOS mode rather than UEFI you could convert 
* However there might not be enough Boot Partition space to convert BIOS to UEFI so starting fresh
* Need to add the OVMF_CODE and OVMF_VARS images for pure-efi
* the disk needs creating as a device rather than simple -hda entry 
* use virtio win drivers iso - https://fedoraproject.org/wiki/Windows_Virtio_Drivers#Direct_download
* if your Win ISO is not UEFI ready then at the UEFI shell tab or dir/cd to FS0:\EFI\BOOT\BOOTX64.EFI
* this guide uses libvirt - might that be easier to start? [http://vfio.blogspot.co.uk/2015/05/vfio-gpu-how-to-series-part-4-our-first.html]
* 

"windows is loading files, starting windows, just goes blank"
similar to [http://serverfault.com/questions/776406/windows-7-setup-hangs-at-starting-windows-using-proxmox-4-2]

#### patch nvidia driver install

This was the option that **worked** for me, and stopped me suffering from the Code 43 error.
I tried it on a UEFI image, but it _might_ also work on a bios image. 

* follow the instructions at [https://github.com/sk1080/nvidia-kvm-patcher]
* Uncheck time sync and backdate clock
* AdminCMD: Bcdedit.exe -set TESTSIGNING ON
* AdminPS1: Set-ExecutionPolicy Unrestricted   (then set back to  Restricted )


#### other Code 43 workaround suggestions

https://ubuntuforums.org/showthread.php?t=2335849&page=2
https://forums.linuxmint.com/viewtopic.php?f=231&t=229122
http://vfio.blogspot.co.uk/2014/08/vfiovga-faq.html
https://tekwiki.beylix.co.uk/index.php/VGA_Passthrough_with_UEFI%2BVirt-Manager#Nvidia_code_43_error
http://awilliam.github.io/presentations/KVM-Forum-2016/#/4/2
https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF#.22Error_43_:_Driver_failed_to_load.22_on_Nvidia_GPUs_passed_to_Windows_VMs


## other help

http://superuser.com/questions/1039315/qemu-with-gpu-pass-through-wont-start
https://bufferoverflow.io/gpu-passthrough/
https://ubuntuforums.org/showthread.php?t=2320369
https://scottlinux.com/2016/08/28/gpu-passthrough-with-kvm-and-debian-linux/
https://wiki.debian.org/VGAPassthrough


## Example QEMU scripts

### Qemu-Win7.bios.sh

```
#!/bin/bash
# credit - https://www.evonide.com/non-root-gpu-passthrough-setup/
OPTS="-name Win7-BIOS"
# Basic CPU settings.
OPTS="$OPTS -cpu host,kvm=off"
OPTS="$OPTS -smp 8,sockets=1,cores=4,threads=2"
# Enable KVM full virtualization support.
OPTS="$OPTS -enable-kvm"
# Assign memory to the vm.
OPTS="$OPTS -m 4000"
# VFIO GPU and GPU sound passthrough.
OPTS="$OPTS -device vfio-pci,host=01:00.0,multifunction=on"
OPTS="$OPTS -device vfio-pci,host=01:00.1"

# Load our created VM image as a harddrive.
OPTS="$OPTS -hda $(pwd)/Win7Game.jpgw6.vdi"

# Load our OS setup image e.g. ISO file.
OPTS="$OPTS -boot d -cdrom $HOME/media/W7_x64.iso"

# Use the following emulated video device (use none for disabled).
OPTS="$OPTS -vga qxl"
# Redirect QEMU's console input and output.
OPTS="$OPTS -monitor stdio"
 
sudo qemu-system-x86_64 $OPTS
```

### Qemu-Win7.uefi.sh

```
#!/bin/bash
OPTS="-name jpgw6-w7-uefi"
# Basic CPU settings
OPTS="$OPTS -cpu host,kvm=off,hv_vendor_id=Nvidia43FIX"
#OPTS="$OPTS -cpu host,kvm=off,hv_time,hv_relaxed,hv_vapic,hv_spinlocks=0x1fff,hv_vendor_id=Nvidia43FIX"
OPTS="$OPTS -smp 8,sockets=1,cores=4,threads=2"
# Enable KVM full virtualization support.
OPTS="$OPTS -enable-kvm"
# Assign memory to the vm.
OPTS="$OPTS -m 4000"
# VFIO GPU and GPU sound passthrough.
OPTS="$OPTS -device vfio-pci,host=01:00.0,multifunction=on"
OPTS="$OPTS -device vfio-pci,host=01:00.1"
# OPTS="$OPTS -device vfio-pci,host=00:01.0"

# Supply OVMF (general UEFI bios, needed for EFI boot support with GPT disks).
OPTS="$OPTS -drive if=pflash,format=raw,readonly,file=$(pwd)/ovmf-x64/OVMF_CODE-pure-efi.fd"
OPTS="$OPTS -drive if=pflash,format=raw,file=$(pwd)/OVMF_VARS-pure-efi.jpgw6.fd"

# System drive
OPTS="$OPTS -drive id=disk0,if=none,cache=unsafe,file=$(pwd)/jpgw6.uefi.qcow2"
OPTS="$OPTS -device driver=virtio-scsi-pci,id=scsi0"
OPTS="$OPTS -device scsi-hd,drive=disk0"


# UEFI ISO mounts
#OPTS="$OPTS -drive id=cd0,if=none,format=raw,readonly,file=$HOME/Downloads/W7_x64.iso"
#OPTS="$OPTS -device driver=ide-cd,bus=ide.0,drive=cd0"

#OPTS="$OPTS -drive id=virtiocd,if=none,format=raw,file=$(pwd)/virtio-win-0.1.126.iso"
#OPTS="$OPTS -device driver=ide-cd,bus=ide.1,drive=virtiocd"

#OPTS="$OPTS -drive id=nvidcd,if=none,format=raw,file=$(pwd)/nvidiaDrivers.GTX1060.W7-64.376.33.iso"
#OPTS="$OPTS -device driver=ide-cd,bus=ide.0,drive=nvidcd"

#OPTS="$OPTS -drive id=msddk,if=none,format=raw,file=$HOME/Downloads/GRMWDK_EN_7600_1.ISO"
#OPTS="$OPTS -device driver=ide-cd,bus=ide.1,drive=msddk"

OPTS="$OPTS -drive id=msucd,if=none,format=raw,file=$(pwd)/MS.Win7.UpdatesRollupJuly2016.iso"
OPTS="$OPTS -device driver=ide-cd,bus=ide.0,drive=msucd"


# Use the following emulated video device (use none for disabled).
OPTS="$OPTS -vga qxl"
# Redirect QEMU's console input and output.
OPTS="$OPTS -monitor stdio"
 
sudo qemu-system-x86_64 $OPTS
```