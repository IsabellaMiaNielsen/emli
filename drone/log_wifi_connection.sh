#!/bin/bash

create_database() {
    sqlite3 wifi_data.db "create table if not exists wifi_logs (timestamp INTEGER PRIMARY KEY, link_quality INTEGER, signal_level INTEGER);"
}

create_database

while true; do
    timestamp=$(date +%s)
    link_quality=$(awk 'NR==3 {print $3}' /proc/net/wireless)
    signal_level=$(awk 'NR==3 {print $4}' /proc/net/wireless)

    sqlite3 wifi_data.db "insert into wifi_logs (timestamp, link_quality, signal_level) values ($timestamp, $link_quality, $signal_level);"
    sleep 1
    #sqlite3 wifi_data.db  "select * from wifi_logs;"
done