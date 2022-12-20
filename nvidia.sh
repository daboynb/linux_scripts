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
            sudo mkdir -p /var/lib/shim-signed/mok 
            openssl req -new -x509 -newkey rsa:2048 -keyout /var/lib/shim-signed/mok/Nvidia.key -outform DER -out /var/lib/shim-signed/mok/Nvidia.der -nodes -days 36500 -subj "/CN=Graphics Drivers"
            sudo mokutil --import /var/lib/shim-signed/mok/Nvidia.der
            echo options nouveau modeset=0 | sudo tee -a /etc/modprobe.d/nouveau-kms.conf; sudo update-initramfs -u
            read -p "Now, after pressing enter it will reboot; at boot chose enroll mok --> continue --> yes --> insert the password --> reboot"
            sudo reboot
        ;;
    2)
            read -e -p "Drag & drop your Nvidia xxx.run file : " file
            eval file="$file"
            chmod +x $file
            sudo $file --module-signing-secret-key=/var/lib/shim-signed/mok/Nvidia.key --module-signing-public-key=/var/lib/shim-signed/mok/Nvidia.der
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