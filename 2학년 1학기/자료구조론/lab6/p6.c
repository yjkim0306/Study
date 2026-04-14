#include <stdio.h>
#include <stdlib.h>

struct TreeStruct{
    int size; // 최대 노드 개수
    int numOfNode; // 현재 노드 개수
    int* element;
};

typedef struct TreeStruct* Tree;

Tree CreateTree(int size);
void Insert(Tree tree, int value);
void PrintTree(Tree tree);
void PrintPreorder(Tree tree, int index);
void PrintInorder(Tree tree, int index);
void PrintPostorder(Tree tree, int index);
void DeleteTree(Tree tree);

Tree CreateTree(int size)
{
    Tree tree = (Tree)malloc(sizeof(struct TreeStruct));
    if(tree == NULL) 
    {
        printf("Out of space!!!\n");
        exit(0);
    }

    tree->element = (int*)malloc(sizeof(int) * size);
    if(tree->element == NULL)
    {
        printf("Out of space!!!\n");
        exit(0);
    }

    tree->size = size;
    tree->numOfNode = 0;

    return tree;
}

void Insert(Tree tree, int value)
{
    tree->numOfNode++;
    if(tree->numOfNode > tree->size)
    {
        printf("Error! Tree is full.\n");
        return;
    }
    tree->element[tree->numOfNode] = value;
}

void PrintTree(Tree tree)
{
    printf("Preorder: ");
    PrintPreorder(tree, 1);
    printf("\n");
    printf("Inorder: ");
    PrintInorder(tree, 1);
    printf("\n");
    printf("Postorder: ");
    PrintPostorder(tree, 1);
    printf("\n");
}

void PrintPreorder(Tree tree, int index)
{
    if(index <= tree->numOfNode && tree->element[index])
    {
        printf("%d ", tree->element[index]);
        PrintPreorder(tree, index * 2);
        PrintPreorder(tree, index * 2 + 1);
    }
}

void PrintInorder(Tree tree, int index)
{
    if(index <= tree->numOfNode && tree->element[index])
    {
        PrintInorder(tree, index * 2);
        printf("%d ", tree->element[index]);
        PrintInorder(tree, index * 2 + 1);
    }
}

void PrintPostorder(Tree tree, int index)
{
    if(index <= tree->numOfNode && tree->element[index])
    {
        PrintPostorder(tree, index * 2);
        PrintPostorder(tree, index * 2 + 1);
        printf("%d ", tree->element[index]);
    }
}

void DeleteTree(Tree tree)
{
    if(tree == NULL)
    {
        printf("Tree does not exist.\n");
        return;
    }
    else
    {
        free(tree);
        free(tree->element);
    }
}

void main(int argc, char* argv[])
{
    FILE *fi;
    Tree tree;
    int treeSize;
    int tmpNum;

    fi = fopen(argv[1], "r");
    fscanf(fi, "%d", &treeSize);
    tree = CreateTree(treeSize);

    while(fscanf(fi, "%d", &tmpNum) == 1)
    {
        Insert(tree, tmpNum);
    }
    PrintTree(tree);
    DeleteTree(tree);
}