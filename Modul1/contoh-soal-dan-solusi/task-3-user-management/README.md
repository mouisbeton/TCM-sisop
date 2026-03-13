# Contoh Soal 3 - User Management & File Handling

## Soal

Buat script yang menerima username dan password sebagai parameter, kemudian:

1. Validasi password (minimal 8 karakter, mengandung angka dan huruf besar)
2. Simpan ke file `users.txt` dengan format: `username:password`
3. Catat ke log file: `log.txt` dengan format: `[HH:MM:SS] User registered: USERNAME`

**Contoh jalankan:**
```bash
./register.sh john Pass1234
```

**Jawaban Lengkap dengan Breakdown:**

```bash
#!/bin/bash

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
```

**Breakdown Solusi:**

1. **Parameter Handling:**
   - `$1` = username (parameter pertama)
   - `$2` = password (parameter kedua)

2. **Password Validation (3 kondisi):**
   - **Kondisi 1:** `${#PASSWORD} -lt 8`
     - `${#var}` = string length
     - Harus >= 8 karakter
   
   - **Kondisi 2:** `[[ $PASSWORD =~ [0-9] ]]`
     - `=~` = regex matching
     - `[0-9]` = digit 0-9
     - Harus ada minimal 1 digit
   
   - **Kondisi 3:** `[[ $PASSWORD =~ [A-Z] ]]`
     - `[A-Z]` = uppercase letters
     - Harus ada minimal 1 uppercase
   
   - `exit 1` - Terminate jika validation gagal

3. **File Operations:**
   - `echo "$USERNAME:$PASSWORD" >> users.txt`
     - Append `username:password` ke file
     - `>>` = append (jangan overwrite)
   
   - `echo "[$(date +%H:%M:%S)] User registered: $USERNAME" >> log.txt`
     - Append log entry dengan timestamp
     - `$(date +%H:%M:%S)` = current time (HH:MM:SS)

4. **Success Message:**
   - Print konfirmasi registrasi berhasil

**Contoh Eksekusi:**
```bash
./register.sh john Pass1234
```

Validasi untuk `Pass1234`:
- Length: 9 >= 8 ✓
- Digit: `1234` ada ✓
- Uppercase: `P` ada ✓
- **RESULT:** Registrasi BERHASIL

Files yang dibuat:
- `users.txt`: `john:Pass1234`
- `log.txt`: `[15:30:45] User registered: john`

---
