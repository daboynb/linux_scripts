#!/bin/bash

# Update the system
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y

# Change the sources.list
text="deb http://deb.debian.org/debian bookworm main contrib non-free-firmware
deb-src http://deb.debian.org/debian bookworm main contrib non-free-firmware

deb http://deb.debian.org/debian-security/ bookworm-security main contrib non-free-firmware
deb-src http://deb.debian.org/debian-security/ bookworm-security main contrib non-free-firmware
 
deb http://deb.debian.org/debian bookworm-updates main contrib non-free-firmware
deb-src http://deb.debian.org/debian bookworm-updates main contrib non-free-firmware"

sudo echo "$text" | sudo tee /etc/apt/sources.list

# Start upgrade
sudo apt-get update
sudo apt upgrade --without-new-pkgs -y
sudo apt full-upgrade -y
