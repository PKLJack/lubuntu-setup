#!/usr/bin/bash
# Step - Installer workaround
# https://github.com/calamares/calamares/issues/1920
# 

set -eux -o pipefail

echo '#########################'
echo '# Calamares workaround'
echo '#########################'

mkdir -p /mnt/fake-home
mkdir -p /mnt/fake-root
mkdir -p /mnt/fake-var

mount /dev/vg_root/lv_home /mnt/fake-home
mount /dev/vg_root/lv_root /mnt/fake-root
mount /dev/vg_root/lv_var /mnt/fake-var

qterminal -w /mnt/fake-home &
qterminal -w /mnt/fake-root &
qterminal -w /mnt/fake-var &
