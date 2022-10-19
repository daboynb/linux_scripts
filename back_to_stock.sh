# Detect os codename
codename=$(awk '/UBUNTU_CODENAME=/' /etc/os-release | sed 's/UBUNTU_CODENAME=//' | sed 's/[.]0/./')

# Disale all the external repos
cd /etc/apt/sources.list.d && sudo bash -c 'for i in *.list; do mv ${i} ${i}.disabled; done' && cd /home/"$USER"

# Replace sources.list  
text="deb http://archive.ubuntu.com/ubuntu/ $codename main universe restricted multiverse
deb-src http://archive.ubuntu.com/ubuntu/ $codename main universe restricted multiverse
deb http://security.ubuntu.com/ubuntu $codename-security main universe restricted multiverse
deb-src http://security.ubuntu.com/ubuntu $codename-security main universe restricted multiverse
deb http://archive.ubuntu.com/ubuntu/ $codename-updates main universe restricted multiverse
deb-src http://archive.ubuntu.com/ubuntu/ $codename-updates main universe restricted multiverse"

sudo echo "$text" | sudo tee /etc/apt/sources.list

# Start upgrade
sudo apt-get update
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

echo ""
echo "All inside /etc/apt/sources.list.d is now disabled. Enable ONLY what you need!"
echo ""
echo "Example < sudo mv /etc/apt/sources.list.d/mozillateam-ubuntu-ppa-jammy.list.disabled /etc/apt/sources.list.d/mozillateam-ubuntu-ppa-jammy.list >"
echo ""