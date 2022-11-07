#TESTING
apt=apt
which $apt > /dev/null 2>&1
if [ $? == 0 ]
then
sudo apt install pastebinit -y
fi

dnf=dnf
which $dnf > /dev/null 2>&1
if [ $? == 0 ]
then
sudo dnf install pastebinit -y
fi

pacman=pacman
which $pacman > /dev/null 2>&1
if [ $? == 0 ]
then
sudo pacman -Syu pastebinit --noconfirm
fi

( sudo lspci ;uname -a ) >info.txt
cat info.txt | nc termbin.com 9999

