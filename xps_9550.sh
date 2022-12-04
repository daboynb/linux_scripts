#!/bin/bash
echo "Fix the dell xps 9550 issues after replacing the ssd to a nvme"
sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="/&nvme_core.default_ps_max_latency_us=0 net.ifnames=0 biosdevname=0 quiet intremap=no_x2apic_optout /' /etc/default/grub
sudo update-grub
echo "reboot to apply"
