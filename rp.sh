#!/bin/bash

# sudo check
if [ `whoami` = root ];
then
    echo Please do not run this script as root or using sudo
    return 1 2>/dev/null
    exit 1
fi

# Check for dpkg lock
while sudo fuser /var/{lib/{dpkg,apt/lists},cache/apt/archives}/lock >/dev/null 2>&1; do
sleep 1
echo "Waiting... dpkg lock"
done

# Start the system upgrade
echo "Updating system"
sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt autoremove --purge -y

# Enable firewall and allow only port 22
echo "Enable firewall"
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22
sudo ufw enable
echo "Completed"

# Add logo and infos when you log with ssh
SCRIPT_CONTENT=$(cat << 'EOF'
echo "$(tput setaf 2)
       ..   ..
      '. \ ' ' / .'
       .~ .~~~..~.    $(tput sgr0)                   _                          _ $(tput setaf 1)
      : .~.'~'.~. :   $(tput sgr0)   ___ ___ ___ ___| |_ ___ ___ ___ _ _    ___|_|$(tput setaf 1)
     ~ (   ) (   ) ~  $(tput sgr0)  |  _| .'|_ -| . | . | -_|  _|  _| | |  | . | |$(tput setaf 1)
    ( : '~'.~.'~' : ) $(tput sgr0)  |_| |__,|___|  _|___|___|_| |_| |_  |  |  _|_|$(tput setaf 1)
     ~ .~ (   ) ~. ~  $(tput sgr0)              |_|                 |___|  |_|    $(tput setaf 1)
      (  : '~' :  )
       '~ .~~~. ~'
           '~'
$(tput sgr0)"
echo ""
free_storage=$(df -h / | awk '{print $4}' | tail -n 1)
echo "$(tput setaf 4)Free Storage: ${free_storage} $(tput sgr0)"
used_mem=$(free -m | awk '/^Mem:/ {print $3}')
total_mem=$(free -m | awk '/^Mem:/ {print $2}')
echo "$(tput setaf 4)RAM Usage: Used: ${used_mem} MB / Free: $((total_mem - used_mem)) MB / Total: ${total_mem} MB$(tput sgr0)"
EOF
)

echo "$SCRIPT_CONTENT" >> "/home/$USER/.bashrc"

# Disable motd
touch "$HOME/.hushlogin"