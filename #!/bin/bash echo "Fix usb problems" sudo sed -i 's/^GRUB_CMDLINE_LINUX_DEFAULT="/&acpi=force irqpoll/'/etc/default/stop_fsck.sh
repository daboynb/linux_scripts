#!/bin/bash
echo "Stop disk checking at boot"
sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="/&fsck.mode=skip /' /etc/default/grub 
sudo update-grub
echo "reboot to apply"
