# Praktikum Linux & Shell Scripting 

Dokumentasi praktikum komprehensif yang mencakup materi dasar Linux, Shell Scripting, Data Processing dengan AWK, dan proyek-proyek praktis.

---

## Daftar Isi

1. [Materi Modul 1](#materi-modul-1)
   - [Perintah dan Navigasi](#perintah-dan-navigasi)
   - [User dan Permission](#user-dan-permission)
   - [Text Editor](#text-editor)
   - [Shell Scripting](#shell-scripting)
   - [Cron Jobs](#cron-jobs)
   - [AWK](#awk)

2. [Contoh Soal dan Solusi](#contoh-soal-dan-solusi)
   - [Task 1: Filter & Analisis Data CSV](#task-1-filter--analisis-data-csv)
   - [Task 2: Log Processing](#task-2-log-processing)
   - [Task 3: User Management & File Handling](#task-3-user-management--file-handling)
   - [Task 4: System Monitoring & Automation](#task-4-system-monitoring--automation)
   - [Playground Directory](#playground-directory)

3. [Cara Menggunakan Repository](#cara-menggunakan-repository-ini)
4. [Sumber Daya Tambahan](#sumber-daya-tambahan)

---

## Materi Modul 1

### Pengenalan Linux

**Capaian Pembelajaran:**
- Memahami perintah dasar Linux
- Membuat shell script sederhana
- Mengotomatisasi script menggunakan cron

**Prasyarat:**
- OS Linux sudah terinstall
- Pemahaman dasar tentang konsep Linux

---

### Perintah dan Navigasi

#### Perintah Navigasi File dan Direktori

| Command | Kegunaan |
|---------|----------|
| `cd` | Pindah direktori |
| `ls` | Melihat isi direktori |
| `ll` atau `ls -l` | Melihat isi direktori dengan detail |
| `pwd` | Melihat direktori aktif (current directory) |
| `find <nama file>` | Mencari file |
| `locate <nama file>` | Mencari file (lebih cepat dari find) |
| `tree` | Menampilkan struktur direktori dalam bentuk pohon |

#### Perintah Manipulasi File dan Direktori

| Command | Kegunaan |
|---------|----------|
| `cp <asal> <tujuan>` | Menyalin file |
| `mv <asal> <tujuan>` | Memindahkan atau mengganti nama file |
| `rm <file>` | Menghapus file |
| `rm -r <direktori>` | Menghapus direktori dan isinya |
| `touch <file>` | Membuat file kosong atau update timestamp |
| `mkdir <nama folder>` | Membuat folder |
| `mkdir -p <path>` | Membuat folder dan parent folders |
| `cat <file>` | Melihat isi file |
| `less <file>` | Melihat isi file dengan paging |
| `head -n 10 <file>` | Melihat 10 baris pertama file |
| `tail -n 10 <file>` | Melihat 10 baris terakhir file |
| `echo <teks>` | Menampilkan teks |
| `sed` | Melakukan filter dan modifikasi teks |
| `awk` | Operasi teks dan data processing |

#### Perintah User dan Permission

| Command | Kegunaan |
|---------|----------|
| `sudo <perintah>` | Menjalankan perintah dengan hak akses super user |
| `su <user>` | Mengganti user |
| `passwd` | Mengganti password pengguna saat ini |
| `passwd <user>` | Mengganti password user lain (hanya root) |
| `who` | Menampilkan daftar user yang sedang login |
| `whoami` | Menampilkan user saat ini |
| `chmod <mode> <file>` | Mengganti hak akses file |
| `chown <user>:<group> <file>` | Mengganti kepemilikan file |
| `chgrp <group> <file>` | Mengganti grup kepemilikan file |

#### Perintah Lainnya

| Command | Kegunaan |
|---------|----------|
| `history` | Melihat riwayat perintah |
| `grep <pattern> <file>` | Mencari kata dalam file |
| `grep -r <pattern> <direktori>` | Mencari kata secara rekursif |
| `sort <file>` | Mengurutkan baris dalam file |
| `uniq` | Menghapus duplikat baris (perlu di-sort dulu) |
| `ps` | Menampilkan proses yang sedang berjalan |
| `kill <PID>` | Menghentikan program dengan PID tertentu |
| `killall <nama program>` | Menghentikan semua proses dengan nama tersebut |
| `tar -cvf <nama.tar> <file/dir>` | Mengarsip file/direktori |
| `tar -xvf <nama.tar>` | Ekstrak file tar |
| `gzip <file>` | Mengkompres file |
| `gunzip <file.gz>` | Mengekstrak file gz |
| `zip <nama.zip> <file/dir>` | Mengkompres file (format zip) |
| `unzip <nama.zip>` | Mengekstrak file zip |
| `ssh <user@host>` | Akses jarak jauh ke server |
| `scp <file> <user@host:/path>` | Salin file via SSH |
| `du -sh <path>` | Menampilkan ukuran direktori |
| `df -h` | Menampilkan ruang disk yang digunakan |
| `free -m` | Menampilkan penggunaan memori |
| `quota` | Menampilkan sisa ruang disk pengguna |
| `jobs` | Menampilkan daftar proses background |
| `ifconfig` atau `ip addr` | Melihat konfigurasi IP |
| `ping <host>` | Menguji koneksi ke host |
| `netstat` | Menampilkan koneksi jaringan |
| `date` | Menampilkan tanggal dan waktu saat ini |
| `date "+%Y-%m-%d"` | Format tanggal khusus |
| `top` | Melihat proses secara real-time |
| `htop` | Versi interaktif dari top |
| `clear` | Membersihkan terminal |
| `whoami` | Menampilkan user saat ini |

#### Contoh Penggunaan

```bash
# Navigasi direktori
cd /home/user
pwd
ls -la

# Membuat dan memanipulasi file
mkdir my_folder
cd my_folder
touch file.txt
echo "Hello World" > file.txt
cat file.txt

# Copy dan move
cp file.txt file_backup.txt
mv file_backup.txt backup/

# Mencari file
find . -name "*.txt"
grep "Hello" file.txt

# Permission
chmod 755 script.sh
chown user:group file.txt

# Melihat informasi sistem
df -h
free -m
ps aux
```

---

### User dan Permission

#### Konsep User

Pada sistem Linux, setiap aksi dijalankan oleh pengguna tertentu. Setiap pengguna memiliki:
- **Username**: Nama unik pengguna
- **UID (User ID)**: Nomor identitas unik pengguna
- **Password**: Kata sandi untuk autentikasi
- **Home Directory**: Direktori pribadi pengguna (biasanya `/home/username`)
- **Shell**: Command interpreter yang digunakan (biasanya `/bin/bash`)

#### Konsep Permission (Hak Akses)

Setiap file dan direktori memiliki hak akses yang menentukan siapa yang dapat:
- **Read (r)**: Membaca file atau melihat isi direktori
- **Write (w)**: Mengubah file atau membuat/menghapus file dalam direktori
- **Execute (x)**: Menjalankan file atau masuk ke direktori

**Format Permission:**
```
drwxr-xr-x
│││││││││
││││││││└─ Others: Execute
│││││││└── Others: Write
││││││└─── Others: Read
│││││└──── Group: Execute
││││└───── Group: Write
│││└────── Group: Read
││└─────── Owner: Execute
│└──────── Owner: Write
└───────── Owner: Read
          Owner Type (- untuk file, d untuk direktori)
```

**Representasi Numerik:**
```
Read (r)    = 4
Write (w)   = 2
Execute (x) = 1

rwx = 4+2+1 = 7
r-x = 4+0+1 = 5
r-- = 4+0+0 = 4
-w- = 0+2+0 = 2
--x = 0+0+1 = 1
```

#### Contoh Permission

```bash
# Melihat permission
ls -l file.txt
# Output: -rw-r--r-- 1 user group 1024 Mar 13 10:00 file.txt

# Mengubah permission
chmod 755 script.sh    # rwxr-xr-x (user baca/tulis/eksekusi, group dan others hanya baca/eksekusi)
chmod 644 file.txt     # rw-r--r-- (user baca/tulis, group dan others hanya baca)
chmod 600 secret.txt   # rw------- (hanya user yang bisa akses)
chmod +x script.sh     # Tambahkan executable untuk semua
chmod -w file.txt      # Hapus write untuk semua

# Mengubah ownership
chown user:group file.txt     # Ubah owner dan group
chown -R user:group folder/   # Ubah permission rekursif
sudo chown root:root file.txt # Ubah ke root (perlu sudo)
```

---

### Text Editor

#### Nano

Nano adalah text editor yang user-friendly dengan shortcut yang ditampilkan di bawah layar.

```bash
# Membuka file
nano filename.txt

# Shortcut penting
Ctrl + O  # Save file
Ctrl + X  # Exit
Ctrl + K  # Cut line
Ctrl + U  # Paste
Ctrl + W  # Search
Ctrl + G  # Help
```

#### Vim

Vim adalah text editor yang powerful dengan fitur lengkap namun kurva pembelajaran yang lebih curam.

```bash
# Membuka file
vim filename.txt

# Mode navigasi
i       # Insert mode
Esc     # Normal mode
:w      # Save
:q      # Quit
:wq     # Save dan quit
:q!     # Quit tanpa save
:e!     # Reload file
u       # Undo
Ctrl+R  # Redo
```

---

## Shell Scripting

### Pengertian Shell

**Shell** adalah interface antara user dan kernel (inti sistem operasi). Shell bertindak sebagai command interpreter yang memproses perintah dari user.

### Struktur Shell Script Dasar

```bash
#!/bin/bash          # Shebang - menunjukkan interpreter yang digunakan
# Ini adalah komentar

# Variabel
nama="Budi"
umur=20

# Echo untuk menampilkan output
echo "Halo, $nama"
echo "Umur saya: $umur tahun"
```

### Variabel

#### Deklarasi Variabel

```bash
#!/bin/bash

# String
nama="Budi"
alamat='Jalan Merdeka 1'

# Number
umur=20
harga=15000
berat=65.5

# Array
buah=('apel' 'jeruk' 'mangga')
angka=(1 2 3 4 5)

# Variabel dari output command
tanggal=$(date)
tanggal=$(date '+%Y-%m-%d')
jumlah_file=$(ls -1 | wc -l)
```

#### Tipe Variabel Khusus

```bash
$0      # Nama script
$1, $2  # Parameter pertama, kedua, dst
$*      # Semua parameter
$#      # Jumlah parameter
$?      # Exit code perintah terakhir
$$      # PID (Process ID) script saat ini
$!      # PID background job terakhir
```

#### Contoh dengan Parameter

```bash
#!/bin/bash
# script: greet.sh

echo "Nama script: $0"
echo "Parameter 1: $1"
echo "Parameter 2: $2"
echo "Jumlah parameter: $#"
```

```bash
# Menjalankan script
./greet.sh Budi 20
# Output:
# Nama script: ./greet.sh
# Parameter 1: Budi
# Parameter 2: 20
# Jumlah parameter: 2
```

### Input dan Output

#### Output

```bash
#!/bin/bash

# Echo untuk print
echo "Hello, World!"
echo "Nilai: $angka"

# Printf untuk format tertentu
printf "Nama: %s, Umur: %d\n" "$nama" "$umur"

# Redirect ke file
echo "Data baru" > file.txt        # Overwrite
echo "Data tambahan" >> file.txt   # Append
```

#### Input

```bash
#!/bin/bash

# Read dari user
echo "Siapa nama Anda?"
read nama
echo "Halo, $nama"

# Read multiple variables
echo "Input nama dan umur:"
read nama umur
echo "Nama: $nama, Umur: $umur"

# Read dengan prompt
read -p "Masukkan nama: " nama

# Read password (tidak ditampilkan)
read -sp "Masukkan password: " password
```

### Quoting

Quoting digunakan untuk mengamankan string yang mengandung spasi atau karakter khusus.

```bash
#!/bin/bash

# Single quote - literal string
echo 'Value: $angka'       # Output: Value: $angka

# Double quote - variable dievaluasi
echo "Value: $angka"       # Output: Value: 20

# Backslash - escape karakter
echo "He said \"Hello\""    # Output: He said "Hello"

# Command substitution
echo "Hari ini: $(date)"
echo "Hari ini: `date`"     # Cara lama (backtick)
```

### Operator

#### Operator Aritmatika

```bash
#!/bin/bash

a=10
b=3

# Arithmetic expansion dengan ((  ))
echo $((a + b))    # 13
echo $((a - b))    # 7
echo $((a * b))    # 30
echo $((a / b))    # 3
echo $((a % b))    # 1
echo $((a ** b))   # 1000

# Operator increment/decrement
((a++))
((++a))
((a--))
((--a))
```

#### Operator String

```bash
#!/bin/bash

str1="hello"
str2="world"

# Concatenation
result="$str1 $str2"
echo $result        # hello world

# String length
echo ${#str1}       # 5

# Substring
echo ${str1:0:3}    # hel (dari index 0, panjang 3)
echo ${str1:1}      # ello (dari index 1 hingga akhir)

# String replacement
str="hello world hello"
echo ${str//hello/hi}     # hi world hi
echo ${str/hello/hi}      # hi world hello (hanya yang pertama)

# Check if string empty
if [ -z "$str" ]; then
    echo "String kosong"
fi
```

#### Operator Perbandingan (Numerik)

```bash
#!/bin/bash

a=10
b=5

# Perbandingan numerik (gunakan -eq, -ne, -lt, -gt, -le, -ge)
if [ $a -eq $b ]; then echo "Sama"; fi
if [ $a -ne $b ]; then echo "Tidak sama"; fi
if [ $a -lt $b ]; then echo "$a lebih kecil dari $b"; fi        # Less than
if [ $a -gt $b ]; then echo "$a lebih besar dari $b"; fi        # Greater than
if [ $a -le $b ]; then echo "$a <= $b"; fi                      # Less or equal
if [ $a -ge $b ]; then echo "$a >= $b"; fi                      # Greater or equal
```

#### Operator Perbandingan (String)

```bash
#!/bin/bash

str1="hello"
str2="hello"
str3="world"

# Perbandingan string
if [ "$str1" = "$str2" ]; then echo "String sama"; fi
if [ "$str1" != "$str3" ]; then echo "String berbeda"; fi
if [ -z "$str1" ]; then echo "String kosong"; fi
if [ -n "$str1" ]; then echo "String tidak kosong"; fi
```

#### Operator File

```bash
#!/bin/bash

file="test.txt"

# Test file
if [ -f $file ]; then echo "File exists"; fi            # File ada
if [ -d $file ]; then echo "Direktori exists"; fi       # Direktori ada
if [ -e $file ]; then echo "File atau direktori ada"; fi
if [ -r $file ]; then echo "File readable"; fi          # Readable
if [ -w $file ]; then echo "File writable"; fi          # Writable
if [ -x $file ]; then echo "File executable"; fi        # Executable
if [ -s $file ]; then echo "File tidak kosong"; fi      # File size > 0
```

#### Operator Logika

```bash
#!/bin/bash

a=10
b=5

# AND (&&)
if [ $a -gt $b ] && [ $a -lt 20 ]; then
    echo "Kondisi AND terpenuhi"
fi

# OR (||)
if [ $a -eq $b ] || [ $a -gt $b ]; then
    echo "Kondisi OR terpenuhi"
fi

# NOT (!)
if [ ! $a -eq $b ]; then
    echo "Kondisi NOT terpenuhi"
fi

# Dalam test command dengan -a dan -o
if [ $a -gt $b -a $a -lt 20 ]; then
    echo "AND terpenuhi"
fi
```

### Percabangan

#### if-else

```bash
#!/bin/bash

umur=20

if [ $umur -lt 18 ]; then
    echo "Anda masih anak-anak"
elif [ $umur -lt 60 ]; then
    echo "Anda adalah dewasa"
else
    echo "Anda sudah lansia"
fi
```

#### case-esac

```bash
#!/bin/bash

echo "Pilih buah favorit:"
echo "1. Apel"
echo "2. Jeruk"
echo "3. Mangga"
read pilihan

case $pilihan in
    1)
        echo "Anda memilih Apel"
        ;;
    2)
        echo "Anda memilih Jeruk"
        ;;
    3)
        echo "Anda memilih Mangga"
        ;;
    *)
        echo "Pilihan tidak valid"
        ;;
esac
```

### Perulangan

#### for Loop

```bash
#!/bin/bash

# Loop dengan range
for i in {1..5}; do
    echo "Nomor: $i"
done

# Loop dengan list
for buah in apel jeruk mangga; do
    echo "Buah: $buah"
done

# Loop dengan array
arr=('a' 'b' 'c')
for item in "${arr[@]}"; do
    echo "Item: $item"
done

# Loop dengan C-style
for ((i=0; i<5; i++)); do
    echo "Index: $i"
done

# Loop dengan command output
for file in $(ls *.txt); do
    echo "File: $file"
done
```

#### while Loop

```bash
#!/bin/bash

# Basic while loop
counter=1
while [ $counter -le 5 ]; do
    echo "Counter: $counter"
    ((counter++))
done

# Infinite loop (dengan break)
while true; do
    echo "Masukkan angka (0 untuk keluar):"
    read angka
    if [ $angka -eq 0 ]; then
        break
    fi
    echo "Anda input: $angka"
done
```

#### until Loop

```bash
#!/bin/bash

counter=1
until [ $counter -gt 5 ]; do
    echo "Counter: $counter"
    ((counter++))
done
```

### Fungsi

```bash
#!/bin/bash

# Deklarasi fungsi - cara 1
function greet() {
    echo "Halo, $1!"
    echo "Selamat datang"
}

# Deklarasi fungsi - cara 2
add() {
    local result=$(($1 + $2))
    echo $result
}

# Memanggil fungsi
greet "Budi"

# Fungsi dengan return value
sum=$(add 5 3)
echo "Hasil: $sum"

# Fungsi dengan variabel lokal
calculate() {
    local a=$1
    local b=$2
    local result=$((a * b))
    echo "Perkalian $a dan $b = $result"
    return $result
}

calculate 4 5
echo "Return code: $?"
```

---

## Cron Jobs

Cron adalah daemon (layanan background) yang mengeksekusi perintah pada waktu yang ditentukan.

### Pengertian Cron

Cron memungkinkan Anda untuk menjadwalkan script atau perintah untuk berjalan secara otomatis pada interval tertentu.

### Pembuatan Cron Jobs

#### Format Crontab

```
┌───────────── menit (0-59)
│ ┌───────────── jam (0-23)
│ │ ┌───────────── hari bulan (1-31)
│ │ │ ┌───────────── bulan (1-12)
│ │ │ │ ┌───────────── hari minggu (0-6) [0 dan 7 adalah Minggu]
│ │ │ │ │
│ │ │ │ │
* * * * * perintah yang akan dijalankan
```

#### Contoh Crontab

```bash
# Edit crontab
crontab -e

# Contoh schedule:

# Setiap hari jam 9 pagi
0 9 * * * /home/user/script.sh

# Setiap 5 menit
*/5 * * * * /home/user/script.sh

# Setiap hari Senin jam 10 pagi
0 10 * * 1 /home/user/script.sh

# Setiap hari pada jam 12 malam (00:00)
0 0 * * * /home/user/script.sh

# Setiap jam (00:00, 01:00, 02:00, dst)
0 * * * * /home/user/script.sh

# Setiap hari pada jam 10 pagi dan 3 sore
0 10,15 * * * /home/user/script.sh

# Setiap hari kerja pada jam 9 pagi
0 9 * * 1-5 /home/user/script.sh

# 1 Januari setiap tahun
0 0 1 1 * /home/user/backup.sh
```

#### Melihat dan Mengelola Cron

```bash
# Melihat crontab user saat ini
crontab -l

# Melihat crontab user lain (hanya root)
sudo crontab -u username -l

# Menghapus crontab user saat ini
crontab -r

# Melihat log cron
sudo journalctl -u cron
sudo tail -f /var/log/syslog | grep CRON
```

---

## AWK

AWK adalah tool untuk memproses dan menganalisis file teks, khususnya file yang terstruktur seperti CSV.

### Pengertian AWK

AWK adalah bahasa pemrograman yang dirancang untuk pemrosesan teks dan data. AWK dibaca baris per baris dan memproses setiap field (kolom) secara terpisah.

### Struktur Dasar AWK

```bash
awk 'pattern { action }' filename
```

**Contoh:**
```bash
# Mencetak seluruh baris
awk '{ print }' file.txt

# Mencetak field pertama
awk '{ print $1 }' file.txt

# Mencetak field pertama dan ketiga
awk '{ print $1, $3 }' file.txt

# Mencetak dengan kondisi
awk '$2 > 50 { print $1 }' file.txt
```

### BEGIN dan END

```bash
# BEGIN - dijalankan sebelum membaca file
awk 'BEGIN { print "Mulai proses..." }'

# END - dijalankan setelah membaca file
awk 'END { print "Selesai..." }' file.txt

# Contoh lengkap
awk 'BEGIN { sum=0 } { sum += $1 } END { print "Total: " sum }' file.txt
```

### Field Separator

Secara default, AWK menggunakan spasi sebagai pemisah field. Untuk mengubahnya:

```bash
# CSV dengan koma sebagai pemisah
awk -F',' '{ print $1, $2 }' data.csv

# Atau use FS variable
awk 'BEGIN { FS="," } { print $1, $2 }' data.csv

# Mengubah output separator
awk -F',' 'BEGIN { OFS="|" } { print $1, $2 }' data.csv
```

### Variabel AWK

```bash
NR      # Nomor record (baris) saat ini
NF      # Jumlah field (kolom) pada baris saat ini
$0      # Seluruh baris
$1      # Field pertama
$2      # Field kedua, dst
$NF     # Field terakhir
$(NF-1) # Field kedua terakhir

FS      # Field separator (default: spasi)
OFS     # Output field separator (default: spasi)
RS      # Record separator (default: newline)
ORS     # Output record separator (default: newline)
```

### Contoh AWK

#### Contoh 1: Membaca File CSV

```bash
# File: data.csv
name,age,salary
John,25,5000
Jane,30,6000
Bob,28,5500

# Mencetak nama dan gaji
awk -F',' 'NR>1 { print $1 ": " $3 }' data.csv
# Output:
# John: 5000
# Jane: 6000
# Bob: 5500
```

#### Contoh 2: Filter dan Hitung

```bash
# Menghitung total gaji untuk age > 25
awk -F',' 'NR>1 && $2 > 25 { sum += $3 } END { print "Total: " sum }' data.csv
# Output: Total: 11500
```

#### Contoh 3: Format Output

```bash
# Menampilkan dengan format khusus
awk -F',' 'NR>1 { printf "%-10s %3d %7d\n", $1, $2, $3 }' data.csv
# Output:
# John         25   5000
# Jane         30   6000
# Bob          28   5500
```

### Operator dan Fungsi AWK Umum

```bash
# Operator String
str = "hello"
substr(str, 1, 3)      # "hel"
length(str)            # 5
index(str, "ll")       # 3
tolower(str)           # "hello" (lowercase)
toupper(str)           # "HELLO" (uppercase)
gsub(/o/, "0", str)    # Ganti "o" dengan "0"

# Operator Matematika
int(5.7)       # 5
sqrt(16)       # 4
sin(), cos(), atan2()

# Match
if (str ~ /ll/) print "Cocok"           # Jika cocok pattern
if (str !~ /ll/) print "Tidak cocok"    # Jika tidak cocok

# Split
split(str, arr, ",")   # Bagi string berdasarkan delimiter
```

## Tips dan Trik

### Debugging Script Bash

```bash
# Tampilkan setiap perintah sebelum dijalankan
bash -x script.sh

# Atau tambahkan di dalam script
set -x          # Enable debug mode
set +x          # Disable debug mode

# Check syntax tanpa menjalankan
bash -n script.sh

# Verbose mode
bash -v script.sh
```

### Menggunakan grep dan pipe

```bash
# Cari pattern dan tampilkan 2 baris sebelum dan sesudah
grep -B2 -A2 "pattern" file.txt

# Cari pattern dan hitung
grep -c "pattern" file.txt

# Cari case-insensitive
grep -i "Pattern" file.txt

# Kombinasikan dengan pipe
cat file.log | grep "ERROR" | wc -l
```

### Handle Error dengan Exit Code

```bash
#!/bin/bash

command_yang_mungkin_error
if [ $? -ne 0 ]; then
    echo "Terjadi error!"
    exit 1
fi

# Atau gunakan logical operators
command_yang_mungkin_error || echo "Terjadi error!"
command_yang_mungkin_error && echo "Berhasil!"
```

### Redirect Output dan Error

```bash
# Redirect stdout ke file
command > output.txt

# Redirect stderr ke file  
command 2> error.txt

# Redirect dari dan ke file
command < input.txt > output.txt

# Redirect stdout dan stderr ke file yang sama
command &> output_and_error.txt
command > output.txt 2>&1

# Append mode
command >> output.txt

# Discard output
command > /dev/null
command 2>&1 > /dev/null
```

---

---

## Contoh Soal dan Solusi

### Daftar Task

Workspace ini menyediakan beberapa contoh soal dan solusi yang dapat dijadikan referensi:

#### [Task 1: Filter & Analisis Data CSV](contoh-soal-dan-solusi/task-1-social-media-analysis/)
**Topik:** AWK, Data Processing, Pattern Matching

Praktik menggunakan AWK untuk:
- Filter data berdasarkan kondisi multiple (pattern matching)
- Mencari data dengan regex (mengandung angka, tidak mengandung underscore)
- Aggregasi data per kategori

**File:**
- `products.csv` - Sample data produk
- `solution_1a.sh` - Filter produk berdasarkan kriteria
- `solution_1b.sh` - Hitung total stock per kategori

---

#### [Task 2: Log Processing](contoh-soal-dan-solusi/task-2-server-logs/)
**Topik:** Text Processing, Data Aggregation, Join Operation

Praktik menggunakan:
- `awk`, `grep`, `sort`, `uniq` untuk processing log file
- Counting dan aggregation
- Join data dari multiple files (logs dan user mapping)

**File:**
- `access.log` - Sample server access log
- `users.csv` - User IP mapping
- `solution_2a.sh` - Hitung request per IP
- `solution_2b.sh` - Join log dengan user data

---

#### [Task 3: User Management & File Handling](contoh-soal-dan-solusi/task-3-user-management/)
**Topik:** Input Validation, File I/O, String Manipulation, Logging

Praktik membuat script untuk:
- Validasi password (panjang, karakter khusus, huruf besar, angka)
- Simpan data terstruktur ke file
- Catat aktivitas ke log dengan timestamp

**File:**
- `register.sh` - Script registrasi user dengan validasi
- `users.txt` - File penyimpanan user (format: username:password)
- `log.txt` - File log aktivitas registrasi

---

#### [Task 4: System Monitoring & Automation](contoh-soal-dan-solusi/task-4-system-logs/)
**Topik:** System Commands, Data Collection, Automation, Logging

Praktik mengumpulkan dan mencatat:
- Penggunaan RAM dengan `free -m`
- Ukuran folder dengan `du -sh`
- Simpan metrics ke file dengan timestamp
- Dapat dijadwalkan dengan cron untuk monitoring otomatis

**File:**
- `monitor.sh` - Script monitoring sistem
- `metrics_YYYYMMDD.log` - File log hasil monitoring

---

### Playground Directory

Folder `playground/` berisi berbagai script latihan untuk praktek:

**Shell Scripts:**
- `hello.sh` - Hello world dasar
- `variable.sh` - Deklarasi dan penggunaan variabel
- `quoting.sh` - Single quote, double quote, escaping
- `if-else.sh` - Percabangan if-else-elif
- `relational.sh` - Operator perbandingan
- `logical.sh` - Operator logika (AND, OR, NOT)
- `arithmetic.sh` - Operasi aritmatika
- `special.sh` - Variabel special ($0, $1, $#, $?, dll)
- `for-c.sh` - For loop gaya C
- `for-in.sh` - For loop iterasi list
- `for-array.sh` - For loop dengan array
- `while.sh` - While loop
- `function.sh` - Deklarasi dan pemanggilan fungsi



## Sumber Daya Tambahan

### Online Resources
- [GNU Bash Manual](https://www.gnu.org/software/bash/manual/)
- [AWK Tutorial](https://www.gnu.org/software/gawk/manual/)
- [Linux Command Reference](https://linux.die.net/man/)
- [ShellCheck](https://www.shellcheck.net/) - Online bash script checker
