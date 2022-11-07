#!/bin/bash
( sudo lspci ; echo "" ; uname -a ) > info.txt
cat info.txt | nc termbin.com 9999