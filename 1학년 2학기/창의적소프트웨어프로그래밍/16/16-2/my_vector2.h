/* 221118 LAB 16 */
#ifndef __MY_VECTOR_H__
#define __MY_VECTOR_H__
#include <iostream>
using namespace std;
// my_vector2.h - DO NOT modify this class definition
class MyVector2
{
    public:
        // Implement constructor & destructor
        MyVector2();
        MyVector2(int length);
        MyVector2(const MyVector2& mv);
        ~MyVector2();
        
        // Incorrect implementation of assignment operator.
        // Do not use the assignment operator.
        // Do not correct this because the goal is to prevent using the assignment operator.
        MyVector2& operator=(const MyVector2& b) { return *this; };
        
        // Just use the same implementation for these operators
        MyVector2 operator+(const MyVector2& b);
        MyVector2 operator-(const MyVector2& b);
        MyVector2 operator+(const int b);
        MyVector2 operator-(const int b);
        friend ostream& operator<<(ostream& out, MyVector2& b);
        friend istream& operator>>(istream& in, MyVector2& b);

    private:
        int length;
        double *a;
};

#endif // __MY_VECTOR_H__