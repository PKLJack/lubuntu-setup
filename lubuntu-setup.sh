
#########################
# Reset devices
#########################
wipefs --all /dev/sdb
wipefs --all /dev/sda


#########################
# partition table
#########################
parted /dev/sda -- mktable gpt
parted /dev/sdb -- mktable gpt

# parted /dev/sda -- p ; parted /dev/sdb -- p


#########################
# Make partitions
#########################
# HDD
parted /dev/sda -- mkpart 'hdd' ext4 0% 100%

# SSD
parted /dev/sdb -- mkpart 'boot' fat32 1MiB 301MiB
parted /dev/sdb -- mkpart 'root' ext4 301MiB 100%

# parted /dev/sda -- p ; parted /dev/sdb -- p


#########################
# Set flags
#########################

# sda1
parted /dev/sda -- set 1 lvm on

# sdb1
parted /dev/sdb -- set 1 boot on
parted /dev/sdb -- set 1 esp on

# sdb2
parted /dev/sdb -- set 2 lvm on

# parted /dev/sda -- p ; parted /dev/sdb -- p


#########################
# Make file systems
#########################
echo 'Keep /dev/sda1 without file system.'

mkfs.vfat -F 32 /dev/sdb1
# mkfs.ext4 /dev/sdb2

# parted /dev/sdb -- p


#########################
# LVM Stuff
#########################


# Physical Volumnes
pvcreate /dev/sdb2 /dev/sda1

#  Volume Groups
vgcreate vg_root /dev/sdb2 /dev/sda1

# Logical Volumes
echo 'VM testing'
lvcreate --size 12GiB --name lv_root vg_root /dev/sdb2
lvcreate --size 8GiB --name lv_home vg_root /dev/sda1
lvcreate --size 10GiB --name lv_var vg_root /dev/sda1

# Make file systems on logical volumns
mkfs.ext4 /dev/mapper/vg_root-lv_home
mkfs.ext4 /dev/mapper/vg_root-lv_root
mkfs.ext4 /dev/mapper/vg_root-lv_var


#########################
# Finish
#########################
echo 'Done, now move to GUI installer!'
