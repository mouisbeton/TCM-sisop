#!/bin/bash
# Contoh Solusi 3 - Register user dengan validasi

USERNAME=$1
PASSWORD=$2

# Validasi panjang
if [ ${#PASSWORD} -lt 8 ]; then
    echo "Password minimal 8 karakter"
    exit 1
fi

# Validasi harus ada angka
if ! [[ $PASSWORD =~ [0-9] ]]; then
    echo "Password harus mengandung angka"
    exit 1
fi

# Validasi harus ada huruf besar
if ! [[ $PASSWORD =~ [A-Z] ]]; then
    echo "Password harus mengandung huruf besar"
    exit 1
fi

# Simpan ke file
echo "$USERNAME:$PASSWORD" >> users.txt

# Catat ke log
echo "[$(date +%H:%M:%S)] User registered: $USERNAME" >> log.txt

echo "User $USERNAME berhasil terdaftar"
