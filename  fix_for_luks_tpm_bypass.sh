#!/bin/bash
echo "Fix from https://pulsesecurity.co.nz/advisories/tpm-luks-bypass"
sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="/&rd.shell=0 rd.emergency=reboot /' /etc/default/grub
sudo update-grub
echo "reboot to apply"