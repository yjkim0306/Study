#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(int argc, char* argv[])
{
    int n = atoi(argv[1]);
    char** names;

    names = (char**)malloc(n * sizeof(char*));
    for(int i = 0; i < n; i++)
    {
        names[i] = (char*)malloc(30 * sizeof(char));
    }

    printf("enter %d names:\n", n);
    
    for(int i = 0; i < n; i++)
    {
        scanf("%s", names[i]);
    }

    printf("the names you entered:\n");
    
    for(int i = 0; i < n; i++)
    {
        printf("%s\n", names[i]);
    }

    for(int i = 0; i < n; i++) free(names[i]);
    free(names);

    return 0;
}