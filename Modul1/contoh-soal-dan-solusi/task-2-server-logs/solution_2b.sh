#!/bin/bash
# Contoh Solusi 2b - Cari username dengan error terbanyak

IP_ERROR=$(awk '$NF >= 400 {print $1}' access.log | sort | uniq -c | sort -rn | head -1 | awk '{print $2}')

grep "^$IP_ERROR" users.csv | while IFS=',' read ip user; do
    ERROR_COUNT=$(awk -v ip="$ip" '$1==ip && $NF>=400 {count++} END {print count+0}' access.log)
    echo "$user: $ERROR_COUNT errors"
done
