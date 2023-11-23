#include <stdio.h>
#define NUM_PROCESSES 5
#define NUM_RESOURCES 3
int available[NUM_RESOURCES] = {3, 3, 2};
int max_demand[NUM_PROCESSES][NUM_RESOURCES] = {
    {7, 5, 3},
    {3, 2, 2},
    {9, 0, 2},
    {2, 2, 2},
    {4, 3, 3}
};
int allocation[NUM_PROCESSES][NUM_RESOURCES] = {
    {0, 1, 0},
    {2, 0, 0},
    {3, 0, 2},
    {2, 1, 1},
    {0, 0, 2}
};
int need[NUM_PROCESSES][NUM_RESOURCES];
int isSafeState(int process, int request[]) {
    for (int i = 0; i < NUM_RESOURCES; i++) {
        if (request[i] > need[process][i]) {
            return 0;
        }
    }
    for (int i = 0; i < NUM_RESOURCES; i++) {
        if (request[i] > available[i]) {
            return 0;
        }
    }
    for (int i = 0; i < NUM_RESOURCES; i++) {
        available[i] -= request[i];
        allocation[process][i] += request[i];
        need[process][i] -= request[i];
    }
    int finish[NUM_PROCESSES] = {0};
    int work[NUM_RESOURCES];
    for (int i = 0; i < NUM_RESOURCES; i++) {
        work[i] = available[i];
    }
    int count = 0;
    while (count < NUM_PROCESSES) {
        int found = 0;
        for (int i = 0; i < NUM_PROCESSES; i++) {
            if (finish[i] == 0) {
                int j;
                for (j = 0; j < NUM_RESOURCES; j++) {
                    if (need[i][j] > work[j]) {
                        break;
                    }
                }
                if (j == NUM_RESOURCES) {
                    for (j = 0; j < NUM_RESOURCES; j++) {
                        work[j] += allocation[i][j];
                    }
                    finish[i] = 1;
                    found = 1;
                    count++;
                }
            }
        }
        if (!found) {
            for (int i = 0; i < NUM_RESOURCES; i++) {
                available[i] += request[i];
                allocation[process][i] -= request[i];
                need[process][i] += request[i];
            }
            return 0;
        }
    }
    return 1;
}
void allocateResources(int process, int request[]) {
    if (isSafeState(process, request)) {
        printf("Resource request for Process %d granted.\n", process);
    } else {
        printf("Resource request for Process %d denied (would lead to deadlock).\n", process);
    }
}
int main() {
    for (int i = 0; i < NUM_PROCESSES; i++) {
        for (int j = 0; j < NUM_RESOURCES; j++) {
            need[i][j] = max_demand[i][j] - allocation[i][j];
        }
    }
    int process = 1;
    int request[NUM_RESOURCES] = {1, 0, 2};
    allocateResources(process, request);
    process = 3;
    int request2[NUM_RESOURCES] = {0, 2, 0};
    allocateResources(process, request2);
    return 0;
}
