# Solution - Task 4: Proxy Terbaik di New Eridu

## Subtask A - Log 5 Menit
**File rujukan:** minute5_log.sh

**Kode:**
```bash
metric_path="/home/mouis/metrics"
timestamp=$(date +"%Y%m%d%H%M%S")
mkdir -p "$metric_path"

memory=$(free -m | awk 'NR==2{printf "%s,%s,%s,%s,%s,%s", $2,$3,$4,$5,$6,$7}')
swap=$(free -m | awk 'NR==3{printf "%s,%s,%s", $2,$3,$4}')
dir_size=$(du -sh "$home_path" | awk '{print $1}')

log_file="$metric_path/metrics_$timestamp.log"

echo "mem_total,mem_used,mem_free,mem_shared,mem_buff,mem_available,swap_total,swap_used,swap_free,path,path_size" > "$log_file"
echo "$memory,$swap,$home_path,$dir_size" >> "$log_file"

chmod 600 "$log_file"
```

**Penjelasan:**
- `free -m` dipakai untuk RAM dan swap, diproses dengan `awk`.
- `du -sh` mengambil ukuran folder home.
- Header dan isi dicetak ke `metrics_YYYYmmddHHMMSS.log`.
- `chmod 600` menjaga agar hanya pemilik yang bisa membaca.

## Subtask B - Agregasi Per Jam
**File rujukan:** agg_5min_to_hour.sh

**Kode (pengumpulan data):**
```bash
for file in $(find "$metric_path" -name "metrics_$(date +"%Y%m%d")*.log" -mmin -60); do
    if [ -f "$file" ]; then
        IFS=',' read -r mem_total_val mem_used_val mem_free_val mem_shared_val mem_buff_val mem_available_val swap_total_val swap_used_val swap_free_val _ path_size_val <<< "$(cat "$file" | awk 'NR==2')"
        mem_total+=("$mem_total_val")
        ...
        path_size+=("${path_size_val//[^0-9]/}")
        n=$((n + 1))
    fi
done
```

**Penjelasan:**
- `find` memilih file log 60 menit terakhir.
- `read` memecah baris kedua CSV menjadi variabel.
- Nilai disimpan ke array untuk dihitung min, max, avg.

**Kode (statistik):**
```bash
avg(){ ... }
max(){ ... }
min(){ ... }
```
**Penjelasan:**
- `avg` menjumlahkan seluruh nilai lalu dibagi jumlah data.
- `min` dan `max` mencari nilai minimum dan maksimum.

**Kode (output):**
```bash
{
echo "type,mem_total,mem_used,mem_free,mem_shared,mem_buff,mem_available,swap_total,swap_used,swap_free,path_size"
echo "minimum,$mem_total_min,...,$path_size_min"M""
echo "maximum,$mem_total_max,...,$path_size_max"M""
echo "average,$mem_total_avg,...,$path_size_avg"M""
} > "$log_file"

chmod 600 "$log_file"
```
**Penjelasan:**
- Tiga baris output untuk minimum, maksimum, dan rata-rata.
- Sufiks `M` ditambahkan ke `path_size`.

## Subtask C - Uptime dan Load Average
**File rujukan:** uptime_monitor.sh

**Kode:**
```bash
uptime=$(uptime | awk -F ',' '{print $1}')
avg_load=$(cat /proc/loadavg | awk '{print $1","$2","$3}')
log_file="$metric_path_path/uptime_$timestamp.log"
{
echo "uptime,load_avg_1min,load_avg_5min,load_avg_15min"
echo "$uptime, $avg_load"
} > "$log_file"

chmod 600 "$log_file"
```

**Penjelasan:**
- `uptime` diambil dari bagian sebelum koma pertama.
- `load average` diambil dari tiga angka awal `/proc/loadavg`.
- Data disimpan ke `uptime_YYYYmmddHH.log`.

## Subtask D - Cleanup Log Lama
**File rujukan:** cleanup_log.sh

**Kode:**
```bash
log_path="/home/mouis/metrics"
find "$log_path" -name "metrics_agg_*.log" -type f -mmin +720 -exec rm -f {} \;
```

**Penjelasan:**
- `-mmin +720` memilih file lebih tua dari 12 jam.
- File log agregasi dihapus otomatis.
