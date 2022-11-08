#!/bin/bash
( echo "lspci" ; sudo lspci ; echo "" ; echo "uname -a" ; uname -a ; echo "" ; echo "lshw" ; sudo lshw ) > info.txt
cat info.txt | nc termbin.com 9999