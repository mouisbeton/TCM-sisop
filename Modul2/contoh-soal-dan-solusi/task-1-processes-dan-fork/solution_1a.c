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
