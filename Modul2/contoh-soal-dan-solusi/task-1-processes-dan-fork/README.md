# Contoh Soal 1 - Proses dan Fork

## Pengenalan Konsep

Dalam sistem operasi, setiap program yang berjalan adalah sebuah **proses**. Fungsi `fork()` memungkinkan sebuah proses membuat **child process** (proses anak) yang merupakan duplikasi dari parent process (proses induk).

**Karakteristik fork():**
- Proses induk dan anak memiliki **memory space yang terpisah**
- Keduanya mulai eksekusi dari baris sesudah `fork()`
- `fork()` mengembalikan nilai berbeda untuk parent dan child
  - Parent: `fork()` mengembalikan **PID anak**
  - Child: `fork()` mengembalikan **0**

---

## Soal a) Parent-Child Processes

Buatlah program C yang:
1. Program induk membuat **2 child processes**
2. **Child 1** menampilkan: `"I am child 1 with PID: <PID>"` sebanyak **3 kali**
3. **Child 2** menampilkan: `"I am child 2 with PID: <PID>"` sebanyak **3 kali**
4. **Parent** menampilkan: `"I am parent with PID: <PID>"`
5. Parent menunggu semua child selesai dengan `wait()`

### Jawaban:

```c
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>

int main() {
    pid_t pid1, pid2;
    
    // Membuat child process 1
    pid1 = fork();
    
    if (pid1 == 0) {
        // Child Process 1
        for (int i = 1; i <= 3; i++) {
            printf("I am child 1 with PID: %d\n", getpid());
            sleep(1);
        }
        return 0;
    }
    
    // Membuat child process 2
    pid2 = fork();
    
    if (pid2 == 0) {
        // Child Process 2
        for (int i = 1; i <= 3; i++) {
            printf("I am child 2 with PID: %d\n", getpid());
            sleep(1);
        }
        return 0;
    }
    
    // Parent Process
    printf("I am parent with PID: %d\n", getpid());
    
    // Menunggu semua child selesai
    wait(NULL);
    wait(NULL);
    
    return 0;
}
```

### Penjelasan Solusi:

1. **`pid1 = fork()`** - Membuat child process pertama
   - Di parent: `pid1` = PID anak
   - Di child 1: `pid1` = 0, maka masuk blok `if (pid1 == 0)`

2. **`if (pid1 == 0)`** - Cek apakah proses saat ini adalah child 1
   - Child 1 menampilkan pesannya dan `return 0` untuk keluar

3. **`pid2 = fork()`** - Membuat child process kedua (hanya di parent)
   - Setelah child 1 keluar, baris ini dieksekusi oleh parent dan child 2

4. **`if (pid2 == 0)`** - Cek apakah proses saat ini adalah child 2
   - Child 2 menampilkan pesannya dan `return 0`

5. **`wait(NULL)`** - Parent menunggu hingga child selesai
   - Dipanggil 2 kali untuk menunggu kedua child

### Output yang Diharapkan:

```
I am parent with PID: 1234
I am child 1 with PID: 1235
I am child 2 with PID: 1236
I am child 1 with PID: 1235
I am child 2 with PID: 1236
I am child 1 with PID: 1235
I am child 2 with PID: 1236
```

*(Urutan output mungkin berbeda karena scheduler OS)*

---

## Soal b) Process dengan Nilai Argument

Buatlah program C yang:
1. Program menerima **1 argument** berupa angka
2. Jika **angka genap**, tampilkan: `"<angka> is EVEN"`
3. Jika **angka ganjil**, tampilkan: `"<angka> is ODD"`
4. Buat **2 child processes**:
   - Child 1 menampilkan: `"Child 1: Processing <angka>"`
   - Child 2 menampilkan: `"Child 2: Processing <angka>"`
5. Parent menampilkan hasil ganjil/genap

### Jawaban:

```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <number>\n", argv[0]);
        return 1;
    }
    
    int number = atoi(argv[1]);
    pid_t pid1, pid2;
    
    // Membuat child process 1
    pid1 = fork();
    if (pid1 == 0) {
        printf("Child 1: Processing %d\n", number);
        return 0;
    }
    
    // Membuat child process 2
    pid2 = fork();
    if (pid2 == 0) {
        printf("Child 2: Processing %d\n", number);
        return 0;
    }
    
    // Parent Process - Check ganjil/genap
    if (number % 2 == 0) {
        printf("%d is EVEN\n", number);
    } else {
        printf("%d is ODD\n", number);
    }
    
    // Menunggu semua child selesai
    wait(NULL);
    wait(NULL);
    
    return 0;
}
```

### Penjelasan:

1. **`argc` dan `argv`** - Menerima command-line arguments
   - `argc` = jumlah argument (termasuk nama program)
   - `argv[0]` = nama program
   - `argv[1]` = angka yang diinput

2. **`atoi(argv[1])`** - Mengkonversi string menjadi integer

3. **`number % 2 == 0`** - Cek apakah genap atau ganjil

### Cara Menjalankan:

```bash
gcc -o solution_1b solution_1b.c
./solution_1b 10
```

### Output untuk input 10:

```
Child 1: Processing 10
Child 2: Processing 10
10 is EVEN
```

---

## Ringkasan Konsep Penting

| Konsep | Penjelasan |
|--------|-----------|
| `fork()` | Membuat child process yang identik dengan parent |
| Return value `fork()` | 0 = child, > 0 = parent (nilai adalah PID child) |
| `getpid()` | Mendapatkan PID dari proses saat ini |
| `wait()` | Menunggu child process selesai |
| `sleep()` | Menunda eksekusi selama N detik |
| `atoi()` | Mengkonversi string ke integer |

---

## Tips Debugging

1. **Gunakan `printf()` dengan PID** untuk melacak proses mana yang berjalan
2. **Gunakan `ps` command** di terminal lain untuk melihat proses yang sedang berjalan
3. **Jangan lupa `wait()`** agar tidak ada zombie process
4. **Order output tidak pasti** karena scheduler OS

