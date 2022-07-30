#!/bin/bash

# Dependencies
sudo apt-get install virtualbox-6.1 -y

# Menu
mainmenu() {
    echo -ne "
1) Create keys and import with mok 
2) Sign kernel modules
0) Exit
Choose an option:  "
    read -r ans
    case $ans in

    1)
            openssl req -new -x509 -newkey rsa:2048 -keyout /home/"$USER"/virtualbox.key -outform DER -out /home/"$USER"/virtualbox.der -nodes -days 36500 -subj "/CN=virtualbox"
            sudo mokutil --import /home/"$USER"/virtualbox.der
            read -p "Now when it reboot chose enroll mok --> continue --> yes --> insert the password --> reboot"
            sudo reboot
        ;;
    2)
            text='#!/bin/bash
for modfile in $(dirname $(modinfo -n vboxdrv))/*.ko; do
echo "Signing $modfile"
/usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 \
                                            /home/"$USER"/virtualbox.key \
                                            /home/"$USER"/virtualbox.der "$modfile"
done'
            echo "$text" | tee /home/"$USER"/sign.sh
            chmod 700 /home/"$USER"/sign.sh
            sudo /home/"$USER"/sign.sh
            modprobe vboxdrv
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
