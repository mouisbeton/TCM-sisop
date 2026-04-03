# Contoh Soal 4 - Threads (Benang)

## Pengenalan Konsep

**Thread** adalah unit eksekusi ringan (lightweight) yang berbagi memory space dengan thread lain dalam proses yang sama. Berbeda dengan process yang memiliki memory space terpisah.

**Perbedaan Process vs Thread:**

| Aspek | Process | Thread |
|-------|---------|--------|
| Memory | Terpisah | Shared |
| Creation Cost | Berat | Ringan |
| Context Switch | Berat | Ringan |
| Communication | IPC (complex) | Direct (shared memory) |

**Fungsi Thread Penting:**
- `pthread_create()` - Membuat thread baru
- `pthread_join()` - Menunggu thread selesai
- `pthread_exit()` - Keluar dari thread
- `pthread_self()` - Dapatkan thread ID

---

## Soal a) Thread Sederhana - Untuk Parallel Task

Buatlah program C yang:
1. **Main thread** menampilkan: `"Main thread started"`
2. Buat **2 threads**:
   - **Thread 1** menampilkan: `"Thread 1: Processing task"` (3x dengan sleep 1 detik)
   - **Thread 2** menampilkan: `"Thread 2: Processing task"` (3x dengan sleep 1 detik)
3. Main thread menunggu kedua thread selesai
4. Main thread menampilkan: `"Main thread finished"`
5. Compile dengan: `gcc -pthread -o solution_4a solution_4a.c`

### Jawaban:

```c
#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

void* thread1_func(void *arg) {
    for (int i = 1; i <= 3; i++) {
        printf("Thread 1: Processing task (%d/3)\n", i);
        sleep(1);
    }
    return NULL;
}

void* thread2_func(void *arg) {
    for (int i = 1; i <= 3; i++) {
        printf("Thread 2: Processing task (%d/3)\n", i);
        sleep(1);
    }
    return NULL;
}

int main() {
    pthread_t tid1, tid2;
    
    printf("Main thread started (PID: %d)\n", getpid());
    
    // Membuat thread 1
    if (pthread_create(&tid1, NULL, thread1_func, NULL) != 0) {
        perror("pthread_create()");
        return 1;
    }
    
    // Membuat thread 2
    if (pthread_create(&tid2, NULL, thread2_func, NULL) != 0) {
        perror("pthread_create()");
        return 1;
    }
    
    // Menunggu thread 1 selesai
    pthread_join(tid1, NULL);
    printf("Thread 1 finished\n");
    
    // Menunggu thread 2 selesai
    pthread_join(tid2, NULL);
    printf("Thread 2 finished\n");
    
    printf("Main thread finished\n");
    
    return 0;
}
```

### Penjelasan Solusi:

1. **`void* thread_func(void *arg)`** - Fungsi yang akan dijalankan thread
   - Return type harus `void*`
   - Parameter harus `void*` (bisa NULL jika tidak perlu)

2. **`pthread_t tid1, tid2`** - Variable untuk menyimpan thread ID

3. **`pthread_create(&tid1, NULL, thread1_func, NULL)`** - Membuat thread
   - Argument 1: pointer ke `pthread_t`
   - Argument 2: thread attributes (NULL = default)
   - Argument 3: function pointer
   - Argument 4: argument untuk function (NULL jika tidak ada)

4. **`pthread_join(tid1, NULL)`** - Menunggu thread selesai
   - Main thread akan block sampai `tid1` selesai
   - Argument 2 untuk menerima return value (NULL = tidak perlu)

5. **Compile dengan `-pthread`**:
   ```bash
   gcc -pthread -o solution_4a solution_4a.c
   ./solution_4a
   ```

### Output yang Diharapkan:

```
Main thread started (PID: 2345)
Thread 1: Processing task (1/3)
Thread 2: Processing task (1/3)
Thread 1: Processing task (2/3)
Thread 2: Processing task (2/3)
Thread 1: Processing task (3/3)
Thread 2: Processing task (3/3)
Thread 1 finished
Thread 2 finished
Main thread finished
```

*(Urutan output thread 1 dan 2 mungkin berbeda karena scheduler)*

---

## Soal b) Thread dengan Shared Memory dan Argument

Buatlah program C yang:
1. Main thread membuat **shared variable**: `total_count = 0`
2. Buat **3 threads**, setiap thread menerima argument:
   - Thread 1: `arg = 10` (tambah 10 ke total_count)
   - Thread 2: `arg = 20` (tambah 20 ke total_count)
   - Thread 3: `arg = 30` (tambah 30 ke total_count)
3. Setiap thread:
   - Membaca `total_count`
   - Tambahkan dengan argument yang diterima
   - Tulis kembali ke `total_count`
   - Tampilkan: `"Thread X added <arg>, total is now <total>"`
4. Main thread menampilkan final `total_count` (seharusnya 60)

### Jawaban:

