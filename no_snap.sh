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

    # Check the output of snap list
    if [ -z "$snap_list_output" ]; then
        echo "No snaps left."
        break
    fi

    # Extract the snap names 
    snap_names=($(echo "$snap_list_output" | awk 'NR>1 {print $1}'))

    for snap_name in "${snap_names[@]}"
    do
        sudo killall "$snap_name" >/dev/null 2>&1
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

# Remove snap folders
rm -rf /home/"$USER"/snap
sudo rm -rf /snap /var/snap /var/lib/snapd /var/cache/snapd /usr/lib/snapd

# Update system
sudo apt update
sudo apt upgrade -y --allow-downgrades
sudo apt dist-upgrade -y
sudo apt autoremove --purge -y

# Install brave browser
sudo apt install apt-transport-https curl -y
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg            
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser -y

# Set firefox deb
sudo add-apt-repository ppa:mozillateam/ppa -y
printf "Package: firefox*\nPin: release o=LP-PPA-mozillateam\nPin-Priority: 1000" >> mozilla-firefox 
sudo mv mozilla-firefox /etc/apt/preferences.d/mozillateamppa
sudo chown root:root /etc/apt/preferences.d/mozillateamppa
# uncomment to install ff sudo apt install -t 'o=LP-PPA-mozillateam' firefox

echo "Script completed successfully"

echo "TO APPLY ALL THE CHANGES PLEASE REBOOT"
