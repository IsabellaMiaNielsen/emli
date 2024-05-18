#!/bin/bash

cleanup() {
    rm -f "$PIPE"
    rm -rf "$IMAGE_DIR"/*
    kill $(jobs -p)
    exit 0
}

trap cleanup EXIT

PIPE=/tmp/camera_daemon_pipe
rm -f "$PIPE"
mkfifo "$PIPE"
chmod 666 "$PIPE"

handle_command() {
    case "$1" in
        "Time")
            /home/group7/emli/camera/camera/take_photo.sh 'Time'
	    ;;
        "External")
	        /home/group7/emli/camera/camera/take_photo.sh 'External'
        ;;
	    "Motion")
            latest_temp_image=$(/home/group7/emli/camera/camera/motion_cap_functions.sh "$latest_temp_image")
        ;;
    esac
}

IMAGE_DIR="/home/group7/emli/camera/image_stream"
if [ -n "$(ls -A "$IMAGE_DIR")" ]; then
    rm -rf "$IMAGE_DIR"/*
fi

/home/group7/emli/camera/rain_sensor/wait_for_rain.sh &
/home/group7/emli/camera/rain_sensor/write_json.sh &
/home/group7/emli/camera/motion_sensor/wait_for_pressure.sh &
/home/group7/emli/camera/motion_detection.sh &

while true; do
    if read -r command < "$PIPE"; then
        handle_command "$command"
    fi
done
