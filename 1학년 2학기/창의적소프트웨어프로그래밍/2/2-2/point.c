/* 220915 LAB 2 */
#include <stdio.h>

typedef struct 
{
    int xpos;
    int ypos;
} Point;

Point getScale2xPoint(const Point* p)
{
    Point a; //빈 구조체
    a.xpos = p-> xpos * 2; 
    a.ypos = p-> ypos * 2;
    return a;
}

void swapPoints(Point* p1,Point* p2)
{
    Point temp; //임시 구조체
    temp = *p1;
    *p1 = *p2;
    *p2 = temp;
}

int main()
{
    Point pos1;
    scanf("%d %d", &pos1.xpos, &pos1.ypos);
    Point pos2 = getScale2xPoint(&pos1);
    printf("Calling getScale2xPoint()\nP1 : %d %d\nP2 : %d %d\n", pos1.xpos, pos1.ypos, pos2.xpos, pos2.ypos);
    swapPoints(&pos1,&pos2);
    printf("Calling swapPoint()\nP1 : %d %d\nP2 : %d %d\n", pos1.xpos, pos1.ypos, pos2.xpos, pos2.ypos);
    return 0;
}
