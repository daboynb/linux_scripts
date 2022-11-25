#!/bin/bash
# Variable with pkexec
text="pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY KDE_SESSION_VERSION=5 KDE_FULL_SESSION=true dolphin"
# Create dolphin.sh
echo "$text" >> /home/"$USER"/dolphin.sh
chmod +x dolphin.sh
# Variable for the alias
textb="alias dp="\""/home/$USER/dolphin.sh"\"""
# Add the alias to .bashrc
echo "$textb" >> /home/"$USER"/.bashrc
# Update .bashrc
source .bashrc
