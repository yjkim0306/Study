/* 221104 LAB 13 */
#pragma once
#include <iostream>
#include <string>
#include <vector>
using namespace std;
class Canvas{
    public:
        // 1 < = row <= 10, 1 <= col <= 10
        Canvas(int row, int col);
        ~Canvas();

        // Dot with the brush at (x, y). If (x, y) is outside the canvas, just ignore it.
        void DrawPixel(int x, int y, char brush);

        // Print out the canvas
        void Print();

    private:
        // Define data member to save drawn shapes
        vector<vector<string> > canvas;
        int width, height;
};

class Shape{
    public:
        virtual ~Shape();
        virtual void Draw(Canvas* canvas);
    protected:
    //Define common properties of shapes
        int x, y, width, height;
        char brush;

};

class Rectangle : public Shape{
    /* Define required members */ 
    public:
        Rectangle(int x_, int y_, int width_, int height_, char brush_);
        ~Rectangle();
        void Draw(Canvas* canvas);
};

class UpTriangle : public Shape{
    /* Define required members */
    public:
        UpTriangle(int x_, int y_, int height_, char brush_);
        ~UpTriangle();
        void Draw(Canvas* canvas);
};

class DownTriangle : public Shape{ 
    /* Define required members */ 
    public:
        DownTriangle(int x_, int y_, int height_, char brush_);
        ~DownTriangle();
        void Draw(Canvas* canvas);
};

class Diamond : public Shape{
    /* Define required members */
    public:
        Diamond(int x_, int y_, int height_, char brush_);
        ~Diamond();
        void Draw(Canvas* canvas);
};

