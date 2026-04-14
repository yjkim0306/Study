/* 221118 LAB 16 */
#ifndef __MY_VECTOR_H__
#define __MY_VECTOR_H__
#include <iostream>
using namespace std;
// my_vector.h - DO NOT modify this class definition
class MyVector
{
    public:
        // Implement constructor & destructor
        MyVector();
        MyVector(int length);
        ~MyVector();

        // Implement operators
        MyVector& operator=(const MyVector& b);
        MyVector operator+(const MyVector& b);
        MyVector operator-(const MyVector& b);
        MyVector operator+(const int b);
        MyVector operator-(const int b);
        friend ostream& operator<<(ostream& out, MyVector& b);
        friend istream& operator>>(istream& in, MyVector& b);

    private:
        int length;
        double *a;
};

#endif // __MY_VECTOR_H__