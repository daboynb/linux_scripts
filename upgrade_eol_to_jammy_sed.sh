#!/bin/bash

# Ask for sudo privileges
[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

# Upgrade 21.04 or 21.10 to 22.04

# Detect hirsute
if cat /etc/apt/sources.list | grep hirsute
then
    echo "You're on hirsute"
    echo "adding jammy repos"
    sudo sed -i 's/hirsute/jammy/g' /etc/apt/sources.list
fi

# Detect impish
if cat /etc/apt/sources.list | grep impish
then
    echo "You're on impish"
    echo "adding jammy repos"
    sudo sed -i 's/impish/jammy/g' /etc/apt/sources.list
fi

# Bypass "An upgrade from 'xxx' to 'xxx' is not supported with this tool" error
sudo sed -i 's/continue/pass/g' /usr/lib/python3/dist-packages/UpdateManager/Core/MetaRelease.py

# Start upgrade
sudo apt-get update
sudo do-release-upgrade
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y
