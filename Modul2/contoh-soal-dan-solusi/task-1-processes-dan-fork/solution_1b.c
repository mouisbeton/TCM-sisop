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
