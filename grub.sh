#!/bin/bash
echo "Replace Systemd-boot with grub on pop_os"
sudo apt install grub-efi -y
sudo grub-install   
sudo cp /boot/grub/x86_64-efi/grub.efi /boot/efi/EFI/pop/grubx64.efi
sudo bootctl remove
sudo bash -c 'echo "GRUB_TIMEOUT=10" >> /etc/default/grub'
sudo update-grub
