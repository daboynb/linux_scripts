sudo snap remove firefox

printf "Package: *\nPin: release o=LP-PPA-mozillateam\nPin-Priority: 1001" >> mozilla-firefox
sudo mv mozilla-firefox /etc/apt/preferences.d/mozilla-firefox
sudo chown root:root /etc/apt/preferences.d/mozilla-firefox

printf 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' >> 51unattended-upgrades-firefox
sudo mv 51unattended-upgrades-firefox /etc/apt/apt.conf.d/51unattended-upgrades-firefox
sudo chown root:root /etc/apt/apt.conf.d/51unattended-upgrades-firefox

sudo add-apt-repository ppa:mozillateam/ppa -y
sudo apt update
sudo apt install firefox -y
