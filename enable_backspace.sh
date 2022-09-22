#Enable backspace
sudo apt-get install python3-nautilus -y
mkdir -p ~/.local/share/nautilus-python/extensions
cd ~/.local/share/nautilus-python/extensions
wget https://raw.githubusercontent.com/riclc/nautilus_backspace/master/BackspaceBack.py
killall nautilus
