#!/bin/bash
# Add grub background image
echo "make a backup of/boot/grub/grub.cfg"
sucp cp /boot/grub/grub.cfg /boot/grub/grub.cfg.bak
echo "Insert an image inside /boot/grub and name it splash0.png"
read -p "Press enter when you have done"
if [ -f /boot/grub/splash0.png ]  
 then
    echo "splash0.png detected"
 else
    echo "splash0.png is not present"
    break
 fi
sudo sed -i "s@/usr/share/desktop-base/homeworld-theme/grub/grub-4x3.png@/grub/splash0.png@g" /boot/grub/grub.cfg
sudo update-grub
echo "done"
