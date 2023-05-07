#!/bin/bash

# Check if the package folder exist
if [ -d "/home/$USER/packages" ]  
then
     echo "The /home/$USER/packages folder exist, delete it!"
     exit 1
else
     echo "Let's start"
fi

# Check requirements
sudo dpkg -l | grep -qw makedeb || bash -ci "$(wget -qO - 'https://shlink.makedeb.org/install')"
sudo dpkg -l | grep -qw alien || sudo apt install alien -y
sudo dpkg -l | grep -qw git || sudo apt install git -y

# Create woeusb-ng deb
mkdir /tmp/woeusb && cd /tmp/woeusb || exit 1
git clone 'https://mpr.makedeb.org/woeusb-ng'
cd woeusb-ng/ || exit 1
makedeb 

# Create rpm package
sudo alien -r /tmp/woeusb/woeusb-ng/woeusb-ng*.deb

# Create arch package
git clone https://github.com/Asher256/archalien.git
cd archalien || exit 1
python3 archalien.py /tmp/woeusb/woeusb-ng/woeusb-ng*.deb

# Copy packages
mkdir /home/"$USER"/packages
cp /tmp/woeusb/woeusb-ng/woeusb-ng*.deb /home/"$USER"/packages
cp /tmp/woeusb/woeusb-ng/woeusb-ng*.rpm /home/"$USER"/packages
cp /tmp/woeusb/woeusb-ng/woeusb-ng*.pkg.tar.gz /home/"$USER"/packages

# Del dir
rm -rf /tmp/woeusb

# How to install
echo
echo "To install the deb version use 'sudo apt install /home/$USER/packages/woeusb-ng*.deb'"
echo
echo "To install the arch version use 'sudo rpm -i /home/$USER/packages/woeusb-ng*.rpm"
echo
echo "To install the arch version use 'sudo pacman -U /home/$USER/packages/woeusb-ng*.pkg.tar.gz"