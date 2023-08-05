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
sudo apt install ufw -y
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22
sudo ufw enable
echo "Completed"

# Install tmux
sudo apt install tmux -y

# Install fail2ban
sudo apt-get install fail2ban -y
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo service fail2ban restart

# Unattended upgrades
sudo apt install unattended-upgrades -y
sudo systemctl enable unattended-upgrades
sudo systemctl start unattended-upgrades

# Configure settings
sudo sed -i 's~^//\(.*"origin=Debian,codename=${distro_codename}-proposed-updates";\)~\1~' /etc/apt/apt.conf.d/50unattended-upgrades
sudo sed -i 's~^//\(.*"origin=Debian,codename=${distro_codename}-updates";\)~\1~' /etc/apt/apt.conf.d/50unattended-upgrades
text="APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::AutocleanInterval "1";"
sudo echo "$text" | sudo tee /etc/apt/apt.conf.d/20auto-upgrades

# Run every 4 hour 
# https://unix.stackexchange.com/a/295471
sudo bash -c 'echo "0 0-23/4 * * * root sleep $(( $RANDOM % 14400 ));PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin unattended-upgrade" >> /etc/cron.d/unattended-upgrade' 

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

# Add tmux session when you log with ssh
SCRIPT_CONTENT=$(cat << 'EOF'
if [[ $- =~ i ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_TTY" ]]; then
  tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux
fi
EOF
)

echo "$SCRIPT_CONTENT" >> "/home/$USER/.bashrc"

# Disable motd
touch "$HOME/.hushlogin"

# Update .bashrc
echo "To apply run this command 👉 'source .bashrc' "
