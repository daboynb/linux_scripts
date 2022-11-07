#!/bin/bash
# Variable
text="button.titlebutton {
  min-height: 24px;
  min-width: 24px;
  padding: 0;
}

button.titlebutton.close {
  background-color: @error_color;
  color: white;
}

button.titlebutton.maximize {
  background-color: @warning_color;
  color: white;
}

button.titlebutton.minimize {
  background-color: green;
  color: white;
}

button.titlebutton.minimize:hover {
  background-color: lime;
  color: white;
}"

# Check if .config exist
if [ -d  /home/"$USER"/.config ]  
then
    echo "folder exist"
else
    mkdir -p /home/"$USER"/.config
fi

# Check if gtk folder exist and create gtk.css
if [ -d  /home/"$USER"/.config/gtk-2.0 ]  
then
    echo "folder exist"
    echo "$text" | tee /home/"$USER"/.config/gtk-2.0/gtk.css
else
    mkdir -p /home/"$USER"/.config/gtk-2.0
    echo "$text" | tee /home/"$USER"/.config/gtk-2.0/gtk.css
fi

# Check if gtk folder exist and create gtk.css
if [ -d  /home/"$USER"/.config/gtk-3.0 ]  
then
    echo "folder exist"
    echo "$text" | tee /home/"$USER"/.config/gtk-3.0/gtk.css
else
    mkdir -p /home/"$USER"/.config/gtk-3.0
    echo "$text" | tee /home/"$USER"/.config/gtk-3.0/gtk.css
fi

# Check if gtk folder exist and create gtk.css
if [ -d  /home/"$USER"/.config/gtk-4.0 ]  
then
    echo "folder exist"
    echo "$text" | tee /home/"$USER"/.config/gtk-4.0/gtk.css
else
    mkdir -p /home/"$USER"/.config/gtk-4.0
    echo "$text" | tee /home/"$USER"/.config/gtk-4.0/gtk.css
fi

# Check if gtk folder exist and create gtk.css
if [ -d  /home/"$USER"/.config/gtk-5.0 ]  
then
    echo "folder exist"
    echo "$text" | tee /home/"$USER"/.config/gtk-5.0/gtk.css
else
    mkdir -p /home/"$USER"/.config/gtk-5.0
    echo "$text" | tee /home/"$USER"/.config/gtk-5.0/gtk.css
fi
echo "Completed"