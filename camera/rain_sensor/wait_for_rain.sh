#!/bin/bash

# Infinite loop
serial_port="/dev/ttyACM0"
while true; do
    # Run the command to read from serial port with a timeout of 2 seconds
    # exec 3<"$serial_port"
    response=$(timeout 2s cat < "$serial_port")

    # Check if there is any response
    if [ -n "$response" ]; then
        echo "Received response: $response"
        
        # Extract the value of "rain_detect" using jq
        rain_detect=$(echo "$response" | jq -r '.rain_detect // empty')
        # rain_detect=$(echo "$rain_detect" | xargs)
        # Debugging: Print the value of rain_detect
        echo "Value of rain_detect: $rain_detect"
        
        if [[ "$rain_detect" == *"1"* ]]; then
            echo "Rain detected. Sending MQTT message..."
            # Replace 'your_mqtt_topic' and 'your_message' with actual values
            mosquitto_pub -h localhost -p 1883 -u group7 -P Group7 -t rain_watch -m 2
            # exec 3>&-
            fuser -k "$serial_port"
            sleep 1
        else
            echo "No rain detected."
        fi
    else
        echo "No response received within the timeout period."
    fi

    # exec 3>&-
    
    sleep 1
done
