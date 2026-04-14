/* 221110 LAB 14 */
#include <iostream>
#include <vector>
using namespace std;
class B
{
public:
    virtual ~B() {}
};

class C : public B
{
public:
    void test_C() { cout << "C::test_C()" << endl; }
};

class D : public B
{
public:
    void test_D() { cout << "D::test_D()" << endl; }
};

int main()
{
    vector<B*> arr;
    char input;
    while(1)
    {
        cin >> input;
        if(input == '0') break;
        else if(input == 'B') arr.push_back(new B);
        else if(input == 'C') arr.push_back(new C);
        else if(input == 'D') arr.push_back(new D);
    }
    for(int i = 0; i < arr.size(); i++)
    {
        C* pc = dynamic_cast<C*>(arr[i]);
        D* pd = dynamic_cast<D*>(arr[i]);
        if(pc) pc->test_C();
        else if(pd) pd->test_D();
    }
    for(int i = 0; i < arr.size(); i++)
    {
        delete arr[i];
    }

    return 0;
}