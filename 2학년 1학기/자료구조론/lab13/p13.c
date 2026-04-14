#include <stdio.h>
#include <stdlib.h>

const int INF = (int)2e9; // 매우 큰 수; 초기 설정용

typedef struct Node
{
    int vertex; // 정점 번호
    int dist; // 최단 거리
    int prev; // 경로 이전 정점
}Node;

typedef struct Graph
{
    int size; 
    Node* nodes; // 정점의 집합
    int** matrix; // 두 정점 사이의 거리를 저장할 2차원 배열
}Graph;

typedef struct Heap
{
    int capacity; 
    int size;
    Node* elements;
}Heap;

Graph* createGraph(int X);
Graph* findShortestPath(Graph* G, int s);
void printShortestPath(Graph* G);

Heap* createMinHeap(int X);
void insert(Heap* H, Node N);
Node deleteMin(Heap* H);
void decreaseKey(Heap* H, Node N);

Graph* createGraph(int X)
{
    Graph* G = malloc(sizeof(struct Graph));
    if(G == NULL)
    {
        printf("Out of space!!!\n");
        exit(0);
    }

    G->size = X;
    G->nodes = malloc(sizeof(struct Node) * (X + 1));
    if(G->nodes == NULL)
    {
        printf("Out of space!!!\n");
        exit(0);
    }

    for(int i = 1; i <= X; i++)
    {
        G->nodes[i].vertex = i;
        G->nodes[i].dist = INF;
        G->nodes[i].prev = -1;
    }

    G->matrix = (int**)malloc(sizeof(int*) * (X + 1));
    if(G->matrix == NULL)
    {
        printf("Out of space!!!\n");
        exit(0);
    }

    for(int i = 1; i <= X; i++)
    {
        G->matrix[i] = (int*)malloc(sizeof(int) * (X + 1));
        if(G->matrix[i] == NULL)
        {
            printf("Out of space!!!\n");
            exit(0);
        }
    }

    for(int i = 1; i <= X; i++) // 배열 0으로 초기화
    {
        for(int j = 1; j <= X; j++)
            G->matrix[i][j] = 0;
    } 

    return G;
}

Graph* findShortestPath(Graph* G, int s)
{
    Heap* H = createMinHeap(G->size + 1); // 정점의 개수보다 1 더 크게
    G->nodes[s].dist = 0; // 시작점의 최단 거리 0으로 초기화
    for(int i = 1; i <= G->size; i++)
    {
        if(i != s && G->matrix[s][i] != 0) // 시작점이 아니고 시작점에서 도달 가능하다면
        {
            G->nodes[i].dist = G->matrix[s][i]; // 최단 거리를 업데이트
            G->nodes[i].prev = s; // 이전 정점을 시작점으로 설정
        }
    }

    for(int i = 1; i <= G->size; i++)
        if(i != s) // 시작점이 아닌 경우
            insert(H, G->nodes[i]); // 최소 힙(우선순위 큐 역할)에 각 정점을 넣어줌
    
    /* 수업자료에 나온대로 구현 */
    while(H->size != 0)
    {
        Node min = deleteMin(H);
        for(int i = 1; i <= G->size; i++)
        {
            if(G->matrix[min.vertex][i] != 0) 
            {
                if(min.dist + G->matrix[min.vertex][i] < G->nodes[i].dist)
                {
                    G->nodes[i].dist = min.dist + G->matrix[min.vertex][i];
                    G->nodes[i].prev = min.vertex;
                    decreaseKey(H, G->nodes[i]);
                }
            }
        }
    }

    return G;
}

void printShortestPath(Graph* G)
{
    for(int i = 2; i <= G->size; i++) // 1번 정점은 어차피 도달 불가하므로 2번부터 탐색
    {
        Node current = G->nodes[i]; // 현재 정점을 나타낼 노드; 업데이트해줘야돼서 따로 변수로 만듦
        int dis = current.dist; // 비용을 나타낼 정수; 현재 정점이 업데이트될 때마다 바꿔주어야 돼서 따로 변수로 만듦
        printf("%d", current.vertex); // 도착점부터 출력
        while(1)
        {
            if(current.prev == -1) // 시작점이면
            {
                if(dis != INF) // 도달 가능하면
                    printf(" cost: %d\n", dis); // 비용 출력
                else // 도달 불가능하면
                    printf(" can not be reached.\n"); 
                break;
            }
            else
            {
                printf("<-%d", current.prev); // 이전 정점 출력
                current = G->nodes[current.prev]; // 현재 정점을 이전 정점으로 업데이트
            }
        }
    }
}

Heap* createMinHeap(int X)
{
    Heap* H = malloc(sizeof(struct Heap));
    if(H == NULL)
    {
        printf("Out of space!!!\n");
        exit(0);
    }

    H->capacity = X;
    H->size = 0;
    H->elements = malloc(sizeof(struct Node) * (X + 1));
    if(H->elements == NULL)
    {
        printf("Out of space!!!\n");
        exit(0);
    }

    return H;
}

void insert(Heap* H, Node N)
{
    if(H->size == H->capacity)
    {
        printf("Heap is full.\n");
        return;
    }
    
    /* p9.c - maxHeap과 반대 조건으로 설정 */
    int i;
    for(i = ++H->size; H->elements[i / 2].dist > N.dist && i != 1; i /= 2)
        H->elements[i] = H->elements[i / 2];
    H->elements[i] = N;
    return;
}

Node deleteMin(Heap* H)
{
    /* p9.c - deleteMax와 반대 조건으로 설정 */
    Node MinElement, LastElement;
    MinElement = H->elements[1];
    LastElement = H->elements[H->size--];

    int i, Child;
    for(i = 1; i * 2 <= H->size; i = Child)
    {
        Child = i * 2;
        if(Child != H->size && H->elements[Child].dist > H->elements[Child + 1].dist) // 반대 조건
            Child++;
        if(LastElement.dist > H->elements[Child].dist) // 반대 조건
            H->elements[i] = H->elements[Child];
        else
            break;
    }

    H->elements[i] = LastElement;
    return MinElement;
}

void decreaseKey(Heap* H, Node N)
{
    int i;
    for(i = 1; i <= H->size; i++)
        if(H->elements[i].vertex == N.vertex)
            break;
    for(; H->elements[i / 2].dist > N.dist && i != 1; i /= 2)
        H->elements[i] = H->elements[i / 2];
    H->elements[i] = N;
    return;
}

int main(int argc, char* argv[])
{
    FILE* fi = fopen(argv[1], "r");
    int size;

    fscanf(fi, "%d", &size);

    Graph* G = createGraph(size);

    int node_s, node_d, weight;

    while(fscanf(fi, "%d %d %d", &node_s, &node_d, &weight) != EOF)
        G->matrix[node_s][node_d] = weight;
    
    G = findShortestPath(G, 1);

    printShortestPath(G);

    return 0;
}