#!/bin/bash
# sudo check
if [ `whoami` = root ];
then
    echo Please do not run this script as root or using sudo
    return 1 2>/dev/null
    exit 1
fi
# Pre requisites
sudo apt-get install build-essential -y

# Download coreutils
cd /home/"$USER"
wget https://ftp.gnu.org/gnu/coreutils/coreutils-9.1.tar.xz
tar xvJf coreutils-9.1.tar.xz
cd /home/"$USER"/coreutils-9.1

# Download and apply the patch
wget https://raw.githubusercontent.com/jarun/advcpmv/master/advcpmv-0.9-9.1.patch
patch -p1 -i advcpmv-0.9-9.1.patch 
./configure
make

# Save the patched binaries
mkdir /home/"$USER"/patched
cp /home/"$USER"/coreutils-9.1/src/cp /home/"$USER"/patched
cp /home/"$USER"/coreutils-9.1/src/mv /home/"$USER"/patched

# Clean 
cd /home/"$USER"
rm -rf /home/"$USER"/coreutils-9.1
rm /home/"$USER"/coreutils-9.1.tar.xz

# Copy modfied binaries
sudo cp /home/"$USER"/patched/cp /usr/local/bin/cp
sudo cp /home/"$USER"/patched/mv /usr/local/bin/mv

# Alias
echo 'alias cp="/usr/local/bin/cp -g"' >> .bashrc
echo 'alias mv="/usr/local/bin/mv -g"' >> .bashrc
echo "To apply run this command 👉 'source .bashrc' "