/* 221117 LAB 15 */
#include <iostream>
#ifndef __STRING_H__
#define __STRING_H__
using namespace std;
// my_string2.h - DO NOT modify this class definition
class MyString2
{
    public:
        // Add constructors you need, including copy constructor
        MyString2();
        MyString2(const MyString2& b);
        // Incorrect implementation of assignment operator.
        // Do not use the assignment operator.
        // Do not correct this because the goal is to prevent using the assignment operator.
        MyString2& operator=(const MyString2& b){   return *this;   };
        // Just use the same implementations for these operators
        MyString2 operator+(const MyString2& b);
        MyString2 operator*(const int b);
        friend std::ostream& operator<<(std::ostream& out, MyString2& my_string);
        friend std::istream& operator>>(std::istream& in, MyString2& my_string);
    private:
        std::string str;
};

#endif // __STRING_H__