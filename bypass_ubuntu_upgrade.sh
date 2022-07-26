#!/bin/bash
sudo sed -i 's/continue/pass/g' /usr/lib/python3/dist-packages/UpdateManager/Core/MetaRelease.py
sudo sed -i 's/hirsute/jammy/g' /etc/apt/sources.list
sudo apt-get update
echo "Upgrade distro"
sudo do-release-upgrade
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y
