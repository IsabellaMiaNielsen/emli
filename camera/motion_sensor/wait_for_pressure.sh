#!/bin/bash

# MQTT broker details
MQTT_SERVER="localhost"
MQTT_PORT="1883"
MQTT_USERNAME="group7"
MQTT_PASSWORD="Group7"
MQTT_TOPIC="group7/count"

while true; do
	mosquitto_sub -h "$MQTT_SERVER" -p "$MQTT_PORT" -u "$MQTT_USERNAME" -P "$MQTT_PASSWORD" -t "$MQTT_TOPIC" | while IFS= read -r line; do
    	if [ "$line" = "1" ]; then
        	/home/group7/emli/camera/camera/send_command_to_camera_daemon.sh "External"
        	sleep 1
    	fi
	done
done
