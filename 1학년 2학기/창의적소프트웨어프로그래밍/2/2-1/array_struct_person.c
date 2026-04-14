/* 220915 LAB 2 */
#include <stdio.h>

struct Person {
    char name[11];
    int age;
};

int main()
{
    struct Person student[3];
    for(int i=0; i<3; i++)
    {
        scanf("%s %d", student[i].name, &student[i].age);
    }
    for(int i=0; i<3; i++)
    {
        printf("Name:%s, Age:%d\n", student[i].name, student[i].age);
    }

    return 0;
}