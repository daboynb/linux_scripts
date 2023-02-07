#!/bin/bash

# Disable all the external repos
if [ -f /etc/apt/sources.list.d/*.list ]  
then
     echo ""
else
sudo bash -c 'for i in /etc/apt/sources.list.d/*.list; do mv ${i} ${i}.disabled; done'
fi

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
        # precise, change repos 
        text="deb http://old-releases.ubuntu.com/ubuntu/ precise main restricted universe multiverse
        deb http://old-releases.ubuntu.com/ubuntu/ precise-updates main restricted universe multiverse
        deb http://old-releases.ubuntu.com/ubuntu/ precise-security main restricted universe multiverse"
        sudo echo "$text" | sudo tee /etc/apt/sources.list

        # Prerequisites
        sudo apt-get update
        sudo apt-get install update-manager-core update-manager -y
        sudo apt-get upgrade -y
        sudo apt-get dist-upgrade -y 

        # Download and run the ubuntu upgrade tool
        mkdir trusty
        cd trusty
        wget http://archive.ubuntu.com/ubuntu/dists/trusty-updates/main/dist-upgrader-all/current/trusty.tar.gz
        tar -xaf trusty.tar.gz 
        sudo ./trusty --frontend=DistUpgradeViewText
        ;;
        
    2)
        # trusty, change repos 
        text="deb http://archive.ubuntu.com/ubuntu/ trusty main universe restricted multiverse
        deb-src http://archive.ubuntu.com/ubuntu/ trusty main universe restricted multiverse
        deb http://security.ubuntu.com/ubuntu trusty-security main universe restricted multiverse
        deb-src http://security.ubuntu.com/ubuntu trusty-security main universe restricted multiverse
        deb http://archive.ubuntu.com/ubuntu/ trusty-updates main universe restricted multiverse
        deb-src http://archive.ubuntu.com/ubuntu/ trusty-updates main universe restricted multiverse"
        sudo echo "$text" | sudo tee /etc/apt/sources.list

        # Prerequisites
        sudo apt-get update
        sudo apt-get install update-manager-core update-manager -y
        sudo apt-get upgrade -y
        sudo apt-get dist-upgrade -y 

        # Download and run the ubuntu upgrade tool
        mkdir xenial
        cd xenial
        wget http://archive.ubuntu.com/ubuntu/dists/xenial-updates/main/dist-upgrader-all/current/xenial.tar.gz
        tar -xaf xenial.tar.gz 
        sudo ./xenial --frontend=DistUpgradeViewText
        ;;
    
    3)   
        # xenial, change repos 
        text="deb http://archive.ubuntu.com/ubuntu/ xenial main universe restricted multiverse
        deb-src http://archive.ubuntu.com/ubuntu/ xenial main universe restricted multiverse
        deb http://security.ubuntu.com/ubuntu xenial-security main universe restricted multiverse
        deb-src http://security.ubuntu.com/ubuntu xenial-security main universe restricted multiverse
        deb http://archive.ubuntu.com/ubuntu/ xenial-updates main universe restricted multiverse
        deb-src http://archive.ubuntu.com/ubuntu/ xenial-updates main universe restricted multiverse"
        sudo echo "$text" | sudo tee /etc/apt/sources.list

        # Prerequisites
        sudo apt-get update
        sudo apt-get install update-manager-core update-manager -y
        sudo apt-get upgrade -y
        sudo apt-get dist-upgrade -y 

        # Download and run the ubuntu upgrade tool
        mkdir bionic
        cd bionic
        wget http://archive.ubuntu.com/ubuntu/dists/bionic-updates/main/dist-upgrader-all/current/bionic.tar.gz
        tar -xaf bionic.tar.gz 
        sudo ./bionic --frontend=DistUpgradeViewText
        ;;
    4)      
        # bionic, change repos 
        text="deb http://archive.ubuntu.com/ubuntu/ bionic main universe restricted multiverse
        deb-src http://archive.ubuntu.com/ubuntu/ bionic main universe restricted multiverse
        deb http://security.ubuntu.com/ubuntu bionic-security main universe restricted multiverse
        deb-src http://security.ubuntu.com/ubuntu bionic-security main universe restricted multiverse
        deb http://archive.ubuntu.com/ubuntu/ bionic-updates main universe restricted multiverse
        deb-src http://archive.ubuntu.com/ubuntu/ bionic-updates main universe restricted multiverse"
        sudo echo "$text" | sudo tee /etc/apt/sources.list

        # Prerequisites
        sudo apt-get update
        sudo apt-get install update-manager-core update-manager -y
        sudo apt-get upgrade -y
        sudo apt-get dist-upgrade -y 

        # Download and run the ubuntu upgrade tool
        mkdir focal
        cd focal
        wget http://archive.ubuntu.com/ubuntu/dists/focal-updates/main/dist-upgrader-all/current/focal.tar.gz
        tar -xaf focal.tar.gz 
        sudo ./focal --frontend=DistUpgradeViewText
        ;;
    5)
        # focal, change repos 
        text="deb http://archive.ubuntu.com/ubuntu/ focal main universe restricted multiverse
        deb-src http://archive.ubuntu.com/ubuntu/ focal main universe restricted multiverse
        deb http://security.ubuntu.com/ubuntu focal-security main universe restricted multiverse
        deb-src http://security.ubuntu.com/ubuntu focal-security main universe restricted multiverse
        deb http://archive.ubuntu.com/ubuntu/ focal-updates main universe restricted multiverse
        deb-src http://archive.ubuntu.com/ubuntu/ focal-updates main universe restricted multiversee"
        sudo echo "$text" | sudo tee /etc/apt/sources.list

        # Prerequisites
        sudo apt-get update
        sudo apt-get install update-manager-core update-manager -y
        sudo apt-get upgrade -y
        sudo apt-get dist-upgrade -y 

        # Download and run the ubuntu upgrade tool
        mkdir jammy
        cd jammy
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