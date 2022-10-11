cd /etc/apt/sources.list.d && sudo bash -c 'for i in *.list; do mv ${i} ${i}.disabled; done' && cd /home/"$USER"

 # Replace sources.list change focal to your distro codename 
        text="deb http://archive.ubuntu.com/ubuntu/ focal main universe restricted multiverse
deb-src http://archive.ubuntu.com/ubuntu/ focal main universe restricted multiverse
deb http://security.ubuntu.com/ubuntu focal-security main universe restricted multiverse
deb-src http://security.ubuntu.com/ubuntu focal-security main universe restricted multiverse
deb http://archive.ubuntu.com/ubuntu/ focal-updates main universe restricted multiverse
deb-src http://archive.ubuntu.com/ubuntu/ focal-updates main universe restricted multiverse"

sudo echo "$text" | sudo tee /etc/apt/sources.list

# Start upgrade
sudo apt-get update
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y
