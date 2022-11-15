#!/bin/bash
# Ask for a confirm
while [ -z $prompt ];
    do read -p "Do you want to make a backup? (y/n)?" choice;
    case "$choice" in
        y|Y ) break;;
        n|N ) exit 0;;
    esac;
    done;

# Ask the name of the folder to bk
read -e -p "Type the name of the folder to backup or drag and drop it on the terminal : " dir

# Eval the variable to combine arguments into a single string 
eval dir="$dir"

# Ask the name of the bk folder
read -e -p "Select the name of the backup folder : " backdir

# Create the bk folder
mkdir "$backdir"

# Copy the folder
cp -r "$dir" "$backdir"

# Print the result
if [ $? == 0 ]
then
echo "$dir succesfully copied"
else
echo "Error, not copied!"
fi 