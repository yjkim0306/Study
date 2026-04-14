/* 221014 LAB 9 */
#include <iostream>
#include <string>
using namespace std;
#include "rect.h"
int main()
{
    while(1)
    {
        string shape;
        int width, height;
        cin >> shape;
        if(shape == "quit") break;
        if(shape == "nonsquare")
        {
            cin >> width >> height;
            NonSquare* ns = new NonSquare(width, height);
            ns -> print();
            cout << "Area: " << ns -> getArea() << "\n";
            cout << "Perimeter: " << ns -> getPerimeter() << "\n";
            delete ns;
        }
        else if(shape == "square")
        {
            cin >> width;
            Square* s = new Square(width);
            s -> print();
            cout << "Area: " << s -> getArea() << "\n";
            cout << "Perimeter: " << s -> getPerimeter() << "\n";
            delete s;
        }
    }
    return 0;
}