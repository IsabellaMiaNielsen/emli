#!/bin/bash

dng_path=""

usage() {
    echo "Usage: $0 [-t trigger]"
    echo "Options:"
    echo "  -t trigger  : What caused camera to take the picture [Time/Motion/External]"
    echo "  -d dng path     : Path to dng file that needs to be converted to json"
    exit 1
}

while getopts "d:" opt; do
    case ${opt} in
        d )
            dng_path=$OPTARG
            ;;
        \? )
            echo "Invalid option: $OPTARG" 1>&2
            usage
            ;;
    esac
done
shift $((OPTIND -1))

validate_file_path() {
    local path="$1"
    if [ ! -f "$path" ]; then
        echo "File $path does not exist"
        exit 1
    fi
}

trim_surrounding_spaces() {
        awk '{$1=$1;print}' <<< "$1"
}

convert_dng_to_json() {
        local metadata=$(exiftool "$1")
        local delimeter=":"
        json="{"
        while IFS= read -r line; do
                key=$(trim_surrounding_spaces "${line%%$delimeter*}")
                value=$(trim_surrounding_spaces "${line#*$delimeter}")
                json+="\"$key\":\"$value\","
        done <<< "$metadata"
        json="${json%,}}"
        echo "$json"
}

validate_file_path "$dng_path"
convert_dng_to_json "$dng_path"

