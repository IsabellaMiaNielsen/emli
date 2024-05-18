#!/bin/bash


CAM_SSID="EMLI-TEAM-7" # Camera's access point SSID

check_cam_ap() {
    nmcli device wifi list | grep -q "$CAM_SSID" # Returns true if detected, otherwise false
}

connect_to_cam_ap() {
    nmcli con up "$CAM_SSID" 
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
