#include <stdio.h>
#include <stdlib.h>

typedef struct Node* PtrToNode;
typedef PtrToNode List;
typedef PtrToNode Position;
typedef int ElementType;

struct Node{
    ElementType element;
    Position next;
};

List MakeEmptyList()
{
    List l = (List)malloc(sizeof(struct Node));
    l->element = -999;
    l->next = NULL;
    return l;
}

int isLast(Position p, List l)
{
    Position current = l;
    while(current->next != NULL)
        current = current->next;
    return p == current;
}

// returns key of the previous node of x in list l.
Position FindPrevious(ElementType x, List l) 
{
    Position p;
    p = l;
    while(p->next != NULL && p->next->element != x)
        p = p->next;
    return p;
}

// returns the position of the key x in l
Position Find(ElementType x, List l)
{
    if(x == -1)
    {
        return l;
    }
    Position p;
    p = l->next;
    while(p != NULL && p->element != x)
        p = p->next;
    return p;
}

// insert x after p in l 
void Insert(ElementType x, Position p, List l)
{
    Position TmpCell;

    TmpCell = malloc(sizeof(struct Node));
    if(TmpCell == NULL) 
    {
        printf("Out of space!!!");
        return;
    }
    if(p == NULL)
    {
        printf("Insertion (%d) Failed: cannot find the location to be inserted.\n", x);
        return;
    }
    TmpCell->element = x;
    TmpCell->next = p->next;
    p->next = TmpCell;
}

// delete x in l
void Delete(ElementType x, List l)
{
    Position p, TmpCell;

    p = FindPrevious(x, l);
    if(!isLast(p, l))
    {
        TmpCell = p->next;
        p->next = TmpCell->next;
        free(TmpCell);
    }
    else printf("Deletion failed: element %d is not in the list.\n", x);
}

void DeleteList(List l)
{
    Position p = NULL, tmp = NULL;
    p = l->next;
    l->next = NULL;
    while(p != NULL)
    {
        tmp = p->next;
        free(p);
        p = tmp;
    }
}

void PrintList(List l)
{
    PtrToNode tmp = NULL;
    tmp = l->next;
    if(tmp == NULL)
    {
        printf("list is empty!\n");
        return;
    }
    while(tmp != NULL)
    {
        printf("key: %d\t", tmp->element);
        tmp = tmp->next;
    }
    printf("\n");
}

int main(int argc, char* argv[])
{
    char command;
    int key1, key2;
    FILE *input, *output;
    Position header = NULL, tmp = NULL;
    
    if(argc <= 1)
    {
    	printf("Please enter an input file.");
        return 0;
    }
    else
        input = fopen(argv[1], "r");
    
    header = MakeEmptyList();

    while(1)
    {
        command = fgetc(input);
        if(feof(input)) break;
        
        switch(command)
        {
            case 'i':
                fscanf(input, "%d %d\n", &key1, &key2);
                tmp = Find(key2, header);
                Insert(key1, tmp, header);
                break;
            case 'd':
                fscanf(input, "%d\n", &key1);
                Delete(key1, header);
                break;
            case 'f':
                fscanf(input, "%d\n", &key1);
                tmp = FindPrevious(key1, header);
                if(isLast(tmp, header)) 
                    printf("Could not find %d in the list.\n", key1);
                else if(tmp->element > 0) 
                    printf("Key of the previous node of %d is %d.\n", key1, tmp->element);
                else 
                    printf("Key of the previous node of %d is header.\n", key1);
                break;
            case 'p':
                PrintList(header);
                break;
            default:
                printf("Invalid command line");
        }
    }

    DeleteList(header);
    fclose(input);
    
    return 0;
}