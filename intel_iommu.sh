#!/bin/bash
echo "Fix iommu errors"
sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="/&intel_iommu=off/' /etc/default/grub
sudo update-grub
echo "reboot to apply"
