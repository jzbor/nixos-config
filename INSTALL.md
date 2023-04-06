# Manual Installation

## Preparation
Same as with every Linux install:
* make a backup
* grab a live iso and burn it to a stick
* boot the live image

## Networking
Refer to the [NixOS Manual](https://nixos.org/manual/nixos/stable/index.html#sec-installation-manual-networking) if networking is not enabled yet on the live system.

## Partitioning (UEFI) and Formatting
So the layout will look something like this:
1. `512MB` Boot Partition/ESP (`fat32`)
2. `128G - 256G` Root Partition (`ext4`)
3. `remaining space` Home Partition (`ext4 on LUKS` - unlocked via `pam_mount`)

The following instructions should be carried out as root (`sudo -i`).

### Partitioning with `fdisk`
Enter a new parted shell as the root user:
```sh
fdisk /dev/<your-device>
```
Create a new GPT partition table (`o` for MBR layout):
```
g
```
Create the ESP/boot partition:
```
n
1
<Enter>
+512M
```
Create the root partition:
```
n
2
<Enter>
+172G
```
And create the home partition:
```
n
3
<Enter>
<Enter>
```
To make the boot partition bootable we have to change its type:
```
t
1
1
```
Now you can write your changes to the disk:
```
w
```

### Formatting the disks
Format boot partition:
```sh
mkfs.fat -F 32 -n BOOT /dev/<your-partition1>
```
Format root partition:
```sh
mkfs.ext4 -L nixos-root /dev/<your-partition2>
```
Setup home partition with cryptsetup:
```sh
cryptsetup --type luks2 --label crypt0-home luksFormat /dev/<your-partition3>
cryptsetup luksOpen /dev/disk/by-label/HOMECRYPT crypt0
mkfs.ext4 -L HOME /dev/mapper/crypt0
```

## Bootstrapping the NixOS Installation
Mounting the root and boot partitions:
```sh
mount /dev/disk/by-label/nixos-root /mnt
mkdir /mnt/boot
mount /dev/disk/by-label/BOOT /mnt/boot
```

You can now install the flake directly
```sh
nixos-install --impure --flake "github:jzbor/nixos-config#<hostname>
```

If you want to add the hardware config to the repo first you can print it with
```sh
nixos-generate-config --show-hardware-config --root /mnt
```




