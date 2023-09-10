#!/usr/bin/bash
# Step - Partition
# 

set -eux -o pipefail

echo '#########################'
echo '# partition table'
echo '#########################'
parted --script /dev/sda -- mktable gpt
parted --script /dev/sdb -- mktable gpt

# parted --script /dev/sda -- p ; parted --script /dev/sdb -- p


echo '#########################'
echo '# Make partitions'
echo '#########################'
# HDD
parted --script /dev/sda -- mkpart 'hdd' ext4 0% 100%

# SSD
parted --script /dev/sdb -- mkpart 'boot' fat32 1MiB 301MiB
parted --script /dev/sdb -- mkpart 'root' ext4 301MiB 100%

# parted --script /dev/sda -- p ; parted --script /dev/sdb -- p


echo '#########################'
echo '# Set flags'
echo '#########################'

# sda1
parted --script /dev/sda -- set 1 lvm on

# sdb1
parted --script /dev/sdb -- set 1 boot on
parted --script /dev/sdb -- set 1 esp on

# sdb2
parted --script /dev/sdb -- set 2 lvm on

# parted --script /dev/sda -- p ; parted --script /dev/sdb -- p


echo '#########################'
echo '# Make file systems'
echo '#########################'
echo 'Keep /dev/sda1 without file system.'

mkfs.vfat -F 32 /dev/sdb1
# mkfs.ext4 /dev/sdb2

# parted --script /dev/sdb -- p
