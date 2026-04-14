//main.cpp
#include <iostream>
#include "shapes.h"
using namespace std;
int main()
{
    Circle circle;
    Rectangle rect;
    char shape;
    int a, b, c, d;
    while(1)
    {
        cout << "shape?" << "\n";
        cin >> shape;
        if(shape == 'C') 
        {
            cin >> a >> b >> c;
            circle.cset(a, b, c);
            cout << "area: ";
            circle.cArea();
            cout << ", perimeter: ";
            circle.cPerimeter();
        }
        else if(shape == 'R')
        {
            cin >> a >> b >> c >> d;
            rect.rset(a, b, c, d);
            cout << "area: ";
            rect.rArea();
            cout << ", perimeter: ";
            rect.rPerimeter();
        }
        else if(shape == 'Q') return 0;
        cout << "\n";
    }
    return 0;
}