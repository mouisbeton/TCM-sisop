# Contoh Soal 3 - Shared Memory (Memori Bersama)

## Pengenalan Konsep

**Shared Memory** adalah mekanisme IPC (Inter-Process Communication) yang memungkinkan dua atau lebih proses mengakses area memory yang sama. Ini lebih efisien dibanding pipe karena tidak perlu copying data.

**Cara Kerja Shared Memory:**
1. Proses membuat shared memory segment dengan `shmget()`
2. Proses "attach" segment ke address space-nya dengan `shmat()`
3. Proses dapat menulis/membaca dari memory yang sama
4. Proses "detach" dengan `shmdt()`
5. Proses terakhir menghapus dengan `shmctl()`

**Fungsi Penting:**
- `shmget(key, size, flags)` - Membuat/akses shared memory
- `shmat(id, addr, flags)` - Attach shared memory
- `shmdt(addr)` - Detach shared memory
- `shmctl(id, cmd, buf)` - Control shared memory

---

## Soal a) Shared Memory Dasar - Parent dan Child Share Data

Buatlah program C yang:
1. Parent membuat **shared memory** dengan ukuran 1024 bytes
2. Parent **menulis struct** ke shared memory:
   ```
   struct Data {
       int id;
       int value;
       char name[50];
   }
   ```
3. Parent menulis: `id=1, value=100, name="Sample Data"`
4. Child process **membaca** dari shared memory dan menampilkan data
5. Child menghitung `value * 2` dan **menulis kembali** ke shared memory
6. Parent membaca hasil dan menampilkan

### Jawaban:

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/wait.h>

struct Data {
    int id;
    int value;
    char name[50];
};

int main() {
    key_t key = ftok(".", 'A');  // Generate key
    int shmid;
    struct Data *shared_data;
    pid_t pid;
    
    // Membuat shared memory (1024 bytes)
    shmid = shmget(key, sizeof(struct Data), IPC_CREAT | 0666);
    if (shmid < 0) {
        perror("shmget");
        return 1;
    }
    
    // Attach shared memory ke parent
    shared_data = (struct Data *)shmat(shmid, NULL, 0);
    if (shared_data == (struct Data *)(-1)) {
        perror("shmat");
        return 1;
    }
    
    // Parent menulis data
    shared_data->id = 1;
    shared_data->value = 100;
    strcpy(shared_data->name, "Sample Data");
    
    printf("Parent wrote: id=%d, value=%d, name=%s\n", 
           shared_data->id, shared_data->value, shared_data->name);
    
    pid = fork();
    
    if (pid == 0) {
        // Child Process
        // Attach shared memory ke child
        shared_data = (struct Data *)shmat(shmid, NULL, 0);
        
        // Child membaca data dari shared memory
        printf("Child read: id=%d, value=%d, name=%s\n",
               shared_data->id, shared_data->value, shared_data->name);
        
        // Child mengubah value (kalikan 2)
        shared_data->value = shared_data->value * 2;
        
        printf("Child modified value to: %d\n", shared_data->value);
        
        // Detach shared memory
        shmdt(shared_data);
        return 0;
        
    } else {
        // Parent Process
        wait(NULL);  // Tunggu child selesai
        
        // Parent membaca lagi hasil modifikasi child
        printf("Parent read after child: id=%d, value=%d, name=%s\n",
               shared_data->id, shared_data->value, shared_data->name);
        
        // Detach shared memory
        shmdt(shared_data);
        
        // Hapus shared memory
        shmctl(shmid, IPC_RMID, NULL);
    }
    
    return 0;
}
```

### Penjelasan Solusi:

1. **`struct Data`** - Struktur data yang akan di-share
   - Berisi: id (int), value (int), name (char array)

2. **`ftok()`** - Generate key untuk shared memory
   - Argument: path (harus file yang ada), id
   - Return: unique key untuk shmget()

3. **`shmget(key, size, flags)`** - Membuat/akses shared memory
   - `IPC_CREAT` = create jika belum ada
   - `0666` = permission read/write untuk semua

4. **`shmat(shmid, NULL, 0)`** - Attach ke address space
   - Mengembalikan pointer ke shared memory
   - `NULL` = OS pilih address sendiri

5. **`shmdt()`** - Detach dari shared memory
   - Setiap proses yang attach harus detach

6. **`shmctl(id, IPC_RMID, NULL)`** - Hapus shared memory
   - Hanya parent yang menghapus

### Output yang Diharapkan:

```
Parent wrote: id=1, value=100, name=Sample Data
Child read: id=1, value=100, name=Sample Data
Child modified value to: 200
Parent read after child: id=1, value=200, name=Sample Data
```

---

## Soal b) Shared Memory dengan Multiple Operations

Buatlah program C yang:
1. Parent membuat shared memory untuk menyimpan **counter**
2. Parent set counter = 0, kemudian tampilkan
3. **Child 1** membaca counter, tambah 5, tulis kembali
4. **Child 2** membaca counter, tambah 10, tulis kembali
5. Parent menunggu kedua child, baca counter final, tampilkan
6. Hasil akhir seharusnya: `0 + 5 + 10 = 15`

### Jawaban:

```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/wait.h>

