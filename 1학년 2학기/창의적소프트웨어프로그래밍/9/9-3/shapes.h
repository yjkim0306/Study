/* 221014 LAB 9 */
#include <iostream>
#pragma once
using namespace std;
class Shape{
    public:
        Shape();
        Shape(int x_, int y_, char brush_);
        double GetArea(){};
        int GetPerimeter(){};
        void Draw(int canvas_width, int canvas_height){};
    protected:
        int x, y;
        char brush;
};

class Rectangle: public Shape
{
    int width, height;
    public:
        Rectangle(int width, int height, int x, int y, char brush);
        double GetArea();
        int GetPerimeter();
        void Draw(int canvas_width, int canvas_height);
};

class Square: public Shape
{
    int length;
    public:
        Square(int length, int x, int y, char brush);
        double GetArea();
        int GetPerimeter();
        void Draw(int canvas_width, int canvas_height);
};

class Diamond: public Shape
{
    int distance;
    public:
        Diamond(int distance, int x, int y, char brush);
        double GetArea();
        int GetPerimeter();
        void Draw(int canvas_width, int canvas_height);
};