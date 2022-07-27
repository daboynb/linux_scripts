#!/bin/bash
# Repo added --> main, restricted, universe, multiverse. Normal updates and security ones.
# Change mirror as you like, http://us.archive will be http://your_country_mirror.archive
echo "Adding jammy repo"
text="deb http://archive.ubuntu.com/ubuntu/ jammy main universe
deb http://archive.ubuntu.com/ubuntu/ jammy-updates main universe
deb http://security.ubuntu.com/ubuntu jammy-security main universe"

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
