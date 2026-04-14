/* 221027 LAB 10 */
#include <iostream>
#include <vector>
#include "sorted.h"
void SortedArray::AddNumber(int num)
{
    numbers_.push_back(num);
}

vector<int> SortedArray::GetSortedAscending()
{
    sort(numbers_.begin(), numbers_.end());
    for(int i = 0; i < numbers_.size(); i++)
    {
        cout << numbers_[i] << " ";
    }
    cout << "\n";
    return numbers_;
}

vector<int> SortedArray::GetSortedDescending()
{
    sort(numbers_.rbegin(), numbers_.rend());
    for(int i = 0; i < numbers_.size(); i++)
    {
        cout << numbers_[i] << " ";
    }
    cout << "\n";
    return numbers_;
}
int SortedArray::GetMax()
{
    int maximum = *max_element(numbers_.begin(), numbers_.end());
    return maximum;
}

int SortedArray::GetMin()
{
    int minimum = *min_element(numbers_.begin(), numbers_.end());
    return minimum;
}