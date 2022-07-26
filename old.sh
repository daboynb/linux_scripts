#!/bin/bash
echo "Restore old network interface names"
sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="/&net.ifnames=0 biosdevname=0 /' /etc/default/grub
sudo update-grub
echo "reboot to apply"