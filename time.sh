#!/bin/bash
echo "Fix the time on dual boot"
timedatectl set-local-rtc 1 --adjust-system-clock
