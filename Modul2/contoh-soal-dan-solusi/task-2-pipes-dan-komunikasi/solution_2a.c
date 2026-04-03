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
