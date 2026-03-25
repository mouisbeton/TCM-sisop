#!/bin/bash

declare -A error_count

awk '$9 == 500 {print $1}' access.log | sort | uniq -c > temp_500.log

while read jumlah ip; do
    komputer=$(echo "$ip" | awk -F '.' '{print $4}')
    pengguna=$(awk -v komputer="$komputer" -F, '$2 == komputer {print $3}' peminjaman_computer.csv | head -n 1)

    if [ -n "$pengguna" ]; then
        ((error_count[$pengguna]+=$jumlah))
    fi
done < temp_500.log

rm temp_500.log

declare -a hasil
pemenang=""
max_error=0

for pengguna in "${!error_count[@]}"; do
    hasil+=("$pengguna ${error_count[$pengguna]}")
    if [ "${error_count[$pengguna]}" -gt "$max_error" ]; then
        max_error=${error_count[$pengguna]}
        pemenang=$pengguna
    fi
done

printf "%s\n" "${hasil[@]}" | sort -k2 -nr | awk '!seen[$1]++'

echo -e "\nPemenang adalah $pemenang dengan total $max_error error 500."
