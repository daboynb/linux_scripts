#!/bin/bash
echo "Fix Key is stored in legacy trusted.gpg keyring (/etc/apt/trusted.gpg), see the DEPRECATION section in apt-key(8) for details."
cd /etc/apt 
sudo cp trusted.gpg trusted.gpg.d
sudo apt update
echo "Completed"