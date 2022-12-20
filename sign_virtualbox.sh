#!/bin/bash
# Menu
mainmenu() {
    echo -ne "
1) Create keys and import with mok 
2) Build kernel modules 
0) Exit
Choose an option:  "
    read -r ans
    case $ans in

    1)
            sudo mkdir -p /var/lib/shim-signed/mok
            openssl req -new -x509 -newkey rsa:2048 -keyout /var/lib/shim-signed/mok/virtualbox.priv -outform DER -out /var/lib/shim-signed/mok/virtualbox.der -nodes -days 36500 -subj "/CN=virtualbox/"
            sudo mokutil --import /var/lib/shim-signed/mok/virtualbox.der           
            read -p "Now, after pressing enter it will reboot; at boot chose enroll mok --> continue --> yes --> insert the password --> reboot"
            sudo reboot
        ;;
    2)
            sudo rcvboxdrv setup
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