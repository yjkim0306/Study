#include <stdio.h>
#include <stdlib.h>
struct MergeSort{
    int Capacity;
    int Size;
    int *array;
    int *Tmparray;
};

typedef struct MergeSort* MergeSort;

MergeSort make_list(int size);
void Insert(MergeSort m, int a);
void printArray(MergeSort A, int l, int r);
void RmergeSort(MergeSort A, int l, int r);
void ImergeSort(MergeSort A, int n);
void Merge(MergeSort A, int l, int m, int r);
void merge(MergeSort A, int l, int m, int r);

void main(int argc, char *argv[])
{
    int size, key;
    int *iter_tmp, *rec_tmp;
    FILE *fi = fopen(argv[1], "r");
    MergeSort iter_m, rec_m;

    fscanf(fi, "%d", &size);

    iter_m = make_list(size);
    rec_m = make_list(size);

    for(int i = 0; i < size; i++)
    {
        fscanf(fi, "%d", &key);
        Insert(iter_m, key);
        Insert(rec_m, key);
    }

    printf("input : \n");
    printArray(iter_m, 0, iter_m->Size - 1);
    printf("\n");

    printf("iterative : \n");
    ImergeSort(iter_m, iter_m->Size - 1);
    printf("\n");

    printf("recursive : \n");
    RmergeSort(rec_m, 0, rec_m->Size - 1);
    printf("\n");
}

MergeSort make_list(int size)
{
    MergeSort m = (MergeSort)malloc(sizeof(struct MergeSort));
    if(m == NULL)
    {
        printf("Out of space!!!\n");
        exit(0);
    }

    m->array = (int*)malloc(sizeof(int) * size);
    if(m->array == NULL)
    {
        printf("Out of space!!!\n");
        exit(0);
    }

    m->Tmparray = (int*)malloc(sizeof(int) * size);
    if(m->Tmparray == NULL)
    {
        printf("Out of space!!!\n");
        exit(0);
    }

    m->Capacity = size;
    m->Size = 0;

    return m;
}

void Insert(MergeSort m, int a)
{
    if(m->Size >= m->Capacity)
    {
        printf("Cannot insert: Array is full.\n");
        return;
    }
    m->array[m->Size++] = a;
}

void printArray(MergeSort A, int l, int r)
{
    for(int i = l; i <= r; i++)
        printf("%d ", A->array[i]);
    printf("\n");
}

void RmergeSort(MergeSort A, int l, int r)
{
    int c;
    if(l < r)
    {
        c = (l + r) / 2;
        RmergeSort(A, l, c);
        RmergeSort(A, c + 1, r);
        merge(A, l, c + 1, r);
        printArray(A, l, r);
    }
}

void ImergeSort(MergeSort A, int n)
{
    int size, left;
    for(size = 1; size <= n; size *= 2)
    {
        for(left = 0; left < n; left += 2 * size)
        {
            int mid = left + size;
            int right;
            if(left + 2 * size - 1 < n)
                right = left + 2 * size - 1;
            else
                right = n;

            merge(A, left, mid, right);
            printArray(A, left, right);
        }
    }
    
}

void merge(MergeSort A, int l, int m, int r)
{
    int LeftEnd = m - 1;
    int TmpPos = l;
    int NumElements = r - l + 1;

    while(l <= LeftEnd && m <= r)
    {
        if(A->array[l] <= A->array[m])
            A->Tmparray[TmpPos++] = A->array[l++];
        else
            A->Tmparray[TmpPos++] = A->array[m++];
    }

    while(l <= LeftEnd)
        A->Tmparray[TmpPos++] = A->array[l++];
    while(m <= r)
        A->Tmparray[TmpPos++] = A->array[m++];

    for(int i = 0; i < NumElements; i++, r--)
        A->array[r] = A->Tmparray[r];
}