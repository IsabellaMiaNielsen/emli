#!/bin/bash


CAM_SSIDS=("EMLI-TEAM-7") # Camera's access point SSID

check_cam_ap() {
    local CAM_SSID="$1"
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
    for CAM_SSID in "${CAM_SSIDS[@]}"; do
        if check_cam_ap "$CAM_SSID"; then
            echo "Camera's access point detected. Connecting..."
            connect_to_cam_ap "$CAM_SSID"
            break 2  # Exit both loops after successful connection
        else
            echo "Camera's access point not detected. Waiting..."
            sleep 2  # Wait for 2 seconds before scanning again
        fi
    done
done

echo "Connected to Camera's access point."
echo "Logging wifi connection..."
./log_wifi_connection.sh &
./sync_time.sh
