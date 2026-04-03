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
