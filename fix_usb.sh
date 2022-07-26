#!/bin/bash
echo "Fix usb problems"
sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="/&acpi=force irqpoll /' /etc/default/grub 
sudo update-grub
echo "reboot to apply"