/* 221103 LAB 12 */
#include <iostream>
#include <string>
#include <vector>
using namespace std;
class A
{
private:
    int* memberA;
public:
    A(int a)
    {
        memberA = new int;
        *memberA = a;
        cout << "new memberA\n";
    }
    virtual ~A()
    {
        cout << "delete memberA\n";
    }
    virtual void print()
    {
        cout << "*memberA " << *memberA << endl;
    }
};

class B : public A
{
private:
    double* memberB;
public:
    B(double b) : A(1)
    {
        memberB = new double;
        *memberB = b;
        cout << "new memberB\n";
    }
    virtual ~B()
    {
        cout << "delete memberB\n";
    }
    virtual void print()
    {
        A::print();
        cout << "*memberB " << *memberB << endl;
    }
};

class C : public B
{
private:
    string* memberC;
public:
    C(const string& c) : B(1.1)
    {
        memberC = new string;
        *memberC = c;
        cout << "new memberC\n";
    }
    virtual ~C()
    {
        cout << "delete memberC\n";
    }
    virtual void print()
    {
        B::print();
        cout << "*memberC " << *memberC << endl;
    }
};

int main()
{
    int n;
    double d;
    string str;
    cin >> n >> d >> str;
    A* a = new A(n);
    B* b = new B(d);
    C* c = new C(str);
    vector<A*> arr;
    arr.push_back(a);
    arr.push_back(b);
    arr.push_back(c);
    for(int i = 0; i < 3; i++)
    {
        arr[i]->print();
    }
    delete a;
    delete b;
    delete c;
    
    return 0;
}