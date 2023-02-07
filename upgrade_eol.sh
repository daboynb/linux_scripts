#!/bin/bash

# Disable all the external repos
sudo bash -c 'for i in /etc/apt/sources.list.d/*.list; do mv ${i} ${i}.disabled; done'

# Grep codename
codename=$(awk '/UBUNTU_CODENAME=/' /etc/os-release | sed 's/UBUNTU_CODENAME=//' | sed 's/[.]0/./')

# Menu
mainmenu() {
    echo -ne "
1) Upgrade from 12.04 to 14.04 
2) Upgrade from 14.04 to 16.04
3) Upgrade from 16.04 to 18.04
4) Upgrade from 18.04 t0 20.04
5) Upgrade from 20.04 to 22.04
0) Exit
Choose an option:  "
    read -r ans
    case $ans in

    1)
        # Detect precise, change repos to old-releases.ubuntu.com 
        if cat /etc/os-release | grep precise ; then
        echo "You're on precise"
        text="deb http://old-releases.ubuntu.com/ubuntu/ precise main restricted universe multiverse
        deb http://old-releases.ubuntu.com/ubuntu/ precise-updates main restricted universe multiverse
        deb http://old-releases.ubuntu.com/ubuntu/ precise-security main restricted universe multiverse"
        sudo echo "$text" | sudo tee /etc/apt/sources.list
        else
        echo "You are on precise."
        mainmenu
        fi

        # Prerequisites
        sudo apt-get update
        sudo apt-get install update-manager-core update-manager -y
        sudo apt-get upgrade -y
        sudo apt-get dist-upgrade -y 

        # Download and run the ubuntu upgrade tool
        wget http://archive.ubuntu.com/ubuntu/dists/trusty-updates/main/dist-upgrader-all/current/trusty.tar.gz
        tar -xaf trusty.tar.gz 
        sudo ./trusty --frontend=DistUpgradeViewText
        ;;
        
    2)
        # Detect trusty, change repos to old-releases.ubuntu.com 
        if [ $codename == trusty ]; then
        echo "You're on trusty"
        text="deb http://old-releases.ubuntu.com/ubuntu/ $codename main restricted universe multiverse
        deb http://old-releases.ubuntu.com/ubuntu/ $codename-updates main restricted universe multiverse
        deb http://old-releases.ubuntu.com/ubuntu/ $codename-security main restricted universe multiverse"
        sudo echo "$text" | sudo tee /etc/apt/sources.list
        else
        echo "You are on $codename."
        mainmenu
        fi

        # Prerequisites
        sudo apt-get update
        sudo apt-get install update-manager-core update-manager -y
        sudo apt-get upgrade -y
        sudo apt-get dist-upgrade -y 

        # Download and run the ubuntu upgrade tool
        wget http://archive.ubuntu.com/ubuntu/dists/xenial-updates/main/dist-upgrader-all/current/xenial.tar.gz
        tar -xaf xenial.tar.gz 
        sudo ./xenial --frontend=DistUpgradeViewText
        ;;
    
    3)   
        # Detect xenial, change repos to old-releases.ubuntu.com 
        if [ $codename == xenial ]; then
        echo "You're on xenial"
        text="deb http://old-releases.ubuntu.com/ubuntu/ $codename main restricted universe multiverse
        deb http://old-releases.ubuntu.com/ubuntu/ $codename-updates main restricted universe multiverse
        deb http://old-releases.ubuntu.com/ubuntu/ $codename-security main restricted universe multiverse"
        sudo echo "$text" | sudo tee /etc/apt/sources.list
        else
        echo "You are on $codename."
        mainmenu
        fi

        # Prerequisites
        sudo apt-get update
        sudo apt-get install update-manager-core update-manager -y
        sudo apt-get upgrade -y
        sudo apt-get dist-upgrade -y 

        # Download and run the ubuntu upgrade tool
        wget http://archive.ubuntu.com/ubuntu/dists/bionic-updates/main/dist-upgrader-all/current/bionic.tar.gz
        tar -xaf bionic.tar.gz 
        sudo ./bionic --frontend=DistUpgradeViewText
        ;;
    4)      
        # Detect bionic, change repos to old-releases.ubuntu.com 
        if [ $codename == bionic ]; then
        echo "You're on bionic"
        text="deb http://old-releases.ubuntu.com/ubuntu/ $codename main restricted universe multiverse
        deb http://old-releases.ubuntu.com/ubuntu/ $codename-updates main restricted universe multiverse
        deb http://old-releases.ubuntu.com/ubuntu/ $codename-security main restricted universe multiverse"
        sudo echo "$text" | sudo tee /etc/apt/sources.list
        else
        echo "You are on $codename."
        mainmenu
        fi

        # Prerequisites
        sudo apt-get update
        sudo apt-get install update-manager-core update-manager -y
        sudo apt-get upgrade -y
        sudo apt-get dist-upgrade -y 

        # Download and run the ubuntu upgrade tool
        wget http://archive.ubuntu.com/ubuntu/dists/focal-updates/main/dist-upgrader-all/current/focal.tar.gz
        tar -xaf focal.tar.gz 
        sudo ./focal --frontend=DistUpgradeViewText
        ;;
    5)
        # Detect focal, change repos to old-releases.ubuntu.com 
        if [ $codename == focal ]; then
        echo "You're on focal"
        text="deb http://old-releases.ubuntu.com/ubuntu/ $codename main restricted universe multiverse
        deb http://old-releases.ubuntu.com/ubuntu/ $codename-updates main restricted universe multiverse
        deb http://old-releases.ubuntu.com/ubuntu/ $codename-security main restricted universe multiverse"
        sudo echo "$text" | sudo tee /etc/apt/sources.list
        else
        echo "You are on $codename."
        mainmenu
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