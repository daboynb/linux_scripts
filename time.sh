#!/bin/bash
echo "Fix the time on dual boot"
timedatectl set-local-rtc 1 --adjust-system-clock
echo "reboot to apply and sync the windows clock for the last time"