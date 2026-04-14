/* 221014 LAB 9 */
//main.cpp
#include <iostream>
using namespace std;
#include "number.h"
int main()
{
    string shape;
    while(1)
    {
        cin >> shape;
        if(shape == "quit") break;
        int input;
        if(shape == "number")
        {
            cin >> input;
            Number n;
            n.setNumber(input);
            cout << "getNumber(): " << n.getNumber() << "\n";
        }
        else if(shape == "square")
        {
            cin >> input;
            Square s;
            s.setNumber(input);
            cout << "getNumber(): " << s.getNumber() << "\ngetSquare(): " << s.getSquare() << "\n";
        }
        else if(shape == "cube") 
        {
            cin >> input;
            Cube c;
            c.setNumber(input);
            cout << "getNumber(): " << c.getNumber() << "\ngetSquare(): " << c.getSquare() << "\ngetCube(): " << c.getCube() << "\n";
        }
    }
    return 0;
}