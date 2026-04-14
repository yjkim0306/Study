/* 221124 LAB 17 */
#pragma once
#include <iostream>
template <class T>
class MyContainer
{
    public:
        MyContainer(int size)
        {
            n_elements = size;
            obj_arr = new T[n_elements];
        }
        ~MyContainer()
        {
            delete[] obj_arr;
        }
        void clear()
        {
            obj_arr = NULL;
        }
        int size()
        {
            return n_elements;
        }

        template <class U>
        friend std::istream& operator>>(std::istream &in, MyContainer<U> &b);
        template <class U>
        friend std::ostream& operator<<(std::ostream &out, MyContainer<U> &b);

    protected:
        T* obj_arr = NULL;
        int n_elements;
};

template <class T>
std::istream& operator>>(std::istream &in, MyContainer<T> &b)
{
    for(int i = 0; i < b.n_elements; i++)
    {
        in >> b.obj_arr[i];
    }
    return in;
}

template <class T>
std::ostream& operator<<(std::ostream &out, MyContainer<T> &b)
{
    for(int i = 0; i < b.n_elements; i++)
    {
        out << b.obj_arr[i] << " ";
    }
    out << "\n";
    return out;
}