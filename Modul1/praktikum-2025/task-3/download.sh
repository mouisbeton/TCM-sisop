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

if [[ $active_user != " " ]]; then
    Download_Dir="$home_path/cloud_storage/downloads/$active_user"
    mkdir -p "$Download_Dir"
    count=$((RANDOM % 20 + 2))
    query="nature"
    imagelink=$(wget --user-agent 'Mozilla/5.0' -qO - "www.google.be/search?q=${query}\&tbm=isch" | sed 's/</\n</g' | grep '<img' | head -n"$count" | tail -n1 | sed 's/.*src="\([^"]*\)".*/\1/')
    Timestamp=$(date '+%H-%M_%d-%m-%Y')
    Jpg_File="$Download_Dir/$Timestamp.jpg"

    wget -O "$Jpg_File" "$imagelink"
fi
