#!/bin/bash

# Define the JSON string
json_string="{'wiper_angle': 60}"
echo "$json_string"
# Define the serial port
serial_port="/dev/ttyACM0"  # Update this with the actual serial port

# Write the JSON string to the serial port
echo -e "$json_string" > "$serial_port"

# Read the response from the serial port
response=$(timeout 2s cat < "$serial_port")

# Check if there is any response
if [ -n "$response" ]; then
    echo "Received response: $response"
else
    echo "No response received within the timeout period."
fi
