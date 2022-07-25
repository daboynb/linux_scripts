#!/bin/bash
echo "Enable firewall and install a gui"
sudo apt install ufw gufw -y
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
