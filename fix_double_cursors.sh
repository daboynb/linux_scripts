#!/bin/bash
lid_state=$(cat /proc/acpi/button/lid/LID0/state | awk '{print $2}')
if [ "$lid_state" = "closed" ]; then
    xinput disable "DLL06E4:01 06CB:7A13 Touchpad"
    xinput disable "USB OPTICAL MOUSE"
    xinput enable "USB OPTICAL MOUSE"
else
    xinput enable "DLL06E4:01 06CB:7A13 Touchpad"
fi
