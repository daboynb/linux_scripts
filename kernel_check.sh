#!/bin/bash
# Display the latest kernel installed
ls -v /boot/vmlinuz-* | tail -n 1 > text 
# Remove some words from the output
sed -i "s/boot\|vmlinuz-*//g" text > /dev/null 2>&1
sed -i 's|/||g' text > /dev/null 2>&1
installed_kernel=$(cat text)
# Check current installed kernel
current=$(uname -r)
# Assign variables
echo latest installed kernel : $installed_kernel
echo current installed kernel : $current
# Check if the kernel is the same or not
if [ $installed_kernel = $current ]; then
    echo "You have the latest kernel already installed"
else
  echo "You need to reboot to apply the new kernel"
fi
rm text
