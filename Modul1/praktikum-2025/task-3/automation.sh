#!/bin/bash

home_path="/home/mouis"
Log_File="$home_path/cloud_storage/cloud_log.txt"

script_path="$home_path/work/praktikum-modul-1-d02/task-3"

last_login=$(grep "LOGIN: INFO User" "$Log_File" | tail -1)
last_logout=$(grep "LOGOUT: INFO User" "$Log_File" | tail -1)

login_date=$(echo "$last_login" | awk '{print $1, $2}')
logout_date=$(echo "$last_logout" | awk '{print $1, $2}')

if [[ "$login_date" > "$logout_date" ]]; then
    active_user=$(echo "$last_login" | awk '{print $6}')
else
   active_user=" "
fi

if [[ $active_user != " " ]]; then
    crontab -l | grep -q "$script_path/download.sh" || (crontab -l 2>/dev/null; echo "*/2 * * * * $script_path/download.sh") | crontab -
    crontab -l | grep -q "$script_path/archive.sh" || (crontab -l 2>/dev/null; echo "0 */1 * * * $script_path/archive.sh") | crontab -
else
    crontab -l | grep -v $script_path/download.sh | crontab -
    crontab -l | grep -v $script_path/archive.sh | crontab -
fi
