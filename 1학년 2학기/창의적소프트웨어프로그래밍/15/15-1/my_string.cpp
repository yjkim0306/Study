/* 221117 LAB 15 */
#include "my_string.h"
using namespace std;
inline MyString& MyString::operator=(const MyString& b)
{
    str = b.str;
    return (*this);
}

inline MyString MyString::operator+(const MyString& b)
{
    MyString result;
    result.str = str + b.str;
    return result;
}

inline MyString MyString::operator*(const int b)
{
    MyString result;
    for(int i = 0; i < b; i++)
    {
        result.str += str;
    }
    return result;
}

inline ostream& operator<<(ostream& out, MyString& my_string)
{
    out << my_string.str << endl;
    return out;
}

inline istream& operator>>(istream& in, MyString& my_string)
{
    in >> my_string.str;
    return in;
}