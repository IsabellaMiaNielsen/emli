#!/bin/bash

echo "Syncing camera's time to our time"
date=$(date +"%Y-%m-%d %H:%M:%S")
ssh -t -i /home/mia/emli/emli/drone/.ssh/id_ed25519_rpi group7@192.168.10.1 "sudo date -s '$date'"

echo "Starting to download photos..."
./download_photos.sh