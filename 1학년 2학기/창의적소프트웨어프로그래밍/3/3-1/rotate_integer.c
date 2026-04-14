/* 220916 LAB 3 */
#include <stdio.h>

void rotateLeft(int* pa, int* pb, int* pc){
    int temp;
    temp = *pa;
    *pa = *pb;
    *pb = *pc;
    *pc = temp;
}

void rotateRight(int* pa, int* pb, int* pc){
    int temp;
    temp = *pc;
    *pc = *pb;
    *pb = *pa;
    *pa = temp;
}

int main(){
    int a = 10, b = 20, c =30;
    printf("%d:%d:%d\n", a, b, c);

    while(1)
    {
        int input;
        scanf("%d", &input);
        if(input==1) rotateLeft(&a,&b,&c);
        if(input==2) rotateRight(&a,&b,&c);
        else if(input!=1 && input!=2) break;
        printf("%d:%d:%d\n", a,b,c);
    }
}