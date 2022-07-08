#!/bin/bash
openssl req -new -x509 -newkey rsa:2048 -keyout /home/"$USER"/Nvidia.key -outform DER -out /home/"$USER"/Nvidia.der -nodes -days 36500 -subj "/CN=Graphics Drivers"
sudo mokutil --import /home/"$USER"/Nvidia.der
echo options nouveau modeset=0 | sudo tee -a /etc/modprobe.d/nouveau-kms.conf; sudo update-initramfs -u
sudo reboot
