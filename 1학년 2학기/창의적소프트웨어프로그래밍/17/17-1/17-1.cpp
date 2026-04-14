/* 221124 LAB 17 */
#include <iostream>
using namespace std;

template <typename T>
void myswap(T& a, T& b)
{
    T temp = a;
    a = b;
    b = temp;
}

int main()
{
    int a, b;
    double c, d;
    string s1, s2;
    cin >> a >> b;
    myswap(a, b);
    cout << "After calling myswap() : " << a << " " << b << "\n";;
    cin >> c >> d;
    myswap(c, d);
    cout << "After calling myswap() : " << c << " " << d << "\n";;
    cin >> s1 >> s2;
    myswap(s1, s2);
    cout << "After calling myswap() : " << s1 << " " << s2 << "\n";

    return 0;
}