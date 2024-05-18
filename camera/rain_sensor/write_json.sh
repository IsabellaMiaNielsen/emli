#!/bin/bash

# Define the JSON string
json_string_180="{'wiper_angle': 180}"
json_string_0="{'wiper_angle': 0}"
echo "$json_string_150"

# Define the serial port
serial_port="/dev/ttyACM0"  # Update this with the actual serial port

# Write the JSON string to the serial port
# echo -e "$json_string_180" > "$serial_port"

# Read the response from the serial port


# MQTT broker settings
broker_host="localhost"  # Update with your MQTT broker host
broker_port="1883"       # Update with your MQTT broker port
topic="rain_watch"       # Update with the MQTT topic you want to subscribe to

# Function to process MQTT messages
process_mqtt_message() {
    # Add your processing logic here
    # For example, you can parse the message, perform actions based on its content, etc.
    echo "Received MQTT message: $1"
    if [[ "$1" == *"2"* ]]; then
        # exec 3<"$serial_port"
        sleep 1
        echo "Rain detected. Taking action..."
        echo -e "$json_string_180" > "$serial_port"
        sleep 0.5
        echo -e "$json_string_0" > "$serial_port"
        # exec 3>&-
        # sleep 1
        fuser -k "$serial_port"
        # dd if="$serial_port" of=/dev/null bs=1 count=1 >/dev/null 2>&1
        
    else
        echo "No rain detected."
    fi
}

# Run MQTT subscriber in the foreground
while true; do
    mosquitto_sub -h "$broker_host" -p "$broker_port" -u group7 -P Group7 -t "$topic" | 
    while IFS= read -r message; do
        process_mqtt_message "$message"
    done
done