#!/bin/bash
# sudo check
if [ `whoami` = root ];
then
    echo Please do not run this script as root or using sudo
    return 1 2>/dev/null
    exit 1
fi
# Pre requisites
sudo apt update
sudo apt install p7zip-full build-essential -y

# Download and install VirtualBox Guest Additions
cd /tmp
mkdir VBoxGuestAdditions
wget -P VBoxGuestAdditions http://download.virtualbox.org/virtualbox/7.0.2/VBoxGuestAdditions_7.0.2.iso
7z x VBoxGuestAdditions/VBoxGuestAdditions*.iso -oVBoxGuestAdditions
chmod +x VBoxGuestAdditions/*.run
sudo VBoxGuestAdditions/*.run
rm -rf VBoxGuestAdditions 
sudo adduser "$USER" vboxsf
echo "Done"