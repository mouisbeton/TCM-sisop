# Contoh Soal 2 - Log Processing

## Soal

Anda memiliki `access.log`:

```
192.168.1.5 [13/Mar/2024:10:15] GET /home 200
192.168.1.8 [13/Mar/2024:10:16] POST /login 200
192.168.1.5 [13/Mar/2024:10:17] GET /admin 404
192.168.1.8 [13/Mar/2024:10:18] GET /home 500
192.168.1.5 [13/Mar/2024:10:19] GET /home 200
```

Dan `users.csv`:
```
ip,username
192.168.1.5,Ahmad
192.168.1.8,Siti
```

**a) Hitung total request per IP**

**Jawaban:**
```bash
#!/bin/bash
awk '{print $1}' access.log | sort | uniq -c | awk '{print $2 ": " $1 " requests"}'
```

**Breakdown Solusi a):**

1. **`awk '{print $1}'`** - Extract field pertama (IP address)
   - Output: satu IP per baris

2. **`| sort`** - Sort untuk mengelompokkan IP yang sama
   - Contoh: IP muncul berurutan jika di-sort

3. **`| uniq -c`** - Count occurrences
   - Format output: `count IP_address`
   - Contoh: `3 192.168.1.5`

4. **`| awk '{print $2 ": " $1 " requests"}'`** - Format output
   - `$2` = IP address
   - `$1` = count
   - Output: `192.168.1.5: 3 requests`

Output:
```
192.168.1.5: 3 requests
192.168.1.8: 2 requests
```

**b) Cari username yang error 404 atau 500 terbanyak**

**Jawaban:**
```bash
#!/bin/bash
awk '$NF >= 400 {print $1}' access.log | sort | uniq -c | sort -rn | head -1 | awk '{ip=$2} END {
    while((getline < "users.csv") > 0) {
        split($0, a, ",")
        if(a[1]==ip) print a[2] ": " $1 " errors"
    }
}'
```

**Breakdown Solusi b):**

1. **`awk '$NF >= 400 {print $1}'`** - Filter error (status >= 400)
   - `$NF` = field terakhir (status code)
   - Extract IP dari setiap error

2. **`| sort | uniq -c`** - Count error per IP
   - Group dan count occurrences

3. **`| sort -rn | head -1`** - Ambil IP dengan error terbanyak
   - Sort descending (`-rn`)
   - Ambil baris pertama (`head -1`)

4. **AWK Join dengan CSV:**
   - `awk '{ip=$2} END {`
   - Read IP dari pipeline (field ke-2 dari uniq -c)
   - END block untuk membaca users.csv
   - `while((getline < "users.csv") > 0)` - Read file baris per baris
   - `split($0, a, ",")` - Split comma-separated values
   - `if(a[1]==ip) print a[2] ": " $1 " errors"` - Match dan print result

Output:
```
Ahmad: 1 errors
```
Ahmad: 1 errors
```

---