```c
#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

int total_count = 0;  // Shared variable

void* add_to_count(void *arg) {
    int value = *(int *)arg;  // Cast void* menjadi int*
    
    // Baca nilai sekarang
    int current = total_count;
    
    // Tambah dengan argument
    total_count = current + value;
    
    printf("Thread added %d, total count is now %d\n", value, total_count);
    
    free(arg);  // Free memory yang dialokasikan di main
    return NULL;
}

int main() {
    pthread_t tid1, tid2, tid3;
    
    printf("Main thread: total_count = %d\n", total_count);
    
    // Thread 1 dengan argument 10
    int *arg1 = malloc(sizeof(int));
    *arg1 = 10;
    pthread_create(&tid1, NULL, add_to_count, arg1);
    
    // Thread 2 dengan argument 20
    int *arg2 = malloc(sizeof(int));
    *arg2 = 20;
    pthread_create(&tid2, NULL, add_to_count, arg2);
    
    // Thread 3 dengan argument 30
    int *arg3 = malloc(sizeof(int));
    *arg3 = 30;
    pthread_create(&tid3, NULL, add_to_count, arg3);
    
    // Menunggu semua thread selesai
    pthread_join(tid1, NULL);
    pthread_join(tid2, NULL);
    pthread_join(tid3, NULL);
    
    printf("Main thread: final total_count = %d\n", total_count);
    
    return 0;
}
```

### Penjelasan Solusi:

1. **`int total_count = 0`** - Shared variable di level global
   - Semua thread otomatis bisa akses karena shared memory space

2. **`int *arg1 = malloc(sizeof(int))`** - Allocate memory untuk argument
   - Jangan gunakan `&variable` dari loop karena akan berubah
   - Gunakan `malloc` agar memory stable

3. **`*(int *)arg`** - Cast dan dereference argument
   - `(int *)arg` = cast void* menjadi int*
   - `*(int *)arg` = dereference untuk dapat nilai int

4. **Race Condition!** - Hasil mungkin tidak selalu 60 karena:
   ```c
   current = total_count;      // Read
   total_count = current + v;  // Write
   // Bisa diselingi thread lain diantara Read dan Write
   ```

### Output yang Diharapkan (ideal):

```
Main thread: total_count = 0
Thread added 10, total count is now 10
Thread added 20, total count is now 30
Thread added 30, total count is now 60
Main thread: final total_count = 60
```

### Output yang Mungkin Terjadi (race condition):

```
Main thread: total_count = 0
Thread added 10, total count is now 10
Thread added 20, total count is now 30
Thread added 30, total count is now 40  // Should be 60!
Main thread: final total_count = 40
```

---

## Catatan: Race Condition

Pada soal b), **race condition** bisa terjadi:

```
Timeline 1 (Correct - Result 60):
T1: Read (0)   -> T1: Write (0+10=10)
T2: Read (10)  -> T2: Write (10+20=30)
T3: Read (30)  -> T3: Write (30+30=60) [OK]

Timeline 2 (Race Condition - Result 50):
T1: Read (0)
T2: Read (0)       <- Baca sebelum T1 write!
T3: Read (0)       <- Baca sebelum T1 dan T2 write!
T1: Write (0+10=10)
T2: Write (0+20=20) <- Overwrite T1, hilang +10!
T3: Write (0+30=30) <- Overwrite T2, hilang +20!
Result: 30 [FAIL]
```

**Solusi:** Gunakan **Mutex** untuk synchronization (topik selanjutnya).

---

## Ringkasan Penting

| Fungsi | Tujuan |
|--------|--------|
| `pthread_create()` | Membuat thread baru |
| `pthread_join()` | Menunggu thread selesai |
| `pthread_self()` | Dapatkan thread ID saat ini |
| `pthread_exit()` | Exit thread explicitly |
| `malloc()` / `free()` | Alokasi/free memory untuk argument |

---

## Tips dan Debugging

1. **Compile dengan `-pthread`**:
   ```bash
   gcc -pthread -o program program.c
   ```

2. **Jangan gunakan stack variable untuk argument**:
   ```c
   // [SALAH]
   int x = 10;
   pthread_create(&tid, NULL, func, &x);
   
   // [BENAR]
   int *x = malloc(sizeof(int));
   *x = 10;
   pthread_create(&tid, NULL, func, x);
   free(x);  // Dalam thread function
   ```

3. **Thread berbagi memory**, hati-hati race condition:
   ```c
   // [TIDAK AMAN]
   total++; // Read-Modify-Write bukan atomic
   
   // [AMAN] (dengan mutex - topik berikutnya)
   pthread_mutex_lock(&mutex);
   total++;
   pthread_mutex_unlock(&mutex);
   ```

4. **Check return values**:
   ```c
   if (pthread_create(&tid, NULL, func, arg) != 0) {
       perror("pthread_create");
       return 1;
   }
   ```

5. **Gunakan `gdb` untuk debug thread**:
   ```bash
   gdb ./program
   (gdb) info threads
   (gdb) thread 1
   ```

