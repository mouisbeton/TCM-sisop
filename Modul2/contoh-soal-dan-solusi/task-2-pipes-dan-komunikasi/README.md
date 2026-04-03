# Contoh Soal 2 - Pipes dan Komunikasi Antar Proses

## Pengenalan Konsep

**Pipe** adalah mekanisme komunikasi antar proses dalam sistem operasi yang memungkinkan proses satu memberikan output ke proses lain sebagai input.

**Karakteristik Pipe:**
- Komunikasi **one-way** (satu arah)
- Parent process membuat pipe sebelum `fork()`
- Child process mewarisi file descriptor dari pipe
- Satu end untuk membaca (read), satu end untuk menulis (write)
- Sintaks: `pipe(fd)` dimana `fd[0]` untuk membaca, `fd[1]` untuk menulis

---

## Soal a) Pipe Sederhana - Parent Menulis, Child Membaca

Buatlah program C yang:
1. Parent process membuat sebuah **pipe**
2. Parent **menulis pesan** ke pipe: `"Hello from parent"`
3. Child process **membaca pesan** dari pipe
4. Child **menampilkan pesan** yang diterima
5. Tutup semua file descriptor

### Jawaban:

```c
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <sys/wait.h>

int main() {
    int fd[2];
    pid_t pid;
    char buffer[100];
    char message[] = "Hello from parent";
    
    // Membuat pipe
    if (pipe(fd) == -1) {
        perror("pipe");
        return 1;
    }
    
    // Membuat child process
    pid = fork();
    
    if (pid == 0) {
        // Child Process - MEMBACA dari pipe
        close(fd[1]);  // Tutup write end
        
        // Membaca dari pipe
        read(fd[0], buffer, sizeof(buffer));
        
        printf("Child received: %s\n", buffer);
        
        close(fd[0]);  // Tutup read end
        return 0;
    } else {
        // Parent Process - MENULIS ke pipe
        close(fd[0]);  // Tutup read end
        
        // Menulis ke pipe
        write(fd[1], message, strlen(message) + 1);
        
        printf("Parent sent: %s\n", message);
        
        close(fd[1]);  // Tutup write end
        
        // Menunggu child selesai
        wait(NULL);
    }
    
    return 0;
}
```

### Penjelasan Solusi:

1. **`int fd[2]`** - Array untuk menyimpan file descriptor
   - `fd[0]` = read end (untuk membaca)
   - `fd[1]` = write end (untuk menulis)

2. **`pipe(fd)`** - Membuat pipe
   - Return 0 jika berhasil, -1 jika gagal

3. **`close(fd[1])`** - Menutup write end di child
   - Child hanya perlu membaca, tidak menulis
   - Penting untuk trigger EOF saat parent menulis

4. **`read(fd[0], buffer, size)`** - Membaca dari pipe
   - Menunggu data tersedia
   - Return jumlah byte yang dibaca

5. **`write(fd[1], message, size)`** - Menulis ke pipe
   - Send data melalui pipe

### Output yang Diharapkan:

```
Parent sent: Hello from parent
Child received: Hello from parent
```

---

## Soal b) Pipe Dua Arah - Parent dan Child Berkomunikasi

Buatlah program C yang:
1. Membuat **2 pipes** (parent->child dan child->parent)
2. **Parent menulis**: `"Number from parent: 42"`
3. **Child membaca** dan menampilkan pesan parent
4. **Child menulis**: `"Number squared: 1764"` (42 x 42 = 1764)
5. **Parent membaca** dan menampilkan pesan dari child
6. Tutup semua file descriptor dengan baik

### Jawaban:

```c
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <sys/wait.h>

int main() {
    int fd1[2], fd2[2];  // fd1: parent->child, fd2: child->parent
    pid_t pid;
    char buffer[100];
    
    // Membuat 2 pipes
    if (pipe(fd1) == -1 || pipe(fd2) == -1) {
        perror("pipe");
        return 1;
    }
    
    pid = fork();
    
    if (pid == 0) {
        // Child Process
        close(fd1[1]);  // Tutup write end dari fd1
        close(fd2[0]);  // Tutup read end dari fd2
        
        // Membaca dari parent (via fd1)
        read(fd1[0], buffer, sizeof(buffer));
        printf("Child received: %s\n", buffer);
        
        // Menulis ke parent (via fd2)
        char response[] = "Number squared: 1764";
        write(fd2[1], response, strlen(response) + 1);
        
        close(fd1[0]);
        close(fd2[1]);
        return 0;
        
    } else {
        // Parent Process
        close(fd1[0]);  // Tutup read end dari fd1
        close(fd2[1]);  // Tutup write end dari fd2
        
        // Menulis ke child (via fd1)
        char message[] = "Number from parent: 42";
        write(fd1[1], message, strlen(message) + 1);
        printf("Parent sent: %s\n", message);
        
        // Membaca dari child (via fd2)
        read(fd2[0], buffer, sizeof(buffer));
        printf("Parent received: %s\n", buffer);
        
        close(fd1[1]);
        close(fd2[0]);
        
        // Menunggu child selesai
        wait(NULL);
    }
    
    return 0;
}
```

### Penjelasan Solusi:

1. **`int fd1[2], fd2[2]`** - Dua pipes untuk komunikasi dua arah
   - `fd1` untuk parent->child
   - `fd2` untuk child->parent

2. **Close yang tepat** - Sangat penting untuk komunikasi pipe:
   - Di child: tutup write end `fd1` (tidak perlu) dan read end `fd2` (tidak perlu)
   - Di parent: tutup read end `fd1` (tidak perlu) dan write end `fd2` (tidak perlu)

3. **Order operasi** - Harus koordinasi untuk menghindari deadlock:
   - Parent menulis dulu, kemudian child membaca
   - Child menulis response, parent membaca

### Output yang Diharapkan:

```
Parent sent: Number from parent: 42
Child received: Number from parent: 42
Parent received: Number squared: 1764
```

---

## Ringkasan Penting

| Fungsi | Penjelasan |
|--------|-----------|
| `pipe(fd)` | Membuat pipe, return 0=sukses, -1=gagal |
| `read(fd, buffer, size)` | Membaca dari file descriptor |
| `write(fd, data, size)` | Menulis ke file descriptor |
| `close(fd)` | Menutup file descriptor |
| `$` | Untuk komunikasi satu arah saja |
| Dua pipes | Diperlukan untuk komunikasi dua arah |

---

## Tips Debugging

1. **Selalu tutup file descriptor** yang tidak digunakan
   - Di child: tutup yang tidak perlu dibaca/tulis
   - Di parent: tutup yang tidak perlu dibaca/tulis

2. **Perhatikan urutan operasi** agar tidak deadlock:
   - Pastikan ada yang menulis sebelum membaca
   - Jangan membaca dari pipe yang kosong tanpa writer

3. **Gunakan `perror()`** untuk debugging:
   ```c
   if (pipe(fd) == -1) {
       perror("pipe");
       return 1;
   }
   ```

4. **Test dengan print statement**:
   ```c
   printf("DEBUG: Just wrote to pipe\n");
   ```

