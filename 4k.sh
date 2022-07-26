#!/bin/bash
echo "Make grub bigger"
sudo sed -i 's/#GRUB_GFXMODE="640x480"/GRUB_GFXMODE="640x480"/g' /etc/default/grub
sudo update-grub
echo "reboot to apply"