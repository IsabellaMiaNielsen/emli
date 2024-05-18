#!/bin/bash

auto="1"
exposure="20000"
iso="800"

usage() {
    echo "Usage: $0 [-e exposure] [-i iso]"
    echo "Options:"
    echo "  -e exposure : Camera exposure time in ms"
    echo "  -i iso      : ISO controls ammount of light camera lets in"
    exit 1
}

while getopts "e:i:" opt; do
    case ${opt} in
        e )
            exposure=$OPTARG
	    auto="0"
            ;;
	i )
	    iso=$OPTARG
	    auto="0"
	    ;;
        \? )
            echo "Invalid option: $OPTARG" 1>&2
            usage
            ;;
    esac
done
shift $((OPTIND -1))

capture() {
	local output=$1 exposure=$2 iso=$3
	LC_NUMERIC=C
	iso=$(awk -v iso="$iso" 'BEGIN {printf "%.2f\n", iso / 100}')

	if [[ $auto = "1" ]]; then
        	rpicam-still -t "0.01" -r -o "$output" > /dev/null 2>&1
    	else
        	rpicam-still -t "0.2" --shutter "$exposure" -r --gain "$iso" -o "$output" > /dev/null 2>&1
    	fi

    	if [ $? -ne 0 ]; then
        	exit 1
    	fi
}

workdir="/var/www/html/pictures"
folder="$workdir/$(date +"%Y-%m-%d")"
picture="$(date +"%H%M%S_%3N").jpg"
output="$folder/$picture"
mkdir -p "$folder"

capture "$output" "$exposure" "$iso"
while [ ! -f "$output" ]; do
    sleep 0.1
done

echo "$output"
