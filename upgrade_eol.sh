#!/bin/bash

# Disable all the external repos
cd /etc/apt/sources.list.d && sudo bash -c 'for i in *.list; do mv ${i} ${i}.disabled; done' && cd /tmp

# Grep codename
codename=$(awk '/UBUNTU_CODENAME=/' /etc/os-release | sed 's/UBUNTU_CODENAME=//' | sed 's/[.]0/./')

# Change repos to old-releases.ubuntu.com 
text="deb http://old-releases.ubuntu.com/ubuntu/ $codename main restricted universe multiverse
deb http://old-releases.ubuntu.com/ubuntu/ $codename-updates main restricted universe multiverse
deb http://old-releases.ubuntu.com/ubuntu/ $codename-security main restricted universe multiverse"
sudo echo "$text" | sudo tee /etc/apt/sources.list

# Prerequisites
sudo apt-get update
sudo apt-get install update-manager-core update-manager -y
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y 

# Download and run the ubuntu upgrade tool
wget http://archive.ubuntu.com/ubuntu/dists/$codename-updates/main/dist-upgrader-all/current/$codename.tar.gz
tar -xaf $codename.tar.gz 
sudo ./codename --frontend=DistUpgradeViewText