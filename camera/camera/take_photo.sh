#!/bin/bash

validate_trigger() {
    local trigger=$1
    if [[ "$trigger" != "Time" && "$trigger" != "Motion" && "$trigger" != "External" ]]; then
        echo "Invalid trigger. Available options are: Time, Motion, External"
        exit 1
    fi
}

trigger=$1
validate_trigger "$trigger"
picture_path="$(/home/group7/emli/camera/camera/capture.sh)"
dng_path="${picture_path%.*}.dng"
json=$(/home/group7/emli/camera/camera/dng_to_json.sh -d "$dng_path")
/home/group7/emli/camera/camera/customized_json.sh -t "$trigger" -j "$json" -p "$picture_path"
rm -f $dng_path
/home/group7/emli/camera/logger/log_message.sh "Picture taken. Trigger $trigger."
