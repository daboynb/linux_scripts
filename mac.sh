#!/bin/bash

# Ask for sudo privileges
[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

# Dependencies
sudo dpkg -l | grep -qw net-tools || sudo apt install net-tools -y

# Menu
mainmenu() {
    echo -ne "
1) Random mac 
2) Custom mac
0) Exit
Choose an option:  "
    read -r ans
    case $ans in

    1)
            # Stop network-manager
            sudo systemctl stop NetworkManager.service
            # Ifconfig
            sudo ifconfig
            # Ask for input
            read -r -p "Enter interface name: " netinterface
            sudo ifconfig "$netinterface" down
            sudo macchanger -r "$netinterface"
            sudo ifconfig "$netinterface" up 
            # Stop network-manager
            sudo systemctl start NetworkManager.service
        ;;
    2)
            # Stop network-manager
            sudo systemctl stop NetworkManager.service
            # Ifconfig
            sudo ifconfig
            # Ask for input
            read -r -p "Enter interface name: " netinterface
            read -r -p "Enter custom mac (ex. b2:aa:0e:56:ed:f7) : " custom
            sudo ifconfig "$netinterface" down
            sudo macchanger -m "$custom" "$netinterface"
            sudo ifconfig "$netinterface" up 
            # Stop network-manager
            sudo systemctl start NetworkManager.service
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
