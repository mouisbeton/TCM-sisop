# Solution - Task 2: Liburan Bersama Rudi

## Subtask A
**File rujukan:** rudi-a.sh

**Kode:**
```bash
awk '{ ip_count[$1]++; status_count[$9]++ } END { 
    print "Total Request per IP:"
    for (ip in ip_count) {
        print ip, ip_count[ip]
    }
    print "\nJumlah Status Code:"
    for (status in status_count) {
        print status, status_count[status]
    }
}' access.log
```

**Penjelasan:**
- `$1` adalah IP address, `$9` adalah status code.
- `ip_count[$1]++` menghitung request per IP.
- `status_count[$9]++` menghitung jumlah status code.
- Bagian `END` mencetak kedua ringkasan.

## Subtask B
**File rujukan:** rudi-b.sh

**Kode:**
```bash
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
```

**Penjelasan:**
- `read tanggal ip` menerima input tanggal dan IP.
- `komputer` mengambil oktet ke-4 dari IP (nomor komputer).
- `tanggal_log` mengubah format agar cocok dengan format waktu di `access.log`.
- `awk` pada `peminjaman_computer.csv` mencocokkan tanggal dan nomor komputer untuk mendapatkan nama pengguna.
- Jika `pengguna` kosong, program berhenti dengan pesan error.
- `mkdir -p backup` memastikan folder ada.
- `nama_file` dibentuk sesuai format yang diminta.
- `grep` memfilter IP dan tanggal, `awk` menulis format log:
  `[dd/mm/yyyy:hh:mm:ss]: Method - Endpoint - Status Code`.
- Pesan akhir menampilkan nama pengguna dan lokasi file.

## Subtask C
**File rujukan:** rudi-c.sh

**Kode:**
```bash
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
```

**Penjelasan:**
- `awk '$9 == 500 {print $1}'` mengambil IP yang menghasilkan status 500.
- `sort | uniq -c` menghitung jumlah 500 per IP.
- Loop membaca `jumlah ip`, lalu memetakan IP ke pengguna via `peminjaman_computer.csv`.
- `error_count` menampung total error 500 per pengguna.
- Mencari `pemenang` dengan nilai `max_error` terbesar.
- Menampilkan ringkasan dan pemenang akhir.
