#!/bin/bash
# Ask for sudo privileges
[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

echo "WELCOME TO THE UBUNTU 21.04 AND 21.10 UPGRADE SCRIPT"
echo "If the first fails, try with the second."

# Menu
mainmenu() {
    echo -ne "
1) Upgrade to 22.04 with the official ubuntu method ( old-releases.ubuntu.com )
2) Upgrade to 22.04 replacing the entire sources.list with the jammy repos
3) Upgrade to 22.04 replacing the current distro codename with jammy into the sources.list with sed
0) Exit
Choose an option:  "
    read -r ans
    case $ans in

    1)
        # Detect hirsute, change repos to old-releases.ubuntu.com 
        if cat /etc/apt/sources.list | grep hirsute
        then
            echo "You're on hirsute"
            text="deb http://old-releases.ubuntu.com/ubuntu/ hirsute main restricted universe multiverse
deb http://old-releases.ubuntu.com/ubuntu/ hirsute-updates main restricted universe multiverse
deb http://old-releases.ubuntu.com/ubuntu/ hirsute-security main restricted universe multiverse"
        sudo echo "$text" | sudo tee /etc/apt/sources.list
        fi

        # Detect impish, change repos to old-releases.ubuntu.com 
        if cat /etc/apt/sources.list | grep impish
        then
            echo "You're on impish"
            text="deb http://old-releases.ubuntu.com/ubuntu/ impish main restricted universe multiverse
deb http://old-releases.ubuntu.com/ubuntu/ impish-updates main restricted universe multiverse
deb http://old-releases.ubuntu.com/ubuntu/ impish-security main restricted universe multiverse"
        sudo echo "$text" | sudo tee /etc/apt/sources.list
        fi

        # Prerequisites
        sudo apt-get update
        sudo apt-get install update-manager-core update-manager -y
        sudo apt-get upgrade -y
        sudo apt-get dist-upgrade -y 

        # Download and run the ubuntu upgrade tool
        wget http://archive.ubuntu.com/ubuntu/dists/jammy-updates/main/dist-upgrader-all/current/jammy.tar.gz
        tar -xaf jammy.tar.gz 
        sudo ./jammy --frontend=DistUpgradeViewText
        ;;
    2)
        # Replace sources.list   
        text="deb http://archive.ubuntu.com/ubuntu/ jammy main universe restricted multiverse
deb-src http://archive.ubuntu.com/ubuntu/ jammy main universe restricted multiverse
deb http://security.ubuntu.com/ubuntu jammy-security main universe restricted multiverse
deb-src http://security.ubuntu.com/ubuntu jammy-security main universe restricted multiverse
deb http://archive.ubuntu.com/ubuntu/ jammy-updates main universe restricted multiverse
deb-src http://archive.ubuntu.com/ubuntu/ jammy-updates main universe restricted multiverse"

        sudo echo "$text" | sudo tee /etc/apt/sources.list

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
        ;;
    3)   
        # Detect hirsute and replace codename in the sources.list
        if cat /etc/apt/sources.list | grep hirsute
        then
            echo "You're on hirsute"
            echo "adding jammy repos"
            sudo sed -i 's/hirsute/jammy/g' /etc/apt/sources.list
        fi

        # Detect impish and replace codename in the sources.list
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
