#include <stdio.h>
#include <stdlib.h>
#include <time.h>

typedef struct _DisjointSet{
    int size;
    int *ptr_arr;
}DisjointSets;

typedef struct _PrintDisjointSet{
    int size;
    int *ptr_arr;
}PrintDisjointSets;

void init(DisjointSets *sets, PrintDisjointSets *maze, int n);
int find(DisjointSets *sets, int x);
void union_(DisjointSets *sets, int i, int j);
void createMaze(DisjointSets *sets, PrintDisjointSets *maze, int n);
void printMaze(PrintDisjointSets *maze, int n);
void freeMaze(DisjointSets *sets, PrintDisjointSets *maze);

void init(DisjointSets *sets, PrintDisjointSets *maze, int n)
{
    sets->size = n * n;
    maze->size = 2 * n * (n + 1);
    sets->ptr_arr = (int *)malloc(sizeof(int) * sets->size + 1);
    maze->ptr_arr = (int *)malloc(sizeof(int) * maze->size + 1);

    for(int i = 1; i <= sets->size; i++)
        sets->ptr_arr[i] = 0;

    for(int i = 0; i < maze->size; i++)
        maze->ptr_arr[i] = 1;
}

int find(DisjointSets *sets, int x)
{
    if(sets->ptr_arr[x] <= 0)
        return x;
    else
        return (sets->ptr_arr[x] = find(sets, sets->ptr_arr[x]));
}

void union_(DisjointSets *sets, int i, int j)
{
    int p1 = find(sets, i);
    int p2 = find(sets, j);

    if(sets->ptr_arr[p2] < sets->ptr_arr[p1])
        sets->ptr_arr[p1] = p2;
    else
    {
        if(sets->ptr_arr[p2] == sets->ptr_arr[p1])
            sets->ptr_arr[p1]--;
        sets->ptr_arr[p2] = p1;
    }
}

void createMaze(DisjointSets *sets, PrintDisjointSets *maze, int n)
{
    srand(time(NULL));
    int s = n * n;
    
    while(find(sets, 1) != find(sets, s))
    {
        int wall = rand() % (2 * s + 1);

        if(wall >= 1 && wall <= s)
        {
            int cell_a = wall;
            int cell_b = cell_a + 1;
            if(cell_a % n == 0)
                continue;
            if(find(sets, cell_a) != find(sets, cell_b))
            {
                maze->ptr_arr[wall] = 0;
                union_(sets, cell_a, cell_b);
            }
        }
        else
        {
            int cell_a = wall % s;
            if(cell_a == 0)
                cell_a = s;
            int cell_b = cell_a + n;
            
            if(cell_b > s)
                continue;
            if(find(sets, cell_a) != find(sets, cell_b))
            {
                maze->ptr_arr[wall] = 0;
                union_(sets, cell_a, cell_b);
            }
        }
    }
}

void printMaze(PrintDisjointSets *maze, int n)
{
    int s = n * n;
    maze->ptr_arr[s] = 0;
    for(int i = 0; i < n; i++)
        printf(" -");
    printf("\n");

    for(int i = 0; i < n; i++)
    {
        if(i != 0)
            printf("|");
        else
            printf(" ");
        for(int j = 1; j <= n; j++)
        {
            char x = (maze->ptr_arr[i * n + j] ? '|' : ' ');
            printf(" %c", x);
        }
        printf("\n");

        for(int j = 1; j <= n; j++)
        {
            char x = (maze->ptr_arr[i * n + j + s] ? '-' : ' ');
            printf(" %c", x);
        }
        printf("\n");
    }
}

void freeMaze(DisjointSets *sets, PrintDisjointSets *maze)
{
    free(sets);
    free(sets->ptr_arr);

    free(maze);
    free(maze->ptr_arr);
}

int main(int argc, char* argv[])
{
    int num;
    FILE *fi = fopen(argv[1], "r");
    fscanf(fi, "%d", &num);
    fclose(fi);

    DisjointSets *sets;
    PrintDisjointSets *maze;

    sets = (DisjointSets*)malloc(sizeof(DisjointSets));
    maze = (PrintDisjointSets*)malloc(sizeof(PrintDisjointSets));

    init(sets, maze, num);

    createMaze(sets, maze, num);

    printMaze(maze, num);

    freeMaze(sets, maze);

    return 0;
}