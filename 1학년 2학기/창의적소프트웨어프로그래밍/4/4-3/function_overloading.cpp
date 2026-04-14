/* 220922 LAB 4 */
#include <iostream>
#include <string>

using namespace std;

int add(int a, int b)
{
    return a + b;
}

string add(string a, string b)
{
    string c = a + "-" + b;
    return c;
}

int main()
{
    int a, b;
    string c, d;
    cin >> a >> b >> c >> d;
    cout << add(a,b) << endl << add(c,d) << endl;

    return 0;
}