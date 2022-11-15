#!/bin/bash
# Pre requisites
sudo apt update
sudo apt-get install p7zip-full build-essential -y

# Download and install VirtualBox Guest Additions
mkdir /home/"$USER"/VBoxGuestAdditions
cd /home/"$USER"/VBoxGuestAdditions
wget http://download.virtualbox.org/virtualbox/7.0.2/VBoxGuestAdditions_7.0.2.iso
7z x VBoxGuestAdditions*.iso 
chmod +x ./*.run
sudo ./*.run
echo "Done"