#!/bin/bash

PIPE=/tmp/camera_daemon_pipe

if [ ! -p "$PIPE" ]; then
    echo "Error: Daemon pipe not found."
    exit 1
fi

echo "$1" > "$PIPE"
