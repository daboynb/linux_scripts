echo "Enabling os-prober"
sudo bash -c 'echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub' 
sudo update-grub 
echo "Reboot to apply"
