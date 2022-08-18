#!/bin/bash

# Dependencies
sudo apt-get install linux-headers-$(uname -r) build-essential libglvnd-dev pkg-config -y

# Add 32-bit libs
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install libc6:i386 -y

# Menu
mainmenu() {
    echo -ne "
1) Create keys and import with mok 
2) Install drivers
0) Exit
Choose an option:  "
    read -r ans
    case $ans in

    1)
            openssl req -new -x509 -newkey rsa:2048 -keyout /home/"$USER"/Nvidia.key -outform DER -out /home/"$USER"/Nvidia.der -nodes -days 36500 -subj "/CN=Graphics Drivers"
            sudo mokutil --import /home/"$USER"/Nvidia.der
            echo options nouveau modeset=0 | sudo tee -a /etc/modprobe.d/nouveau-kms.conf; sudo update-initramfs -u
            read -p "Now, after pressing enter it will reboot; at boot chose enroll mok --> continue --> yes --> insert the password --> reboot"
            sudo reboot
        ;;
    2)
            read -e -p "Drag & drop your Nvidia xxx.run file : " file
            eval file=$file
            echo "$file" | tr -d ''
            chmod +x $file
            sudo $file --module-signing-secret-key=/home/"$USER"/Nvidia.key --module-signing-public-key=/home/"$USER"/Nvidia.der
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
