#!/bin/bash

install_arch_linux_dependencies() {
    echo "Installing Arch Linux dependencies..."
    sudo pacman -Syu p7zip python-pip python-wxpython
}

install_debian_dependencies() {
    echo "Installing Debian-based dependencies..."
    sudo apt install git p7zip-full python3-pip python3-wxgtk4.0 grub2-common grub-pc-bin parted dosfstools ntfs-3g
}

install_fedora_dependencies() {
    echo "Installing Fedora-based dependencies..."
    sudo dnf install git p7zip p7zip-plugins python3-pip python3-wxpython4
}

install_woeusb_ng() {
    echo "Cloning WoeUSB-ng repository..."
    git clone https://github.com/WoeUSB/WoeUSB-ng.git
    cd WoeUSB-ng
    sudo pip3 install .
    cd ..
}

if command -v pacman &>/dev/null; then
    echo "Arch Linux"
    install_arch_linux_dependencies
    install_woeusb_ng
elif command -v apt-get &>/dev/null; then
    echo "Debian-based (Debian)"
    install_debian_dependencies
    install_woeusb_ng
elif command -v dnf &>/dev/null; then
    echo "Fedora-based"
    install_fedora_dependencies
    install_woeusb_ng
else
    echo "Unknown"
fi