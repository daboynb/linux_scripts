#!/bin/bash
# List disks and partitions
sudo fdisk -l

# Ask for root partition name
read -r -p "Enter root partition (example /dev/sdax): " root

# Mount root
sudo mount $root /mnt

# Ask for /boot partition
read -p "Do you have the /boot partition ? <y/N> " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
    read -r -p "Enter boot partition (example /dev/sdax): " boot
    sudo mount $boot /mnt/boot
else
  echo "skipping"
fi

# Ask for /efi partition
read -p "Do you have the /efi partition ? <y/N> " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
    read -r -p "Enter efi partition (example /dev/sdax): " efi
    sudo mount $efi /mnt/boot/efi
else
  echo "skipping"
fi

sudo mount --bind /dev /mnt/dev &&
sudo mount --bind /dev/pts /mnt/dev/pts &&
sudo mount --bind /proc /mnt/proc &&
sudo mount --bind /sys /mnt/sys &&
sudo mount --bind /run /mnt/run

# Ask for disk name
read -r -p "Enter the disk name without the partitions number (example /dev/sdx): " disk

# Chroot
sudo chroot /mnt /bin/bash -c "sudo grub-install $disk"
sudo chroot /mnt /bin/bash -c "sudo update-grub"

# Unmount
sudo umount -l /mnt/sys &&
sudo umount -l /mnt/proc &&
sudo umount -l /mnt/dev/pts &&
sudo umount -l /mnt/dev &&
sudo umount -l /mnt/run &&
sudo umount -l /mnt
echo "Completed"
