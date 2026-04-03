#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>
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
