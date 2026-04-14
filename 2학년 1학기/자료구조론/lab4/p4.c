#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Stack
{
    int* key;
    int top;
    int max_stack_size;
}Stack;

Stack* CreateStack(int max);
void Push(Stack* s, int x);
int Pop(Stack* s);
int Top(Stack* s);
void DeleteStack(Stack* s);
int IsEmpty(Stack* s);
int IsFull(Stack* s);
void Postfix(Stack* s, char input_str);

Stack* CreateStack(int max)
{
    Stack* s;
    
    s = (Stack*)malloc(sizeof(Stack));
    if(s == NULL)
    {
        printf("Out of space!!!\n");
        exit(0);
    }

    s->key = (int*)malloc(sizeof(int) * max);
    if(s->key == NULL)
    {
        printf("Out of space!!!\n");
        exit(0);
    }

    s->max_stack_size = max;
    s->top = -1;

    return s;
}

void Push(Stack* s, int x)
{
    if(IsFull(s))
    {
        printf("Error: Stack is full.\n");
        return;
    }
    else
        s->key[++s->top] = x;
}

int Pop(Stack* s)
{
    if(IsEmpty(s))
    {
        printf("Error: Stack is empty.\n");
        exit(0);
    }
    else
    {
        int ret = s->key[s->top];
        s->top--;
        return ret;
    }
}

int Top(Stack* s)
{
    if(!IsEmpty(s))
        return s->key[s->top];
    else
    {
        printf("Error: Stack is empty.\n");
        exit(0);
    }
}

void DeleteStack(Stack* s)
{
    if(s == NULL) 
        printf("Stack does not exist.\n");
    else
    {
        while(!IsEmpty(s))
        {
            Pop(s);
        }
        free(s->key);
        free(s);
    }
}

int IsEmpty(Stack* s)
{
    return s->top <= -1;
}

int IsFull(Stack* s)
{
    return s->top >= s->max_stack_size - 1;
}

void Postfix(Stack* s, char input_str)
{   
    if(input_str >= 49 && input_str <= 57)
    {
        int tmp = input_str - '0';
        Push(s, tmp);
    }
    else
    {
        int x = Pop(s);
        int y = Pop(s);
        switch(input_str)
        {
            case '+':
                Push(s, y + x);
                break;
            case '-':
                Push(s, y - x);
                break;
            case '*':
                Push(s, y * x);
                break;
            case '/':
                Push(s, y / x);
                break;
            case '%':
                Push(s, y % x);
                break;
            default:
                printf("Invalid command line.\n");
        }
    }
}

void main(int argc, char* argv[])
{
    FILE* fi = fopen(argv[1], "r");

    Stack* stack = CreateStack(10);
    
    char c;
    printf("Top numbers: ");
    int cnt = 100;
    while(cnt--)
    {
        fscanf(fi, "%c", &c);
        if(c == '#')
            break;
        Postfix(stack, c);
        printf("%d ", Top(stack));
    }
    printf("\n");
    printf("evaluation result: %d\n", Pop(stack));

    fclose(fi);
    DeleteStack(stack);
}