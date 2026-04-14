/* 221014 LAB 9 */
#include <iostream>
#include <cmath>
using namespace std;
#include "shapes.h"
Shape::Shape(int x, int y, char brush)
{
    this->x = x;
    this->y = y;
    this->brush = brush;
}

Rectangle::Rectangle(int width, int height, int x, int y, char brush):Shape(x, y, brush)
{
    this->width = width;
    this->height = height;
}

double Rectangle::GetArea()
{
    return width * height;
}

int Rectangle::GetPerimeter()
{
    return 2 * (width + height);
}

void Rectangle::Draw(int canvas_width, int canvas_height)
{
    for(int i = 0; i <= canvas_height; i++)
    {
        for(int j = 0; j <= canvas_width; j++)
        {
            if(i == 0 && j == 0) cout << " ";
            else if(i == 0) cout << j-1;
            else if(j == 0) cout << i-1;
            else
            {
                if(i >= y + 1 && i < y + 1 + height && j >= x + 1 && j < x + 1 + width) cout << brush;
                else cout << ".";
            }
        }
        cout << "\n";
    }
}

Square::Square(int length, int x, int y, char brush):Shape(x, y, brush)
{
    this->length = length;    
}

double Square::GetArea()
{
    return length * length;
}

int Square::GetPerimeter()
{
    return 4 * length;
}

void Square::Draw(int canvas_width, int canvas_height)
{
    for(int i = 0; i <= canvas_height; i++)
    {
        for(int j = 0; j <= canvas_width; j++)
        {
            if(i == 0 && j == 0) cout << " ";
            else if(i == 0) cout << j-1;
            else if(j == 0) cout << i-1;
            else
            {
                if(i >= y + 1 && i < y + 1 + length && j >= x + 1 && j < x + 1 + length) cout << brush;
                else cout << ".";
            }
        }
        cout << "\n";
    }
}

Diamond::Diamond(int distance, int x, int y, char brush):Shape(x, y, brush)
{
    this->distance = distance;
}

double Diamond::GetArea()
{
    return (1 + 2 * distance) * (1 + 2 * distance) / 2;
}

int Diamond::GetPerimeter()
{
    return int((1 + 2 * distance) / sqrt(2)) * 4;
}

void Diamond::Draw(int canvas_width, int canvas_height){
    bool** can=new bool*[canvas_height];
    for(int i=0; i<=canvas_height; i++)
        can[i]=new bool[canvas_width];
    for(int i=0; i<=canvas_height; i++)
        for(int j=0; j<=canvas_width; j++)
            can[i][j]=false;
    int nx=x+1;
    int ny=y+distance+1;
    for(int i=0; i<=distance; i++)
        for(int j=0; j<=distance; j++)
            if(i+j<=distance){
                if(ny+i<=canvas_height && nx+j<=canvas_width)
                    can[ny+i][nx+j]=true;
                if(ny+i<=canvas_height && nx-j>0)    
                    can[ny+i][nx-j]=true;
                if(ny-i>0 && nx+j<=canvas_width)
                    can[ny-i][nx+j]=true;
                if(ny-i>0 && nx-j>0)
                    can[ny-i][nx-j]=true;
            }
    for(int i=0; i<=canvas_height; i++){
        for(int j=0; j<=canvas_width; j++){
            if(i==0 && j==0) cout << " ";
            else if(i==0) cout << j-1;
            else if(j==0) cout << i-1;
            else{
                if(can[i][j])
                    cout << brush;
                else
                    cout << ".";
            }
        }
        cout << endl;
    }
    for(int i=0; i<canvas_height; i++)
        delete[] can[i];
    delete[] can;
}
