#!/bin/bash
# Ask for sudo privileges
[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

# Check requirements
sudo dpkg -l | grep -qw util-linux || sudo apt-get install util-linux -y

# Create swap file and add to fstab 
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo su -c "echo '/swapfile swap swap defaults 0 0' >> /etc/fstab"
sudo sysctl vm.swappiness=10
sudo su -c "echo 'vm.swappiness=10' >> /etc/sysctl.conf"
echo "Completed"
# Swappiness can be set to values between 0 and 100 
# A low value means the kernel will try to avoid swapping as much as possible 
# An higher value instead will make the kernel aggressively try to use swap space