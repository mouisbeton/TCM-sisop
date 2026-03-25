#!/bin/bash

read tanggal ip

komputer=$(echo $ip | awk -F '.' '{print $4}')
tanggal_log=$(date -d "$tanggal" +"%d/%b/%Y")
pengguna=$(awk -v tanggal="$tanggal" -v komputer="$komputer" -F, '$1 == tanggal && $2 == komputer {print $3}' peminjaman_computer.csv)

if [ -z "$pengguna" ]; then
    echo "Data yang kamu cari tidak ada"
    exit 1
fi

mkdir -p backup
waktu=$(date +"%H%M%S")
nama_file="/backup/${pengguna}_${tanggal//\//_}_${waktu}.log"

grep "$ip" access.log | grep "$tanggal_log" | awk '{print "[" substr($4,2) "]: " $6 " - " $7 " - " $9}' > "$nama_file"

echo "Pengguna saat itu adalah $pengguna"
echo "Log Aktivitas $pengguna disimpan di $nama_file"
