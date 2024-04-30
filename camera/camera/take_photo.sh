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
picture_file="$($(pwd)/capture.sh)"
picture_path="$(pwd)/$picture_file"
dng_path="${picture_path%.*}.dng"
$(pwd)/dng_to_json.sh -t "$trigger" -d "$dng_path" -p "$picture_path"
