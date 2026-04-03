#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <sys/wait.h>

int main() {
    int fd1[2], fd2[2];  // fd1: parent→child, fd2: child→parent
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
