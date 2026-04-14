/* 221124 LAB 17 */
#include <iostream>
#include "my_container.h"
using namespace std;

int main()
{
    int n;
    cin >> n;
    MyContainer<int> container1(n);
    cin >> container1;
    cout << container1;
    int m; 
    cin >> m;
    MyContainer<double> container2(m);
    cin >> container2;
    cout << container2;
    int k;
    cin >> k;
    MyContainer<string> container3(k);
    cin >> container3;
    cout << container3;

    return 0;
}