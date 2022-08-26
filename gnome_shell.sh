#!/bin/bash
echo "Enable right click touchpad and the close,minimize,maximize buttons on gnome shell"
gsettings set org.gnome.desktop.peripherals.touchpad click-method 'areas'
gsettings set org.gnome.desktop.wm.preferences button-layout "close,minimize,maximize:"
