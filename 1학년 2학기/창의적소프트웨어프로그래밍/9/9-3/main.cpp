/* 221014 LAB 9 */
#include <iostream>
#include <string>
using namespace std;
#include "shapes.h"
int main()
{
    int canvas_x, canvas_y, x, y;
    string shape;
    char brush;
    cin >> canvas_x >> canvas_y;
    while(1)
    {
        cin >> shape;
        if(shape == "quit") break;
        if(shape == "rect")
        {
            int width, height;
            cin >> x >> y >> width >> height;
            cin >> brush;
            Rectangle rect(width, height, x, y, brush);
            cout << "Area: " << rect.GetArea() << "\n";
            cout << "Perimeter: " << rect.GetPerimeter() << "\n";
            rect.Draw(canvas_x, canvas_y);
        }
        if(shape == "square")
        {
            int length;
            cin >> x >> y >> length;
            cin >> brush;
            Square square(length, x, y, brush);
            cout << "Area: " << square.GetArea() << "\n";
            cout << "Perimeter: " << square.GetPerimeter() << "\n";
            square.Draw(canvas_x, canvas_y);
        }
        if(shape == "diamond")
        {
            int distance;
            cin >> x >> y >> distance;
            cin >> brush;
            Diamond diamond(distance, x, y, brush);
            cout << "Area: " << diamond.GetArea() << "\n";
            cout << "Perimeter: " << diamond.GetPerimeter() << "\n";
            diamond.Draw(canvas_x, canvas_y);
        }
    }
    return 0;
}