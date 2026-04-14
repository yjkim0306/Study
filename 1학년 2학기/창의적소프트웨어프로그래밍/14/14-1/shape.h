/* 221110 LAB 14 */
#pragma once
#include <iostream>
#include <vector>
using namespace std;
class Shape
{
public:
    Shape(double width, double height);
    virtual ~Shape();
    virtual double getArea() const = 0;

protected:
    double width, height;
};

class Triangle: public Shape
{
public:
    Triangle(double width, double height);
    double getArea() const;
};

class Rectangle: public Shape
{
public:
    Rectangle(double width, double height);
    double getArea() const;
};