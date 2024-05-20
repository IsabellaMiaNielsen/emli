#!/bin/bash

# # Function to capture image from RPICam and save it
# capture_image() {
#     current_image_path="/home/group7/emli/camera/image_stream/current_image_$(date +"%Y%m%d%H%M%S").jpg"
#     rpicam-still -t "0.01" -o "$current_image_path" > /dev/null 2>&1
# }

# # Function to call Python script for image comparison
# compare_images_python() {
#     python_result=$(python3 /home/group7/emli/camera/motion_sensor/motion_detect.py "$current_image_path" "$last_image_path")
#     echo "$python_result"
#     if [ "$python_result" == "Motion detected" ]; then
#         echo "motion detected"
#         # Do something if images are the same
#     elif [ "$python_result" == "No motion" ]; then
#         echo "no motion detected"
#         # Do something if images are different
#     else
#         echo "Error in Python script"
#         # Handle error condition
#     fi
# }

# check_for_motion(){
#     capture_image
#     compare_images_python
#     if [ -n "$last_image_path" ]; then
#         rm "$last_image_path"
#     fi
#     last_image_path="$current_image_path"
#     echo $last_image_path
# }
IMAGE_DIR="/home/group7/emli/camera/image_stream"
if [ -n "$(ls -A "$IMAGE_DIR")" ]; then
    rm -rf "$IMAGE_DIR"/*
fi
# Main loop
while true; do
    /home/group7/emli/camera/camera/send_command_to_camera_daemon.sh "Motion"
    sleep 3
done
