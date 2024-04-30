#!/bin/bash

dng_path=""
picture_path=""
trigger=""

usage() {
    echo "Usage: $0 [-t trigger]"
    echo "Options:"
    echo "  -t trigger  : What caused camera to take the picture [Time/Motion/External]"
    echo "  -d dng path     : Path to dng file that needs to be converted to json"
    echo "  -p picture path     : Path to picture from which dng was created"
    exit 1
}

while getopts "t:d:p:" opt; do
    case ${opt} in
        t )
            trigger=$OPTARG
	    ;;
	d )
	    dng_path=$OPTARG
	    ;;
	p )
            picture_path=$OPTARG
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

get_ms_from_filename() {
	local filename="$1"
	milliseconds="${filename##*_}"
	milliseconds="${milliseconds%.*}"
	if [[ ${#milliseconds} -eq 3 && $milliseconds =~ ^[0-9]+$ ]]; then
    		echo "$milliseconds"
	else
    		echo "000"
	fi
}

get_formatted_datetime() {
	local json="$1" milliseconds="$2"
	datetime=$(echo "$json" | jq -r --arg key "File Modification Date/Time" '.[$key]')
	datetime_without_timezone="${datetime%[+-]*}"
	timezone="${datetime##*[+-]}"
	sign="${datetime:${#datetime_without_timezone}:${#datetime} - ${#datetime_without_timezone} - ${#timezone}}"
	date_part=$(echo "$datetime" | cut -d ' ' -f 1)
	time_part=$(echo "$datetime" | cut -d ' ' -f 2 | cut -d "$sign" -f 1)
	formatted_date="${date_part//:/-}"
	formatted_datetime="${formatted_date} ${time_part}.${milliseconds}$sign${timezone}"
	echo "$formatted_datetime"
}

get_epoch_seconds() {
	local datetime="$1" milliseconds="$2"
	datetime_without_timezone="${datetime%[+-]*}"
    	timezone="${datetime##*[+-]}"
	sign="${datetime:${#datetime_without_timezone}:${#datetime} - ${#datetime_without_timezone} - ${#timezone}}"
	seconds_since_epoch=$(TZ="UTC$sign$timezone" date -d "$datetime_without_timezone" +%s)
	result="$seconds_since_epoch.$milliseconds"
	echo "$result"
}

json_append() {
	local json="$1" k="$2" v="$3"
	json=$(jq --arg key "$k" --arg value "$v" '. + {($key): $value}' <<< "$json")
	echo "$json"
}

customized_json() {
	local json="$1" trigger="$2" epoch="$3" date_time="$4" picture_file_name="$5"
        local customized_json="{}"
	customized_json=$(json_append "$customized_json" "File Name" "$picture_file_name")
	customized_json=$(json_append "$customized_json" "Create Date" "$date_time")
	customized_json=$(json_append "$customized_json" "Create Seconds Epoch" "$epoch")
	customized_json=$(json_append "$customized_json" "Trigger" "$trigger")

	local keys=("Subject Distance" "Exposure Time" "ISO")
	for ((i=0; i<${#keys[@]}; i++)); do
        	value=$(echo "$json" | jq -r --arg key "${keys[i]}" '.[$key]')
        	customized_json=$(json_append "$customized_json" "${keys[i]}" "$value")
	done
	echo "$customized_json"
}

validate_file_path "$dng_path"
validate_file_path "$picture_path"

json=$(convert_dng_to_json "$dng_path")

milliseconds=$(get_ms_from_filename "$(echo "$json" | jq -r --arg key "File Name" '.[$key]')")
date_time=$(get_formatted_datetime "$json" "$milliseconds")
epoch_seconds=$(get_epoch_seconds "$date_time" "$milliseconds")
picture_file_name=$(basename "$picture_path")

customized_json "$json" "$trigger" "$epoch_seconds" "$date_time" "$picture_file_name" > "${picture_path%.*}.json"
