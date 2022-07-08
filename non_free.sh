#!/bin/bash
# Enable non free repo
echo "Adding non-free repo"
text="deb http://deb.debian.org/debian bullseye main contrib non-free
deb-src http://deb.debian.org/debian bullseye main contrib non-free
deb http://deb.debian.org/debian-security/ bullseye-security main contrib non-free
deb-src http://deb.debian.org/debian-security/ bullseye-security main contrib non-free
 
deb http://deb.debian.org/debian bullseye-updates main contrib non-free
deb-src http://deb.debian.org/debian bullseye-updates main contrib non-free"

sudo echo "$text" | sudo tee /etc/apt/sources2.list
sudo apt update 
echo "Completed"
