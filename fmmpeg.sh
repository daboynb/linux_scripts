#!/bin/bash

# Check if deps are installed
sudo dpkg -l | grep -qw ffmpeg || sudo apt-get install ffmpeg -y

# Function to avoid repating the code
ffmpeg_func() {
        # Get video's path
        read -e -p "Drag & drop your video file: " video_file
        eval video_file="$video_file"

        # Echo the video's path
        echo Full path: "$video_file"

        # Get the filename without the extension
        video_file_name=$(basename "$video_file")
        video_file_name_without_ext="${video_file_name%.*}"

        # Check if the folder already exists
        if [ -d "/tmp/extracted_video/$video_file_name_without_ext" ]; then
            while [ -z "$prompt" ]; do
                read -p "This folder already exists! Overwrite it? (y/n): " choice
                case "$choice" in
                    y|Y )
                        rm -rf "/tmp/extracted_video/$video_file_name_without_ext"
                        mkdir -p "/tmp/extracted_video/$video_file_name_without_ext"
                        break
                        ;;
                    n|N ) 
                        exit 0
                        ;;
                esac
            done
        else
            mkdir -p "/tmp/extracted_video/$video_file_name_without_ext"
        fi
        
        # Cd into it
        cd "/tmp/extracted_video/$video_file_name_without_ext"
}

mainmenu() {
    echo -ne "
1) Output every single frame 
2) Output one image every x second or x minute
0) Exit
Choose an option:  "
    read -r ans
    case $ans in

    1)
        ffmpeg_func

        # EXtract every single frame from the selected video
        ffmpeg -i "$video_file" "frame%d.png"
        ;;
    2)
        ffmpeg_func
        
        echo ""
        echo "Examples"
        echo ""
        echo "To output one image every second enter 1 when asked"
        echo "To output one image every minute enter 1/60 when asked"
        echo "To output one image every 10 minutes enter 1/600 when asked"
        echo ""

        # Ask to the user 
        read -p "Defines the time : " selected_time

        # Output one image every x second or minute
        ffmpeg -i "$video_file" -vf fps="$selected_time" "out%d.png"
        ;;
    0)      
        echo "Bye bye."
        exit 0
        ;;
    *)
        echo "Wrong option."
        mainmenu
        ;;
    esac
}

mainmenu