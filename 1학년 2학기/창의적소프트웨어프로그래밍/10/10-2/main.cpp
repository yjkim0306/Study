/* 221027 LAB 10 */
#include <iostream>
#include <vector>
#include <string>
#include <algorithm>
#include "intset.h"
using namespace std;
IntegerSet intSet;
int main()
{
    while(1)
    {
        string str;
        cin >> str;
        if(str == "quit") return 0;
        int n;
        cin >> n;
        if(str == "add")
        {
            intSet.AddNumber(n);
        }
        else if(str == "del")
        {
            intSet.DeleteNumber(n);
        }
        else if(str == "get")
        {
            cout << intSet.GetItem(n) << "\n";
        }
    }
    return 0;
}