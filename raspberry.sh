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

# Install tmux
sudo apt install tmux -y
echo "set -g terminal-overrides 'xterm*:smcup@:rmcup@'" > .tmux.comf

# Install fail2ban
sudo apt-get install fail2ban -y
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo wget https://raw.githubusercontent.com/daboynb/linux_scripts/main/jail.local -O /etc/fail2ban/jail.local
sudo service fail2ban restart

# Keep the pi updated
update_script="$HOME/update.sh"

create_update_script() {
cat << EOF > ${update_script}
#!/bin/bash

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
EOF
}

create_update_script

chmod +x $update_script
(crontab -l ; echo "0 */6 * * * $HOME/update.sh") | crontab -
sudo systemctl restart cron

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
# https://stackoverflow.com/a/40192494/19680438
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
