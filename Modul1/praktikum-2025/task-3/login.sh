#!/bin/bash

home_path="/home/$USER"

User_File="$home_path/cloud_storage/users.txt"
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

# echo $active_user

log_message() {
    echo "$(date '+%y/%m/%d %H:%M:%S') $1" >> "$Log_File"
}

login(){
if [[ $active_user != " " ]] ; then
    log_message "LOGIN: ERROR User $active_user is already logged in"
    echo "Pengguna $active_user sedang log in. Tolong log out terlebih dahulu."
    exit 1
fi

read -p "Enter username: " username
read -p "Enter password: " password
echo

stored_password=$(grep "^$username:" "$User_File" | cut -d: -f2)

if [[ $stored_password == $password ]]; then
log_message "LOGIN: INFO User $username logged in"
echo "Login berhasil"
else
log_message "LOGIN: ERROR Failed login attempt on User $username "
echo "Pengguna $username gagal log in. Silakan coba lagi."
fi
}

logout(){
if [[ $active_user != " " ]] ; then
log_message "LOGOUT: INFO User $active_user logged out"
echo "Logout berhasil"
else
echo "Tidak ada pengguna yang sedang log in."
fi
}

echo "1. Login"
echo "2. Logout"
read -p "Pilih menu(1 atau 2): " menu

case $menu in
    1) login
       ;;
    2) logout
       ;;
    *) echo "Pilihan tidak valid. Silakan coba lagi."
       ;;
esac