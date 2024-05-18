message=$1

log_file="/var/www/html/logs/camera-log.txt"
datetime=$(date +"%Y-%m-%d %H:%M:%S.%N %Z")

echo "$datetime $message" >> "$log_file"
