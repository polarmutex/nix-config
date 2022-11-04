# PolarMutex Nix Config

## ZFS Setup

Based on [bhougland18](https://github.com/bhougland18/nixos_config)
Based on [openzfs docs for nixos](https://openzfs.github.io/openzfs-docs/Getting%20Started/NixOS/Root%20on%20ZFS/1-preparation.html)

* Assuming single disk install

### Step 1: Delete existing partitions and start with a clean state
command: list devices
```bash
lsblk
```
command: wipe partitions
```bash
sgdisk --zap-all /dev/sda
```
You should get a nice terminal output that reads "GPT data structures destroyed! You may now partition the disk using fdisk or other utilities."

### Step 2: Setup Partitions

Okay, now we need to setup the partitions using the by-id aliases for devices.

Issue this command to find the disk on your system. We want to find Id of /dev/sda (or whatever your disk is):
command: list the devices with the ID
```bash
ls -l /dev/disk/by-id/
```
command : create $DISK variable
```bash
DISK=/dev/disk/by-id/{disk to install on}
```

Just like when we created the blank partition table, we are going to use the linux program sgdisk to help us with creating our paritions. More information can be found [here](https://fedoramagazine.org/managing-partitions-with-sgdisk/).

Caution: ZFS on Linux has issues when you place the swap mount within the ZFS partition, so the instrustions below will create a dedicated swap partition.

Before you follow the steps below you should probably calculate the amount of space you are going to need for the swap partition. My machine has 16GB of memory so I am going with 20GB. In order to calculate your swap you can refer to this [article](https://itsfoss.com/swap-size/).

#### Configuring EFI

command : create partitions, each line is a command.
```bash
sgdisk -n 0:0:+1GiB -t 0:EF00 -c 0:boot $DISK
sgdisk -n 0:0:+20GiB -t 0:8200 -c 0:swap $DISK
sgdisk -n 0:0:0 -t 0:BF01 -c 0:ZFS $DISK
```
* Partition 1 will be the EFI boot partition.
* Partition 2 will be the swap partition.
* Partition 3 will be the main ZFS partition, using up the remaining space on the drive.

To make the next steps easier to understand lets again make some variables:
command : create each variable, each line is a command.
```bash
BOOT=$DISK-part1
SWAP=$DISK-part2
ZFS=$DISK-part3
```

### Step 3: Configuring ZFS

Below is the basic structure we will be creating. Notice than the ZFS pools and datasets are all contained within the disk we labeled as ZFS . We will have a home data set that we will snapshot and a nixos dataset that we will not snapshot as Nixos does a good job at keeping that information in sync and it isn’t necessary to backup.
TODO: MAke Diagram

#### Create ZFS pool
```bash
zpool create \
    -o ashift=12 \
    -o autotrim=on \
    -R /mnt \
    -O acltype=posixacl \
    -O canmount=off \
    -O compression=zstd \
    -O dnodesize=auto \
    -O normalization=formD \
    -O relatime=on \
    -O xattr=sa \
    -O mountpoint=/ \
    rpool \
    $ZFS
```

#### Create ZFS datasets
Create root system container:
```bash
zfs create \
 -o canmount=off \
 -o mountpoint=none \
 rpool/nixos
```
Create system datasets:
```bash
zfs create -o canmount=on -o mountpoint=/     rpool/nixos/root
zfs create -o canmount=on -o mountpoint=/home rpool/nixos/home
zfs create -o canmount=off -o mountpoint=/var  rpool/nixos/var
zfs create -o canmount=on  rpool/nixos/var/lib
zfs create -o canmount=on  rpool/nixos/var/log
zfs create -o refreservation=1G -o mountpoint=none rpool/reserved
zfs set com.sun:auto-snapshot=true <pool>/<fs>
```

#### Mount filesystems
* / should already be mounted

command : mount the boot partition. Each line is a command.
```bash
mkfs.vfat $BOOT
mkdir /mnt/boot
mount $BOOT /mnt/boot
```

command : make swap
```bash
mkswap -L swap $SWAP
```

### Step 4: configure NIXOS
command: generate nixos config files
```bash
nixos-generate-config  --root /mnt
```
Import ZFS-specific configuration:
```bash
sed -i "s|./hardware-configuration.nix|./hardware-configuration.nix ./zfs.nix|g" /mnt/etc/nixos/configuration.nix
```
Configure hostid:
```bash
tee -a /mnt/etc/nixos/zfs.nix <<EOF
{ config, pkgs, ... }:

{ boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "$(head -c 8 /etc/machine-id)";
  #boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
EOF
```
Mount datasets with zfsutil option:
```bash
sed -i 's|fsType = "zfs";|fsType = "zfs"; options = [ "zfsutil" "X-mount.mkdir" ];|g' \
/mnt/etc/nixos/hardware-configuration.nix
```
Set root password:
```bash
rootPwd=$(mkpasswd -m SHA-512 -s)
polarPwd=$(mkpasswd -m SHA-512 -s)
```
Declare password in configuration:
```bash
tee -a /mnt/etc/nixos/zfs.nix <<EOF
users.users.root.initialHashedPassword = "${rootPwd}";
users.users.polar = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    initialHashedPassword = "${polarPwd}";
};
services.openssh.enable = true;
environment.systemPackages = with pkgs; [
vim
];
nix.settings = {
    allowed-users = ["@wheel"];
    trusted-users = ["@wheel"];
};
security.sudo.wheelNeedsPassword = false;
}
EOF
```
Install system and apply configuration:
```bash
nixos-install -v --show-trace --no-root-passwd --root /mnt
```

need to copy my ssh key






## nix-direnv

```bash
echo "use flake" >> .envrc && direnv allow
```

## Docs
[nix mvp](https://gist.github.com/edolstra/40da6e3a4d4ee8fd019395365e0772e7)

## TODO
### Polarvortex
[fail2ban](https://github.com/Icy-Thought/Snowflake/blob/main/modules/services/fail2ban.nixhttps://github.com/Icy-Thought/Snowflake/blob/main/modules/services/fail2ban.nix)

Took inspiration from the following:

- [wiltaylor](https://github.com/wiltaylor/dotfiles)
- [pinpox](https://github.com/pinpox/nixos)
- [DieracDelta](https://github.com/DieracDelta/flakes)
- [Gerschtli](https://github.com/Gerschtli/nix-config)
- [Misterio77](https://github.com/Misterio77/nix-config)
- [davidtwco](https://github.com/davidtwco/veritas)
- [fufexan](https://github.com/fufexan/dotfiles)

## setup work

### redhat
    - install base os
    - create my user
    - turn off selinux "sudo vim /etc/selinux/config"
    - reboot
    - install nix "sh <(curl -L https://nixos.org/nix/install) --daemon"
    - generate ssh key for github
    - clone nix-config
    - mkdir ~/.config/nix
    - vim ~/.config/nix/nix.conf  "experimental-features = nix-command flakes"
    - nix develop
    - install wezterm from centor 8
    - make work_redhat
