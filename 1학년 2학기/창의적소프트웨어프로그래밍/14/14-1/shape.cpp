/* 221110 LAB 14 */
#include "shape.h"
using namespace std;
inline Shape::Shape(double width, double height)
{
    this->width = width;
    this->height = height;
}
inline Shape::~Shape(){};

inline Triangle::Triangle(double width, double height) : Shape(width, height)
{
    this->width = width;
    this->height = height;
}

inline double Triangle::getArea() const
{
    double area = 0.5 * width * height;
    return area;
}

inline Rectangle::Rectangle(double width, double height) : Shape(width, height)
{
    this->width = width;
    this->height = height;
}

inline double Rectangle::getArea() const
{
    double area = width * height;
    return area;
}