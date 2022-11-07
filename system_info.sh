#!/bin/bash
( sudo lspci ;uname -a ) >info.txt
cat info.txt | nc termbin.com 9999