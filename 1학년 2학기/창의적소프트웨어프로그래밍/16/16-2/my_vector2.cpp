/* 221118 LAB 16 */
#include "my_vector2.h"
using namespace std;

inline MyVector2::MyVector2()
{
    length = 0;
    a = 0;
}

inline MyVector2::MyVector2(int length)
{
    this->length = length;
    a = new double[length];
}

inline MyVector2::MyVector2(const MyVector2& mv)
{
    this->length = mv.length;
    a = new double[length];
    for(int i = 0; i < length; i++) a[i] = mv.a[i];
}

inline MyVector2::~MyVector2()
{
    delete[] a;
}

inline MyVector2 MyVector2::operator+(const MyVector2& b)
{
    MyVector2 result(this->length);
    for(int i = 0; i < this->length; i++) result.a[i] = this->a[i] + b.a[i];
    return result;
}

inline MyVector2 MyVector2::operator-(const MyVector2& b)
{
    MyVector2 result(this->length);
    for(int i = 0; i < this->length; i++) result.a[i] = this->a[i] - b.a[i];
    return result;
}

inline MyVector2 MyVector2::operator+(const int b)
{
    MyVector2 result(this->length);
    for(int i = 0; i < this->length; i++) result.a[i] = this->a[i] + b;
    return result;
}

inline MyVector2 MyVector2::operator-(const int b)
{
    MyVector2 result(this->length);
    for(int i = 0; i < this->length; i++) result.a[i] = this->a[i] - b;
    return result;
}

inline ostream& operator<<(ostream& out, MyVector2& b)
{
    for(int i = 0; i < b.length; i++)
    {
        out << b.a[i] << " ";
    }
    return out;
}

inline istream& operator>>(istream& in, MyVector2& b)
{
    for(int i = 0; i < b.length; i++)
    {
        in >> b.a[i];
    }
    return in;
}