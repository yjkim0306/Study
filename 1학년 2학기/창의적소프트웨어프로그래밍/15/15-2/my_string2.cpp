/* 221117 LAB 15 */
#include "my_string2.h"
using namespace std;
inline MyString2::MyString2() {}

inline MyString2::MyString2(const MyString2& b)
{
    str = b.str;
}

inline MyString2 MyString2::operator+(const MyString2& b)
{
    MyString2 result;
    result.str = str + b.str;
    return result;
}

inline MyString2 MyString2::operator*(const int b)
{
    MyString2 result;
    for(int i = 0; i < b; i++)
    {
        result.str += str;
    }
    return result;
}

inline std::ostream& operator<<(std::ostream& out, MyString2& my_string)
{
    out << my_string.str << endl;
    return out;
}

inline std::istream& operator>>(std::istream& in, MyString2& my_string)
{
    in >> my_string.str;
    return in;
}