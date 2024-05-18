#!/bin/bash

# Function to capture image from RPICam and save it
capture_image() {
    current_image_path="/home/group7/emli/camera/image_stream/current_image_$(date +"%Y%m%d%H%M%S").jpg"
    rpicam-still -t "0.01" -o "$current_image_path" > /dev/null 2>&1
}

# Function to call Python script for image comparison
compare_images_python() {
    python_result=$(python3 /home/group7/emli/camera/motion_sensor/motion_detect.py "$current_image_path" "$last_image_path")
    
    if [ "$python_result" == "Motion detected" ]; then
        /home/group7/emli/camera/camera/take_photo.sh 'Motion'
    fi
}
check_for_motion(){
    last_image_path=$1
    capture_image
    compare_images_python
    if [ -n "$last_image_path" ]; then
        rm "$last_image_path"
    fi
    last_image_path="$current_image_path"
}

current_path=$1
check_for_motion "$current_path"
echo "$current_image_path"