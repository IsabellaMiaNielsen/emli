#!/bin/bash

# Camera's access point SSID
CAM_SSID="EMLI-TEAM-7"
CAM_PASSWORD="group7group7"

# Function to check if Camera's access point is detected
check_cam_ap() {
    nmcli device wifi list | grep -q "$CAM_SSID" # Returns true if detected, otherwise false
}

# Function to connect to Camera's access point
connect_to_cam_ap() {
    nmcli device wifi connect "$CAM_SSID" password "$CAM_PASSWORD"
}

check_if_connected_to_cam() {
    nmcli connection show --active | grep -q "$CAM_SSID" # Returns true if connected, otherwise false
}

# Main loop
while true; do
    if check_cam_ap; then
        echo "Camera's access point detected. Connecting..."
        connect_to_cam_ap
        break  # Exit loop after successful connection
    else
        echo "camera's access point not detected. Waiting..."
        sleep 2  # Wait for 2 seconds before scanning again
    fi
done

echo "Connected to Camera's access point."
echo "Logging wifi connection..."
./log_wifi_connection.sh &
./sync_time.sh
