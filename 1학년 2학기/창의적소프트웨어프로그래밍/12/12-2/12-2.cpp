/* 221103 LAB 12 */
#include <iostream>
#include <string>
#include <vector>
using namespace std;
class A
{
public:
    virtual string getTypeInfo()
    {
        return "This is an instance of class A\n";
    }
};

class B : public A
{
public:
    virtual string getTypeInfo()
    {
        return "This is an instance of class B\n";
    }
};

class C : public B
{
public:
    virtual string getTypeInfo()
    {
        return "This is an instance of class C\n";
    }
};

void printObjectTypeInfo1(A* object)
{
    cout << object->getTypeInfo();
}

void printObjectTypeInfo2(A& object)
{   

    cout << object.getTypeInfo();
}

int main()
{
    A* a = new A;
    B* b = new B;
    C* c = new C;
    vector<A*> arr;
    arr.push_back(a);
    arr.push_back(b);
    arr.push_back(c);
    for(int i = 0; i < arr.size(); i++)
    {
        printObjectTypeInfo1(arr[i]);
        printObjectTypeInfo2(*arr[i]);
    }
    return 0;
}