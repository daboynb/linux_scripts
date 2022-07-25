# One line code
To fix the time on dual boot:

    timedatectl set-local-rtc 1 --adjust-system-clock
    
Enable right click button on touchpad (gnome, notebook):

    gsettings set org.gnome.desktop.peripherals.touchpad click-method 'areas'

Make grub bigger (4k screen):

    sudo sed -i 's/#GRUB_GFXMODE="640x480"/GRUB_GFXMODE="640x480"/g' /etc/default/grub' && sudo update-grub

Fix usb problems:

    sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="/&acpi=force irqpoll /' /etc/default/grub && sudo update-grub

Restore old network interface names:

    sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="/&net.ifnames=0 biosdevname=0 /' /etc/default/grub && sudo update-grub


# Scripts

# fw.sh
Enable ufw, set it to deny any incoming connection and install gufw

# grub.sh
Replace Systemd-boot with grub on pop_os

# mac.sh
Script to change your mac address

# non_free
Add the non free repo to Debian bullseye

# nvidia.sh
Create the key for sign the proprietary driver and install. [Install is working on Debian but not in ubuntu]
 
# brave.sh
Install brave browser

# swapfile.sh
Create a swapfile and set the swappiness value to 10

# bypass_ubuntu_upgrade.sh
Bypass error "An upgrade from 'xxx' to 'xxx' is not supported with this tool.". For the releases that reached their eol.

# telemetry_off.sh
Disable ubuntu telemetry. 
