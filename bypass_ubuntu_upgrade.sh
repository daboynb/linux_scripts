#!/bin/bash
echo "Adding non-free repo"
text="deb http://it.archive.ubuntu.com/ubuntu/ jammy main universe restricted multiverse
deb-src http://it.archive.ubuntu.com/ubuntu/ jammy main universe restricted multiverse

deb http://security.ubuntu.com/ubuntu jammy-security main universe restricted multiverse
deb-src http://security.ubuntu.com/ubuntu jammy-security main universe restricted multiverse

deb http://it.archive.ubuntu.com/ubuntu/ jammy-updates main universe restricted multiverse
deb-src http://it.archive.ubuntu.com/ubuntu/ jammy-updates main universe restricted multiverse"

sudo echo "$text" | sudo tee /etc/apt/sources.list
sudo sed -i 's/continue/pass/g' /usr/lib/python3/dist-packages/UpdateManager/Core/MetaRelease.py
sudo apt-get update
echo "Upgrade distro"
sudo do-release-upgrade
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y
