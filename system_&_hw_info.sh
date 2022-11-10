#!/bin/bash
(printf "LSPCI\n" ; sudo lspci ; printf "\nUNAME -A\n" ; uname -a ; printf "\nLSHW\n" ; sudo lshw ; printf "\nSOURCES.LIST\n" ; sudo cat /etc/apt/sources.list) > info.txt
output=$(cat info.txt | nc termbin.com 9999)
clear
echo "[+] Link to share --> $output"