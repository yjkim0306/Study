/* 221027 LAB 10 */
#pragma once
#include <iostream>
#include <vector>
using namespace std;
class IntegerSet
{
public:
    void AddNumber(int num);
    void DeleteNumber(int num);

    int GetItem(int pos);
private:
    vector<int> numbers_;
};