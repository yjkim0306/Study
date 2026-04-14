/* 221027 LAB 10 */
#include <iostream>
#include <vector>
#include <algorithm>
#include "intset.h"
using namespace std;
void IntegerSet::AddNumber(int num)
{
    if(find(numbers_.begin(), numbers_.end(), num) == numbers_.end())
    {
        numbers_.push_back(num);
        sort(numbers_.begin(), numbers_.end());
    }
    for(int i = 0; i < numbers_.size(); i++)
        {
            cout << numbers_[i] << " ";
        }
    cout << "\n";
}

void IntegerSet::DeleteNumber(int num)
{
    if(find(numbers_.begin(), numbers_.end(), num) != numbers_.end())
    {
        remove(numbers_.begin(), numbers_.end(), num);
        sort(numbers_.begin(), numbers_.end());
        numbers_.resize(numbers_.size() - 1);
    }
    for(int i = 0; i < numbers_.size(); i++)
    {
        cout << numbers_[i] << " ";
    }
    cout << "\n";
}

int IntegerSet::GetItem(int pos)
{

    int res = -1;
    if(pos <= numbers_.size())
    {
        res = numbers_[pos];
    }
    return res;
}