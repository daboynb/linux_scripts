#!/bin/bash
# Tested on 22.04 and 22.10

# Sudo check
if [ `whoami` = root ];
then
    echo Please do not run this script as root or using sudo
    return 1 2>/dev/null
    exit 1
fi

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

# Stop the daemon and disable it
sudo systemctl stop snapd && sudo systemctl disable snapd

# Purge snapd
sudo apt purge snapd -y

# Prevent snap from being reinstalled 
printf "Package: snapd\nPin: release a=*\nPin-Priority: -10" >> no-snap.pref 
sudo mv no-snap.pref /etc/apt/preferences.d/
sudo chown root:root /etc/apt/preferences.d/no-snap.pref

# Done
echo "Snap removed"

# Configure firefox to be installed only from the ppa 
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

echo "Update and clean the system"

# Remove snap folders
rm -rf /home/"$USER"/snap
sudo rm -rf /snap /var/snap /var/lib/snapd /var/cache/snapd /usr/lib/snapd

# Update system
sudo apt update
sudo apt upgrade -y --allow-downgrades
sudo apt dist-upgrade -y
sudo apt autoremove --purge -y

# Variables
flatpak_install="sudo apt install flatpak -y"
flatpak_add_repo="sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo"
gnome_software_install="sudo apt install gnome-software -y"
gnome_software_plugin="sudo apt install gnome-software-plugin-flatpak -y"

# Install flatpak
while [ -z $prompt ];
    do read -p "Install flatpak? (y/n): " choice;
    case "$choice" in
        y|Y ) fp="yes";$flatpak_install;$flatpak_add_repo;break;;
        n|N ) fp="no";echo "skipping";break;;
    esac;
    done;

# Install gnome-software center
if [ $fp == "yes" ]; then
    while [ -z $prompt ];
    do read -p "Install gnome-software-center and flatpak plugin?: (y/n) " choice;
    case "$choice" in
        y|Y ) $gnome_software_install;$gnome_software_plugin;break;;
        n|N ) echo "skipping";break;;
    esac;
    done;
else
    while [ -z $prompt ];
    do read -p "Install gnome software center?: (y/n) " choice;
    case "$choice" in
        y|Y ) $gnome_software_install;break;;
        n|N ) echo "skipping";break;;
    esac;
    done;
fi

echo "Script completed successfully"

echo "TO APPLY ALL THE CHANGES PLEASE REBOOT"