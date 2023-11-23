#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>
#define NUM_READERS 5
#define NUM_WRITERS 2
int shared_data = 0;
sem_t mutex, writeblock;
int reader_count = 0;
void *reader(void *arg) {
    while (1) {
        usleep(100000);
        sem_wait(&mutex);
        reader_count++;
        if (reader_count == 1) {
            sem_wait(&writeblock);
        }
        sem_post(&mutex);
        printf("Reader is reading: %d\n", shared_data);
        sem_wait(&mutex);
        reader_count--;
        if (reader_count == 0) {
            sem_post(&writeblock);
        }
        sem_post(&mutex);
    }
}
void *writer(void *arg) {
    while (1) {
        sem_wait(&writeblock);
        shared_data++;
        printf("Writer is writing: %d\n", shared_data);
        sem_post(&writeblock);
        usleep(100000);
    }
}
int main() {
    pthread_t reader_threads[NUM_READERS];
    pthread_t writer_threads[NUM_WRITERS];
    sem_init(&mutex, 0, 1);
    sem_init(&writeblock, 0, 1);
    for (int i = 0; i < NUM_READERS; i++) {
        pthread_create(&reader_threads[i], NULL, reader, NULL);
    }
    for (int i = 0; i < NUM_WRITERS; i++) {
        pthread_create(&writer_threads[i], NULL, writer, NULL);
    }
    for (int i = 0; i < NUM_READERS; i++) {
        pthread_join(reader_threads[i], NULL);
    }
    for (int i = 0; i < NUM_WRITERS; i++) {
        pthread_join(writer_threads[i], NULL);
    }
    sem_destroy(&mutex);
    sem_destroy(&writeblock);
    return 0;
}
