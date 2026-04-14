/* 221118 LAB 16 */
#include "my_vector.h"
using namespace std;
inline MyVector::MyVector() {}

inline MyVector::MyVector(int length)
{
    this->length = length;
    a = new double[length];
    for(int i = 0; i < length; i++) a[i] = this->a[i];
}

inline MyVector::~MyVector()
{
    delete[] a;
}

inline MyVector& MyVector::operator=(const MyVector& b)
{
    length = b.length;
    a = new double[length];
    for(int i = 0; i < length; i++)
    {
        a[i] = b.a[i];
    }
    return *this;
}

inline MyVector MyVector::operator+(const MyVector& b)
{
    MyVector result(length);
    for(int i = 0; i < b.length; i++)
    {
        result.a[i] = a[i] + b.a[i];
    }
    return result;
}

inline MyVector MyVector::operator-(const MyVector& b)
{
    MyVector result(length);
    for(int i = 0; i < b.length; i++)
    {
        result.a[i] = a[i] - b.a[i];
    }
    return result;
}

inline MyVector MyVector::operator+(const int b)
{
    MyVector result(length);
    for(int i = 0; i < length; i++)
    {   
        result.a[i] = a[i] + b;
    }
    return result;
}

inline MyVector MyVector::operator-(const int b)
{
    MyVector result(length);
    for(int i = 0; i < length; i++)
    {
        result.a[i] = a[i] - b;
    }
    return result;
}

inline ostream& operator<<(ostream& out, MyVector& b)
{
    for(int i = 0; i < b.length; i++)
    {
        out << b.a[i] << " ";
    }
    return out;
}

inline istream& operator>>(istream& in, MyVector& b)
{
    for(int i = 0; i < b.length; i++)
    {
        in >> b.a[i];
    }
    return in;
}