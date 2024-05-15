connected() {
    nmcli connection show --active | grep -q "EMLI-TEAM-7" # Returns true if connected, otherwise false
}

number_of_folders=$(ls -l /home/mia/emli/emli/drone/photos | grep -c '^d')
temp_path="/home/group7/emli/camera/pictures/temp.json"
temp_path_2="/home/group7/emli/camera/pictures/temp_2.json"

while connected; do
    echo "We're still connected, downloading photos"
    folders=$(ssh -i .ssh/id_ed25519_rpi group7@192.168.10.1 'ls -d ~/emli/camera/pictures/*/')
    if [ -n "$folders" ]; then
        remaining_folders=$(echo "$folders" | tail -n +$number_of_folders)
        for folder in $remaining_folders; do
            files=$(ssh -i .ssh/id_ed25519_rpi group7@192.168.10.1 "ls $folder")
            for file in $files; do
                if [ ! -d  "/home/mia/emli/emli/drone/photos/$(basename $folder)" ]; then
                    mkdir "/home/mia/emli/emli/drone/photos/$(basename $folder)"
                fi
                if [ ! -f "/home/mia/emli/emli/drone/photos/$(basename $folder)/$file" ]; then
                    if [[ $file == *.json ]]; then
                            # Add section to the JSON file on the camera
                            epoch_seconds=$(date +%s)
                            message='{"Drone Copy": {"Drone ID": "WILDDRONE-001", "Seconds Epoch": "'$epoch_seconds'"}}'
                            ssh -i .ssh/id_ed25519_rpi group7@192.168.10.1 "echo '$message' >> $temp_path"
                            ssh -i .ssh/id_ed25519_rpi group7@192.168.10.1 "jq -s add \"$temp_path\" \"$folder/$file\" > $temp_path_2"
                            ssh -i .ssh/id_ed25519_rpi group7@192.168.10.1 "mv $temp_path_2 $folder/$file"
                            ssh -i .ssh/id_ed25519_rpi group7@192.168.10.1 "rm $temp_path"
                        fi
                    scp -r -i .ssh/id_ed25519_rpi group7@192.168.10.1:"$folder/$file" /home/mia/emli/emli/drone/photos/$(basename $folder)
                fi
            done
        done
        echo "All files copied. No new files to copy."
    else
        echo "No folders found"
    fi
done

echo "We lost connection to the cam. Flying on"
pkill -f log_wifi_connection.sh
./describe_img.sh &
./connect_to_cam.sh
