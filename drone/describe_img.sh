#!/bin/bash

temp_path="/home/mia/emli/emli/drone/temp.json"
temp_path_2="/home/mia/emli/emli/drone/temp_2.json"
echo "Starting to describe new images"
folders=$(ls -d /home/mia/emli/emli/drone/photos/*/)
if [ -f "/home/mia/emli/emli/drone/last_image_path.txt" ]; then
    last_image_path=$(cat "/home/mia/emli/emli/drone/last_image_path.txt")
    IFS=',' read -ra path_parts <<< "$last_image_path"
    folder_index=${path_parts[0]}
    index=${path_parts[1]} 
else
    folder_index=1
    img_path=""
    index=1
fi
remaining_folders=$(echo "$folders" | tail -n +$folder_index)
for folder in $remaining_folders; do
    image_paths=$(ls -f $folder*.jpg)
    if [ $index -ne 1 ]; then
        remaining_image_paths=$(echo "$image_paths" | tail -n +$index)
    else
        remaining_image_paths=$image_paths
    fi
    for img_path in $remaining_image_paths; do
        echo "Describing $img_path"
        json_path="${img_path%.*}.json"
        if [ -f "$json_path" ]; then
            desc=$(ollama run llava:7b "describe $img_path")
            # Check for double quotes in the description
            if [[ $desc = *'"'* ]]; then
                desc="${desc//\"/\'}"
            fi
            desc="${desc//$'\n'/ }"
            message='{"Annotation": {"Source": "Ollama:7b", "Text": "'$desc'"}}'
            # Create temp JSON file
            echo "$message" >> $temp_path
            # Append new data to the JSON file
            jq -s add "$temp_path" "$json_path" > $temp_path_2
            mv $temp_path_2 $json_path
            rm "$temp_path"
            echo "Data appended successfully for $img_path."
            echo "Uploading to git"
            git add $json_path
            git commit -m "Added new data for $img_path"
            git push
            index=$((index+1))
            echo "$folder_index,$index" > /home/mia/emli/emli/drone/last_image_path.txt
        else
            echo "Did not find the json file for $img_path."
        fi
    done
    index=1
    folder_index=$((folder_index+1))
done
