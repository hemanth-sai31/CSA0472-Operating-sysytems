#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#define NUM_THREADS 2
#define NUM_INCREMENTS 10000
int sharedCounter = 0;
pthread_mutex_t mutex;
void* incrementCounter(void* threadID) {
    int id = *((int*)threadID);
for (int i = 0; i < NUM_INCREMENTS; i++) {
        pthread_mutex_lock(&mutex);
        sharedCounter++;
        pthread_mutex_unlock(&mutex);
    }
printf("Thread %d finished\n", id);
    pthread_exit(NULL);
}
int main() {
    pthread_t threads[NUM_THREADS];
    int threadIDs[NUM_THREADS];
pthread_mutex_init(&mutex, NULL);
for (int i = 0; i < NUM_THREADS; i++) {
        threadIDs[i] = i;
        int result = pthread_create(&threads[i], NULL, incrementCounter, &threadIDs[i]);
        if (result) {
            fprintf(stderr, "Error creating thread %d: %d\n", i, result);
            exit(-1);
        }
    }
for (int i = 0; i < NUM_THREADS; i++) {
        pthread_join(threads[i], NULL);}
pthread_mutex_destroy(&mutex);
printf("Shared Counter: %d\n", sharedCounter);
    return 0;
