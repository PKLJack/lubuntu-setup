#!/usr/bin/bash
# Step - Clean up
# 

set -eux -o pipefail

echo '#########################'
echo '# Clean up'
echo '#########################'

# Reset LVM
lvdisplay -c | cut -d ':' -f 1 | xargs -r lvremove -f # `-f` flag needed
vgdisplay -c | cut -d ':' -f 1 | xargs -r vgremove
pvdisplay --separator=':' --columns --noheadings | cut -d ':' -f 1 | xargs -r pvremove

# Reset devices
wipefs --all /dev/sdb
wipefs --all /dev/sda