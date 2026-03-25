# Solution - Task 3: Ignatius Si Cloud Engineer

Dokumen ini menjelaskan tiap blok kode berdasarkan skrip yang ada.

## Subtask A - Register dan Login
**File rujukan:** register.sh, login.sh

### register.sh
**Kode (bagian inti):**
```bash
mkdir -p $home_path/cloud_storage
touch "$User_File" "$Log_File"

log_message() {
    echo "$(date '+%y/%m/%d %H:%M:%S') $1" >> "$Log_File"
}
```
**Penjelasan:**
- Membuat folder dan file penyimpanan data user serta log.
- Fungsi `log_message` mencatat aktivitas sesuai format waktu.

**Kode (validasi username):**
```bash
if grep -qi "^$lower_username:" <(tr 'A-Z' 'a-z' < "$User_File"); then
    log_message "REGISTER: ERROR User already exists"
    echo "Pengguna sudah ada. Tolong buat nama yang berbeda."
    continue
fi
```
**Penjelasan:**
- Mengecek duplikasi username tanpa peka huruf besar/kecil.
- Jika ada, tulis log error dan minta input ulang.

**Kode (validasi password):**
```bash
if [ ${#password} -lt 8 ]; then
    log_message "REGISTER: ERROR Password must be at least 8 characters"
    echo "Password harus memiliki setidaknya 8 karakter."
    continue
fi

if [[ ! "$password" =~ [A-Z] || ! "$password" =~ [0-9] || ! "$password" =~ [[:punct:]] ]]; then
    ...
    return 1
fi

if [[ "$password" == "$username" ]]; then
    log_message "REGISTER: ERROR Password cannot be the same as the username"
    echo "Password tidak boleh sama dengan nama pengguna."
    continue
fi
```
**Penjelasan:**
- Memastikan panjang minimal 8 karakter.
- Memastikan ada huruf kapital, angka, dan karakter spesial.
- Menolak password yang sama dengan username.

**Kode (penyimpanan):**
```bash
echo "$username:$password" >> "$User_File"
log_message "REGISTER: INFO User $username registered successfully"
```
**Penjelasan:**
- Menyimpan user dan password ke `users.txt`.
- Mencatat log sukses.

### login.sh
**Kode (cek sesi aktif):**
```bash
last_login=$(grep "LOGIN: INFO User" "$Log_File" | tail -1)
last_logout=$(grep "LOGOUT: INFO User" "$Log_File" | tail -1)

login_date=$(echo "$last_login" | awk '{print $1, $2}')
logout_date=$(echo "$last_logout" | awk '{print $1, $2}')

if [[ "$login_date" > "$logout_date" ]]; then
    active_user=$(echo "$last_login" | awk '{print $6}')
else
   active_user=" "
fi
```
**Penjelasan:**
- Membandingkan timestamp login terakhir dan logout terakhir.
- Jika login lebih baru, berarti ada user aktif.

**Kode (login/logout):**
```bash
if [[ $active_user != " " ]] ; then
    log_message "LOGIN: ERROR User $active_user is already logged in"
    echo "Pengguna $active_user sedang log in. Tolong log out terlebih dahulu."
    exit 1
fi
```
**Penjelasan:**
- Mencegah login baru jika masih ada user aktif.

## Subtask B - Otomasi Download
**File rujukan:** automation.sh, download.sh

### automation.sh
**Kode:**
```bash
if [[ $active_user != " " ]]; then
    crontab -l | grep -q "$script_path/download.sh" || (crontab -l 2>/dev/null; echo "*/2 * * * * $script_path/download.sh") | crontab -
    crontab -l | grep -q "$script_path/archive.sh" || (crontab -l 2>/dev/null; echo "0 */1 * * * $script_path/archive.sh") | crontab -
else
    crontab -l | grep -v $script_path/download.sh | crontab -
    crontab -l | grep -v $script_path/archive.sh | crontab -
fi
```
**Penjelasan:**
- Jika user aktif: pasang cron untuk download dan archive.
- Jika tidak aktif: hapus cron terkait.
- Catatan: interval di sini berbeda dengan spesifikasi README (download 2 menit, archive 1 jam).

### download.sh
**Kode:**
```bash
if [[ $active_user != " " ]]; then
    Download_Dir="$home_path/cloud_storage/downloads/$active_user"
    mkdir -p "$Download_Dir"
    count=$((RANDOM % 20 + 2))
    query="nature"
    imagelink=$(wget --user-agent 'Mozilla/5.0' -qO - "www.google.be/search?q=${query}\&tbm=isch" | sed 's/</\n</g' | grep '<img' | head -n"$count" | tail -n1 | sed 's/.*src="\([^"]*\)".*/\1/')
    Timestamp=$(date '+%H-%M_%d-%m-%Y')
    Jpg_File="$Download_Dir/$Timestamp.jpg"

    wget -O "$Jpg_File" "$imagelink"
fi
```
**Penjelasan:**
- Membuat folder download user aktif.
- Mengambil satu URL gambar dari hasil pencarian Google Images.
- Menyimpan gambar dengan format nama `HH-MM_DD-MM-YYYY.jpg`.

## Subtask C - Arsip Gambar
**File rujukan:** archive.sh

**Kode:**
```bash
Download_Dir="$home_path/cloud_storage/downloads/$active_user"
Archive_Dir="$home_path/cloud_storage/archives/$active_user"

mkdir -p "$Archive_Dir"

Timestamp=$(date '+%H-%d-%m-%Y')
Zip_File="$Archive_Dir/archive_$Timestamp.zip"

cd "$Download_Dir"
zip -r "$Zip_File" *.jpg

if [[ $? -eq 0 ]]; then
    rm *.jpg
fi
```
**Penjelasan:**
- Menentukan folder download dan archive milik user aktif.
- Membuat file ZIP `archive_HH-DD-MM-YYYY.zip`.
- Jika zip sukses, file JPG dihapus agar hemat storage.
