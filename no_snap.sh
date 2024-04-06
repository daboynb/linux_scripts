#!/bin/bash

# Sudo check
if [ `whoami` = root ];
then
    echo Please do not run this script as root or using sudo
    return 1 2>/dev/null
    exit 1
fi

# Check for dpkg lock
while sudo fuser /var/{lib/{dpkg,apt/lists},cache/apt/archives}/lock >/dev/null 2>&1; do
sleep 1
echo "Waiting... dpkg lock"
done

# Start
sudo apt update

echo "Removing snap...This will take a while"

# Uninstall snap packages
while true; do
    snap_list_output=$(snap list)

    # Check if the output of `snap list
    if [ -z "$snap_list_output" ]; then
        echo "No snaps left."
        break
    fi

    # Extract the snap names 
    snap_names=($(echo "$snap_list_output" | awk 'NR>1 {print $1}'))

    for snap_name in "${snap_names[@]}"
    do
        pgrep -f "$snap_name" >/dev/null 2>&1
        sudo snap remove --purge "$snap_name" >/dev/null 2>&1
    done
done

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

echo "Script completed successfully"

echo "TO APPLY ALL THE CHANGES PLEASE REBOOT"
