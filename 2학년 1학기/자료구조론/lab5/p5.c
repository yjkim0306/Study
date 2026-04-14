#include <stdio.h>
#include <stdlib.h>

struct CircularQueueStruct
{
    int *key;
    int first;
    int rear;
    int qsize;
    int max_queue_size;
};

typedef struct CircularQueueStruct* CircularQueue;

CircularQueue MakeEmpty(int max);
int IsEmpty(CircularQueue Q);
int IsFull(CircularQueue Q);
void Dequeue(CircularQueue Q);
void Enqueue(CircularQueue Q, int x);
void PrintFirst(CircularQueue Q);
void PrintRear(CircularQueue Q);
void DeleteQueue(CircularQueue Q);

CircularQueue MakeEmpty(int max)
{
    CircularQueue Q;

    Q = (CircularQueue)malloc(sizeof(struct CircularQueueStruct));
    if(Q == NULL)
    {
        printf("Out of space!!!\n");
        exit(0);
    }

    Q->key = (int*)malloc(sizeof(int) * max);
    if(Q->key == NULL)
    {
        printf("Out of space!!!\n");
        exit(0);    
    }

    Q->first = 1;
    Q->rear = 0;
    Q->qsize = 0;
    Q->max_queue_size = max;

    return Q;
}

int IsEmpty(CircularQueue Q)
{
    return Q->qsize <= 0;
}

int IsFull(CircularQueue Q)
{
    return Q->qsize >= Q->max_queue_size;
}

void Dequeue(CircularQueue Q)
{
    if(IsEmpty(Q))
    {
        printf("Dequeue failed : Queue is Empty!\n");
        return;
    }
    Q->qsize--;
    
    printf("Dequeue %d\n", Q->key[Q->first]);
    if(Q->first == Q->max_queue_size)
        Q->first = 1;
    else
        ++Q->first; 
}

void Enqueue(CircularQueue Q, int x)
{
    if(IsFull(Q))
    {
        printf("Enqueue failed : Queue is Full!\n");
        return;
    }
    Q->qsize++;

    if(Q->rear == Q->max_queue_size)
    {
        Q->rear = 0;
        Q->key[Q->rear] = x;
    }
    else
        Q->key[++Q->rear] = x;
    printf("Enqueue %d\n", x);
}

void PrintFirst(CircularQueue Q)
{
    if(IsEmpty(Q))
    {
        printf("Queue is Empty!\n");
        return;
    }
    else
        printf("First : %d\n", Q->key[Q->first]);
}

void PrintRear(CircularQueue Q)
{
    if(IsEmpty(Q))
    {
        printf("Queue is Empty!\n");
        return;
    }
    else
        printf("Rear : %d\n", Q->key[Q->rear]);
}

void DeleteQueue(CircularQueue Q)
{
    if(Q == NULL)
    {
        printf("Queue does not exist.\n");
        return;
    }
    else
    {
        free(Q->key);
        free(Q);
    }
}

void main(int argc, char* argv[])
{
    char command;
    FILE *input;
    CircularQueue queue;
    int queueSize;
    int tmpNum;

    input = fopen(argv[1], "r");

    while(1)
    {
        command = fgetc(input);
        if(feof(input)) break;
        switch(command)
        {
            case 'n':
                fscanf(input, "%d", &queueSize);
                queue = MakeEmpty(queueSize);
                break;
            case 'e':
                fscanf(input, "%d", &tmpNum);
                Enqueue(queue, tmpNum);
                break;
            case 'd':
                Dequeue(queue);
                break;
            case 'f':
                PrintFirst(queue);
                break;
            case 'r':
                PrintRear(queue);
                break;
            default:
                break;
        }
    }

    DeleteQueue(queue);
}