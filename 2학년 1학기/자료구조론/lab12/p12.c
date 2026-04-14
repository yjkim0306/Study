#include <stdio.h>
#include <stdlib.h>

typedef struct _Queue
{
    int size;
    int *key;
    int front;
    int rear;
}Queue;

Queue *CreateQueue(int X);
void Enqueue(Queue *Q, int item);
int Dequeue(Queue *Q);

typedef struct _Graph
{
    int size;
    int *vertex;
    int **edge;
}Graph;

Graph *CreateGraph(int X);
void InsertEdge(Graph *G, int u, int v);
void Topsort(Graph *G);

Queue *CreateQueue(int X)
{
    Queue* Q = malloc(sizeof(struct _Queue));
    if(Q == NULL)
    {
        printf("Out of space!!!\n");
        exit(0);
    }

    Q->key = (int*)malloc(sizeof(int) * X);
    if(Q->key == NULL)
    {
        printf("Out of space!!!\n");
        exit(0);
    }

    Q->front = 0;
    Q->rear = -1;
    Q->size = X;

    return Q;
}

void Enqueue(Queue *Q, int item)
{
    if(Q->size == (Q->rear + 1))
    {
        printf("Queue is full.\n");
        return;
    }

    Q->rear++;
    Q->key[Q->rear] = item;
}

int Dequeue(Queue *Q)
{
    if(Q->front > Q->rear)
        return -1;

    return Q->key[Q->front++];
}

Graph *CreateGraph(int X)
{
    Graph* G = malloc(sizeof(struct _Graph));

    if(G == NULL)
    {
        printf("Out of space!!!\n");
        exit(0);
    }

    G->size = X;
    G->vertex = (int*)malloc(sizeof(int) * X);
    G->edge = (int**)malloc(sizeof(int*) * X);

    for(int i = 0; i < X; i++)
        G->edge[i] = (int*)malloc(sizeof(int) * X);

    for(int i = 0; i < X; i++)
        for(int j = 0; j < X; j++)
            G->edge[i][j] = 0;

    return G;
}

void InsertEdge(Graph *G, int u, int v)
{
    int i, j;
    for(i = 0; i < G->size; i++)
        if(G->vertex[i] == u)
            break;

    for(j = 0; j < G->size; j++)
        if(G->vertex[j] == v)
            break;

    G->edge[i][j] = 1;
}

void Topsort(Graph *G)
{
    Queue* Q = CreateQueue(G->size);
    int inDegree[G->size]; 

    for(int i = 0; i < G->size; i++) 
        inDegree[i] = 0;

    for(int i = 0; i < G->size; i++)
        for(int j = 0; j < G->size; j++)
            inDegree[j] += G->edge[i][j];

    for(int i = 0; i < G->size; i++)
        if(inDegree[i] == 0)
            Enqueue(Q, G->vertex[i]);

    while(1)
    {
        int x = Dequeue(Q);
        if(x < 0)
            break;
        printf("%d ", x);

        int i;
        for(i = 0; i < G->size; i++)
        {
            if(G->vertex[i] == x)
                break;
        }
        for(int y = 0; y < G->size; y++)
        {
            if(G->edge[i][y] == 1)
            {
                inDegree[y]--;
                if(inDegree[y] == 0)
                    Enqueue(Q, G->vertex[y]);
            }
        }
    }
    printf("\n");
}

int main(int argc, char *argv[])
{
    FILE *fi = fopen(argv[1], "r");
    int X, u, v;
    fscanf(fi, "%d", &X);
    
    Graph *G = CreateGraph(X);

    for(int i = 0; i < X; i++)
        fscanf(fi, "%d", &G->vertex[i]);
    
    while(fscanf(fi, "%d %d", &u, &v) != EOF)
        InsertEdge(G, u, v);

    Topsort(G);
    
    return 0;
}