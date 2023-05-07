#!/bin/bash

install_arch_linux_dependencies() {
    printf "\n\n============\nInstalling Arch Linux dependencies...\n============\n\n"
    sudo pacman -S "$1" "$2" "$3" --noconfirm
    check_installation_status 1
}

install_debian_dependencies() {
    printf "\n\n============\nInstalling Debian-based dependencies...\n============\n\n"
    sudo apt install -y git p7zip-full python3-pip python3-wxgtk4.0 grub2-common grub-pc-bin parted dosfstools ntfs-3g
    check_installation_status 1
}

install_fedora_dependencies() {
    printf "\n\n============\nInstalling Fedora-based dependencies...\n\n"
    sudo dnf install -y git p7zip p7zip-plugins python3-pip python3-wxpython4
    check_installation_status 1
}

install_woeusb_ng() {
    if check_installation_status 0; then
        if [ -d "/tmp/woeusb" ]; then
            sudo rm -rf /tmp/woeusb
        fi

        if command -v pacman && ! check_arch_dependencies "$@"; then
            exit 1
        fi
        printf "\n\n============\nCloning WoeUSB-ng repository...\n============\n\n"
        mkdir /tmp/woeusb && cd /tmp/woeusb || exit 1
        git clone https://github.com/WoeUSB/WoeUSB-ng.git
        cd WoeUSB-ng || exit 1
        sudo pip3 install .
        cd ../.. || exit 1
        sudo rm -rf /tmp/woeusb

    fi
}

check_arch_dependencies() {
    flag=true;
    dep=[]
    for dependency in "$@"; do 
        if ! pacman -Q "$dependency" > /dev/null 2>&1; then
            flag=false;
            dep+=$dependency
        fi
    done

    if $flag; then
        printf "\nall dependencies are satisfied\n"
        return 0;
    else 
        printf "\nWARNING: the dependencies : %s aren't satisfied, please install them\n" "${dep[*]}"
        exit 1
    fi
}

check_installation_status() {
    if [ $? -eq 0 ]; then
        if [ $1 -eq 1 ]; then
            echo "Installation successful."
        fi
        return 0
    else
        if [ "$1" -eq 1 ]; then
            echo "FAILED: Installation failed."
        fi
        exit 1
    fi

}

dependencies=("p7zip" "python-pip" "python-wxpython")
if command -v pacman &>/dev/null; then
    echo "Arch Linux"
    install_arch_linux_dependencies "${dependencies[@]}"
elif command -v apt-get &>/dev/null; then
    echo "Debian-based (Debian)"
    install_debian_dependencies
elif command -v dnf &>/dev/null; then
    echo "Fedora-based"
    install_fedora_dependencies
else
    echo "Unknown"
    exit 1
fi

install_woeusb_ng "${dependencies[@]}"
