#!/bin/bash

# Upgrade function
upgrade (){
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get dist-upgrade -y
    sudo apt-get install -f -y
    sudo apt-get autoremove --purge -y
    sudo do-release-upgrade
}

# Check if sudo apt update ran succesfully
apt_update(){
    output=$(sudo apt update 2>&1)
    if grep -q 'Err\|W:' <<< "$output"; then
        echo "sudo apt update failed"
        echo "$output" | grep -E 'Err|W:'
    else
        echo "sudo apt update successful"

    fi
}

# Bypass "An upgrade from 'xxx' to 'xxx' is not supported with this tool" error
sudo sed -i 's/continue/pass/g' /usr/lib/python3/dist-packages/UpdateManager/Core/MetaRelease.py

# Disable all the external repos
if [ -f /etc/apt/sources.list.d/*.list ]  
then
     sudo bash -c 'for i in /etc/apt/sources.list.d/*.list; do mv ${i} ${i}.disabled; done'
else
     echo "Skipping"
fi

# Grep codename
codename=$(awk '/UBUNTU_CODENAME=/' /etc/os-release | sed 's/UBUNTU_CODENAME=//' | sed 's/[.]0/./')

# Set default sources.list
current_release="deb http://archive.ubuntu.com/ubuntu/ $codename main universe restricted multiverse
deb http://security.ubuntu.com/ubuntu $codename-security main universe restricted multiverse
deb http://archive.ubuntu.com/ubuntu/ $codename-updates main universe restricted multiverse"

sudo echo "$current_release" | sudo tee "/etc/apt/sources.list"

# Check the result of the apt_update funciton
check_output=$(apt_update)
if echo "$check_output" | grep -q "sudo apt update successful"; then
    echo "sudo apt update successful"
else
    # Edit sources.list
    old_release="deb http://old-releases.ubuntu.com/ubuntu/ $codename main restricted universe multiverse
    deb http://old-releases.ubuntu.com/ubuntu/ $codename-updates main restricted universe multiverse
    deb http://old-releases.ubuntu.com/ubuntu/ $codename-security main restricted universe multiverse"
    sudo echo "$old_release" | sudo tee /etc/apt/sources.list

    # Check again 
    check_output=$(check)
    if echo "$check_output" | grep -q "sudo apt update successful"; then
        echo "sudo apt update successful"
    else
        echo "Failed to run sudo apt update"
        exit
    fi
fi

upgrade
