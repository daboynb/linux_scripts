#!/bin/bash
# Ask for sudo privileges
[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

# Fix vmmon not found or not loaded
sudo vmware-modconfig --console --install-all 

# Sign modules
openssl req -new -x509 -newkey rsa:2048 -keyout MOK.priv -outform DER -out MOK.der -nodes -days 36500 -subj "/CN=VMware/"
sudo /usr/src/linux-headers-`uname -r`/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n vmmon)
sudo /usr/src/linux-headers-`uname -r`/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n vmnet)
mokutil --import MOK.der
read -p "Now, after pressing enter it will reboot; at boot chose enroll mok --> continue --> yes --> insert the password --> reboot"
sudo reboot