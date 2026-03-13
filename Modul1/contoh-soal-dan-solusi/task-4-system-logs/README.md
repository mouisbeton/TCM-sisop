# Contoh Soal 4 - System Monitoring & Automation

## Soal

Buat script `monitor.sh` yang:

1. Catat penggunaan RAM dengan `free -m`
2. Catat ukuran folder `/tmp` dengan `du -sh`
3. Catat hasil ke file: `metrics_YYYYMMDD.log`
4. Format: `TIMESTAMP | RAM_USED | FOLDER_SIZE`

**Jawaban Lengkap dengan Breakdown:**

```bash
#!/bin/bash

# Dapatkan RAM terpakai
RAM_USED=$(free -m | awk 'NR==2 {print $3}')

# Dapatkan ukuran folder /tmp
FOLDER_SIZE=$(du -sh /tmp | awk '{print $1}')

# Dapatkan timestamp
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Tentukan nama file
LOG_FILE="metrics_$(date +%Y%m%d).log"

# Simpan ke file
echo "$TIMESTAMP | ${RAM_USED}MB | $FOLDER_SIZE" >> "$LOG_FILE"

echo "Log tersimpan: $LOG_FILE"
```

**Breakdown Solusi:**

1. **RAM Extraction:**
   ```bash
   RAM_USED=$(free -m | awk 'NR==2 {print $3}')
   ```
   - `free -m` = Memory usage dalam MB
   - `NR==2` = Baris ke-2 (summary line)
   - `$3` = Field ke-3 (used memory)
   - Contoh output: `4532`

2. **Folder Size Extraction:**
   ```bash
   FOLDER_SIZE=$(du -sh /tmp | awk '{print $1}')
   ```
   - `du -sh /tmp` = Disk usage folder /tmp
     - `-s` = summary (total saja)
     - `-h` = human-readable (M, G, etc)
   - `$1` = Extract size value
   - Contoh output: `256M`

3. **Timestamp:**
   ```bash
   TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
   ```
   - Format: YYYY-MM-DD HH:MM:SS
   - Contoh: `2026-03-13 15:30:45`

4. **Dynamic Filename:**
   ```bash
   LOG_FILE="metrics_$(date +%Y%m%d).log"
   ```
   - Filename berisi tanggal YYYYMMDD
   - Contoh: `metrics_20260313.log`
   - File baru setiap hari

5. **Data Logging:**
   ```bash
   echo "$TIMESTAMP | ${RAM_USED}MB | $FOLDER_SIZE" >> "$LOG_FILE"
   ```
   - Append format: `timestamp | memory | size`
   - `>>` = append (jangan overwrite)
   - Contoh: `2026-03-13 15:30:45 | 4532MB | 256M`

**Command Substitution:**
- `$(command)` = Jalankan command dan simpan output ke variable
- Alternative: backtick ``` `command` ```

**Contoh Output File:**
```
2026-03-13 15:30:45 | 4532MB | 256M
2026-03-13 15:35:50 | 4645MB | 312M
2026-03-13 15:40:15 | 4501MB | 289M
```

**Contoh output file:**
```
2024-03-13 10:15:30 | 4532MB | 256M
2024-03-13 10:20:45 | 4645MB | 312M
2024-03-13 10:25:50 | 4501MB | 289M
```

---
