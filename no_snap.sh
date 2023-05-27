#!/bin/bash
# Tested on 22.04 and 22.10

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

# Functions
flatpak_only() {
    sudo apt install flatpak -y
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

flatpak_and_software_center() {
    sudo apt install flatpak -y
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    sudo apt install gnome-software -y
    sudo apt install gnome-software-plugin-flatpak -y
}

software_center_only() {
    sudo apt install gnome-software -y
}

# Menu
mainmenu() {
    echo -ne "
1) Install flatpak 
2) Install flatpak and the gnome software center
3) Install the gnome software center without flatpak
0) Exit
Choose an option:  "
    read -r ans
    case $ans in

    1)     
            flatpak_only
        ;;
    2)
            flatpak_and_software_center
        ;;
    3)
            software_center_only
        ;;
    0)      
            echo "Bye bye."
            exit 0
            ;;
    *)
        echo "Wrong option."
        mainmenu
        ;;
    esac
}

mainmenu

echo "Script completed successfully"

echo "TO APPLY ALL THE CHANGES PLEASE REBOOT"
