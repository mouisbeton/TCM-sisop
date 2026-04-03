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
