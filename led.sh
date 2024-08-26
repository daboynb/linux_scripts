#!/bin/bash

while true; do
    # Check the led status and activate if necessary
    for i in /sys/class/leds/*scrolllock; do
        if [ "$(cat $i/brightness)" -eq "0" ]; then
            echo 1 > $i/brightness
        fi
    done

    # Check the led status and activate if necessary
    for i in /sys/class/leds/*capslock; do
        if [ "$(cat $i/brightness)" -eq "0" ]; then
            echo 1 > $i/brightness
        fi
    done

    # Sleep
    sleep 0.1
done
