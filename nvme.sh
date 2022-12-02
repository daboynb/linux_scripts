#!/bin/bash
echo "This fix the issues with the nvme drives"
sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="/&nvme_core.default_ps_max_latency_us=0 /' /etc/default/grub 
sudo update-grub
echo "Completed"
