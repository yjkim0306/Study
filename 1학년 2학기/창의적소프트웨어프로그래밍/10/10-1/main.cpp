/* 221027 LAB 10 */
#include <iostream>
#include <algorithm>
#include <string>
#include <vector>
#include "sorted.h"
using namespace std;
SortedArray sorted;
int main()
{
    int num = 1;
    string str;
    while(1)
    {
        cin >> str; 
        if(str == "ascend")
        {
            sorted.GetSortedAscending();
        }
        else if(str == "descend")
        {
            sorted.GetSortedDescending();
        }
        else if(str == "max")
        {
            cout << sorted.GetMax() << "\n";
        }
        else if(str == "min")
        {
            cout << sorted.GetMin() << "\n";
        }
        else if(str == "quit") return 0;
        else
        {
            sorted.AddNumber(stoi(str));
        }
    }

}