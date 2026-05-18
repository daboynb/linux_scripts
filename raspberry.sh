#!/bin/bash

# sudo check
if [ "$(id -u)" -eq 0 ]; then
    echo "Please do not run this script as root or using sudo"
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
echo "set -g terminal-overrides 'xterm*:smcup@:rmcup@'" > .tmux.conf

# Install fail2ban
sudo apt-get update -y
sudo apt-get install -y fail2ban crudini ufw

sudo systemctl enable --now fail2ban

sudo tee /etc/fail2ban/jail.d/sshd.local > /dev/null <<EOF
[sshd]
enabled = true
backend = systemd
maxretry = 3
bantime = 3600
findtime = 600
EOF

sudo systemctl restart fail2ban

sudo fail2ban-client status sshd

# Keep the pi updated
sudo apt update -y
sudo apt install -y unattended-upgrades apt-listchanges

sudo dpkg-reconfigure -f noninteractive unattended-upgrades

sudo tee /etc/apt/apt.conf.d/20auto-upgrades > /dev/null <<EOF
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::AutocleanInterval "7";
EOF

sudo tee /etc/apt/apt.conf.d/50unattended-upgrades > /dev/null <<EOF
Unattended-Upgrade::Origins-Pattern {
        "origin=Debian,codename=\${distro_codename}-security";
};

Unattended-Upgrade::Remove-Unused-Dependencies "true";
Unattended-Upgrade::Automatic-Reboot "false";
EOF

# Install docker
curl -sSL https://get.docker.com | sh
sudo usermod -aG docker $USER

# Portainer
sudo docker pull portainer/portainer-ce:latest
sudo docker run -d -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest

# Step 1: Install Google Authenticator PAM module
sudo apt install libpam-google-authenticator -y

# Step 2: Configure SSH to require 2FA
echo "auth required pam_google_authenticator.so" | sudo tee -a /etc/pam.d/sshd

# Step 3: Update SSHD configuration to enable authentication methods
sudo sed -i 's/^#*KbdInteractiveAuthentication .*/KbdInteractiveAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/^#*PermitRootLogin .*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
sudo sed -i 's/^#*UsePAM .*/UsePAM yes/' /etc/ssh/sshd_config
sudo sed -i 's/^#*PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Step 4: Run Google Authenticator setup for the current user
# Flags match the answers below: time-based, force-write file, disallow reuse,
# do not increase window, enable rate-limit 3/30s.
google-authenticator -t -d -f -r 3 -R 30 -W

# Equivalent interactive answers:
# Make tokens "time-based" (y/n): y
# Update the .google_authenticator file (y/n): y
# Disallow multiple uses (y/n): y
# Increase the original generation time limit (y/n): n
# Enable rate-limiting (y/n): y

# Step 5: Restart SSH service to apply all changes
sudo systemctl restart ssh.service

# Argon case
# curl https://download.argon40.com/argon1.sh | bash
