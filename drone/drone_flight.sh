#!/bin/bash

cleanup() {
    echo "Cleaning up before exiting..."
    pkill -f log_wifi_connection.sh
    pkill -P $$  # Send termination signal to all child processes
    exit 0
}


# Trap SIGTERM and SIGINT signals
trap 'cleanup' SIGTERM SIGINT SIGKILL

./connect_to_cam.sh $

wait # Wait for child processes to finish

