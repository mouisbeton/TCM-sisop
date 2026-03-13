# Contoh Soal 1 - Filter & Analisis Data CSV

## Soal

Anda memiliki file `products.csv` yang berisi data produk:

```
id,name,price,stock,category
101,Product_X2000,50000,15,Electronics
102,Product_Y99,75000,8,Fashion
103,Item2024_Pro,120000,5,Electronics
104,Item_Z,45000,20,Fashion
105,Product2500,95000,3,Electronics
```

**a) Filter produk yang nama mengandung angka 2 dan TIDAK mengandung underscore, tampilkan hasilnya.**

**Jawaban:**
```bash
#!/bin/bash
awk -F',' 'NR>1 && $2 ~ /2/ && $2 !~ /_/ {print $2}' products.csv | sort
```

**Breakdown Solusi a):**

1. **`awk -F','`** - Set field separator ke koma
2. **`NR>1`** - Skip header (baris ke-1)
3. **`$2 ~ /2/`** - Field 2 (name) harus mengandung angka 2
4. **`$2 !~ /_/`** - Field 2 TIDAK boleh mengandung underscore
5. **`{print $2}`** - Print nama jika kondisi terpenuhi
6. **`| sort`** - Urutkan output

**Analisis:**
- `Product_X2000`: Ada 2 ✓, tapi ada _ ✗ → DITOLAK
- `Product2500`: Ada 2 ✓, tidak ada _ ✓ → **VALID**
- Lainnya: Tidak memenuhi kriteria → DITOLAK

Output:
```
Product2500
```

**b) Hitung total stock untuk setiap kategori.**

**Jawaban:**
```bash
#!/bin/bash
awk -F',' 'NR>1 {stock[$5]+=$4} END {for(cat in stock) print cat ": " stock[cat]}' products.csv
```

**Breakdown Solusi b):**

1. **`stock[$5]+=$4`** - Accumulation pattern
   - `$5` = kategori (key array)
   - `$4` = stock (value)
   - `+=` operator untuk increment

2. **`END { for(cat in stock) ... }`** - Loop setelah semua data dibaca
   - Loop setiap kategori di array
   - Print kategori dan totalnya

**Perhitungan:**
```
Electronics: 15 + 5 + 3 = 23
Fashion: 8 + 20 = 28
```

**Konsep:** Associative array untuk aggregasi data per kategori

Output:
```
Fashion: 28
Electronics: 23
```

---
