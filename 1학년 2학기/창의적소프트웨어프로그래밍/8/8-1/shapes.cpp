//shapes.cpp
#include <iostream>
using namespace std;
#include "shapes.h"

double res;
void Circle::cset(int x, int y, int r)
{
    x_ = x;   
    y_ = y;
    r_ = r;
}
void Circle::cArea()
{
    res = 3.14*r_*r_;
    cout << res;
}
void Circle::cPerimeter()
{
    res = 2*3.14*r_;
    cout << res << "\n";
}

void Rectangle::rset(int x1, int y1, int x2, int y2)
{
    x1_ = x1;
    y1_ = y1;
    x2_ = x2;
    y2_ = y2;
}
void Rectangle::rArea()
{
    res = (x2_ - x1_) * (y1_ - y2_);
    cout << res;
}

void Rectangle::rPerimeter()
{
    res = 2 * ((x2_ - x1_) + (y1_ - y2_));
    cout << res << "\n";
}