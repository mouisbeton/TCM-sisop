# Solution - Task 1: Top Global New Jeans

## Subtask A
**File rujukan:** new-jeans-a.sh

**Kode:**
```bash
awk -F ',' '
        $2 ~ /2/ && $2 !~ /_/ {print $2}
        ' newjeans_analysis/DataStreamer.csv | sort -V
awk -F ',' '
        BEGIN {count=0} $2 ~ /2/ && $2 !~ /_/ {count++} 
        END{print "jumlah nama: "count}
        ' newjeans_analysis/DataStreamer.csv
```

**Penjelasan blok 1:**
- `-F ','` menetapkan pemisah kolom CSV.
- `$2 ~ /2/` memilih username yang mengandung angka 2.
- `$2 !~ /_/` menolak username yang mengandung underscore.
- `{print $2}` mencetak kolom username.
- `| sort -V` mengurutkan hasil berdasarkan ASCII (versi numerik).

**Penjelasan blok 2:**
- `BEGIN {count=0}` inisialisasi penghitung.
- Kondisi filter sama seperti blok pertama.
- `count++` menambah jumlah username yang lolos.
- `END{print "jumlah nama: "count}` menampilkan total.

## Subtask B
**File rujukan:** new-jeans-b.sh

**Kode:**
```bash
songs=$(awk -F ',' '
        $2 ~ /[0-9]/ {print $3} 
        ' newjeans_analysis/DataStreamer.csv |sort -V | uniq -c | sort -nr)

hit_song=$(echo "$songs" | head -n 1)

song_name=$(echo "$hit_song" | awk '{print $2}') 
user_count=$(echo "$hit_song" | awk '{print $1}')

echo $song_name $user_count
if [ $user_count -ge 24 ]; 
then
    echo "Keren, Minji! Kamu hebat <3!"
else
    echo "Maaf, Minji, total streamingnya tidak sesuai harapan :("
fi
```

**Penjelasan:**
- `awk` memilih baris dengan username berangka (`$2 ~ /[0-9]/`) lalu mencetak judul lagu (`$3`).
- `sort -V | uniq -c | sort -nr` menghitung frekuensi tiap lagu dan mengurutkan dari yang terbanyak.
- `head -n 1` mengambil lagu paling sering muncul.
- `awk '{print $2}'` dan `awk '{print $1}'` memisahkan nama lagu dan jumlah user.
- `if [ $user_count -ge 24 ]` menentukan pesan yang dicetak sesuai aturan.

## Subtask C
**File rujukan:** new-jeans-c.sh

**Kode:**
```bash
songs=$(awk -F ',' '
		$2 ~ /[0-9]/ {print $3} 
		' newjeans_analysis/DataStreamer.csv | sort -V | uniq -c | sort -nr)

hit_song=$(echo "$songs" | head -n 1)

song_name=$(echo "$hit_song" | awk '{print $2}')
user_count=$(echo "$hit_song" | awk '{print $1}') 

awk -F ',' -v song="$song_name" -v user="$user_count" '
		$2 ~ song {print $2, ":", user, "\n", $1, $3}
		' newjeans_analysis/AlbumDetails.csv
```

**Penjelasan:**
- Blok awal sama seperti Subtask B untuk mencari lagu teratas dan jumlah user.
- `-v song=... -v user=...` mengirim variabel ke `awk`.
- `awk` membaca `AlbumDetails.csv` dan mencari baris lagu yang cocok (`$2 ~ song`).
- Output:
  - Baris 1: `judul_lagu : jumlah_user`.
  - Baris 2: `nama_album tahun_rilis` tanpa tanda kutip.

## Subtask D
**File rujukan:** new-jeans-d.sh

**Kode:**
```bash
devices=$(awk -F ',' '
    NR>1 {count[$7]+=1}{sum[$7]+=$4}
    END {for (device in count) {
            print count[device],",",sum[device],"seconds,", device;
        }
    }' newjeans_analysis/DataStreamer.csv) 
    
loyal=$(awk -F ',' '
    NR>1 {count[$7]+=1}{sum[$7]+=$4}
    END {for (device in count) {
            print sum[device]/count[device],"seconds per user,", device; 
        }
    }' newjeans_analysis/DataStreamer.csv) 

echo "$devices"
echo "--------"
echo "$devices" | awk -F ',' '{print "Top users: ",$1",",$3}' | sort -k 3 -nr | head -n 1
echo "$devices" | awk -F ',' '{print "Top durations: ",$2,",",$3}' | sort -nr | head -n 1
most_loyal=$(echo "$loyal" | sort -nr | head -n 1)
echo "Most loyal: $most_loyal"
```

**Penjelasan:**
- `NR>1` melewati header CSV.
- `count[$7]` menghitung jumlah user per device.
- `sum[$7]` menjumlah total durasi (`$4`) per device.
- `devices` menyimpan ringkasan: `jumlah_user,total_durasi,device`.
- `loyal` menyimpan rasio `total_durasi/jumlah_user` per device.
- `sort -k 3 -nr` memilih device dengan user terbanyak.
- `sort -nr` pada total durasi memilih device dengan durasi tertinggi.
- `Most loyal` diambil dari rasio terbesar.
