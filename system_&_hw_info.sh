#!/bin/bash
lspci="#############################################################################
lspci
#############################################################################"
uname="
#############################################################################
uname -a
#############################################################################"
lshw="
#############################################################################
lshw
#############################################################################"
source="
#############################################################################
sources.list
#############################################################################"

(echo "$lspci" ; sudo lspci ; echo "$uname" ; uname -a ; echo "$lshw" ; sudo lshw ; echo "$source" ; sudo cat /etc/apt/sources.list) > info.txt
output=$(cat info.txt | nc termbin.com 9999)
clear
echo "[$green+$txtrst] Link to share: $output"