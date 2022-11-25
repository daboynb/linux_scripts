#!/bin/bash
# Variable with pkexec
dolphin="pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY KDE_SESSION_VERSION=5 KDE_FULL_SESSION=true dolphin"
# Create dolphin.sh
echo "$dolphin" >> /home/"$USER"/.dolphin.sh
chmod +x .dolphin.sh
# Variable for the alias
alias="alias dp="\""/home/$USER/.dolphin.sh"\"""
# Add the alias to .bashrc
echo "$alias" >> /home/"$USER"/.bashrc
# Update .bashrc
source /home/"$USER"/.bashrc
