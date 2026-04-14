/* 221027 LAB 10 */
#pragma once
#include <vector>
using namespace std;
class SortedArray
{
public:
    void AddNumber(int num);

    vector<int> GetSortedAscending();
    vector<int> GetSortedDescending();
    int GetMax();
    int GetMin();
private:
    vector<int> numbers_;
};