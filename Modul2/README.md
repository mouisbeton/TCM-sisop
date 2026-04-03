# Modul 2 Sistem Operasi

---

## Daftar Isi

1. [Materi Modul 2](#materi-modul-2)
   - [Pendahuluan](#pendahuluan)
   - [Proses](#proses)
   - [Thread](#thread)
   - [IPC (Interprocess Communication)](#ipc)

2. [Contoh Soal dan Solusi](#contoh-soal-dan-solusi)

3. [Playground Directory](#playground-directory)

4. [Cara Menggunakan Repository](#cara-menggunakan-repository-ini)
5. [Sumber Daya Tambahan](#sumber-daya-tambahan)

---

## Materi Modul 2

### Pengenalan Proses, Thread, dan IPC

**Capaian Pembelajaran:**
- Memahami apa itu proses, thread, dan IPC
- Mampu membedakan perbedaan proses dan thread
- Dapat membuat program dengan multiproses dan multithread

**Prasyarat:**
- Memahami dasar pemrograman C
- Lingkungan Linux dengan `gcc` terinstall
- Graspof *nix Command dan bash script

---

### Pendahuluan

#### Pengertian Proses

Pernahkah kalian membuka banyak aplikasi dalam laptop? Jika iya, maka kalian telah mengimplementasikan `proses`. Meskipun, kita sedang membuka satu aplikasi, tetapi aplikasi yang lain masih ada di latar belakang sebagai proses yang menunggu giliran.

Proses sendiri dapat didefinisikan sebagai **program yang sedang dieksekusi oleh OS**. Ketika suatu program tersebut dieksekusi oleh OS, proses tersebut memiliki **PID (Process ID)** yang merupakan identifier dari suatu proses. Pada UNIX, untuk melihat proses yang dieksekusi oleh OS dengan memanggil perintah shell `ps`. Untuk melihat lebih lanjut mengenai perintah `ps` dapat membuka `man ps`.

#### Pengertian Thread

Thread adalah **unit dasar dari eksekusi** yang dapat melakukan tugas-tugas tertentu di dalam sebuah proses. Thread-thread ini bekerja bersama-sama di dalam sebuah proses untuk menyelesaikan pekerjaan secara bersamaan. Mereka berbagi sumber daya dan konteks yang sama dengan proses utama di mana mereka berjalan.

Contoh dari thread adalah saat kita membuka browser, umumnya kita akan membuka banyak tab secara bersamaan. Masing-masing tab atau jendela tersebut mungkin akan dijalankan sebagai thread yang berbeda dalam satu proses utama dari aplikasi web browser.

#### Pengertian Multiprocess dan Multithread

**1. Multiprocess**

Multiproses adalah pendekatan di mana sistem operasi dapat menjalankan beberapa proses secara bersamaan.

Karakteristik:
- Memiliki memori yang terpisah dan sumber daya yang terisolasi
- Proses-proses ini tidak berbagi memori atau variabel antara satu sama lain, kecuali jika ada mekanisme khusus seperti shared memory
- Jika satu proses mengalami kegagalan atau crash, proses lainnya biasanya tidak terpengaruh

Contoh kasus:
> Saat membuka beberapa aplikasi dalam satu waktu, jika terdapat satu aplikasi yang bermasalah/crash, maka aplikasi lain tidak akan terpengaruh

**2. Multithread**

Multithreading adalah pendekatan di mana sebuah proses dapat memiliki beberapa thread yang berjalan secara bersamaan di dalamnya.

Karakteristik:
- Thread-thread dalam satu proses berbagi memori dan sumber daya
- Mereka dapat saling berkomunikasi dengan mudah dan berbagi variabel
- Jika satu thread mengalami kegagalan atau crash, hal itu dapat mempengaruhi keseluruhan proses dan thread-thread lainnya

Contoh kasus:
> Sebuah server web perlu mampu menangani banyak permintaan HTTP dari klien secara bersamaan tanpa menghambat kinerja atau waktu tanggapan. Dibutuhkan multithreading untuk menangani setiap permintaan klien secara terpisah.

---

### Proses

#### Macam-Macam PID

| Jenis | Deskripsi | Fungsi C |
|-------|-----------|----------|
| **User ID (UID)** | Identifier yang menampilkan user yang menjalankan program | `uid_t getuid(void);` |
| **Process ID (PID)** | Angka unik dari suatu proses untuk mengidentifikasinya | `pid_t getpid(void);` |
| **Parent PID (PPID)** | ID dari parent process yang membuat proses tersebut | `pid_t getppid(void);` |

#### Melihat Proses Berjalan

```bash
# Melihat proses user saat ini
ps

# Melihat semua proses yang berjalan (detail)
ps aux

# Melihat proses dalam bentuk tree
pstree
```

Penjelasan output `ps aux`:
- **UID**: user yang menjalankan program
- **PID**: process IDnya
- **PPID**: parent PID
- **C**: CPU Utilization (%)
- **STIME**: waktu proses dijalankan
- **TTY**: terminal yang menjalankan proses (jika kosong = background)
- **TIME**: lamanya proses berjalan
- **CMD**: perintah yang menjalankan proses tersebut

#### Menghentikan Proses

```bash
# Menghentikan proses dengan normal termination (SIGTERM)
kill <pid>

# Menghentikan proses secara paksa (SIGKILL)
kill -9 <pid>

# Menghentikan proses berdasarkan nama
pkill <nama-proses>
```

| Signal | Nilai | Efek |
|--------|-------|------|
| SIGHUP | 1 | Hangup |
| SIGINT | 2 | Interrupt from keyboard (Ctrl+C) |
| SIGKILL | 9 | Terminate paksa |
| SIGTERM | 15 | Termination signal (default) |
| SIGSTOP | 17,19,23 | Stop/pause the process (Ctrl+Z) |

#### Membuat Proses

**Fungsi `fork()`** - Membuat child process dari parent process:

```c
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>

int main(){
  pid_t child_id;
  child_id = fork();

  printf("Hello World\n");

  if(child_id != 0){
    printf("Parent process. PID: %d, Child's PID: %d\n", 
           (int)getpid(), (int)child_id);
  }else {
    printf("Child process. PID: %d, Parent's PID: %d\n", 
           (int)getpid(), (int)getppid());
  }

  return 0;
}
```

**Fungsi `exec()`** - Menjalankan program baru dan menggantikan proses saat ini:

```c
#include <stdio.h>
#include <unistd.h>

int main () {
  char *argv[4] = {"ls", "-l", "/home/", NULL};
  execv("/bin/ls", argv);
  
  // Baris ini tidak akan dijalankan karena exec menggantikan proses
  printf("This line will not be executed\n");
  return 0;
}
```

**Fungsi `wait()`** - Parent menunggu child process selesai:

```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int main() {
    pid_t pid = fork();

    if (pid < 0) {
        printf("Error: Fork Failed\n");
        exit(1);
    }
    else if (pid == 0) {
        printf("Child process!\n");
        exit(0);
    }
    else {
        int status;
        wait(&status);
        if (WIFEXITED(status)) {
            printf("Child exited with status: %d\n", WEXITSTATUS(status));
        }
        exit(0);
    }
}
```

**Fungsi `system()`** - Menjalankan command shell dari program C:

```c
#include <stdlib.h>

int main() {
  int return_value;
  return_value = system("ls -l");
  return return_value;
}
```

#### Menjalankan Proses di Latar Belakang

```bash
# Jalankan program di background (dengan &)
./program &

# Lihat daftar background jobs
jobs

# Lanjutkan job yang dijeda (fg = foreground, bg = background)
fg %1
bg %1

# Jalankan command di background
wget http://example.com/file.zip &
```

#### Jenis-Jenis Proses

| Jenis | Deskripsi |
|-------|-----------|
| **Zombie Process** | Child process yang sudah exit tapi parent belum me-release resourcenya |
| **Orphan Process** | Child process yang parent-nya sudah terminate untuk parent masih berjalan |
| **Daemon Process** | Process yang berjalan di background tanpa kontrol dari terminal |

#### Daemon

Daemon adalah suatu program yang berjalan di background secara terus menerus tanpa adanya interaksi secara langsung dengan user yang sedang aktif.

Langkah pembuatan daemon:
1. Fork parent process dan terminate parent
2. Ubah mode file dengan `umask(0)`
3. Buat unique Session ID dengan `setsid()`
4. Ubah working directory dengan `chdir("/")`
5. Tutup file descriptor standar (STDIN, STDOUT, STDERR)
6. Buat loop utama dengan `sleep()` interval

---

### Thread

#### Multiprocess vs Multithread

| Aspek | Multiprocess | Multithread |
|-------|--------------|-------------|
| Eksekusi | Banyak proses konkuren | Banyak thread dalam 1 proses |
| Resource | Membutuhkan sumber daya besar | Lebih ekonomis |
| Memory | Memori terpisah per proses | Berbagi memori dalam proses |
| Komunikasi | Perlu mekanisme IPC khusus | Mudah berkomunikasi |
| Resiliensi | Isolasi antar proses | Satu crash bisa berdampak ke semua |

Contoh:
- **Chrome** menggunakan multiprocess (setiap tab = process baru)
- **Game** menggunakan multithread (rendering, audio, logic dalam 1 process)

#### Pembuatan Thread

```c
#include <pthread.h>

int pthread_create(pthread_t *restrict tidp,
                   const pthread_attr_t *restrict attr,
                   void *(*start_rtn)(void *),
                   void *restrict arg);
```

Penjelasan:
- `tidp`: pointer untuk thread ID baru
- `attr`: atribut thread (NULL = default)
- `start_rtn`: fungsi yang dijalankan thread
- `arg`: argument untuk fungsi
- Return: 0 jika berhasil, error number jika gagal

Contoh:
```c
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

void *run(void *args) {
    int num = *(int *)args;
    printf("Number: %d\n", num);
    return NULL;
}

int main() {
    pthread_t t_id[3];
    
    for (int i = 0; i < 3; i++) {
        int *num = (int *)malloc(sizeof(int));
        *num = i + 1;
        pthread_create(&t_id[i], NULL, &run, (void *)num);
    }

    for (int i = 0; i < 3; i++) {
        pthread_join(t_id[i], NULL);
    }
    
    return 0;
}
```

**Compile dan jalankan:**
```bash
gcc -pthread -o program program.c
./program
```

#### Menggunakan Thread dengan `wait`

Gunakan `pthread_join()` untuk menunggu thread selesai:

```c
pthread_join(t_id, NULL);  // Tunggu thread selesai
```

#### Mutual Exclusion (Mutex)

Mutex digunakan untuk mengamankan akses ke shared resource sehingga hanya satu thread yang bisa mengakses pada saat bersamaan:

```c
#include <pthread.h>

pthread_mutex_t lock;

// Inisialisasi
pthread_mutex_init(&lock, NULL);

// Gunakan dalam critical section
pthread_mutex_lock(&lock);
// ... critical code ...
pthread_mutex_unlock(&lock);

// Cleanup
pthread_mutex_destroy(&lock);
```

---

### IPC (Interprocess Communication)

#### Pengertian IPC

IPC merupakan mekanisme yang memungkinkan proses-proses untuk saling berkomunikasi dan berbagi data. Ada beberapa jenis IPC:

#### Pipes (Pipa)

Pipes adalah komunikasi satu arah antar proses menggunakan file descriptor.

```c
#include <unistd.h>

int pipe(int pipefd[2]);
// pipefd[0] = untuk baca
// pipefd[1] = untuk tulis
```

Contoh komunikasi parent-child dengan pipe:

```c
#include <stdio.h>
#include <unistd.h>
#include <string.h>

int main() {
    int pipefd[2];
    pipe(pipefd);
    
    if (fork() == 0) {
        // Child process
        close(pipefd[0]);  // Tutup read end
        char *msg = "Hello from child";
        write(pipefd[1], msg, strlen(msg));
        close(pipefd[1]);
    } else {
        // Parent process
        close(pipefd[1]);  // Tutup write end
        char buffer[100];
        read(pipefd[0], buffer, 100);
        printf("Received: %s\n", buffer);
        close(pipefd[0]);
    }
    
    return 0;
}
```

#### Shared Memory

Shared memory memungkinkan multiple proses membaca/menulis pada memori yang sama:

```c
#include <sys/ipc.h>
#include <sys/shm.h>

// Buat/dapatkan shared memory segment
int shmid = shmget(key, size, IPC_CREAT | 0666);

// Attach proses ke shared memory
void *shm = shmat(shmid, NULL, 0);

// Gunakan pointer untuk baca/tulis
*(int *)shm = 42;
int value = *(int *)shm;

// Detach dari shared memory
shmdt(shm);

// Hapus shared memory segment
shmctl(shmid, IPC_RMID, NULL);
```

---

## Contoh Soal dan Solusi

Folder **`contoh-soal-dan-solusi/`** menyediakan berbagai contoh soal dan solusi yang dirancang untuk membantu Anda memahami konsep-konsep fundamental dari Modul 2.

### Daftar Contoh Soal

#### **Task 1: Processes dan Fork** 
Memahami pembuatan proses, parent-child relationship, dan synchronization.
- **Soal a)** - Parent-Child Processes: Membuat 2 child processes
- **Soal b)** - Process dengan Arguments: Menerima parameter dan conditional logic
- [Lihat folder task-1-processes-dan-fork](contoh-soal-dan-solusi/task-1-processes-dan-fork/)

#### **Task 2: Pipes dan Komunikasi Antar Proses**
IPC menggunakan pipes untuk komunikasi antar proses.
- **Soal a)** - Pipe Sederhana: Parent menulis, child membaca
- **Soal b)** - Bidirectional Communication: Dua pipes untuk komunikasi dua arah
- [Lihat folder task-2-pipes-dan-komunikasi](contoh-soal-dan-solusi/task-2-pipes-dan-komunikasi/)

#### **Task 3: Shared Memory**
IPC menggunakan shared memory untuk direct memory sharing antar proses.
- **Soal a)** - Shared Memory Dasar: Parent menulis struct, child membaca dan modify
- **Soal b)** - Multiple Processes: 2 children mengakses shared memory bersamaan
- [Lihat folder task-3-shared-memory](contoh-soal-dan-solusi/task-3-shared-memory/)

#### **Task 4: Threads**
Concurrent programming menggunakan threads dalam satu proses.
- **Soal a)** - Threads Sederhana: 2 threads berjalan parallel
- **Soal b)** - Threads dengan Shared Variable: 3 threads akses shared counter
- [Lihat folder task-4-threads](contoh-soal-dan-solusi/task-4-threads/)

### Cara Menggunakan Contoh Soal

1. Masuk ke folder task yang ingin dipelajari:
   ```bash
   cd contoh-soal-dan-solusi/task-1-processes-dan-fork/
   ```

2. Baca README.md untuk memahami konsep dan soal:
   ```bash
   cat README.md
   ```

3. Lihat solusi dan coba compile:
   ```bash
   gcc -o solution_1a solution_1a.c
   ./solution_1a
   ```

4. Untuk Task 4 (threads), gunakan flag `-pthread`:
   ```bash
   gcc -pthread -o solution_4a solution_4a.c
   ./solution_4a
   ```

---

## Playground Directory

Folder `playground/` berisi berbagai kode C dan shell script untuk praktek:

### Contoh Proses

| File | Deskripsi |
|------|-----------|
| `process-without-fork.c` | Program sederhana tanpa fork |
| `process-with-fork.c` | Dasar fork - membuat child process |
| `process-with-exec.c` | Menggunakan exec untuk menjalankan program baru |
| `process-with-fork-exec.c` | Kombinasi fork dan exec |
| `process-with-fork-exec-wait.c` | Fork, exec, dan wait - parent menunggu child |
| `process-with-fork-exec-wait-2.c` | Variasi fork+exec+wait |
| `process-with-system.c` | Menggunakan fungsi system() |
| `system.c` | Menjalankan shell script dari C |
| `inibash.sh` | Contoh shell script yang dipanggil dari C |

### Contoh Thread

| File | Deskripsi |
|------|-----------|
| `without-thread.c` | Program linear tanpa thread |
| `without-thread-with-fork.c` | Program linear menggunakan fork |
| `thread.c` | Dasar penggunaan pthread |
| `thread-with-fork.c` | Kombinasi thread dan fork |
| `join-thread.c` | Menggunakan pthread_join() untuk wait |
| `mutual-exclusion.c` | Mutex untuk sinkronisasi thread |
| `mutual-exclusion-2.c` | Variasi mutex |

### Contoh IPC (Pipes & Shared Memory)

| File | Deskripsi |
|------|-----------|
| `pipes-without-fork.c` | Pipe dalam satu proses |
| `pipes-with-fork.c` | Pipe untuk komunikasi parent-child |
| `shared-memory-1.c` | Shared memory - pengirim data |
| `shared-memory-2.c` | Shared memory - penerima data |
| `sender.c` | Program pengirim untuk IPC |
| `receiver.c` | Program penerima untuk IPC |

---

## Cara Menggunakan Repository Ini

### 1. Persiapan Lingkungan

Pastikan Anda memiliki:
- Linux OS (Ubuntu, Debian, CentOS, dll)
- `gcc` compiler untuk C
- `make` (opsional, untuk project besar)

Install dependensi:
```bash
# Ubuntu/Debian
sudo apt-get install build-essential

# CentOS/RHEL
sudo yum install gcc
```

### 2. Compile dan Jalankan Program C

```bash
# Masuk ke direktori playground
cd Modul2/playground

# Compile program biasa
gcc -o program program.c
./program

# Compile program dengan pthread
gcc -pthread -o program program.c
./program

# Compile dengan debug info
gcc -g -o program program.c
```

### 3. Jalankan Shell Script

```bash
# Jalankan script bash
bash inibash.sh

# Atau dengan chmod +x terlebih dahulu
chmod +x inibash.sh
./inibash.sh
```

### 4. Eksperimen dan Modifikasi

- Coba modifikasi program sesuai kebutuhan
- Gunakan `printf()` untuk debug
- Test berbagai skenario proses/thread
- Gunakan `gdb` untuk debugging lebih lanjut

---

## Sumber Daya Tambahan

### Online Resources
- [GNU C Library (glibc) documentation](https://www.gnu.org/software/libc/manual/)
- [POSIX Thread Programming](https://linux.die.net/man/7/pthreads)
- [Interprocess Communication in Linux](https://www.geeksforgeeks.org/ipc-using-pipes/)
- [Beej's Guide to IPC](https://beej.us/guide/bgipc/)
- [Advanced Programming in the UNIX Environment](https://www.oreilly.com/library/view/advanced-programming-in/9780136383550/)

### Man Pages (Linux)
```bash
man fork          # Dokumentasi fork
man exec          # Dokumentasi exec
man pthread       # Dokumentasi thread
man pipe          # Dokumentasi pipe
man shmget        # Dokumentasi shared memory
man ps            # Dokumentasi ps command
man kill          # Dokumentasi kill command
```

### Tools Berguna
- [GDB Debugger](https://www.gnu.org/software/gdb/) - Debugging program
- [Valgrind](https://valgrind.org/) - Memory profiling
- [strace](https://strace.io/) - System call tracing
- [lsof](http://people.freebsd.org/~abe/) - List open files

---
