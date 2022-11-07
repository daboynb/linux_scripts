#TESTING
apt=apt
which $apt > /dev/null 2>&1
if [ $? == 0 ]
then
debian=debian
fi

dnf=dnf
which $dnf > /dev/null 2>&1
if [ $? == 0 ]
then
fedora=fedora
fi

pacman=pacman
which $pacman > /dev/null 2>&1
if [ $? == 0 ]
then
arch=arch
fi

# Debian
if [ $apt == apt ]; then
echo "You're on Debian"
sudo apt install pastebinit -y
fi

# Fedora 
if [ $dnf == dnf ]; then
echo "You're on Fedora"
sudo dnf install pastebinit -y
fi

# Arch
if [ $pacman == pacman ]; then
echo "You're on Fedora"
sudo pacman -S pastebinit --noconfirm
fi

( sudo lspci t ;uname -a ) >info.txt
pastebinit -i info.txt -b http://pastebin.com