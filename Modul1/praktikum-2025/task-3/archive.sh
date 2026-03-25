#!/bin/bash

home_path="/home/mouis"
Log_File="$home_path/cloud_storage/cloud_log.txt"

last_login=$(grep "LOGIN: INFO User" "$Log_File" | tail -1)
last_logout=$(grep "LOGOUT: INFO User" "$Log_File" | tail -1)

login_date=$(echo "$last_login" | awk '{print $1, $2}')
logout_date=$(echo "$last_logout" | awk '{print $1, $2}')

if [[ "$login_date" > "$logout_date" ]]; then
    active_user=$(echo "$last_login" | awk '{print $6}')
else
   active_user=" "
fi

Download_Dir="$home_path/cloud_storage/downloads/$active_user"
Archive_Dir="$home_path/cloud_storage/archives/$active_user"

mkdir -p "$Archive_Dir"

Timestamp=$(date '+%H-%d-%m-%Y')
Zip_File="$Archive_Dir/archive_$Timestamp.zip"

cd "$Download_Dir"
zip -r "$Zip_File" *.jpg

if [[ $? -eq 0 ]]; then
    rm *.jpg
fi