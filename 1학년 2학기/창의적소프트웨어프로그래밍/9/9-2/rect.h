/* 221014 LAB 9 */
#include <iostream>
using namespace std;
class Rectangle{
    public:
        Rectangle(int width, int height); //Implement to store necessary data as member variables
        int getArea(); //Returns the area of this rectangle
        int getPerimeter(); //Returns the perimeter of this rectangle
    protected: //Define member variables you need
        int _width;
        int _height;
};

class Square: public Rectangle{
    public:
        Square(int width); //Implement to call the parent class's constructor properly
        void print(); //Print out information about this object (ex. '5x5 Square')
};

class NonSquare: public Rectangle{
    public:
        NonSquare(int width, int height); //Implement to call the parent class's constructor properly
        void print(); //Print out information about this object (ex. '2x7 NonSquare')
};