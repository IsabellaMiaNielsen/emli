#!/bin/bash

kill_process() {
    local child_pid="$1"
    # Kill the process
    kill "$child_pid"
    # Wait for process to exit
    wait "$child_pid"
}

cleanup() {
    echo "Cleaning up before exiting..."
    pkill -P $$  # Send termination signal to all child processes
    exit 0
}


# Trap SIGTERM and SIGINT signals
trap 'cleanup' SIGTERM SIGINT SIGKILL

# Start to try to connect to camera
./connect_to_cam.sh $

# Wait for child processes to finish
wait

