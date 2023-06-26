#!/bin/bash
echo "Enable backspace"
sudo apt-get install python3-nautilus -y
mkdir -p ~/.local/share/nautilus-python/extensions
cd ~/.local/share/nautilus-python/extensions
wget https://raw.githubusercontent.com/jesusferm/Nautilus-43-BackSpace/main/BackSpace.py
killall nautilus
echo "Completed"
