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
/home/group7/emli/camera/camera/dng_to_json.sh -t "$trigger" -d "$dng_path" -p "$picture_path"
#rm $dng_path
/home/group7/emli/camera/logger/log_message.sh "Picture taken. Trigger $trigger."
