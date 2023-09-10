#!/usr/bin/bash
# Step - LVM
# 

set -eux -o pipefail

echo '#########################'
echo '# LVM Stuff'
echo '#########################'


# Physical Volumes
pvcreate /dev/sdb2 /dev/sda1

#  Volume Groups
vgcreate vg_root /dev/sdb2 /dev/sda1

# Logical Volumes
echo 'VM testing'
lvcreate --yes --size 12GiB --name lv_root vg_root /dev/sdb2
lvcreate --yes --size 8GiB --name lv_home vg_root /dev/sda1
lvcreate --yes --size 10GiB --name lv_var vg_root /dev/sda1

# Make file systems on logical volumes
mkfs.ext4 -q /dev/mapper/vg_root-lv_home
mkfs.ext4 -q /dev/mapper/vg_root-lv_root
mkfs.ext4 -q /dev/mapper/vg_root-lv_var
