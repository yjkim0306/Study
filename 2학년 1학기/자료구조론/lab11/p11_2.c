#include <stdio.h>
#include <stdlib.h>
#include <string.h>
struct QuickSort
{
    int Capacity;
    int Size;
    int *array;
};

typedef struct QuickSort* QuickSort;

QuickSort make_list(int size);
void Insert(QuickSort q, int a);
void printArray(QuickSort q);
void swap(int *a, int *b);
int middle_partition(QuickSort q, int low, int high);
int leftmost_partition(QuickSort q, int left, int right);
int rightmost_partition(QuickSort q, int left, int right);
void quicksort(QuickSort q, int left, int right, int type);

void main(int argc, char* argv[])
{
    char type_s[10];
    int list_size, key, type_i;
    QuickSort q;
    FILE *fi = fopen(argv[1], "r");

    fscanf(fi, "%s", type_s);
    if(!(strcmp(type_s, "leftmost"))) type_i = 0;
    else if(!(strcmp(type_s, "rightmost"))) type_i = 1;
    else if(!(strcmp(type_s, "middle"))) type_i = 2;

    fscanf(fi, "%d", &list_size);
    q = make_list(list_size);
    for(int i = 0; i < list_size; i++)
    {
        fscanf(fi, "%d", &key);
        Insert(q, key);
    }

    quicksort(q, 0, list_size - 1, type_i);

    free(q->array);
    free(q);
}

QuickSort make_list(int size)
{
    QuickSort q = (QuickSort)malloc(sizeof(struct QuickSort));
    if(q == NULL)
    {
        printf("Out of space!!!\n");
        exit(0);
    }

    q->array = (int*)malloc(sizeof(int) * size);
    if(q->array == NULL)
    {
        printf("Out of space!!!\n");
        exit(0);
    }

    q->Capacity = size;
    q->Size = 0;

    return q;
}

void Insert(QuickSort q, int a)
{
    if(q->Size >= q->Capacity)
    {
        printf("Cannot insert: Array is full.\n");
        return;
    }
    q->array[q->Size++] = a;
}

void printArray(QuickSort q)
{
    printf("result : ");
    for(int i = 0; i < q->Size; i++)
        printf("%d ", q->array[i]);
    printf("\n");
}

void swap(int *a, int *b)
{
    int temp = *a;
    *a = *b;
    *b = temp;
}

int middle_partition(QuickSort q, int low, int high)
{
    int pivot = q->array[(low + high) / 2];
    printf("pivot value : %d\n", pivot);
    int i = low, j = high;
    for(;;)
    {
        while(q->array[i] < pivot) i++;
        while(q->array[j] > pivot) j--;
        if(i < j)
            swap(&q->array[i], &q->array[j]);
        else
        {
            return i;
        }
    }
}

int leftmost_partition(QuickSort q, int left, int right)
{
    int pivot = q->array[left];
    printf("pivot value : %d\n", pivot);
    int i = left, j = right + 1;
    for(;;)
    {
        while(q->array[--j] > pivot);
        while(q->array[++i] < pivot);
        if(i < j)
            swap(&q->array[i], &q->array[j]);
        else
        {
            swap(&q->array[left], &q->array[j]);
            return j;
        }
    }
}

int rightmost_partition(QuickSort q, int left, int right)
{
    int pivot = q->array[right];
    printf("pivot value : %d\n", pivot);
    int i = left - 1, j = right;
    for(;;)
    {
        while(q->array[--j] > pivot);
        while(q->array[++i] < pivot);
        if(i < j)
            swap(&q->array[i], &q->array[j]);
        else
        {
            swap(&q->array[i], &q->array[right]);
            return i;
        }
    }
}

void quicksort(QuickSort q, int left, int right, int type)
{
    if(left >= right)
        return;

    int type_p;
    if(type == 0)
        type_p = leftmost_partition(q, left, right);
    else if(type == 1)
        type_p = rightmost_partition(q, left, right);
    else if(type == 2)
        type_p = middle_partition(q, left, right);
    printArray(q);    
    quicksort(q, left, type_p - 1, type);
    quicksort(q, type_p + 1, right, type);
}