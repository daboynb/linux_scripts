# check for dpkg lock
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

# Check if flatpak is installed and check for updates
flatpak=flatpak
which $flatpak > /dev/null 2>&1
if [ $? == 0 ]
then
flatpak update -y
fi

# Check if snapd is installed and check for updates
snapd=snapd 
which $snapd > /dev/null 2>&1
if [ $? == 0 ]
then
sudo snap refresh
fi

# Check if fwupd is installed and check for updates
fwupdmgr=fwupdmgr 
which $fwupdmgr > /dev/null 2>&1
if [ $? == 0 ]
then
sudo fwupdmgr refresh
sudo fwupdmgr update -y
fi