# Contoh Soal dan Solusi - Modul 2: Sistem Operasi

Folder ini berisi contoh soal dan solusi untuk **Modul 2 Sistem Operasi**. Setiap task dirancang untuk membantu Anda memahami konsep fundamental sistem operasi seperti proses, pipes, shared memory, dan threads.

## Struktur Folder

```
contoh-soal-dan-solusi/
  - task-1-processes-dan-fork/           (Proses dan Fork)
  - task-2-pipes-dan-komunikasi/         (Pipes dan Komunikasi IPC)
  - task-3-shared-memory/                (Shared Memory)
  - task-4-threads/                      (Threads dan Concurrent Programming)
```

---

## Daftar Task

### **Task 1: Processes dan Fork**
**Topik:** Pembuatan proses, parent-child relationship, `fork()`, `wait()`

**Subsoal:**
- **a) Parent-Child Processes** - Membuat 2 child processes dan synchronization
- **b) Proses dengan Arguments** - Menerima parameter dan conditional logic

**Konsep Penting:**
- `fork()` menghasilkan duplicate process
- Parent dan child berbeda PID
- `wait()` untuk synchronization
- Passing arguments ke program

**File:**
- [README.md](task-1-processes-dan-fork/README.md) - Penjelasan lengkap
- [solution_1a.c](task-1-processes-dan-fork/solution_1a.c) - Solusi soal a
- [solution_1b.c](task-1-processes-dan-fork/solution_1b.c) - Solusi soal b

---

### **Task 2: Pipes dan Komunikasi Antar Proses**
**Topik:** Inter-Process Communication (IPC) dengan pipes, one-way communication

**Subsoal:**
- **a) Pipe Sederhana** - Parent menulis, child membaca
- **b) Bidirectional Communication** - Dua pipes untuk komunikasi zwei arah

**Konsep Penting:**
- Pipe adalah one-way communication channel
- `fd[0]` untuk membaca, `fd[1]` untuk menulis
- Harus tutup file descriptor yang tidak digunakan
- Dua pipes diperlukan untuk bidirectional communication

**File:**
- [README.md](task-2-pipes-dan-komunikasi/README.md) - Penjelasan lengkap
- [solution_2a.c](task-2-pipes-dan-komunikasi/solution_2a.c) - Solusi soal a
- [solution_2b.c](task-2-pipes-dan-komunikasi/solution_2b.c) - Solusi soal b

---

### **Task 3: Shared Memory**
**Topik:** IPC dengan shared memory, direct memory sharing, race conditions

**Subsoal:**
- **a) Shared Memory Dasar** - Parent menulis struct, child membaca dan modify
- **b) Multiple Processes** - 2 children yang akses shared memory bersamaan

**Konsep Penting:**
- Shared memory lebih efisien dari pipe karena tidak ada copying
- `ftok()` generate unique key
- `shmget()` create/access shared memory
- `shmat()` attach ke address space
- `shmdt()` detach
- Race condition bisa terjadi tanpa synchronization

**File:**
- [README.md](task-3-shared-memory/README.md) - Penjelasan lengkap
- [solution_3a.c](task-3-shared-memory/solution_3a.c) - Solusi soal a
- [solution_3b.c](task-3-shared-memory/solution_3b.c) - Solusi soal b

---

### **Task 4: Threads**
**Topik:** Lightweight processes, concurrent programming, shared memory dalam satu proses

**Subsoal:**
- **a) Threads Sederhana** - Membuat 2 threads yang berjalan parallel
- **b) Threads dengan Shared Variable** - 3 threads mengakses shared counter

**Konsep Penting:**
- Thread lebih ringan dari process
- Semua threads dalam satu process berbagi memory space
- `pthread_create()` untuk membuat thread
- `pthread_join()` untuk wait thread selesai
- Hati-hati race conditions saat akses shared variable

**File:**
- [README.md](task-4-threads/README.md) - Penjelasan lengkap
- [solution_4a.c](task-4-threads/solution_4a.c) - Solusi soal a (compile: `gcc -pthread -o solution_4a solution_4a.c`)
- [solution_4b.c](task-4-threads/solution_4b.c) - Solusi soal b (compile: `gcc -pthread -o solution_4b solution_4b.c`)

---

## Cara Menggunakan

### Untuk setiap task:

1. **Baca README.md** untuk memahami konsep dan soal
2. **Lihat solusi** untuk referensi implementasi
3. **Compile dan test**:
   ```bash
   # Task 1, 2, 3 (tanpa pthread)
   gcc -o program_name solution_file.c
   ./program_name
   
   # Task 4 (dengan pthread)
   gcc -pthread -o program_name solution_file.c
   ./program_name
   ```

### Contoh:

```bash
# Task 1a
cd task-1-processes-dan-fork
gcc -o solution_1a solution_1a.c
./solution_1a

# Task 1b dengan argument
./solution_1b 42

# Task 2a
cd ../task-2-pipes-dan-komunikasi
gcc -o solution_2a solution_2a.c
./solution_2a

# Task 4a (dengan pthread)
cd ../task-4-threads
gcc -pthread -o solution_4a solution_4a.c
./solution_4a
```

---


## Catatan Penting

1. **Race Condition** - Mungkin muncul di Task 3b dan Task 4b tanpa mutex/semaphore
2. **Process ID** - Setiap kali run, PID berbeda (tergantung scheduler)
3. **Output Order** - Output dari multiple processes/threads tidak selalu urut
4. **Cleanup** - Task 3 menggunakan shared memory yang perlu dihapus dengan `ipcrm`
5. **Pthread** - Task 4 memerlukan flag `-pthread` saat compile

---

## Troubleshooting

### Shared Memory tidak terhapus:
```bash
# List shared memory
ipcs -m

# Remove shared memory dengan ID
ipcrm -m <id>
```

### Thread compilation error:
```bash
# SALAH
gcc -o program solution_4a.c

# BENAR
gcc -pthread -o program solution_4a.c
```

### Program deadlock/hang:
- Pastikan semua `read()` ada pasangan `write()`
- Pastikan tidak ada circular dependency
- Gunakan `timeout` saat develop

---

## Referensi Tambahan

- **Man pages**: `man fork`, `man pipe`, `man shmget`, `man pthread_create`
- **Online resources**: Linux man pages online
- **Course materials**: Lihat folder praktikum untuk soal-soal lebih kompleks

---

**Selamat belajar!**

