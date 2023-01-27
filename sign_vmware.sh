#!/bin/bash
# Fix vmmon not found or not loaded
sudo vmware-modconfig --console --install-all 

# Sign modules
sudo mkdir -p /var/lib/shim-signed/mok
openssl req -new -x509 -newkey rsa:2048 -keyout /var/lib/shim-signed/mok/vmware.priv -outform DER -out /var/lib/shim-signed/mok/vmware.der -nodes -days 36500 -subj "/CN=VMware/"
sudo /usr/src/linux-headers-`uname -r`/scripts/sign-file sha256 /var/lib/shim-signed/mok/vmware.priv /var/lib/shim-signed/mok/vmware.der $(modinfo -n vmmon)
sudo /usr/src/linux-headers-`uname -r`/scripts/sign-file sha256 /var/lib/shim-signed/mok/vmware.priv /var/lib/shim-signed/mok/vmware.der $(modinfo -n vmnet)
mokutil --import /var/lib/shim-signed/mok/vmware.der
read -p "Now, after pressing enter it will reboot; at boot chose enroll mok --> continue --> yes --> insert the password --> reboot"
sudo reboot