int main() {
    key_t key = ftok(".", 'B');
    int shmid;
    int *counter;
    pid_t pid1, pid2;
    
    // Membuat shared memory
    shmid = shmget(key, sizeof(int), IPC_CREAT | 0666);
    if (shmid < 0) {
        perror("shmget");
        return 1;
    }
    
    // Attach ke parent
    counter = (int *)shmat(shmid, NULL, 0);
    if (counter == (int *)(-1)) {
        perror("shmat");
        return 1;
    }
    
    // Parent set initial value
    *counter = 0;
    printf("Parent initialized counter: %d\n", *counter);
    
    // Membuat child 1
    pid1 = fork();
    if (pid1 == 0) {
        // Child 1
        counter = (int *)shmat(shmid, NULL, 0);
        
        int current = *counter;
        printf("Child 1 read: %d\n", current);
        
        *counter = current + 5;
        printf("Child 1 added 5, counter now: %d\n", *counter);
        
        shmdt(counter);
        return 0;
    }
    
    // Membuat child 2
    pid2 = fork();
    if (pid2 == 0) {
        // Child 2
        counter = (int *)shmat(shmid, NULL, 0);
        
        int current = *counter;
        printf("Child 2 read: %d\n", current);
        
        *counter = current + 10;
        printf("Child 2 added 10, counter now: %d\n", *counter);
        
        shmdt(counter);
        return 0;
    }
    
    // Parent menunggu semua child
    wait(NULL);
    wait(NULL);
    
    // Parent membaca final value
    printf("Parent final counter: %d\n", *counter);
    
    // Cleanup
    shmdt(counter);
    shmctl(shmid, IPC_RMID, NULL);
    
    return 0;
}
```

### Penjelasan Perbedaan dengan Soal a):

1. **Data type yang di-share** = `int` (lebih sederhana)
2. **Multiple children** yang akses data bersamaan
3. **Race condition** mungkin terjadi (lihat catatan di bawah)

### Output yang Diharapkan:

```
Parent initialized counter: 0
Child 1 read: 0
Child 1 added 5, counter now: 5
Child 2 read: 5
Child 2 added 10, counter now: 15
Parent final counter: 15
```

---

## Catatan Penting: Race Condition

Pada Soal b), hasil mungkin tidak selalu 15 karena **race condition**:

```
Skenario A (correct):
1. Child 1 read: 0
2. Child 1 write: 5
3. Child 2 read: 5
4. Child 2 write: 15
Result: 15 [OK]

Skenario B (race condition):
1. Child 1 read: 0
2. Child 2 read: 0 (belum ada yang write)
3. Child 1 write: 5
4. Child 2 write: 10 (overwrite nilai Child 1!)
Result: 10 [FAIL]
```

Untuk mengatasi ini, diperlukan **synchronization** (akan dipelajari di modul selanjutnya dengan mutex/semaphore).

---

## Ringkasan Penting

| Fungsi | Tujuan |
|--------|--------|
| `ftok(path, id)` | Generate unique key |
| `shmget(key, size, flags)` | Create/get shared memory |
| `shmat(id, addr, flags)` | Attach ke address space |
| `shmdt(addr)` | Detach dari shared memory |
| `shmctl(id, IPC_RMID, NULL)` | Hapus shared memory |

---

## Tips dan Debugging

1. **Harus ada file** untuk `ftok()`:
   ```bash
   touch /tmp/shm_file
   ```

2. **Check shared memory yang ada**:
   ```bash
   ipcs -m  # List shared memory
   ipcrm -m <id>  # Remove shared memory
   ```

3. **Pastikan data type cocok**:
   ```c
   counter = (int *)shmat(shmid, NULL, 0);  // Harus int pointer
   ```

4. **Hati-hati overflow** saat attach di child:
   ```c
   if (counter == (void *)(-1)) {  // Error check
       perror("shmat");
   }
   ```

