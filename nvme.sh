#!/bin/bash
echo "This fix the issues with the new nvme drive"
sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="/&nvme_core.default_ps_max_latency_us=0 acpi=noirq net.ifnames=0 biosdevname=0 quiet /' /etc/default/grub 
sudo update-grub
echo "Completed"
