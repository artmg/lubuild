
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

Graphical Processing Unit (GPU) is a common way to refer to a video card. 

GPU Passthrough involves dedicating a GPU to a guest virtual machine, 
so the main hosting desktop will not be able to use it. 
Physically the main desktop will be plugged into the onboard graphics controller.

QEMU is used to run virtual machine "guests" on this host desktop
IOMMU is the hardware mapping technology that allows passthrough
VFIO is the PCI passthrough technique recommended with QEMU 


### Prepare

If you have previously installed Third Party Video Drivers 
for the GPU you will pass through, you may not need these any more, 
so you should remove these. 


### get the hardware IDs for your GPU

lspci | grep VGA
lspci -nn | grep 01:00.

You need the PnP IDs from the end of the line 
for both the video and audio devices on the graphics card
e.g. 10de:1c02,10de:10f1,8086:1901
and also the PCI IDs from the beginning
e.g. 01:00.0,01:00.1

### turn vt-d on in mobo
"Intel Virtualisation = Enabled"
"vt-d = Enabled"
(was by default)

### set up pci stub

SKIP FOR NOW - use vfio-pci instead
credit - https://davidyat.es/2016/09/08/gpu-passthrough/
sudo editor /etc/initramfs-tools/modules
add 
pci-stub


### set up VFIO

credit - https://www.evonide.com/non-root-gpu-passthrough-setup/
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

NOT pci-stub for now - WAS   intel_iommu=on pci-stub.ids=
followed by the ids from hardware above

### Update kernel's copy of files for startup

sudo update-initramfs -u

if you get a missing firmware error see 
https://01.org/linuxgraphics/intel-linux-graphics-firmwares


### reboot

check it's enabled
dmesg | grep -e DMAR -e IOMMU
# credit [https://ubuntuforums.org/showthread.php?t=2322179]
find /sys/kernel/iommu_groups/ -type l

https://ubuntuforums.org/showthread.php?t=2266916

### qemu setup

Just used the Ubuntu package for OVMF (VM equivalent of UEFI/bios)
following [https://www.evonide.com/non-root-gpu-passthrough-setup/] 
to install QEMU

#### group not viable

If you get error `vfio: error, group x is not viable, please ensure all devices within the iommu_group are bound to their vfio bus driver` you can check the check the groupings with the code at 
[https://ubuntuforums.org/showthread.php?t=2322179&p=13478605#post13478605]

The simplest solution is to add ALL devices in the IOMMU Group to the VM. 
Otherwise you will need to override the ACS security (as per passthrough setup articles. 


## other help

http://superuser.com/questions/1039315/qemu-with-gpu-pass-through-wont-start
https://bufferoverflow.io/gpu-passthrough/
https://ubuntuforums.org/showthread.php?t=2320369
https://scottlinux.com/2016/08/28/gpu-passthrough-with-kvm-and-debian-linux/
https://wiki.debian.org/VGAPassthrough


## Example QEMU script

Qemu-Win7.sh
```
#!/bin/bash
# credit - https://www.evonide.com/non-root-gpu-passthrough-setup/
OPTS=""
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
# OPTS="$OPTS -device vfio-pci,host=00:01.0"

# Supply OVMF (general UEFI bios, needed for EFI boot support with GPT disks).
#OPTS="$OPTS -drive if=pflash,format=raw,readonly,file=$(pwd)/ovmf-x64/OVMF_CODE-pure-efi.fd"
#OPTS="$OPTS -drive if=pflash,format=raw,file=$(pwd)/OVMF_VARS-pure-efi.jpgw6.fd"

# Load our created VM image as a harddrive.
#OPTS="$OPTS -hda $(pwd)/Win7Game.jpgw6.qcow2"
OPTS="$OPTS -hda $(pwd)/Win7Game.jpgw6.vdi"

# Load our OS setup image e.g. ISO file.
OPTS="$OPTS -boot d -cdrom /home/user/media/W7_x64.iso"

# Use the following emulated video device (use none for disabled).
OPTS="$OPTS -vga qxl"
# Redirect QEMU's console input and output.
OPTS="$OPTS -monitor stdio"
 
sudo qemu-system-x86_64 $OPTS
```
