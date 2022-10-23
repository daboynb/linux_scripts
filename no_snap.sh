#!/bin/bash
# Tested on 22.04 and 22.10
# Start
sudo apt update

echo "Removing snap...This will take a while"

# Uninstall snap packages
sudo snap remove --purge firefox
sudo snap remove --purge snap-store
sudo snap remove --purge gnome-3-38-2004
sudo snap remove --purge gtk-common-themes
sudo snap remove --purge snapd-desktop-integration
sudo snap remove --purge bare
sudo snap remove --purge core20

# Stop the daemon
sudo systemctl stop snapd && sudo systemctl disable snapd

# Purge snapd
sudo apt purge -y snapd 
sudo apt purge -y gnome-software-plugin-snap 

# Prevent snap from being reinstalled 
printf "Package: snapd\nPin: release a=*\nPin-Priority: -10" >> no-snap.pref 
sudo mv no-snap.pref /etc/apt/preferences.d/
sudo chown root:root /etc/apt/preferences.d/no-snap.pref

# Done
echo "Snap removed"

# Prevent firefox snap from being reinstalled 
echo "Setting firefox preferences"
printf "Package: *\nPin: release o=LP-PPA-mozillateam\nPin-Priority: 1001" >> mozilla-firefox 
sudo mv mozilla-firefox /etc/apt/preferences.d/mozilla-firefox
sudo chown root:root /etc/apt/preferences.d/mozilla-firefox

printf 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' >> 51unattended-upgrades-firefox
sudo mv 51unattended-upgrades-firefox /etc/apt/apt.conf.d/51unattended-upgrades-firefox
sudo chown root:root /etc/apt/apt.conf.d/51unattended-upgrades-firefox

# Install firefox
echo "Installing standard firefox"
sudo add-apt-repository ppa:mozillateam/ppa -y
sudo apt update
sudo apt install firefox -y

echo "Update, clean the system"
# Remove snap folders
rm -rf ~/snap
sudo rm -rf /snap /var/snap /var/lib/snapd /var/cache/snapd /usr/lib/snapd

# Update system
sudo apt update
sudo apt upgrade -y --allow-downgrades
sudo apt dist-upgrade -y
sudo apt autoremove --purge -y

# Install flatpak
echo "Installing flatpak"
sudo apt install flatpak -y
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install gnome-software center
echo "Installing gnome-software center"
sudo apt install gnome-software -y
sudo apt install gnome-software-plugin-flatpak -y

echo "Script completed successfully"

echo "TO APPLY ALL THE CHANGES PLEASE REBOOT"
