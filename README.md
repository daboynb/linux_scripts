# No scripts
To fix the time on dual boot:

    timedatectl set-local-rtc 1 --adjust-system-clock && sudo reboot
    
Enable right click button on touchpad (gnome, notebook):

    gsettings set org.gnome.desktop.peripherals.touchpad click-method 'areas'

# Scripts
-------------------------++++++++++++++++++++++++++++++++++++-------------------------
# fw.sh
Enable ufw, set it to deny any incoming connection and install gufw

# grub.sh
Replace Systemd-boot with grub on pop_os

# mac.sh
Script to change your mac address

# old.sh
Restore old network interface names

# non_free
Add the non free repo to Debian bullseye

# 4K.sh
Make grub bigger for 4k screen

# fix_usb.sh
Fix usb not detected or working intermittently 

# nvidia.sh
Create the key for sign the proprietary driver.
Affter running you'll need to:

    - chose enroll mok --> continue --> yes --> insert the password --> reboot
    - download driver from nvidia (nvdiaxxx.run) and then chmod +x nvidia.run
    - run the driver setup, and choose "sign kernel with keys" and put the path of them
    - reboot and run nvidia-smi to see if the drivers are installed correctly
 
# brave.sh
Install brave browser

# swapfile.sh
Create a swapfile and set the swappiness value to 10
