#!/bin/bash

home_path="/home/$USER"

User_File="$home_path/cloud_storage/users.txt"
Log_File="$home_path/cloud_storage/cloud_log.txt"

mkdir -p $home_path/cloud_storage
touch "$User_File" "$Log_File"

log_message() {
    echo "$(date '+%y/%m/%d %H:%M:%S') $1" >> "$Log_File"
}

# if grep -q "LOGIN: INFO User" "$Log_File" | grep -qv "LOGOUT: INFO User"; then
#     active_user=$(grep "LOGIN: INFO User" "$Log_File" | tail -1 | awk '{print $6}')
#     log_message "LOGIN: ERROR User $active_user is already logged in"
#     echo "Pengguna $active_user sedang log in. Tolong log out terlebih dahulu."
#     exit 1
# fi

while true;do

read -p "Enter username: " username
echo

lower_username=$(echo "$username" | tr 'A-Z' 'a-z')

if grep -qi "^$lower_username:" <(tr 'A-Z' 'a-z' < "$User_File"); then
    log_message "REGISTER: ERROR User already exists"
    echo "Pengguna sudah ada. Tolong buat nama yang berbeda."
    continue
fi

if [[ "$username" =~ [[:space:]] ]]; then
    log_message "REGISTER: ERROR Username cannot contain spaces"
    echo "Username tidak boleh mengandung spasi."
    continue
fi
if [[ "$username" == "" ]]; then
    log_message "REGISTER: ERROR Username cannot be empty"
    echo "Username tidak boleh kosong."
    continue
fi

break
done

while true; do
read -p "Enter password: " password
echo

if [ ${#password} -lt 8 ]; then
    log_message "REGISTER: ERROR Password must be at least 8 characters"
    echo "Password harus memiliki setidaknya 8 karakter."
    continue
fi

if [[ ! "$password" =~ [A-Z] || ! "$password" =~ [0-9] || ! "$password" =~ [[:punct:]] ]]; then
    missing=()
    
    [[ ! "$password" =~ [A-Z] ]] && missing+=("uppercase letter")
    [[ ! "$password" =~ [0-9] ]] && missing+=("number")
    [[ ! "$password" =~ [[:punct:]] ]] && missing+=("special character")
    
    case ${#missing[@]} in
        1) log_message "REGISTER: ERROR Password must contain at least one $error_msg ${missing[0]}" ;;
        2) log_message "REGISTER: ERROR Password must contain at least one $error_msg ${missing[0]} and one ${missing[1]}" ;;
        3) log_message "REGISTER: ERROR Password must contain at least one $error_msg uppercase letter, one number, and one special character" ;;
    esac
    
    echo "Password harus memiliki: ${missing[*]// /, }"
    return 1
fi
if [[ "$password" == "$username" ]]; then
    log_message "REGISTER: ERROR Password cannot be the same as the username"
    echo "Password tidak boleh sama dengan nama pengguna."
    continue
fi
if [[ "$(echo "$password" | tr A-Z a-z)" =~ "cloud" || "$(echo "$password" | tr A-Z a-z)" =~ "storage" ]]; then
    log_message "REGISTER: ERROR Password cannot contain 'cloud' or 'storage'"
    echo "Password tidak boleh mengandung 'cloud' atau 'storage'."
    continue
fi

if [[ "$password" =~ [[:space:]] ]]; then
    log_message "REGISTER: ERROR Password cannot contain spaces"
    echo "Password tidak boleh mengandung spasi."
    continue
fi

break

done

echo "$username:$password" >> "$User_File"
log_message "REGISTER: INFO User $username registered successfully"
echo "Pengguna berhasil terdaftar."
