/* 221104 LAB 13 */
#include <iostream>
#include <string>
#include <vector>
#include "canvas.h"
using namespace std;
Canvas::Canvas(int row, int col)
{
    width = row;
    height = col;
    vector<string> str;
    for(int i = 0; i <= width; i++)
    {
        str.push_back(" ");
    }
    for(int i = 0; i <= height; i++)
    {
        canvas.push_back(str);
    }
    for(int i = 0; i < height; i++)
    {
        canvas[i+1][0] = to_string(i%10);
    }
    for(int i = 0; i < width; i++)
    {
        canvas[0][i+1] = to_string(i%10);
    }
    for(int i = 1; i <= height; i++)
    {
        for(int j = 1; j <= width; j++)
        {
            canvas[i][j] = ".";
        }
    }
}

Canvas::~Canvas() {}

void Canvas::DrawPixel(int x, int y, char brush)
{
    string space = "";
    space.push_back(brush);
    if(x <= width && x > 0 && y <= height && y > 0) 
    {
        canvas[y][x] = space;
    }
}

void Canvas::Print()
{
    for(int i = 0; i <= height; i++)
    {
        for(int j = 0; j <= width; j++)
        {
            cout << canvas[i][j];
        }
        cout << endl;
    }
}

Shape::~Shape() {}

void Shape::Draw(Canvas* canvas) {}

Rectangle::Rectangle(int x_, int y_, int width_, int height_, char brush_)
{
    x = x_;
    y = y_;
    width = width_;
    height = height_;
    brush = brush_; 
}

Rectangle::~Rectangle() {}

void Rectangle::Draw(Canvas* canvas)
{
    for(int i = 0; i < height; i++)
    {
        for(int j = 0; j < width; j++)
        {
            canvas->DrawPixel(x+1+j, y+1+i, brush);
        }
    }
}

UpTriangle::UpTriangle(int x_, int y_, int height_, char brush_)
{
    x = x_;
    y = y_;
    height = height_;
    brush = brush_;
}

UpTriangle::~UpTriangle() {}

void UpTriangle::Draw(Canvas* canvas)
{
    for(int i = 0; i < height; i++)
    {
        for(int j = 0; j <= i; j++)
        {
            canvas->DrawPixel(x+1+j, y+1+i, brush);
            canvas->DrawPixel(x+1-j, y+1+i, brush);
        }
    }
}

DownTriangle::DownTriangle(int x_, int y_, int height_, char brush_)
{
    x = x_;
    y = y_;
    height = height_;
    brush = brush_;
}

DownTriangle::~DownTriangle() {}

void DownTriangle::Draw(Canvas* canvas)
{
    for(int i = 0; i < height; i++)
    {
        for(int j = 0; j <= i; j++)
        {
            canvas->DrawPixel(x+1+j, y+1-i, brush);
            canvas->DrawPixel(x+1-j, y+1-i, brush);
        }
    }
}

Diamond::Diamond(int x_, int y_, int height_, char brush_)
{
    x = x_;
    y = y_;
    height = height_;
    brush = brush_;
}

Diamond::~Diamond() {}

void Diamond::Draw(Canvas* canvas)
{
    string space = "";
    space.push_back(brush);
    for(int i = 0; i < height*2+1; i++)
    {
        if(i <= height)
        {
            for(int j = 0; j <= i; j++)
            {
                canvas->DrawPixel(x+1+j, y+1+i, brush);
                canvas->DrawPixel(x+1-j, y+1+i, brush);
            }
        }
        else
        {
            for(int j = 0; j < height*2+1-i; j++)
            {
                canvas->DrawPixel(x+1+j, y+1+i, brush);
                canvas->DrawPixel(x+1-j, y+1+i, brush);
            }
        }
    }
}