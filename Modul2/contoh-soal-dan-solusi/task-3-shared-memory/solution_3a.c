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
