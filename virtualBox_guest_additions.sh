#!/bin/bash
# Pre requisites
sudo apt update
sudo apt install p7zip-full build-essential -y

# Download and install VirtualBox Guest Additions
mkdir VBoxGuestAdditions
wget -P VBoxGuestAdditions http://download.virtualbox.org/virtualbox/7.0.2/VBoxGuestAdditions_7.0.2.iso
7z x VBoxGuestAdditions/VBoxGuestAdditions*.iso -oVBoxGuestAdditions
chmod +x VBoxGuestAdditions/*.run
sudo VBoxGuestAdditions/*.run
rm -rf VBoxGuestAdditions 
sudo adduser "$USER" vboxsf
echo "Done"