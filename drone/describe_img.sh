json_path="/home/mia/emli/annotated.json"
img_path="/home/mia/emli/test.jpeg"
desc=$(ollama run llava:7b "describe $img_path")
desc="${desc//\"/\'}"
desc="${desc//$'\n'/ }"
message='{"Annotation": {"Source": "Ollama:7b", "Text": "'$desc'"},}'
temp_path="/home/mia/emli/temp.json"

# Check if the file exists
if [ -f "$json_path" ]; then
    # Create temp JSON file
    echo "$message" > $temp_path
    # Append new data to the JSON file
    new_j=$(jq -s add $temp_path $json_path)
    echo "$new_j" > $json_path
    rm "$temp_path"
    echo "Data appended successfully."
else
    echo "Did not get the json file. File doesn't exist"
fi
